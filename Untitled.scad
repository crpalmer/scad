include <utils.scad>

$fn=100;

module ring() {
    union() {
        difference() {
            linear_extrude(height=inch_to_mm(2.0)) circle(d=inch_to_mm(4.5));
            linear_extrude(height=inch_to_mm(2.0)) circle(d=inch_to_mm(4.5) - 5);
        }    
    }
}

module bracket() {
    union() {
        translate([0, 0, inch_to_mm(2.5)/2]) difference() {
            cube([inch_to_mm(3.5), inch_to_mm(3.5), inch_to_mm(2.5)], center=true);
            cube([inch_to_mm(3.5)-10, inch_to_mm(3.5), inch_to_mm(2.5)], center=true);
        }
        difference() {
            cube([inch_to_mm(3.5), inch_to_mm(3.5), inch_to_mm(0.5)], center=true);
            cube([inch_to_mm(3.5)-10, inch_to_mm(3.5) - 10, inch_to_mm(0.5)], center=true);
        }
    }
    
}

bracket();