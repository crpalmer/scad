include <utils_threads.scad>
include <pulleys.scad>
include <wiper-motor.scad>

$fa=1;
$fs=0.6;

module pvc_drive_mount() {
    id=27;      // sch 40 pvc, 3/4" id
    wall=2;
    h=25;
    hole=quarter_twenty_through_hole_d();

    difference() {
        cylinder(d=id+wall*2, h=h);
        translate([0, 0, wall]) cylinder(d=id, h=h);
        cylinder(d=hole, h=wall);
        translate([-id/2-wall, 0, h-hole-wall]) rotate([0, 90, 0]) cylinder(d=hole, h=id+wall*2+10);
    }
}

module pvc_drive_pulley() {
    pulley(profile = PULLEY_XL, teeth = 12, motor_shaft=quarter_twenty_through_hole_d(), pulley_b_dia=30, pulley_b_ht=2, no_of_nuts=0);
}

module motor_pulley() {
    translate([0, 0, -wiper_motor_cap_h()]) wiper_motor_cap(outer_d = 40);
    pulley(profile = PULLEY_XL, teeth = 12, motor_shaft=0, pulley_b_ht=0);    
}

//pvc_drive_mount();
//pvc_drive_pulley();
//rotate([0, 180, 0]) wiper_motor_mount(outer_d = 40);
motor_pulley();