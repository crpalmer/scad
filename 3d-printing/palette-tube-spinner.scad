include <utils.scad>

$fn = 128;

tube_d = 6.5;
real_tube_d = 6;
wall = 2;
gripper_l = 15;
tube_extension_l = 5;
tube_extension_block_l = 1;
filament_l = 10;
clip_d = 10;
clip_l = 25;
mount_len = 20;
ring_d = 10.5;
screw_plate_len = ring_d + wall*2;

module tube_gripper() {
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

module tube_extension() {
    difference() {
        cylinder(d = tube_d + wall*2, h = tube_extension_l);
        cylinder(d = real_tube_d, h = tube_extension_l);
    }
}

module tube_extension_block() {
    difference() {
        cylinder(d = tube_d+wall*2, h= tube_extension_block_l);
        cylinder(d1 = 3.5, d2 = real_tube_d, h = tube_extension_block_l);
    }
}

module tube_filament() {
    transition_l = (real_tube_d - 2)/2;
    filament_d = 3.5;
    difference() {
        cylinder(d = tube_d + wall*2, h=filament_l);
        cylinder(d1 = real_tube_d, d2 = filament_d, h = transition_l);
        translate([0, 0, filament_l - transition_l]) cylinder(d1 = filament_d, d2 = real_tube_d, h = transition_l);
        cylinder(d = filament_d, h=filament_l);
    }
}

module tube_clip() {
    module arm() {
        
        translate([clip_l, clip_d/2, 0]) difference() {
            linear_extrude(height=wall*2) polygon([ [1.25, -2], [-5, -2], [-5, 2]]);
            translate([0, -50, 0]) cube([100, 100, 100]);
        }
    }
    
    difference() {
        union() {
            rotate([0, 90, 0]) cylinder(d = clip_d, h = clip_l);
            arm();
            mirror([0, 1, 0]) arm();
        }
        cylinder(d = tube_d + wall*2, h = clip_d);
        translate([-50, -50, -50]) cube([100, 100, 50]);
        translate([0, -wall/2, 0]) cube([100, wall, 100]);
    }
}

module tube() {
    tube_clip();
    tube_extension_block();
    translate([0, 0, tube_extension_block_l]) tube_extension();
    translate([0, 0, tube_extension_block_l + tube_extension_l]) tube_gripper();
//    translate([0, 0, gripper_l + tube_extension_l]) tube_filament();
}

module mount_ring() {
    w=wall*3;
    difference() {
        cylinder(d=ring_d + w, h=w);
        cylinder(d=ring_d, h=w);
    }
}

module mount_screw_plate() {
    translate([-screw_plate_len, 0, mount_len - wall*2]) 
    difference() {
        cube([screw_plate_len, ring_d, wall*2]);
        translate([screw_plate_len/2+wall, ring_d/2, 0]) cylinder(d = M3_through_hole_d(), h=100);
        translate([0, ring_d - 5, 0]) rotate([0, 0, 45]) cube([10, 10, wall*2]);
        translate([-10, 0, 0]) rotate([0, 0, -45]) cube([10, 10, wall*2]);
    }
}

module mount() {
    translate([-ring_d/2, ring_d/2, 0]) mount_ring();
    cube([wall*2, ring_d, mount_len]);
    mount_screw_plate();
}

tube();
//rotate([0, 90, 0]) mount();
