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

module part_plate(w, l, w_no_radius) {
    faceplate([w, l, h], sqrt((w-w_no_radius)/2*(w-w_no_radius)/2)/2);
}

module dial1() {
    part_plate(139, 190, 134);
}

module dial2() {
    part_plate(187, 150, 170);
}

dial2();
