include <utils_threads.scad>

function flatten(V) = [ for (a = V) for (b = a) b ];

module rounded_square(size, r=1) {
    x=size[0];
    y=size[1];
    union() {
	translate([r,r]) circle(r=r, $fn=50);
	translate([r,y-r]) circle(r=r, $fn=50);
	translate([x-r,r]) circle(r=r, $fn=50);
	translate([x-r,y-r]) circle(r=r, $fn=50);
	translate([0,r]) square([x,y-(r*2)]);
	translate([r,0]) square([x-(r*2),y]);
    }
}

module rounded_cube(size, r=1) {
    linear_extrude(height=size[2]) rounded_square(size=size, r=r);
}

module tapered_cylinder(d0, d1, h, steps=20) {
    linear_extrude(height=h, scale=d1/d0) circle(d=d0);
}

function inch_to_mm(inch) = inch * 25.4;
function mm_to_inch(mm) = mm / 25.4;

module point(p, d=0.01) {
    if (len(p) == 2) {
        translate(p) square([d,d]);
    }
    if (len(p) == 3) {
        translate(p) cube([d,d,d]);
    }
}

function rotate_around(angle, point2d, origin = [0, 0]) =
   [ cos(angle) * (point2d[0] - origin[0]) - sin(angle) * (point2d[1] - origin[1]),
     sin(angle) * (point2d[0] - origin[0]) + cos(angle) * (point2d[1] - origin[1]) ];
