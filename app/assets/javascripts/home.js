geocraft.home = {
    scale: 1.25,
    arcPrecision: 0.5, // closer to zero is more precise
    wideArcLambda: 0.6, // Lower is wider, higher is pointier
    
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

geocraft.home.drawArcs = function(api_url, dataAttr, widthMult) {
    var self = this;

    d3.json(api_url, function(response) {
        var links = [];

        response.links.forEach(function(sales_agg) {
            if (sales_agg.made_in != sales_agg.sold_in) {
                links.push(sales_agg);
            }
        });
        
        if (self.arcs) {
            self.arcs.selectAll("path")
            .data(links)
            .enter().append("path")
            .attr("d", function(d) { 
                var arcPath = self.path(self.arc(d));
                
                var polyPath = d3_utils.wideArc(
                    arcPath, d[dataAttr] * widthMult, self.wideArcLambda
                );
                
                return polyPath;
            });
        } else {
            console.log("self.arcs does not exist");
        }
    });
};

geocraft.home.render = function () {
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

    this.drawArcs("sales_aggregates/links.json?tag=clothing", "value", 0.1);
};

geocraft.home.selectTag = function(tag) {
    var self = this;

    var dataAttr = "value";
    var widthMult = 0.1;

    if ($("#qty_button").hasClass("selected")) {
        dataAttr = "qty";
        widthMult = 0.5;
    }

    this.arcs.selectAll("path").remove();
    this.drawArcs("sales_aggregates/links.json?tag=" + tag, dataAttr, widthMult);
};

geocraft.home.arcWidth = function(dataAttr, widthMult) {
    var self = this;
    
    this.arcs.selectAll("path")
        .attr("d", function(d) {
            return d3_utils.wideArc(
                self.path(self.arc(d)),
                d[dataAttr] * widthMult, self.wideArcLambda
            );
        });
};

geocraft.home.arcStyle = function(attr, func) {
    this.arcs.selectAll("path")
        .style(attr, func);
};
