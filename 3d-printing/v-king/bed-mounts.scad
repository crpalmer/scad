include <utils.scad>
include <utils_threads.scad>
include <high-detail.scad>

mink = 1;
wall = 4;
M5_head_height = 8;
corner_len = 20;
hole_spacing = corner_len + 30;
base = wall + M5_head_height;
corner_h = 8 + base;

module holes() {
    for (x = [-1, 1]*hole_spacing/2) translate([x, 0, 0]) children();
}

module base(w) {
    holes() cylinder(d = w, h = wall);
    translate([-hole_spacing/2, -w/2, 0]) cube([hole_spacing, w, wall]);
}

module corner() {    
    translate([-corner_len/2-wall, -corner_len/2-wall, 0]) cube([corner_len+wall, wall, corner_h]);
    translate([-corner_len/2-wall, -corner_len/2-wall, 0]) cube([wall, corner_len+wall, corner_h]);
    translate([-corner_len/2-wall, -corner_len/2, 0]) cube([corner_len+wall, corner_len, base]);
}

module securing_hole() {
    M3_nut_insert_cutout();
    translate([0, 0, -wall*2]) cylinder(d = M3_through_hole_d(), h=wall*4);
}

module securing_holes() {
    translate([0, -corner_len/2 - wall/2 + .05, base + (corner_h - base) / 2]) rotate([-90, 0, 0]) rotate([0, 0, 90]) securing_hole();
    translate([-corner_len/2 + 0.6, 0, base + (corner_h - base) / 2]) rotate([0, -90, 0]) securing_hole();
    translate([corner_len/2+ wall/2 - 0.2, 0, base + (corner_h - base) / 2]) rotate([0, -90, 0]) securing_hole();
}

module mount_without_securing_holes(w=20) {
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

module mount(w=20) {
    difference() {
        mount_without_securing_holes(w) children();
        securing_holes();
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
        bump_len = corner_len - w + wall + wall;
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

    difference() {
        translate([0, 0, -ext_h]) mount_without_securing_holes(w) side();
        translate([0, -w/2 + wall - 1.8, base + (corner_h - base) / 2]) rotate([-90, 0, 0]) rotate([0, 0, 90]) securing_hole();
    }
}

//back_left();
back_right();
//front();