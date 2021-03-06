include <utils.scad>

$fa = 1;
$fs = 0.6;

outer_d = 35;
motor_shaft_d1 = 10;
shaft_d = inch_to_mm(.25);
nut_d = 18;
nut_h = 8;
gap = 10;
solid_h = 4;

module screw_holes(d) {
    for (angle = [ 0, 90, 180, 270 ]) {
        rotate([0, 0, angle]) translate([0, outer_d/2 - (outer_d - nut_d)/4, 0]) cylinder(d = d, h=100);
    }
}

module motor() {
    difference() {
        bolt_d = 6;
        base_h = 5;
        cylinder(d=outer_d, h=base_h + solid_h);
        cylinder(d1 = 10, d2 = 8.75, h=base_h);
        cylinder(d=6, h=100);
        screw_holes(M3_tapping_hole_d());
    }
}

module shaft() {
    difference() {
        screw_h = 4;
        cylinder(d = outer_d, h = nut_h * 2 + solid_h);
        cylinder(d = nut_d, h = nut_h * 2);
        cylinder(d = shaft_d, h = 100);
        screw_holes(M3_through_hole_d());
        translate([0, 0, screw_h]) screw_holes(6);
    }
}

module toothbrush_bottom_scan() {
    rotate([0, 0, 90]) translate([365, 18, 0]) import("stl/toothbrush-low-no-bristles-chubby-bottom.stl");
}
    
module toothbrush_mount() {
    mount = [70, 125, 20];
    difference() {
        for (angle = [0:90:270]) {
            rotate([0, 0, angle]) difference() {
                translate([-mount[0]/2, 0, 0]) cube(mount);
                translate([0, 60, -5]) toothbrush_bottom_scan();
            }
        }
        translate([0, 0, 10]) cylinder(d=40, h=100);
        cylinder(d = quarter_twenty_through_hole_d(), h=100);
    }
}

//toothbrush_mount();
rotate([0, 180, 0]) shaft();