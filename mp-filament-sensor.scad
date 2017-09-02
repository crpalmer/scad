include <utils.scad>

MM=1.5;
M=MM;
$fn=10;

module base_frame()
{
    union() {
        cube([20-M, 20-M, 9-M]);
        cube([55-M, 10.25-M, 9-M]);
        translate([20-M, 0, 0]) cube([32-M, 10-M, 19-M]);
        translate([50+M/2, 0, 0]) cube([5-M, 76-M, 9-M]);
        translate([39+M/2, 65+M/2, 0]) cube([16-M, 11-M, 9-M]);
    };
}

module screw_holes()
{
    union() {
        translate([4.9, 15, 0]) union() {
            cylinder(d=3.25, h=20, center=true);
            translate([0, 0, 13]) cylinder(d=7, h=20, center=true);
        };
        translate([47, 71, 0]) {
            cylinder(d=3.25, h=20, center=true);
            translate([0, 0, 13]) cylinder(d=7, h=20, center=true);
        };
        translate([47, 15, 0])
            union() {
                cylinder(d=8, h=10, center=true);
                translate([0, 0, 5]) tapered_cylinder(d0=8, d1=0.01, h=5);
            };
    };
}

module filament_holes() {
    translate([35, 0, 11])
        union() {
            rotate([-90, 0, 0]) cylinder(d=2, h=50, center=true);
            rotate([-90, 0, 0]) tapered_cylinder(d0=4, d1=2, h=1);
            translate([0, 2, 0]) rotate([90, 0, 0]) tapered_cylinder(d0=4, d1=2, h=1);
            translate([0, 10.25, 0]) rotate([90, 0, 0]) tapered_cylinder(d0=4, d1=2, h=1);
            translate([0, 9.25, 0]) rotate([-90, 0, 0]) tapered_cylinder(d0=4, d1=2, h=1);
        };
}

module sensor_holes() {
    translate([22, 2, 10]) union() {
        cube([24.5, 6.25, 10.5]);
        translate([11.5, 0, 3]) cube([12.5, 6.25, 7]);
    };
}

difference() {
    translate([M/2, M/2, M/2]) minkowski() {
        base_frame();
        sphere([MM, MM, MM]);
    };
    screw_holes();
    filament_holes();
    sensor_holes();
};
