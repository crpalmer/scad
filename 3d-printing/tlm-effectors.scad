include <utils_threads.scad>
include <tlm-effector-blank.scad>
use <v-slot.scad>
include <high-detail.scad>

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
            translate(hole) cylinder(d=M3_tapping_hole_d(), h=100);
        }
        for (angle = [90, -90]) {
            translate([0, 0, clip_h/2]) rotate([0, 0, angle]) rotate([0, 90, 0]) cylinder(d=M3_tapping_hole_d(), h=100);
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

module ball_cup_arm_mounts(arm_spacing = 35) {
    arm_h = 11;
    arm_w = 7;
    arm_d = M3_tight_through_hole_d();
    w=10;

    module arm2d() {
        difference() {
            polygon([
                [ 0, 0],
                [ 0, arm_h + arm_d/2 ],
                [ arm_d, arm_h + arm_d*1.5 ],
                [ w - arm_d, arm_h + arm_d*1.5 ],
                [ w, arm_h + arm_d / 2 ],
                [ w, 0]
            ]);
            translate([w/2, arm_h]) circle(d = arm_d);
        }
    }
    
    module arm3d() {
        translate([-arm_spacing/2, -w/2, 0])
        union() {
            rotate([90, 0, 90]) linear_extrude(height = arm_w) arm2d();
            translate([arm_w, w, 0]) rotate([90, 0, 0]) linear_extrude(height=w) polygon([ [0, 0], [7, 0], [0, 7] ]);
        }

    }
    
    arm3d();
    mirror([1, 0, 0]) arm3d();
}
    

module carriage_adaptor(arm_spacing = 40, label) {
    wall=5;
    T=10;
    ext=15;
    box=[45.05+wall*2, 10+wall*2, T];
    label = (label == undef ? str(arm_spacing) : label);
    size = len(label) == 1 ? 10 : len(label) == 2 ? 7 : 4;
    union() {
        difference() {
            cube(box, center=true);
            cube(box - [wall*2, wall*2, 0], center=true);
            translate([-100, 0, 0]) rotate([0, 90, 0]) cylinder(d=M4_through_hole_d(), h=200);
        }
        translate([-arm_spacing/2+.5, (box[1]-wall*2)/2+0.5, T/2]) linear_extrude(height=1) text(text=label, size=size, font="Courier New");
        translate([0, 5+wall, 0]) rotate([-90, 0, 0]) ball_cup_arm_mounts(arm_spacing);
    }
}

carriage_h = 10; // 30mm bolts
carriage_belt_clip_spacing = 12.5;

module carriage(arm_spacing = 35) {
    wheel_d = 15.23;
    wheel_x = 80 + wheel_d - 4.75;
    gap_between_wheels = 40;
    wall = 2;
    hole_d = M5_tight_through_hole_d();
    eccentric_hole_d = 7.5;
    belt_gap = 10;
    
    w = wheel_x + wheel_d;
    h = gap_between_wheels + wheel_d;
    
    full = [ w, h, carriage_h];

    module plate() {
        module belt_clip_cutout() {
            for (x = carriage_belt_clip_spacing * [-.5, .5]) {
                translate([x, 0, 0]) cylinder(d = M3_through_hole_d(), h=full[2]);
            }
        }
        
        difference() {
            translate([-full[0]/2, -full[1]/2, 0]) rounded_cube(full, r = 5);
            belt_clip_cutout();
            for (y = [ 1, -1]) {
                y = y * gap_between_wheels/2;
                translate([wheel_x/2, y, 0]) cylinder(d = hole_d, h=100);
            }
            translate([-wheel_x/2, 0, 0]) cylinder(d = eccentric_hole_d, h=100);
        }
    }
    
    union() {
        plate();
        translate([0, full[1]/2-wall-8, full[2]])
            ball_cup_arm_mounts(arm_spacing);
    }
}

module carriage_belt_clip() {
    top_of_rail_to_bottom_of_carriage = 2;
    belt_width = 6;
    belt_tolerance = 0.5;
    wall = 2;
    clip_d = 3;
    clip_h = belt_width + belt_tolerance + wall;
    mink = 1;
    
    screw_mount = [25, 10, 5];
    clip = [wall-mink, clip_d + wall*2, clip_h];

    module screw_mount() {
        difference() {
            translate([-screw_mount[0]/2, -screw_mount[1]/2, 0]) rounded_cube(screw_mount);
            for (x = carriage_belt_clip_spacing/2 * [-1, 1]) {
                translate([x, 0, screw_mount[2]+.01]) rotate([180, 0, 0]) M3_heat_set_hole(h=screw_mount[2]+1);
            }
        }
    }

    screw_mount();
    translate([-clip[0]/2 - mink/2, -screw_mount[1]/2, top_of_rail_to_bottom_of_carriage]) cube([clip[0] + mink, screw_mount[1], clip[2]+.1]);
    
    for (angle = [0, 180]) {
        rotate([0, 0, angle]) translate([0, screw_mount[1]/2, 0]) clip();
    }
    
    module clip() {
        base = [clip[0]+ wall*2, clip[1], top_of_rail_to_bottom_of_carriage];
        
        module clip_raw() {
            difference() {
                cube(clip);
                translate([0, wall, 0]) cube([clip[0], clip_d, clip[2]-wall]);
            }
        }

        union() {
            minkowski() {
                union() {
                    translate([-clip[0]/2, 0, top_of_rail_to_bottom_of_carriage]) clip_raw();
                    translate([-base[0]/2, 0, 0]) cube(base);
                }
                cylinder(d=mink, h=0.1);
            }
        }
    }
}

module endstop_mount() {
    bottom_wall = 2;
    thick = [4.5, 5];
    switch_w = 20;
    hole_spacing = 9.5;
    hole_from_top = 4;
    outer = [23 + thick[1], 40 + thick[0], 8+M3_through_hole_d()+bottom_wall];

    module face() {
        difference() {
            cube(outer);
            translate([0, thick[0], 0]) cube([20, outer[1], outer[2]]);
            translate([20+thick[1], thick[0], 0]) cube(outer);
        }
    }
    
    module mount() {
        face();
        translate([10, thick[0]+1.5, 0]) rotate([0, 0, -90]) vslot_insert(depth=1.5, length=outer[2]);
        translate([20 - .5, thick[0] + 10, 0])vslot_insert(depth = .5, length=outer[2]);
        translate([20 - .5, thick[0] + 30, 0])vslot_insert(depth = .5, length=outer[2]);
    }
    
    module holes() {
        slot_hole_h = outer[2]/2;
        translate([20+2+thick[1], thick[0]+10, slot_hole_h]) rotate([-90, 0, 90]) M3_recessed_through_hole();
        translate([20+2+thick[1], thick[0]+30, slot_hole_h]) rotate([-90, 0, 90]) M3_recessed_through_hole();
        for (dir = [-1, +1]) {
            translate([8 + switch_w/2 + dir*hole_spacing/2, -.01, hole_from_top]) rotate([-90, 0, 0]) M3_heat_set_hole(h=thick[0]+0.4);
        }
    }

    difference() {
        mount();
        holes();
    }
}

module idler_mount() {
    extra_h = 4;
    mink=2;
    thick = 6;
    wide=20;
    
    module rough_shape() {
        polygon([
            [0, 0], [20, 0], [30, extra_h], [50, extra_h], [60, 0], [80, 0],
            [80, thick], [60, thick], [50, extra_h+thick], [30, extra_h+thick], [20, thick], [0, thick]
        ]);
    }
    
    module shape() {
        minkowski() {
            offset(delta=-mink/2) rough_shape();
            circle(d=mink);
        }
    }

    module shape3d() {
        translate([-40, wide/2, 0])
            rotate([90, 0, 0])
            linear_extrude(height = wide)
            shape();
    }
    
    difference() {
        shape3d();
        cylinder(d = M5_tight_through_hole_d(), h=100);
        for (x = [-30, 30]) translate([-x, 0, 0]) cylinder(d = M3_through_hole_d(), h=100);
    }
}

module linear_slide_mount() {
    full=[35, 15, 3];

    module vslot_mount() {
        translate([0, 0, full[2]/2]) rounded_cube(full, center=true);
        for (x = 10 * [-1, 1]) {
            translate([x, full[1]/2, -0.5]) rotate([0, -90, 90]) vslot_insert(depth = .5, length=full[1]);
        }
    }
    
    module guide_channel() {
        wall = 2;
        tolerance = .1;
        Wr = 7 - tolerance;
        H1 = 1.5 - tolerance;
        
        
        for (x = [-Wr/2-wall, Wr/2]) {
            translate([x, -full[1]/2, full[2]]) rounded_cube([wall, full[1], H1]);
        }
    }

    module body() {
        vslot_mount();
        guide_channel();
    }
    
    module holes() {
        cylinder(d = M2_heat_set_hole_d(), h=full[2]);
        for (x = 10 * [-1, 1]) {
            translate([x, 0, -10]) cylinder(d = M3_tight_through_hole_d(), h=full[2] + 10);
        }
    }

    difference() {
        body();
        holes();
    }
}
        
// Effectors
// ----------
//blank_effector();
//chimera_effector();
//rotate([0, 180, 0]) stock_effector();

//rotate([0, 180, 0]) e3d_nimble_effector();
//rotate([0, 180, 0]) e3d_clip();
//e3dv6_nimble_plate();
//e3dv6_bowden_plate();

//rotate([0, 180, 0]) chimera_dual_nimble_effector();
// Right hand plate
//chimera_nimble_plate();
// Left hand plate
//mirror([1, 0, 0]) chimera_nimble_plate();

carriage();
//carriage_belt_clip();
//idler_mount();
//endstop_mount();

//rotate([90, 0, 0])
//    linear_slide_mount();

//carriage_adaptor(34.6, "X");
//carriage_adaptor(34.6, "Y");
//carriage_adaptor(34.8, "Z");
//carriage_adaptor(35);

//clip_effector_blank();

//rotate([90, 0, 0])  blank_effector_carriage_adaptor(arm_spacing = 40);