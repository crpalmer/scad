include <arc.scad>
include <utils.scad>

W=3;
use_edge_hook=1;
generate_x9=1;

hook_points = [
    [-10, 0], [-10-W, 0], [0, 10+W], [10, 2+W], [15, 5+W], [15, 5], [10, 2], [0, 10]
];

module centered_hook() {
    translate([0, 18.5, 0]) polygon(hook_points);
}

module edge_hook() {
    translate([-25, 12, 0]) rotate([0, 0, 25]) polygon(hook_points);
}

module hook() {
    if (use_edge_hook == 0) {
        centered_hook();
    } else {
        edge_hook();
    }
}

module clip() {
    linear_extrude(height=W*2)
        union() {
            translate([0, -40+W/2, 0]) 2D_arc(w=W, r=57, deg=87);
            translate([-30, -1.5, 0]) rotate([0, 0, 100]) 2D_arc(w=W, r=10, deg=80);
            translate([30, -1.5, 0]) rotate([0, 0, -100]) 2D_arc(w=W, r=10, deg=80);
            hook();
        }
}

module clip_x9() {
    for (x = [-90, 0, 90]) {
        for (y = [-40, 0, 40]) {
            translate([x, y, 0]) clip();            
        }
    }
}

if (generate_x9 == 0) {
    clip();
} else {
    clip_x9();
}
