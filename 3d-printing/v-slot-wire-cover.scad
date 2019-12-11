use <v-slot.scad>
include <high-detail.scad>

module tabs() {
    translate([0, -8.25]) offset(delta = 0)
    intersection() {
        vslot_profile();
        translate([-6, 8.25]) square([12, 12]);
    }
}

module flat() {
    difference() {
        translate([-5, 0]) square([10, 1.5]);
        tabs();
    }
}

module ring() {
    intersection() {
        difference() {
            circle(r=3.4);
            circle(r=2.4);
        }
        translate([-4, 0.5]) square([8, 2]);
    }
}

module part2d() {
    translate([0, 1.75]) flat();
    ring();
}

height=12;
difference() {
    rotate([-90, 0, 0]) linear_extrude(height=height) part2d();
    translate([0, height/2, -10]) cylinder(d=3, h=20);
}
//translate([0, -6.4]) linear_extrude(height=0.1) vslot_profile();