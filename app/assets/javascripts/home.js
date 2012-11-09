geocraft.home = {
    scale: 1.25,

    arcPrecision: 0.5,          // closer to zero is more precise
    wideArcLambda: 0.6,         // lower is wider, higher is pointier,
    arcTransitionDuration: 500, // in milliseconds
    
    init: function() {
        this.width = 960 * this.scale;
        this.height = 500 * this.scale;
        
        this.projection = d3.geo.albersUsa()
                            .scale(1000 * this.scale)
                            .translate([480 * this.scale, 250 * this.scale]);

        this.path = d3.geo.path()
                     .projection(this.projection);
            
        this.arc = d3.geo.greatArc()
                    .precision(this.arcPrecision);
                    
    }
}

geocraft.home.getScaleFunc = function(dataAttr) {
    var scaleFunc;

    if (dataAttr == "qty") {
        scaleFunc = function(qty) {
            return qty * 0.5;
        }
    } else if (dataAttr == "value") {
        scaleFunc = function(val) {
            return Math.sqrt(val) * 1.75;
        }
    } else {
        console.log(
            "geocraft.home.getScaleFunc: " + 
            "no scale function defined for dataAttr \"" 
            + dataAttr + "\""
        );
    }

    return scaleFunc;
}

geocraft.home.render = function() {
    var self = this;
    
    var svg = d3.select("body").append("svg")
        .attr("width", this.width)
        .attr("height", this.height);

    this.states = svg.append("g")
        .attr("id", "states");
        
    this.counties = svg.append("g")
        .attr("id", "counties");

    this.arcs = svg.append("g")
        .attr("id", "arcs");

    d3.json("data/contiguous-us-states.json", function(collection) {
      self.states.selectAll("path")
          .data(collection.features)
        .enter().append("path")
          .attr("d", self.path);
    });

    d3.json("data/contiguous-us-counties.json", function(collection) {
      self.counties.selectAll("path")
          .data(collection.features)
        .enter().append("path")
          .attr("d", self.path);
    });

    this.renderArcs("sales_aggregates/links.json?tag=clothing", "value");
};

geocraft.home.renderArcs = function(api_url, dataAttr) {
    var self = this;

    // The unique key of a link is its two locations in alphabetical order.
    // This ensures that pairs like NY,SF and SF,NY are combined,
    // since at the moment arcs are bidirectional.

    function salesAggKey(s) {
        if (s.made_in < s.sold_in)
            return s.made_in + "," + s.sold_in;
        else
            return s.sold_in + "," + s.made_in;
    }

    d3.json(api_url, function(response) {
        // If this is the first render, initialize a links object.
        // Else, reset the qty/value of all links, 
        // and flag everything for deletion,
        // unless the new results contain a link with the same key

        if (!self.links) {
            self.links = {};
        } else {
            for (var key in self.links) {
                self.links[key].toDelete = true;
                self.links[key].qty = 0;
                self.links[key].value = 0.0;
            }
        }

        // If a new link has the same key as an old link,
        // don't delete the old one (so it will transition smoothly)

        response.links.forEach(function(salesAgg) {
            var key = salesAggKey(salesAgg);
            var link = self.links[key];

            if (link) {
                link.qty += salesAgg.qty;
                link.value += salesAgg.value;
                link.toDelete = false;
            } else {
                self.links[key] = salesAgg;
                self.links[key].toDelete = false;
            }
        });

        // Convert from associative array (links) to array (arcData)
        // Filter out links that have the same source and destination
        // Filter out links that are to be deleted

        var arcData = Object
                        .keys(self.links)
                        .map(function(key) { return self.links[key]; })
                        .filter(function(d) { 
                            return ((d.made_in != d.sold_in) && !d.toDelete); 
                        });

        // Change the data associated with each arc path

        var update = self
            .arcs.selectAll("path")
            .data(arcData, function(d) { 
                return salesAggKey(d);
            });

        // Create arcs from new links (start at zero width and grow)

        update
            .enter().append("path")
            .attr("d", function(d) { 
                var arcPath = self.path(self.arc(d));
                return d3_utils.wideArc(arcPath, 0, 1);
            })
            .style("fill-opacity", "1.0");

        // Remove links that are no longer present

        update
            .exit()
            .transition()
            .duration(self.arcTransitionDuration)
            .ease("quad")
            .attr("d", function(d) {
                var arcPath = self.path(self.arc(d));
                return d3_utils.wideArc(arcPath, 0, 1);
            })
            .style("fill-opacity", "0.0")
            .remove();

        // Transition all existing arcs to their final size

        self.arcWidth(dataAttr, update, "quad-in-out");

    });
};

geocraft.home.arcWidth = function(dataAttr, selector, ease) {
    var self = this;

    if (!selector)
        selector = this.arcs.selectAll("path");

    if (!ease)
        ease = "cubic-in-out";

    var scaleFunc = self.getScaleFunc(dataAttr);

    selector
        .transition()
        .duration(self.arcTransitionDuration)
        .ease(ease)
        .attr("d", function(d) {
            return d3_utils.wideArc(
                self.path(self.arc(d)), 
                scaleFunc(d[dataAttr]), 
                self.wideArcLambda
            );
        });
};

geocraft.home.selectTag = function(tag) {
    var self = this;

    var dataAttr = "value";

    if ($("#qty_button").attr("checked")) {
        dataAttr = "qty";
    }

    this.renderArcs("sales_aggregates/links.json?tag=" + tag, dataAttr);
};