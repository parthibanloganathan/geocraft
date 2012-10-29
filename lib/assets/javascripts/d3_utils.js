// Depends on Vector2D.js

var d3_utils = {}

// Currently supports only M, m, L, l, H, h, V, v and Z.
d3_utils.svgPathToPoints = function(pathStr) {
    if (pathStr.charAt(pathStr.length-1) != 'Z')
        pathStr += 'Z';
    
    var pattern = /[MLHVCSQTAZmlhvcsqtaz][0-9.,]*(?=[MLHVCSQTAZmlhvcsqtaz])/g;
    var strokes = pathStr.match(pattern);
    strokes.push("Z");
    
    var points = [];
    var line = false;
    var x = 0;
    var y = 0;
    
    strokes.forEach(function(stroke) {
        var command = stroke.charAt(0);
        var args = stroke.substring(1).split(',');
        
        for (var i = 0; i < args.length; i++)
            args[i] = parseFloat(args[i]);
        
        if (command == 'M') {
            if (line) {
                points.push([x, y]);
                line = false;
            }
            x = args[0];
            y = args[1];
        } else if (command == 'm') {
            x += args[0];
            y += args[1];
        } else if (command == 'L') {
            points.push([x, y]);
            x = args[0];
            y = args[1];
            line = true;
        } else if (command == 'l') {
            points.push([x, y]);
            x += args[0];
            y += args[1];
            line = true;
        } else if (command == 'H') {
            points.push([x, y]);
            x = args[0];
            line = true;
        } else if (command == 'h') {
            points.push([x, y]);
            x += args[0];
            line = true;
        } else if (command == 'V') {
            points.push([x, y]);
            y = args[0];
            line = true;
        } else if (command == 'v') {
            points.push([x, y]);
            y += args[0];
            line = true;
        } else if (command == 'Z') {
            if (line) {
                points.push([x, y]);
                line = false;
            }
            points.push([x, y]);
        } else {
            throw ("d3_utils.svgPathToPoints: SVG path command \'" + command + "\' not supported");
        }
    });
    
    return points;
}

d3_utils.wideArc = function (pathStr, wMax, lambda) {
    var coords = this.svgPathToPoints(pathStr);
    
    var upCoords = [];      // normal to the original arc
    var downCoords = [];    // anti-normal to the original arc

    var N = coords.length;
    var iMid = Math.floor(N / 2);
    
    var maxDist = 0.0;
    for (var i = 1; i < N; i++) {
        maxDist += Math.sqrt(
            Math.pow(coords[i][0] - coords[i-1][0], 2) +
            Math.pow(coords[i][1] - coords[i-1][1], 2)
        );
    }
    
    var curDist = 0.0;

    for (var i = 0; i < N; i++) {
        if (i == 0 || i == N-1) {
            upCoords.push(coords[i]);
            downCoords.push(coords[i]);
        } else {
            var prev = new Vector2D(coords[i-1][0], coords[i-1][1]);
            var cur = new Vector2D(coords[i][0], coords[i][1]);
            var next = new Vector2D(coords[i+1][0], coords[i+1][1]);
            
            var v1 = cur.subtract(prev); // prev -> cur
            var v2 = next.subtract(cur); // cur -> next
            
            curDist += v1.magnitude();
            var norm = v1.add(v2).normalize().perpendicular();
            
            var rMax = 0.5 * wMax;
            var x = curDist / maxDist;
            //var r = rMax * Math.pow(4.0*x*(1.0-x), lambda);
            var r = rMax * Math.pow(Math.sin(x * Math.PI), lambda);
            
            var up = cur.add(norm.multiply(r));
            var down = cur.add(norm.multiply(-r));
            
            upCoords.push([up.x, up.y]);
            downCoords.push([down.x, down.y]);
        }
    }
    
    downCoords.reverse();
    
    var ring = upCoords.concat(downCoords);
    var pathCommands = [];
    
    coordToStr = function(c) {
        return (c[0].toString() + "," + c[1].toString());
    }
    
    pathCommands.push("M", coordToStr(ring[0]));
    for (var i = 1; i < ring.length; i++) {
        pathCommands.push("L", coordToStr(ring[i]));
    }
    
    return pathCommands.join("");
}
