include <utils_threads.scad>
include <pulleys.scad>
include <wiper-motor.scad>

$fa=1;
$fs=0.6;

wall=2;
pvc_od=27;      // sch 40 pvc, 3/4" id
hole=quarter_twenty_through_hole_d();

bearing_h = 7;
bearing_inner_d = 16;
bearing_d = 22.05;

module nut(h = 7, d=12.5) {
    linear_extrude(height=h) difference() {
        offset(delta=wall) circle(d=d, $fn=6);
        circle(d=d, $fn=6);
    }
}

module cap(h=5, base=wall) {
    id=pvc_od;
    difference() {
        cylinder(d=id+wall*2, h=h);
        translate([0, 0, base]) cylinder(d=id, h=h);
    }
}    

module pvc_mount() {
    difference() {
        cap(h=5+wall, base=wall*2);
        cylinder(d=hole, h=wall*2);
    }
}

module bearing_mount() {
    len = 75;
    d=bearing_d + wall*2;
    h=bearing_h + wall;
    hole_d=inch_to_mm(0.177);
    w=hole_d + wall*4;
    module bearing() {
        difference() {
            cylinder(d = d, h=h);
            translate([0, 0, 0]) cylinder(d = bearing_inner_d, h=h);
            translate([0, 0, wall*2]) cylinder(d = bearing_d, h=h-wall);
            cylinder(d=quarter_twenty_through_hole_d(), h=wall);
        }
    }

    module place_bearing() {
        translate([0, 0, d/2+wall*2]) rotate([0, 90, 0]) children();
    }
    
    module mount() {
        place_bearing() bearing();
        difference() {
            translate([0, -d/2, wall*2]) cube([h, d, d/2]);
            place_bearing() cylinder(d=d, h=h);
        }
        translate([0, -len/2, 0]) cube([w, len, wall*2]);
    }
    
    module holes() {
        for (at = [-len/3, len/3]) {
            translate([w/2, at, 0]) cylinder(d=hole_d, h=100);
        }
    }
    
    difference() {
        mount();
        holes();
    }
        
}
    
module pvc_drive_pulley() {
    pulley(profile = PULLEY_XL, teeth = 12, motor_shaft=quarter_twenty_through_hole_d(), pulley_b_dia=30, pulley_b_ht=10, no_of_nuts=2);
}

motor_mount_d = 35;

module motor_pulley() {
    translate([0, 0, -wiper_motor_cap_h()]) wiper_motor_cap(outer_d = motor_mount_d, recessed_h = wiper_motor_cap_h()-2);
    pulley(profile = PULLEY_XL, teeth = 12, motor_shaft=0, pulley_b_ht=0);    
}

//pvc_mount();
//rotate([0, -90, 0])
bearing_mount();
//pvc_drive_pulley();
//rotate([0, 180, 0]) wiper_motor_mount(outer_d = motor_mount_d);
//motor_pulley();