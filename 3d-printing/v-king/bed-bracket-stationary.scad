include <fsr.scad>
include <high-detail.scad>

mink = 1;
wall = 4;
hole_spacing = 80;
M5_head_height = 8;
corner_len = 40;
base = wall + M5_head_height;
corner_h = 9 + base;

module holes() {
    for (x = [-1, 1]*hole_spacing/2) translate([x, 0, 0]) children();
}

module base() {
    holes() cylinder(d = 20, h = wall);
    translate([-hole_spacing/2, -20/2, 0]) cube([hole_spacing, 20, wall]);
}

module corner() {    
    translate([-corner_len/2-wall, -corner_len/2-wall, 0]) cube([corner_len+wall, wall, corner_h]);
    translate([-corner_len/2-wall, -corner_len/2, 0]) cube([wall, corner_len, corner_h]);
    translate([-corner_len/2-wall, -corner_len/2, 0]) cube([corner_len+wall, corner_len, base]);
}

module mount() {
    difference() {
        minkowski() {
            union() {
                base();
                children();
            }
            sphere(d=mink);
        }
        holes() translate([0, 0, -mink]) cylinder(d = 5.5, h = 100);
    }
}

module front_right() {
    mount() corner();
}

module back_right() {
    mount() rotate([0, 0, 90]) corner();
}

module left() {
    module side() {
        len = hole_spacing - 20;
        translate([-len/2, -corner_len/2-wall, 0]) union() {
            cube([len, wall, corner_h]);
            cube([len, corner_len + wall, base]);
        }
    }
        
    mount() side();
}

module fsr_of(angle = 0) {
    difference() {
        children();
        translate([0, 0, base]) rotate([0, 0, angle]) translate([0, -5, 0]) fsr_cutout();
    }
}

fsr_of(-90) front_right();
//fsr_of() back_right();
//fsr_of() left();