include <utils_threads.scad>

$fn=64;

module back() {
    difference() {
        union() {
            cube([15, 46, 3]);
            translate([0, 7, 2]) cube([15, 6, 10]);
            translate([0, 40, 0]) cube([15, 6, 6]);
        }
        translate([7.5-4.5, 10, 0]) cylinder(d=M3_through_hole_d(), h=100);
        translate([7.5+4.5, 10, 0]) cylinder(d=M3_through_hole_d(), h=100);
        translate([15*.25, 40, 3]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=10);
        translate([15*.75, 40, 3]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=10);
    }
}

module front() {
    difference() {
        union() {
            cube([15, 46, 3]);
            translate([0, 40, 0]) cube([15, 6, 6]);
        }
        translate([15*.25, 40, 3]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=10);
        translate([15*.75, 40, 3]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=10);
    }
}

module bottom() {
    back_to_chimera=2+10;
    L=back_to_chimera+18+10;
    P=0.4*4;
    difference() {
        union() {
            translate([-2.5, 0, 0]) cube([5, L, 2]);
            translate([-7.5, 0, 0]) cube([15, 6, 2]);
            translate([-7.5, L-6, 0]) cube([15, 6, 2]);
            translate([-P/2, back_to_chimera+6-P/2, 0]) cube([P, P, 5]);
        }
        translate([-15/4, 3, 0]) cylinder(d=M3_through_hole_d(), h=10);
        translate([15/4, 3, 0]) cylinder(d=M3_through_hole_d(), h=10);
        translate([-15/4, L-3, 0]) cylinder(d=M3_through_hole_d(), h=10);
        translate([15/4, L-3, 0]) cylinder(d=M3_through_hole_d(), h=10);
    }
}

bottom();
