function Vector2D(x, y) {
    this.x = x;
    this.y = y;
}

Vector2D.prototype.magnitude = function() {
    return Math.sqrt(this.x*this.x + this.y*this.y);
}

Vector2D.prototype.magnitudeSq = function() {
    return (this.x*this.x + this.y*this.y);
}

Vector2D.prototype.add = function(other) {
    return new Vector2D(this.x + other.x, this.y + other.y);
}

Vector2D.prototype.addEquals = function(other) {
    this.x += other.x;
    this.y += other.y;
    return this;
}

Vector2D.prototype.subtract = function(other) {
    return new Vector2D(this.x - other.x, this.y - other.y);
}

Vector2D.prototype.subtractEquals = function(other) {
    this.x -= other.x;
    this.y -= other.y;
    return this;
}

Vector2D.prototype.multiply = function(scalar) {
    return new Vector2D(this.x * scalar, this.y * scalar);
}

Vector2D.prototype.multiplyEquals = function(scalar) {
    this.x *= scalar;
    this.y *= scalar;
    return this;
}

Vector2D.prototype.divide = function(scalar) {
    return new Vector2D(this.x / scalar, this.y / scalar);
}

Vector2D.prototype.divideEquals = function(scalar) {
    this.x /= scalar;
    this.y /= scalar;
    return this;
}

Vector2D.prototype.normal = function() {
    var mag = this.magnitude();
    return new Vector2D(this.x / mag, this.y / mag);
}

Vector2D.prototype.normalize = function() {
    var mag = this.magnitude();
    this.x /= mag;
    this.y /= mag;
    return this;
}

Vector2D.prototype.dot = function(other) {
    return (this.x*other.x + this.y*other.y);
}

Vector2D.prototype.cross = function(other) {
    return (this.x*other.y - this.y*other.x);
}

Vector2D.prototype.perpendicular = function() {
    return new Vector2D(-this.y, this.x);
}

Vector2D.prototype.project = function(other) {
    return this.multiply(this.dot(other) / other.magnitudeSq());
};

Vector2D.prototype.toString = function() {
    return "Vector2D[" + this.x + ", " + this.y + "]";
};
