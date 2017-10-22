include <utils.scad>

$fn=100;

arm_len=inch_to_mm(6);
screw_d=4;
T=10;
bracket_T=4;

attacher=[T*2+bracket_T*3, screw_d*3 + T + bracket_T*2, T];

difference() {
    union() {
        translate([-T/2, 0, 0]) cube([T, arm_len, T]);
        translate([-attacher[0]/2, 0, 0]) cube(attacher);
    }
    translate([-attacher[0]/2+T, 0, 0]) cube(attacher - [2*T, T, 0]) ;
    translate([50, screw_d*1.5, screw_d]) rotate([0, -90, 0]) cylinder(d=screw_d, h=100);
    translate([50, arm_len - screw_d * 1.5, screw_d]) rotate([0, -90, 0]) cylinder(d=screw_d, h=100);
}
