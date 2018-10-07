include <utils_threads.scad>

$fn=100;

module mount(h=9) {
    difference() {
        cylinder(d=6.6, h=h);
        cylinder(d=M3_tapping_hole_d(), h=h);
    }
}

T=4;
a_holes=[ [3.3, 3.3], [127-3.3, 3.3], [127-3.3, 85-3.3], [3.3, 85-3.3] ];
m_holes=[ [3.3, -3.3], [3.3, 92-3.3], [3.3+42.5, -3.3], [3.3+42.5, 92-3.3] ]; 
difference() {
    union() {
        translate([0, -7, 0]) cube([127, 85+14, T]);
        for (i = [0:3]) {
            translate([a_holes[i][0], a_holes[i][1], T]) mount();
        }
    };
    for (i = [0:3]) {
        translate([a_holes[i][0], a_holes[i][1], 0]) cylinder(d=M3_through_hole_d(), h=T);
    }
    for (i = [0:3]) {
        translate([m_holes[i][0], m_holes[i][1], 0]) cylinder(d=M3_through_hole_d(), h=T);
    }
}