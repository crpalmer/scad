include <utils_threads.scad>
include <high-detail.scad>

h=3;
wall=4;
screw_top_d = 6;
screw_from_front = 4;
screw_from_side = 6.75;
screw_slot_len = 15-screw_top_d;
screw_delta_y = 153;
glass=130;

module screw_cutout() {
    recessed_screw_slot(d1=M3_through_hole_d(), d2=screw_top_d, h1=1, h2=h, len=screw_slot_len);
}

module front_mount_frame() {
    full=[wall+30+screw_from_side+screw_slot_len/2, screw_from_front + screw_top_d/2 + 30, h];
    difference() {
        cube(full);
        translate([wall, screw_from_front + screw_top_d/2, 0]) cube(full);
    }
}

module front_left_mount() {
    difference() {
        front_mount_frame();
        translate([wall+screw_from_side, screw_from_front+.001, 0]) rotate([0, 0, 90]) screw_cutout();
    }
}

module front_right_mount() {
    difference() {
        mirror([1, 0, 0]) front_mount_frame();
        translate([-(wall+screw_from_side), screw_from_front+.001, 0]) rotate([0, 0, 90]) screw_cutout();
    }
}

module back_mount() {
    difference() {
        cube([screw_top_d+wall*2, screw_delta_y - glass + wall + screw_slot_len/2 - screw_top_d, h]);
        translate([wall + screw_top_d/2, wall + screw_slot_len/2, 0]) screw_cutout();
    }
}

module bed_spacer() {
    difference() {
        cylinder(d=M3_through_hole_d() + wall*2, h=5);
        cylinder(d=M3_through_hole_d(), h=10);
    }
}

bed_spacer();
//back_mount();
//front_left_mount();
//front_right_mount();
