include <utils.scad>

M=1;
$fn=100;

filament_tube_d=3.1;

module sensor_mount() {
    translate([M, M, M]) minkowski() {
        cube([30-M*2, 15-M*2, 14.5-M*2]); // Sensor mount
        sphere([M, M, M]);
    };
}

module filament_holes() {
    rotate([-90, 0, 0]) tapered_cylinder(d0=filament_tube_d*2, d1=filament_tube_d, h=4.1);
    translate([0, 15, 0]) rotate([90, 0, 0]) tapered_cylinder(d0=7, d1=filament_tube_d, h=4.1);
}

module sensor_holes() {
    union() {
        translate([6.6, 0, 0]) cube([13.2, 7, 10.5]);
        translate([0, 0, 7.5]) cube([25.5, 7, 3.5]); // top cutout
        translate([24.25-2, 3.5, 0]) cylinder(d=3, h=20); // screw hole
    };
}

module a() {
difference() {
    sensor_mount();
    translate([0, 4, 4]) sensor_holes();
    translate([13, 0, 6.5]) filament_holes();
};
}

a();