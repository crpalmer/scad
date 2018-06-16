include <utils.scad>

M=1;
$fn=100;

filament_tube_d=2.1;

module sensor_mount() {
    translate([M, M, M]) minkowski() {
        union() {
            cube([30-M*2, 15-M*2, 14.5-M*2]); // Sensor mount
            translate([8.5, 15-M*2, 0]) cube([9-M, 10-M, 11.5-M*2]); // Filament tube
        }
        sphere([M, M, M]);
    };
}

module filament_holes() {
    union() {
        rotate([-90, 0, 0]) tapered_cylinder(d0=filament_tube_d*2, d1=filament_tube_d, h=4.1);
        translate([0, 35, 0]) rotate([90, 0, 0]) tapered_cylinder(d0=7, d1=filament_tube_d, h=4.1);
        rotate([-90, 0,0]) cylinder(d=filament_tube_d, h=1000);
    }
}

module sensor_peep_hole() {
        P=6;
        translate([10, 3.5-P/2, 1.75]) cube([6, P, 1.5]); // cut down on the visible area to make the filament easier to spot
}


module sensor_holes() {
    union() {
        translate([6.6, 0, 0]) cube([5.125, 7, 10.5]);  // left sensor
        translate([14.675, 0, 0]) cube([5.125, 7, 10.5]); // right sensor
        translate([0, 0, 7.5]) cube([25.5, 7, 3.5]); // top cutout
        translate([3.5, 3.5, 0]) cylinder(d=3, h=20); // screw hole (left)
        translate([24.25-2, 3.5, 0]) cylinder(d=3, h=20); // screw hole (right)
        sensor_peep_hole();
    };
}
module full_mount() {
difference() {
    sensor_mount();
    translate([0, 4, 4]) sensor_holes();
    translate([13, 0, 6.5]) filament_holes();
};
}

full_mount();
