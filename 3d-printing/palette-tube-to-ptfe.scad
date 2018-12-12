include <utils.scad>
include <high-detail.scad>

wall = 2;
gripper_l = 15;
tube_extension_l = 5;
tube_extension_block_l = 1;

module tube_gripper(tube_d) {
    module slit() {
        translate([-wall/2, -50, 0]) cube([wall, 100, gripper_l]);
    }
    
    module zip_tie_slot() {
        translate([0, 0, 5]) difference() {
            cylinder(d = tube_d + wall*2, h=5);
            cylinder(d = tube_d + wall, h=5);
            translate([0, 0, 4]) cylinder(d1=tube_d + wall, d2 = tube_d + wall*2, h=1);
            cylinder(d1=tube_d + wall*2, d2 = tube_d + wall, h=1);
        }
    }
    
    difference() {
        cylinder(d=tube_d + wall*2, h=gripper_l);
        cylinder(d=tube_d, h=gripper_l);
        slit();
        zip_tie_slot();
    }
}

module tube_extension(tube_d, real_tube_d) {
    difference() {
        cylinder(d = tube_d + wall*2, h = tube_extension_l);
        cylinder(d = real_tube_d, h = tube_extension_l);
    }
}

module tube_extension_block(tube_d, real_tube_d) {
    difference() {
        cylinder(d = tube_d+wall*2, h= tube_extension_block_l);
        cylinder(d1 = 3.5, d2 = real_tube_d, h = tube_extension_block_l);
    }
}

module tube(real_tube_d) {
    tube_d = real_tube_d + 0.5;
    tube_extension_block(tube_d, real_tube_d);
    translate([0, 0, tube_extension_block_l]) tube_extension(tube_d, real_tube_d);
    translate([0, 0, tube_extension_block_l + tube_extension_l]) tube_gripper(tube_d);
}

rotate([180, 0, 0]) tube(6);
tube(4);
