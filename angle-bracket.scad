include <utils.scad>

hole_d=4;
arm_len=inch_to_mm(1.5);
arm_width=inch_to_mm(1);
thickness=inch_to_mm(1/8);

rotate([0, 0, 90]) cube([arm_len, arm_width, thickness]);
