var geocraft = {};

geocraft.home = {
    scale: 1.25,
    
    init: function() {
        this.width = 960 * this.scale;
        this.height = 500 * this.scale;
    }
}

geocraft.wideArc = function (arc, wmax, lambda) {
    var arcPoly = {
        coordinates: []
    };
    
    var upCoords = [];      // normal the original arc
    var downCoords = [];    // anti-normal the original arc
    
    arc.coordinates.forEach(function(point) {
        console.log(point);
    });
}

geocraft.home.render = function () {
    var self = this;
    
    var projection = d3.geo.albersUsa()
        .scale(1000 * this.scale)
        .translate([480 * this.scale, 250 * this.scale]);

    var path = d3.geo.path()
        .projection(projection);

    var arc = d3.geo.greatArc();
    
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
          .attr("d", path);
    });

    d3.json("data/contiguous-us-counties.json", function(collection) {
      self.counties.selectAll("path")
          .data(collection.features)
        .enter().append("path")
          .attr("d", path);
    });

    d3.json("sales_aggregates/links.json?tag=clothing", function(response) {
        var links = [];

        response.forEach(function(sales_agg) {
            if (sales_agg.made_in != sales_agg.sold_in) {
                links.push(sales_agg);
            }
        });
      
        self.arcs.selectAll("path")
            .data(links)
            .enter().append("path")
            .attr("d", function(d) { /* geocraft.wideArc(arc(d), 5.0, 2.0); */ return path(arc(d)); })
            .style("stroke-width", function (d) { return d.value / 20.0;  } );
    });
};

geocraft.home.arcStyle = function(attr, func) {
    this.arcs.selectAll("path")
        .style(attr, func);
};
