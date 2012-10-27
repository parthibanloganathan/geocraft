geocraft = {}

geocraft.home = function () {
    var scale = 1.25;

    var width = 960 * scale,
        height = 500 * scale;
      
    var projection = d3.geo.albersUsa()
        .scale(1000 * scale)
        .translate([480 * scale, 250 * scale]);

    var path = d3.geo.path()
        .projection(projection);

    var arc = d3.geo.greatArc();

    var svg = d3.select("body").append("svg")
        .attr("width", width)
        .attr("height", height);

    var states = svg.append("g")
        .attr("id", "states");
        
    var counties = svg.append("g")
        .attr("id", "counties");

    var arcs = svg.append("g")
        .attr("id", "arcs");

    d3.json("data/contiguous-us-states.json", function(collection) {
      states.selectAll("path")
          .data(collection.features)
        .enter().append("path")
          .attr("d", path);
    });

    d3.json("data/contiguous-us-counties.json", function(collection) {
      counties.selectAll("path")
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
      
        arcs.selectAll("path")
            .data(links)
            .enter().append("path")
            .attr("d", function(d) { return path(arc(d)); })
            .style("stroke-width", function (d) { return d.value / 20.0;  } );
    });
}