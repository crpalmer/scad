include <utils.scad>
include <wiper-motor.scad>

$fa = 1;
$fs = 0.6;

//rotate([0, 180, 0]) wiper_motor_mount();
rotate([0, 180, 0]) difference() {
    wiper_motor_cap();
    cylinder(d=inch_to_mm(0.255), h=wiper_motor_cap_h());
}