include <utils_threads.scad>
include <tlm-effector-blank.scad>

$fn=64;

T=8;    // Note: Must match the blank's value for thickness

module chimera_orientation_tabs()
{
    w=1.2;
    h=1.2;

    for (x = [-15.05-w, 15.05]) {
        translate([x, -5, -h]) cube([w, 16, h]);
    }
}

module chimera_top_mounting_holes(d=M3_through_hole_d()) {
    union() {
        for (dz = [ [d, -50], [6, T]]) {
            translate([-8.5, 9, dz[1]]) cylinder(d=dz[0], h=100);
            translate([8.5, 9, dz[1]]) cylinder(d=dz[0], h=100);
            translate([0, -3, dz[1]]) cylinder(d=dz[0], h=100);
        }
    }
}

module chimera_boden_holes(d=5) {
    union() {
        translate([-9, 0, -50]) cylinder(d=d, h=100);
        translate([9, 0, -50]) cylinder(d=d, h=100);
        translate([-9, 0, 0]) cylinder(d=10, h=T/2);
        translate([9, 0, 0]) cylinder(d=10, h=T/2);
    };
}

module chimera_effector() {
    difference() {
        rotate([0, 0, 180]) blank_effector();
        chimera_orientation_tabs();
        chimera_top_mounting_holes();
        rotate([0, 0, 180]) chimera_boden_holes();
    }
}

module nimble_mount() {
    union() {
        translate([-5.732, -3, 0]) cube([11.8, 16.427, 3.7]);
        translate([-3.531, -3.073, 3.7]) cube([7.130, 5.065+3.073, 2.614]);
        translate([-5.73, -0.225, 3.7]) cube([11.8, 2.490, 2.5]);
    }
}

module nimble_holes() {
    union() {
        translate([-2, -15, -50]) cylinder(d=M3_tapping_hole_d(), h=100);
        translate([14, 2, -50]) cylinder(d=M3_tapping_hole_d(), h=100);
    }
}
    
module chimera_dual_nimble_effector() {
    difference() {
        union() {
            rotate([0, 0, 180]) blank_effector();
//            chimera_orientation_tabs();
            translate([9, 0, T]) nimble_mount();
            translate([-9, 0, T]) mirror([1, 0, 0]) nimble_mount();
        }
        chimera_top_mounting_holes(d=4);
        chimera_boden_holes();
        translate([9, 0, T]) nimble_holes();
        translate([-9, 0, T]) mirror([1, 0, 0]) nimble_holes();
    }
}

//blank_effector();
//chimera_effector();
chimera_dual_nimble_effector();
