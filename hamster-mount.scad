include <utils.scad>
include <utils_threads.scad>

$fn=100;
T=5;

infinity=1000;

module cradle() {
    module cradle_arm(offset) {
        translate([T/2, 0, inch_to_mm(0.5)]) rotate([0, -90, 0]) difference() {
            translate([offset - inch_to_mm(0.5), 0, 0]) rotate_extrude() translate([-offset, 0, 0]) square([T, T]);
            translate([0, -offset*5, 0]) cube([offset*10, offset*10, T]);
        }
    }

    union() {
        cradle_arm(90);
        translate([0, -10, 0.5]) rotate([0, 0, 90]) cradle_arm(20);
        translate([0, 10, 0.5]) rotate([0, 0, 90]) cradle_arm(20);
    }
}

module arm() {
    union() {
        cradle();
        difference() {
            translate([0, -T/2, 0]) cube([inch_to_mm(2.5), T, T]);
            translate([inch_to_mm(2.5) - 6, 0, 0]) cylinder(d=M3_through_hole_d(), h=T);
        }
    }
}

module stand() {
    difference() {
        union() {
            translate([0, -inch_to_mm(2)/2, 0]) cube([inch_to_mm(1), inch_to_mm(2), T/2]);
            translate([0, -T/2, 0]) cube([T, T, inch_to_mm(5)]);
        }
        translate([T/2, 0, inch_to_mm(5)]) cylinder(d=M3_tapping_hole_d(), h=16, center=true);
    }
}

//arm();
stand();