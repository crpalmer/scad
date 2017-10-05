include <utils.scad>

$fn=100;

mount_thick = 2.25;
thick=4;
height=inch_to_mm(6.25);
depth=inch_to_mm(4);
mount_w=30;
arm_base_w=mount_w*3;
base_max_w=arm_base_w*1.5;

module mount() {
    union() {
        translate([-mount_w/2, 0, 0]) cylinder(d=mount_w, h=mount_thick);
        translate([-mount_w/2, -mount_w/2, 0]) cube([mount_w, mount_w, mount_thick]);
        translate([mount_w/2, 0, 0]) linear_extrude(height=thick) polygon(points=[ [0, mount_w/2], [height, arm_base_w/2], [height, -arm_base_w/2], [0, -mount_w/2]]);
        translate([height+mount_w/2, 0, 0]) rotate([0, -90, 0]) linear_extrude(height=thick) polygon(points=[ [0, arm_base_w/2], [depth, base_max_w/2], [depth, -base_max_w/2], [0, -arm_base_w/2]]);
    };
}


difference() {
    mount();
    cylinder(d=8, h=100);
    translate([6.9, 6.9, 0]) cylinder(d=4.1, h=100);
    translate([-6.9, 6.9, 0]) cylinder(d=4.1, h=100);
    translate([6.9, -6.9, 0]) cylinder(d=4.1, h=100);
    translate([-6.9, -6.9, 0]) cylinder(d=4.1, h=100);
};