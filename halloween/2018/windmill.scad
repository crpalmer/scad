include <utils.scad>

$fa = 1;
$fs = 0.6;

outer_d = 35;
motor_shaft_d1 = 10;
shaft_d = inch_to_mm(.25);
nut_d = 18;
nut_h = 6;
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
        cylinder(d = outer_d, h = nut_h * 2 + solid_h);
        cylinder(d = nut_d, h = nut_h * 2);
        cylinder(d = shaft_d, h = 100);
        screw_holes(M3_through_hole_d());
    }
}
        
//rotate([0, 180, 0]) motor();
rotate([0, 180, 0]) shaft();