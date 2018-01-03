include <utils_threads.scad>

$fn=32;

top_h=2;
glass_h=3;
screw_recess=6.5;

module front_mount(is_left=true) {
    screw_to_side=(5.8+4.9)/2;
    lip=2;
    non_lip=screw_recess+2;
    w=screw_to_side*2;
    
    function side_offset() =
        is_left == true ?
            w : 
            w/2-(screw_to_side+lip*2)
    ;
    
    difference() {
        union() {
            cube([w, lip+non_lip, top_h]);
            cube([w, non_lip, glass_h+top_h]);
            translate([side_offset(), 0, 0]) cube([lip*2, 2*non_lip, top_h+glass_h]);
        }
        translate([w/2, non_lip/2, 0]) cylinder(d=M3_through_hole_d(), h=100);
        translate([w/2, non_lip/2, 0]) cylinder(d=screw_recess, h=top_h+glass_h-1);
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

translate([-10, 0, 0]) rotate([0, -90, 0]) front_mount(false);
//translate([0, 0, 0]) rotate([0, 90, 0]) front_mount(true);
//translate([30, 0, 0]) back_mount();
