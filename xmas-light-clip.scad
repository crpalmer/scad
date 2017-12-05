include <arc.scad>
include <utils.scad>

W=3;

module clip() {
    clip_points = [
        [-10, 0], [-10-W, 0], [0, 10+W], [10, 2+W], [15, 5+W], [15, 5], [10, 2], [0, 10]
    ];

    linear_extrude(height=W*2)
        union() {
            translate([0, -40+W/2, 0]) 2D_arc(w=W, r=55, deg=87);
            translate([-27.75, -0.5, 0]) rotate([0, 0, 120]) 2D_arc(w=W, r=10, deg=90);
            translate([27.75, -0.5, 0]) rotate([0, 0, -120]) 2D_arc(w=W, r=10, deg=90);
            translate([0, 16, 0]) polygon(clip_points);
        }
}

module clip_x6() {
    for (x = [-90, 0, 90]) {
        for (y = [-40, 40]) {
            translate([x, y, 0]) clip();            
        }
    }
}

clip();