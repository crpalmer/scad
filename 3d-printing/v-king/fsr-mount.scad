include <utils.scad>
include <high-detail.scad>
wall=4;
screw_delta=3.3/2+1.1;
board_W=30.5;

module mount() {
    translate([-30.5/2, -20/2, 0]) minkowski() {
        rounded_cube([board_W, 20-1, wall], r = 2);
        sphere(d=1);
    }
    translate([-board_W/2+screw_delta, 0, wall]) cylinder(d = M3_through_hole_d()+wall, h=wall);
    translate([board_W/2-screw_delta, 0, wall]) cylinder(d = M3_through_hole_d()+wall, h=wall);
}

difference() {
    mount();
    translate([-board_W/2+screw_delta, 0, -2]) cylinder(d = M3_through_hole_d(), h=100);
    translate([board_W/2-screw_delta, 0, -2]) cylinder(d = M3_through_hole_d(), h=100);
}
