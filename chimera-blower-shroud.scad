include <utils_threads.scad>

$fn=64;

module chimera_holes() {
    for (at = [ [-4.5, 10], [4.5, 10], [0, 20]]) {
        translate(at) cylinder(d=M3_through_hole_d(), h=100);
    }
}

module fan_holes() {
    for (at = [ [-17.5, 2.5], [17.5, 2.5], [17.5, 2.5+35]]) {
        translate(at) rotate([0, 0, 90]) M3_nut_insert_cutout();
        translate(at) cylinder(d=M3_through_hole_d(), h=100);
    }
}

module shroud_body(dx, dy, dz) {
    hull() {
        point([0+dx, 0, dz]);
        point([0+dx, 7-dy, dz]);
        point([44-dx, 7-dy, dz]);
        point([44-dx, 0, dz]);
        point([dx, 0, 22-dz]);
        point([dx, 2, 22-dz]);
        point([44-dx, 0, 22-dz]);
        point([44-dx, 2, 22-dz]);
    }
}

module shroud_outside() {
    shroud_body(0,0,0);
}

module shroud_inside() {
    shroud_body(2, 2, 3.5);
}

module shroud() {
    difference() {
        shroud_outside();
        shroud_inside();
    }
}

module tusk_holes() {
    for (at = [ [-18, 3.5], [0, 3.5], [18, 3.5] ]) {
        translate(at) cylinder(d=3, h=3.5);
    }
}

difference() {
    translate([-22, 0, 0]) union() {
        cube([44, 42, 3.5]);
        translate([0, 42, 0]) shroud();
    }
    translate([0, 1, 0]) chimera_holes();
    translate([0, 1, 0]) fan_holes();
    translate([0, 42, 0]) tusk_holes();
}