include <utils.scad>
include <fsr.scad>
include <high-detail.scad>

mink = 1;
wall = 4;
M5_head_height = 8;
fsr_pad_h = 4;
corner_len = 30;
fsr_ext = 10;
hole_spacing = corner_len + 30;
base = wall + M5_head_height - fsr_pad_h;
corner_h = 8 + base + fsr_pad_h;

module holes() {
    for (x = [-1, 1]*hole_spacing/2) translate([x, 0, 0]) children();
}

module base(w) {
    holes() cylinder(d = w, h = wall);
    translate([-hole_spacing/2, -w/2, 0]) cube([hole_spacing, w, wall]);
}

module corner() {    
    translate([-corner_len/2-wall, -corner_len/2-wall, 0]) cube([corner_len+wall, wall, corner_h]);
    translate([-corner_len/2-wall, -corner_len/2-wall, 0]) cube([wall, corner_len, corner_h]);
    translate([-corner_len/2-wall, -corner_len/2, 0]) cube([corner_len+wall, corner_len + fsr_ext, base]);
}

module mount(w=20) {
    difference() {
        minkowski() {
            union() {
                base(w=w);
                children();
            }
            sphere(d=mink);
        }
        holes() translate([0, 0, -mink]) cylinder(d = 5.5, h = 100);
    }
}

module back_left() {
    mount() corner();
}

module back_right() {
    mount() mirror([1, 0, 0]) corner();
}

module front() {
    w=19;
    ext_h = 20;
    
    module bump() {
        bump_len = corner_len - w + wall + fsr_ext + wall;
        support_h = triangle_adj_length_angle_opp(55, bump_len);
        translate([0, w, base + ext_h - support_h]) linear_extrude(height = support_h, scale = [1, support_h / 0.1]) square([corner_len, 0.1]);
    }

    module bed_idler_screw_notch() {
        translate([corner_len/2-4, 0, 0]) cube([8, 5, 15]);
    }

    module side() {
        translate([-corner_len/2, -w/2, 0])
        difference() {
            union() {
                cube([corner_len, wall, corner_h + ext_h]);
                cube([corner_len, w, base + ext_h]);
                bump();
            }
            bed_idler_screw_notch();
        }
    }
        
    translate([0, 0, -ext_h]) mount(w) side();
}

module fsr_of(y_offset = -5) {
    difference() {
        children();
        translate([0, 0, base]) translate([0, y_offset, 0]) fsr_cutout();
    }
}

fsr_of() back_left();
//fsr_of() back_right();
//fsr_of(5) front();

