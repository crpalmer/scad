include <utils.scad>

MM=1.5;
M=MM;
$fn=10;

module base_frame()
{
    union() {
        cube([20-M, 20-M, 9-M]);
        cube([55-M, 10.25-M, 9-M]);
        translate([22-M, 0, 0]) cube([30-M, 10-M, 19-M]);
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
//        translate([47, 15, 0])
//            union() {
//                cylinder(d=8, h=10, center=true);
//                translate([0, 0, 5]) tapered_cylinder(d0=8, d1=0.01, h=5);
//            };
    };
}

module filament_holes() {
    translate([34.25, 0, 13])
        union() {
            rotate([-90, 0, 0]) cylinder(d=2.25, h=50, center=true);
            rotate([-90, 0, 0]) tapered_cylinder(d0=4, d1=2.25, h=2);
            translate([0, 10.25, 0]) rotate([90, 0, 0]) tapered_cylinder(d0=4, d1=2.25, h=2);
        };
}

module sensor_holes() {
    translate([22, 1.5, 10]) union() {
        translate([5.6, 0, 0]) cube([5.25, 7, 10.5]);  // left sensor
        translate([13.5, 0, 0]) cube([5.25, 7, 10.5]); // right sensor
        translate([0, 0, 7.5]) cube([24.5, 7, 3]); // top cutout
        translate([24.5-2, 3.5, 5]) cylinder(d=3, h=5.5); // screw hole
        translate([12, 3.125, 3.125]) rotate([0, 90, 0]) cylinder(d=1, h=6, center=true); // cut down on the visible area to make the filament easier to spot
    };
}

module doit() {
difference() {
    translate([M/2, M/2, M/2]) minkowski() {
        base_frame();
        sphere([MM, MM, MM]);
    };
    screw_holes();
    filament_holes();
    sensor_holes();
};
}

module doit2() {
difference() {
    translate([22, 0, 0]) cube([30-M, 10, 19]);
    filament_holes();
    sensor_holes();
    cube([100, 100, 8]);
};
}

translate([-20, 0, -8]) doit2();