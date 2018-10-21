include <utils.scad>
include <high-detail.scad>

w=15;
h=1.5;
mink=2;

module faceplate(dim, radius, slop=0.5) {
    big_dim = dim + [w*2+slop*2, w*2+slop*2, 0];
    
    difference() {
        minkowski() {
            rounded_cube(big_dim, radius);
            sphere(mink);
        }
        translate([w-slop, w-slop, 0]) rounded_cube(dim+[slop*2, slop*2, mink], radius);
        translate([-mink, -mink, -mink]) cube([big_dim[0] + mink*2, big_dim[1] + mink*2, mink]);
    }
}

module part_plate_v1(w, l, w_no_radius) {
    faceplate([w, l, h], sqrt((w-w_no_radius)/2*(w-w_no_radius)/2)/2);
}

module part_plate(w, l, w_no_radius) {
    diameter=sqrt((w-w_no_radius)*(w-w_no_radius));
    faceplate([w, l, h], diameter/2);
}

module dial1() {
    part_plate_v1(139, 190, 134);
}

module dial2() {
    h=150;
    difference() {
        part_plate(187, h, 170);
        translate([-100, -mink, 0]) cube([350, h/2+mink+w, 20]);
    }
    difference() {
        part_plate(187, h, 150);
        translate([-100, h/2+w, 0]) cube([350, 200, 20]);
    }
}

module dial3() {
    part_plate(168, 190, 145);
}

module fuel() {
    difference() {
        minkowski() {
            cylinder(d = 50 - mink*2, h=h);
            sphere(mink);
        }
        cylinder(d = 35, h=20);
        translate([-50, -50, -50]) cube([100, 100, 50]);
    }
}

dial2();
