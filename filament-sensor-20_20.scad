include <utils.scad>
include <utils_threads.scad>

$fn=64;

wall = 4;
thread_len = 4.5;
thread_d = M5_tapping_hole_d();
filament_d = 2.25;

switch_body = [ 7, 25, 14 ];
switch_holes = [ 5.5, 15.0 ];
switch_hole_height = 3;
switch_arm_low = 17.5;
switch_arm_start = 15;
switch_arm_len = 10;
switch_arm_w = switch_body[0];
switch_ball_len = 5;

outer = [switch_body[0]+ wall*2, switch_body[1] + 2*wall + thread_len, switch_arm_low + wall + thread_d/2 ];

extrusion_body = [ wall, outer[1], 15 ];

module switch_arm_cutout()
{
    translate([-switch_arm_w/2, wall+switch_arm_start, switch_body[2]]) union(){
        cube([switch_arm_w, switch_arm_len, switch_arm_low - switch_body[2] + filament_d]);
        // Add a hole to let me push the switch down for testing and flexible filament
        translate([switch_arm_w/2, switch_arm_len - filament_d/2, 0]) cylinder(d=filament_d, h=100);
    }
}

module threaded_coupler()
{
    translate([0, outer[1] - thread_len - thread_len/2, switch_arm_low])
        rotate([-90, 0, 0])
        cylinder(d=thread_d, h=thread_len*2);
}

module filament_tube()
{
    translate([0, -10, switch_arm_low])
        rotate([-90, 0, 0])
        cylinder(d=filament_d, h=switch_body[1]*2+10);
}

module bowden_tube_in()
{
    filament_tube();
    translate([0, -10, switch_arm_low])
        rotate([-90, 0, 0])
        cylinder(d=4, h=switch_arm_start+switch_arm_len/2);
}

module bowden_tube_out()
{
    filament_tube();
    translate([0, outer[1] - thread_len - thread_len/2, switch_arm_low])
        rotate([-90, 0, 0])
        cylinder(d=4, h=100);
}

module switch_mounting_holes()
{
    module hole(d, at) {
        translate([0, wall + at, switch_hole_height])
            rotate([-90, 0, -90])
            cylinder(d=d, h=outer[0]/2+.5);
    }
    
    for (at = switch_holes) {
        union() {
            translate([-outer[0]/2, 0, 0]) hole(d=M3_tapping_hole_d(), at=at);
            hole(d=M3_through_hole_d(), at=at);
        }                
    } 
}

module extrusion_holes()
{
     for (pct = [ 0.25, 0.75 ]) {
        translate([-1, extrusion_body[1]*pct, -extrusion_body[2]/2]) rotate([0, -90, 0]) cylinder(d=M3_through_hole_d(), h=100);
     }
 }

module sensor_mount()
 {
     difference() {
        translate([-outer[0]/2, 0, 0]) union() {
            cube(outer);
            translate([0, 0, -extrusion_body[2]]) cube(extrusion_body);
        }
        translate([-switch_body[0]/2, wall, 0]) cube(switch_body);
//        threaded_coupler();
//        filament_tube();
        bowden_tube_in();
        bowden_tube_out();
        switch_arm_cutout();
        switch_mounting_holes();
        extrusion_holes();
    }
}


module extrusion_mount()
{
    W=2;
    
    difference() {
        union() {
            translate([-10, 0, 0]) cube([20, outer[1], W]);
            translate([3, 0, 0]) cube([W, outer[1], 30]);
            translate([3+W, 0, W]) linear_extrude(scale=[0.01, 1], height=10-3-W) square([10-3-W, outer[1]]);
        }
        for (pct = [0.25, 0.75]) {
            translate([0, extrusion_body[1]*pct, 0]) cylinder(d=M3_through_hole_d(), h=100);
            translate([0, extrusion_body[1]*pct, 25]) rotate([0, 90, 0]) cylinder(d=M3_through_hole_d(), h=100);
        }
    }
}

rotate([0, 180, 0])
   sensor_mount();

//extrusion_mount();