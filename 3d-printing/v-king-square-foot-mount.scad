include <utils.scad>
include <utils_threads.scad>
include <high-detail.scad>

h=2;
difference() {
    union() {
        rounded_cube([22, 22, h], center=true);
        translate([0, 0, h/2]) cylinder(d=11, h=5);
    }
    translate([0, 0, -h]) cylinder(d=inch_to_mm(0.125), h=100);
}
