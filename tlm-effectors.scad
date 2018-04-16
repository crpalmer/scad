include <utils_threads.scad>
include <tlm-effector-blank.scad>

$fn=64;
//util_threads_fake_heat_set_holes = true;

module our_blank_effector(T=8)
{
//    blank_effector(arm_spacing=60, arm_offset = 30, arm_mount_len = M4_long_heat_set_h(), T=T);
    blank_effector();
}

module chimera_orientation_tabs()
{
    w=1.2;
    h=1.2;

    for (x = [-15.05-w, 15.05]) {
        translate([x, -11, -h]) cube([w, 16, h]);
    }
}

module chimera_top_mounting_holes(d=M3_through_hole_d()) {
    translate([-8.5, -9, -50]) cylinder(d=d, h=100);
    translate([8.5, -9, -50]) cylinder(d=d, h=100);
    translate([0, 3, -50]) cylinder(d=d, h=100);
}

module chimera_boden_holes(d=5) {
    union() {
        translate([-9, 0, -50]) cylinder(d=d, h=100);
        translate([9, 0, -50]) cylinder(d=d, h=100);
        translate([-9, 0, 0]) cylinder(d=10, h=3);
        translate([9, 0, 0]) cylinder(d=10, h=3);
    };
}

module chimera_effector() {
    difference() {
        our_blank_effector();
        chimera_orientation_tabs();
        chimera_top_mounting_holes();
        chimera_boden_holes();
    }
}

module nimble_mount() {
    pad_extra = 8.427;
    union() {
        translate([-6.068, -5 - pad_extra, 0]) cube([11.8, 8 + pad_extra, 3.7]);
        translate([-3.6, -5.065, 3.7]) cube([7.130, 5.065+3.073, 2.614]);
        translate([-6.07, -2.265, 3.7]) cube([11.8, 2.490, 2.5]);
    }
}

nimble_plate = [27, 40, 5];
nimble_plate_offset = [-8, -15, 0];

nimble_plate_holes = [ [-5, 20, 0], [12, -10, 0]];
nimble_holes = [ [-2, 15, 0], [14, -2, 0]];

module nimble_mounting_holes(d = M3_heat_set_hole_d()) {
    for (h = nimble_holes) {
        translate(h) cylinder(d=d, h=100);
    }
}

module nimble_plate() {
    module plate_corner_nibble() {
        linear_extrude() polygon([[0, 25], [20, 3], [20, 25]]);
        linear_extrude() polygon([[13.75, -15], [19.25, -7], [19.5, -15]]);
    }
    
    difference() {
        union() {
            translate(nimble_plate_offset) cube(nimble_plate);
            translate([0, 0, nimble_plate[2]]) 
            nimble_mount(0);
        }
        plate_corner_nibble();
        nimble_mounting_holes();
        cylinder(d=5, h=100);
        for (hole = nimble_plate_holes) {
            translate(hole) M3_through_hole();
        }
        translate([-9, 0, 0]) chimera_top_mounting_holes(d=6);
    }
}

module nimble_plate_mounting_holes()
{
    for (h = nimble_plate_holes) {
        translate(h) M3_heat_set_hole(h=100);
    }
}

module chimera_dual_nimble_effector() {
    module nimble_holes() {
        nimble_plate_mounting_holes();
        nimble_mounting_holes(d = M3_through_hole_d());
    }

    difference() {
        union() {
            our_blank_effector(T=10);
            chimera_orientation_tabs();
        }
        chimera_top_mounting_holes();
        chimera_boden_holes();
        translate([9, 0, 0]) nimble_holes();
        translate([-9, 0, 0]) mirror([1, 0, 0]) nimble_holes();
    }
}

clip_d = 34;
clip_h = 5.9;
e3d_throat_d = 12;

clip_body_w = (clip_d - e3d_throat_d)/2;
hole_offset = clip_body_w / 2 + e3d_throat_d/2;

clip_holes = [ [-hole_offset, 0, 0],
               [ 0, -hole_offset, 0],
               [ 0, hole_offset, 0]];

module clip_blank() {
    difference() {
        intersection() {
            cylinder(d=clip_d, h=clip_h);
            translate([-clip_d/2, -clip_d/2, 0]) cube([clip_d*0.75, clip_d, 100]);
        }
        cylinder(d=e3d_throat_d, h=100);
        translate([0, -e3d_throat_d/2, 0]) cube([100, e3d_throat_d, 100]);
    }
}
    
module clip_effector_blank()
{
    module e3d_top_hole() {
        cylinder(d=17, h=100);
    }

    difference() {
        our_blank_effector();
        linear_extrude(height=4) offset(delta=0.1) projection() clip_blank();
        e3d_top_hole();
        for (hole = clip_holes) {
            translate(hole) cylinder(d=M3_through_hole_d(), h=100);
        }
    }
}
        
module e3d_nimble_effector() {
    difference() {
        clip_effector_blank();
        nimble_plate_mounting_holes();
    }
}
    
module e3d_clip() {
    difference() {
        clip_blank();
        for (hole = clip_holes) {
            translate(hole) M3_heat_set_hole(h=100);
        }
    }
}

module stock_effector() {
    module bl_touch_holes() {
        translate([-9, 30, 0]) M3_heat_set_hole(h=100);
        translate([9, 30, 0]) M3_heat_set_hole(h=100);
    }
    
    module fan_holes() {
        for (x = [-1, 1]) {
            for (y = [-1, 1]) {
                rotate([0, 0, -30]) translate([x*16, y*16, 0]) cylinder(d=M3_through_hole_d(), h=100);
            }
        }
    }
    
        
    difference() {
        clip_effector_blank();
        bl_touch_holes();
        fan_holes();
    }
}

module carriage_adaptor(arm_spacing = 60) {
    hsh = M4_long_heat_set_h();
    difference() {
        union() {
            cube([arm_spacing-hsh*2, 10, 10], center=true);
            translate([-22, -5, 5]) cube([5, 10, 10]);
            translate([22-5, -5, 5]) cube([5, 10, 10]);
            translate([arm_spacing/2 - hsh, 0, 0]) rotate([0, 90, 0]) cylinder(d=10, h=hsh-2);
            translate([-arm_spacing/2 + hsh, 0, 0]) rotate([0, -90, 0]) cylinder(d=10, h=hsh-2);
        }
    }
}

// Effectors
// ----------
//blank_effector();
//chimera_effector();
rotate([0, 180, 0]) chimera_dual_nimble_effector();
//rotate([0, 180, 0]) e3d_nimble_effector();
//rotate([0, 180, 0]) stock_effector();
//rotate([0, 180, 0]) e3d_clip();

// Right hand plate
//nimble_plate();
// Left hand plate
//mirror([1, 0, 0]) nimble_plate();

//carriage_adaptor();
