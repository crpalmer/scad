include <bearing.scad>
include <utils_threads.scad>
include <high-detail.scad>

layer_h = 0.2;

bearing_h = 100;
wall=4;
w=38;
screw_d = No8_through_hole_d();

module mount() {
    translate([0, 0, (bearing_h-wall)])
      bearing_8mm_holder_in()
        translate([-w/2, -w/2, -(bearing_h-wall)])
        difference() {
            cube([w, w, bearing_h+7-wall]);
            translate([wall, 0, 0]) cube([w-wall*2, w-wall, bearing_h - wall]);
        }
    ;
}

module base() {
    delta = wall*4 + screw_d;

    translate([-w/2-delta, -w/2, 0]) 
    for (i = [0:layer_h:delta]) {
        translate([0, 0, i]) linear_extrude(height = layer_h) difference() {
            translate([i, 0]) square([w+delta*2-i*2, w+delta-i]);
            translate([delta, 0]) square([w, w]);
        }
    }
}

module screw_holes(hole_d = No8_through_hole_d(), outer_d = 12) {

    module hole() {
        cylinder(d = hole_d, h = 100);
        translate([0, 0, 4]) cylinder(d = outer_d, h=100);
    }
    
    delta = wall*2 + screw_d / 2;
    for (x = [-w/2 - delta, w/2 + delta]) {
        for (y = [-w/2 + delta, w/2 - delta/2]) {
            translate([x, y, 0]) hole();
        }
    }
    translate([0, w/2 + wall + delta/2, 0]) hole();
}

module full_mount() {
    difference() {
        union() {
            mount();
            base();
        }
        screw_holes();
    }
}

module bearing_insert() {
    difference() {
        union() {
            cylinder(d=10, h=4);
            translate([0, 0, 4]) cylinder(d=8, h=7);
        }
        cylinder(d=quarter_twenty_through_hole_d(), h=20);
    }
}

bearing_insert();
//rotate([0, 180, 0]) full_mount();