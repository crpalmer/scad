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
    linear_extrude(height=size[2]) rounded_square(size);
}

module tapered_cylinder(d0, d1, h, steps=20) {
    D=(d0-d1)/steps;
    H=h/steps;
    for (i=[0:steps-1]) translate([0, 0, H*i]) cylinder(d=d0-D*i, h=H);
}

function inch_to_mm(inch) = inch * 25.4;
function mm_to_inch(mm) = mm / 25.4;
