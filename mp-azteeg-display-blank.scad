include <utils_threads.scad>

module inside() {
    cube([150, 70, 2]);
}

module outside() {
    linear_extrude(height=2) polygon( [
        [ 13, 6 ], [137, 6], [150-6, 13], [150 - 6, 70 - 13], [137, 70 - 6], [13, 70 - 6], [6, 70-13], [6, 13]
    ]);
}

difference() {
    union() {
        inside();
        translate([0, 0, 2]) outside();
    }
    for (x = [5, 150-5]) for (y = [5, 70-5]) translate([x, y, 0]) cylinder(d=M3_tapping_hole_d(), h=100, $fn=100);
}
