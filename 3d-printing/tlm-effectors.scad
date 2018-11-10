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
    

module carriage_adaptor(arm_spacing = 40) {
    wall=5;
    T=10;
    ext=15;
    box=[45+wall*2, 10+wall*2, T];
    union() {
        difference() {
            cube(box, center=true);
            cube(box - [wall*2, wall*2, 0], center=true);
            translate([-100, 0, 0]) rotate([0, 90, 0]) cylinder(d=M4_through_hole_d(), h=200);
        }
        translate([-5, (box[1]-wall*2)/2+0.5, T/2]) linear_extrude(height=0.6) text(text=str(arm_spacing), size=4, font="Courier New");
        translate([0, 5+wall, 0]) rotate([-90, 0, 0]) ball_cup_arm_mounts(arm_spacing);
    }
}

module carriage(arm_spacing = 35) {
    wheel_d = 15.23;
    wheel_x = 105 - wheel_d;
    gap_between_wheels = 10;
    belt_gap = 10;
    wall = 4;
    hole_d = M5_tight_through_hole_d();
    eccentric_hole_d = 7.15;
    
    w = wheel_x + wheel_d + wall * 2;
    h_for_wheels = wheel_d*2 + wall*2 + gap_between_wheels;
    h_for_belt_tightener = 30 + wall + M3_through_hole_d() + wall*2;
    h = max(h_for_wheels, h_for_belt_tightener);
    
    full = [ w, h, 10];

    module plate() {        
        difference() {
            translate([-full[0]/2, -full[1]/2, 0]) union() {
                rounded_cube(full, r = 5);
                translate([full[0]*.25, full[1]*.75 - 5, full[2]]) linear_extrude(height = 1) text(str(arm_spacing), font="Courier New", size=10);
            }
            for (y = [ 1, -1]) {
                y = y * (full[1]/2 - wall*2 - hole_d / 2);
                translate([wheel_x/2, y, 0]) cylinder(d = hole_d, h=100);
            }
            translate([-wheel_x/2-0.5, 0, 0]) cylinder(d = eccentric_hole_d, h=100);
        }
    }
    
    module belt_tightener_fixed() {
        translate([5, full[1]/2 - wall - M3_through_hole_d()/2, 0]) union() {
            cylinder(d = M3_through_hole_d(), h=full[2]);
            translate([0, 0, full[2] - 3]) M3_nut_insert_cutout(h=4);
        }
    }

    module belt_tightener_adjustable() {
        slot_w = wall*2;
        slot_h = 8;
        slot_len = 14+wall;
        angle = 30;
        dovetail_w = dovetail_width(w=slot_w, h=slot_h, angle=angle);
        
        translate([0, slot_len - full[1]/2 + wall, 0]) rotate([90, 0, 0]) dovetail(w=slot_w+0.1, h=slot_h+0.3, len=slot_len, angle=angle);
        translate([-dovetail_w/2+0.05, -full[1]/2 + wall + slot_len, 0]) cube([dovetail_w+.2, wall*2 + 1, slot_h + 0.3]);
        translate([0, -full[1]/2 + wall + slot_len, slot_h/2]) rotate([90, 0, 0]) cylinder(d = M3_through_hole_d(), h=100);
    }

    difference() {
        union() {
            plate();
            translate([0, 0, full[2]]) ball_cup_arm_mounts(arm_spacing);
        }
        belt_tightener_fixed();
        translate([belt_gap/2, 0, 0]) belt_tightener_adjustable();
    }
}

module carriage_belt_clip(spacer = 5, mink = 2, center=false) {
    module raw_clip() {
        belt_w = 6;
        belt_w_slop = 0.5;
        wall = 4;
        belt_depth = 1.5;
        belt_depth_slop = 0.5;
        
        inner_after_mink = [ wall, belt_depth + belt_depth_slop, belt_w + belt_w_slop ];
        outer_after_mink = [ 0, wall * 2, spacer + wall] + inner_after_mink;
        outer = outer_after_mink - [mink, mink, mink];
        inner = inner_after_mink + [mink, mink, mink];
        
        echo(inner_after_mink);
        echo(outer_after_mink);
        
        translate([center ? -outer[0]/2 : mink/2, 0, -outer_after_mink[2]+mink/2])
        difference() {
            cube(outer);
            translate([(outer[0] - inner[0]) / 2, (outer[1] - inner[1]) / 2,  wall - mink]) cube(inner);
        }
    }
    
    intersection() {
        minkowski() {
            raw_clip();
            cylinder(d=mink, h=mink, center=true);
        }
        translate([-50, 0, -50]) cube([100, 50, 50]);
    }

}

module carriage_belt_tightener_fixed() {
    wall = 4;
    base = [20, M3_through_hole_d() + wall*2, wall];
    mink = 2;
    
    module top_mount() {
        union() {
            cube(base);
            translate([0, base[1], 0]) cube([base[0], wall, wall*3]);
        }
    }

    difference() {
        union() {
            top_mount();
            carriage_belt_clip(mink=mink, spacer=10-wall);
        }
        translate([wall+base[0]/2, base[1]/2, 0]) cylinder(d = M3_through_hole_d(), h = 100);
    }
}

module carriage_belt_tightener_adjustable() {
    wall=4;
    mink=2;
    
    module top_mount() {
        slot_h = 8;
        translate([0, wall*2, slot_h/2]) rotate([90, 0, 0]) difference() {
            translate([0, -slot_h/2, 0]) dovetail(w=wall*2, h=slot_h, len=wall*2, angle=30);
            cylinder(d = M3_through_hole_d(), h = 100);
            M3_nut_insert_cutout();
        }
    }

    top_mount();
    carriage_belt_clip(mink=mink, spacer=9, center=true);
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

carriage(35);
//rotate([0, -90, 0]) carriage_belt_tightener_fixed();
//rotate([90, 0, 0]) carriage_belt_tightener_adjustable();

endstop_mount();

//carriage_adaptor();
//carriage_adaptor(35);

//clip_effector_blank();

//rotate([90, 0, 0])  blank_effector_carriage_adaptor(arm_spacing = 40);