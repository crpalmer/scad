include <utils_threads.scad>
include <tlm-effector-blank.scad>

$fn=128;
//util_threads_fake_heat_set_holes = true;

module chimera_orientation_tabs()
{
    w=1.2;
    h=1.2;

    for (x = [-15.05-w, 15.05]) {
        translate([x, -11, -h]) cube([w, 16, h]);
    }
}

module chimera_top_mounting_holes(d=M3_through_hole_d()) {
    for (dz = [[d, -50], [d*2, 4]]) {
        union() {
            translate([-8.5, -9, dz[1]]) cylinder(d=dz[0], h=100);
            translate([8.5, -9, dz[1]]) cylinder(d=dz[0], h=100);
            translate([0, 3, dz[1]]) cylinder(d=dz[0], h=100);
        }
    }
}

module chimera_boden_holes(d=5) {
    union() {
        translate([-9, 0, -50]) cylinder(d=11, h=100);
        translate([9, 0, -50]) cylinder(d=11, h=100);
    };
}

module chimera_effector() {
    arm_spacing = 40;
    arm_offset = 25;
    arm_extension = 10;
    arm_mount_len = 10;
    fan_bumpout = 0 ;
    T=10;

    difference() {
        translate([0, 0, T]) rotate([0, 180, 0]) blank_effector(T=T, arm_spacing = arm_spacing, arm_offset = arm_offset, arm_extension = arm_extension, arm_mount_len = arm_mount_len, fan_bumpout = fan_bumpout);
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
    }
}

module chimera_nimble_plate() {
    difference() {
        nimble_plate();
        translate([-9, 0, 0]) chimera_top_mounting_holes(d=6);
    }
}

module e3dv6_nimble_plate() {
    difference() {
        nimble_plate();
        for (hole = clip_holes) {
            translate(hole) cylinder(d=6, h=100);
        }
    }
}

module e3dv6_bowden_plate() {
    coupler_thread_len = 4.5;
    inner_tube_len = 12;
    difference() {
        union() {
            cylinder(d=34, h=4);
            cylinder(d=M5_tapping_hole_d()+8, h=inner_tube_len + coupler_thread_len);
        }
        cylinder(d1=5, d2 = M5_tapping_hole_d(), h=inner_tube_len+coupler_thread_len/4);
        cylinder(d=M5_tapping_hole_d(), h=100);
        for (hole = clip_holes) {
            translate(hole) M3_through_hole();
        }
    }
}

module nimble_plate_mounting_holes()
{
    for (h = nimble_plate_holes) {
        translate(h) M3_heat_set_hole(h=100);
    }
}

module nimble_holes() {
    nimble_plate_mounting_holes();
    nimble_mounting_holes(d = M3_through_hole_d());
}


module chimera_dual_nimble_effector() {
    difference() {
        union() {
            blank_effector(arm_offset = 25);
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
               rotate_around(110, [ -hole_offset, 0, 0]),
               rotate_around(-110, [ -hole_offset, 0, 0])];

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
    arm_spacing = 40;
    arm_offset = 25;
    arm_extension = 10;
    arm_mount_len = 10;
    fan_bumpout = 0 ;
    T=10;
    
    module e3d_top_hole() {
        cylinder(d=17, h=100);
    }
    
    module fan_mounting_holes() {
        translate([0, arm_offset + arm_extension/2 + fan_bumpout + 0.01, T/2]) rotate([90, 0, 0]) union() {
            translate([-7, 0, 0]) M3_heat_set_hole();
            translate([7, 0, 0]) M3_heat_set_hole();
        }
    }

    difference() {
        blank_effector(T=T, arm_spacing = arm_spacing, arm_offset = arm_offset, arm_extension = arm_extension, arm_mount_len = arm_mount_len, fan_bumpout = fan_bumpout);
        linear_extrude(height=6) offset(delta=0.1) projection() clip_blank();
        e3d_top_hole();
        for (hole = clip_holes) {
            translate(hole) cylinder(d=M3_through_hole_d(), h=100);
        }
        fan_mounting_holes();
    }
}
        
module e3d_nimble_effector() {
    difference() {
        clip_effector_blank();
        nimble_holes();
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

module carriage_adaptor(arm_spacing = 40) {
    wall=5;
    T=12;
    ext=15;
    union() {
        difference() {
            cube([45+wall*2, 10+wall*2, T], center=true);
            cube([45, 10, T], center=true);
            translate([-100, 0, 0]) rotate([0, 90, 0]) cylinder(d=M4_through_hole_d(), h=200);
        }
        translate([0, 10/2+wall + ext/2, 0]) difference() {
            cube([arm_spacing, ext, T], center=true);
            cube([arm_spacing-7*2, ext, T], center=true);
            translate([-100, ext/2-5, 0]) rotate([0, 90, 0]) cylinder(d=3, h=200);
        }
    }
}

// Effectors
// ----------
//blank_effector();
//chimera_effector();
//rotate([0, 180, 0]) stock_effector();

//rotate([0, 180, 0]) e3d_nimble_effector();
rotate([0, 180, 0]) e3d_clip();
//e3dv6_nimble_plate();
//e3dv6_bowden_plate();

//rotate([0, 180, 0]) chimera_dual_nimble_effector();
// Right hand plate
//chimera_nimble_plate();
// Left hand plate
//mirror([1, 0, 0]) chimera_nimble_plate();

//carriage_adaptor();

//clip_effector_blank();

//rotate([90, 0, 0])  blank_effector_carriage_adaptor(arm_spacing = 40);