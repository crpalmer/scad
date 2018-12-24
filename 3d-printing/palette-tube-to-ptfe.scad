include <utils.scad>
include <high-detail.scad>

wall = 2;
gripper_l = 15;

module tube_gripper(tube_d, ext_l) {
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
        cylinder(d=tube_d + wall*2, h=gripper_l + ext_l);
        cylinder(d=tube_d, h=gripper_l + ext_l);
        translate([0, 0, ext_l]) slit();
        translate([0, 0, ext_l]) zip_tie_slot();
    }
}

module filament_guide(outer_d, tube_d, filament_d, h) {
    difference() {
        cylinder(d = outer_d, h = h);
        cylinder(d2 = filament_d, d1 = tube_d, h = h);
    }
}

module adaptor() {
    palette_tube_d = 5.75;
    filament_d = 2.25;
    guide_h = 5;

    rotate([180, 0, 0]) tube_gripper(palette_tube_d, 2);
    translate([0, 0, 0]) filament_guide(palette_tube_d + wall*2, palette_tube_d, filament_d, guide_h);
    translate([0, 0, guide_h]) tube_gripper(4.25, 2.25);
}

module end_gripper() {
    tube_gripper(4.25, 2.25);
}

 adaptor();
//end_gripper();