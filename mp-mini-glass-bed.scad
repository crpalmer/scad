include <utils_threads.scad>

$fn=32;

top_h=1;
glass_h=3;
screw_recess=6.5;

module front_mount() {
    screw_to_side=10;
    lip=4;
    side_w=4;
    side_l=15;
    non_lip=screw_recess+2;
    w=130+side_w*2;
    
    difference() {
        translate([-w/2, 0, 0]) union() {
            cube([w, non_lip+side_l, glass_h+top_h]);
        }
        translate([-65+lip, non_lip, 0]) cube([130-lip*2, 100, 100]);
        translate([-65, non_lip, top_h]) cube([130, 100, 100]);
        for (delta = [-1, +1]) {
            translate([delta*(w/2-screw_to_side), non_lip/2, 0]) union() {
                cylinder(d=M3_through_hole_d(), h=100);
                cylinder(d=screw_recess, h=glass_h+top_h-1);
            }
        }
    }
}

module back_mount() {
    difference() {
        union() {
            cube([10, 16, top_h]);
            cube([10, 8, glass_h+top_h]);
        }
        translate([5, 6, 0]) cylinder(d=M3_through_hole_d(), h=100);
    }
}

//translate([-10, 0, 0]) rotate([0, -90, 0]) front_mount(false);
//translate([0, 0, 0]) rotate([0, 90, 0]) front_mount(true);
//translate([30, 0, 0]) back_mount();
rotate([90, 0, 0]) front_mount();