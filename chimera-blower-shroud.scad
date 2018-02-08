include <utils_threads.scad>

$fn=64;

plate = [44, 40, 5];

module chimera_holes(recess_h=0) {
    for (at = [ [-4.5, 10], [4.5, 10], [0, 20]]) {
        translate(at) cylinder(d=M3_through_hole_d(), h=100);
        if (recess_h > 0) {
            translate([at[0], at[1],recess_h]) cylinder(d=6, h=100-recess_h);
        }
    }
}

module fan_holes() {
    for (at = [ [-17.5, 2.5], [17.5, 2.5]]) {
        translate(at) cylinder(d=M3_tapping_hole_d(), h=100);
    }
}

shroud_z = 20+3+plate[2];

module shroud_body(dx, dy, dz) {
    hull() {
        point([0+dx, 0, dz]);
        point([0+dx, 9-dy, dz]);
        point([plate[0]-dx, 9-dy, dz]);
        point([plate[0]-dx, 0, dz]);
        point([dx, 0, shroud_z-dz]);
        point([dx, 4, shroud_z-dz]);
        point([plate[0]-dx, 0, shroud_z-dz]);
        point([plate[0]-dx, 4, shroud_z-dz]);
    }
}

module shroud_outside() {
    shroud_body(0,0,0);
}

module shroud_inside() {
    shroud_body(3, 2, 3);
}

module shroud() {
    union() {
        difference() {
            shroud_outside();
            shroud_inside();
        }
        cube([plate[0]-33, 2, shroud_z]);
    }
}

module tusk_holes() {
    for (at = [ [-18, 3.5], [0, 3.5], [18, 3.5] ]) {
        translate(at) cylinder(d=3, h=plate[2]);
    }
}

module mount() {
    difference() {
        translate([-plate[0]/2, 0, 0]) union() {
            cube(plate);
            translate([0, plate[1], 0]) shroud();
        }
        translate([0, 1, 0]) chimera_holes(plate[2]-3);
        translate([0, 1, 0]) fan_holes();
        translate([0, plate[1], 0]) tusk_holes();
    }
}

module spacer() {
    difference() {
        translate([-7.5, 7.5, 0]) cube([15, 15, 10]);
        chimera_holes();
    }
}

spacer();