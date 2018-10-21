include <utils_threads.scad>
include <high-detail.scad>

holes = [ [4.119, 4], [96.119, 4], [4.4, 119], [96.4, 119] ];

module board_mount() {
    difference() {
        union() {
            cube([100, 123, 2]);
            for (xy = holes) {
                translate(xy) cylinder(d=6, h=6);
            }
        }
        for (xy = holes) {
            translate(xy) cylinder(d=M3_through_hole_d(), h=10);
        }
    }
}

module msm_spacer() {
    difference() {
        cylinder(d=6, h=9);
        cylinder(d = M3_tapping_hole_d(), h=10);
    }
}

board_mount();
//msm_spacer();