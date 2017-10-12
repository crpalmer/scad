include <utils.scad>

angle=152;

$fn=100;

hole_d=4;
arm_len=inch_to_mm(1);
arm_width=inch_to_mm(1);
thickness=inch_to_mm(1/8);

module arm() {
    difference() {
        cube([arm_len, arm_width, thickness]);
        translate([(arm_len-thickness)/2 + thickness, arm_width/2, 0]) cylinder(d=hole_d, h=thickness);
    };
}

difference() {
    union() {
        translate([0, thickness, 0]) rotate([90, 0, 0]) arm();
        rotate([90, 0, 100]) arm();
    };
    cylinder(h=arm_width*3, d=thickness, center=true);
};
