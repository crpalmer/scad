include <utils.scad>

MM=1.5;
M=MM;
$fn=100;

lower_h=7;
filament_tube_d=2.1;
peep_hole_d=1;

module sensor_mount() {
    union() {
        translate([24.8-M, 0, 0]) cube([30-M, 10-M, 17.5-M]); // Sensor mount
        translate([36.05-M-3, 0, 0]) cube([9-M, 20-M, 13.5-M]); // Filament tube
    };
}

module base_frame()
{
    union() {
        cube([20-M, 20-M, lower_h-M]); // Left side screw plate
        cube([55-M, 10-M, lower_h-M]); // Bottom base portion
        sensor_mount();
        translate([50+M/2, 0, 0]) cube([5-M, 76-M, lower_h-M]); // Right base
        translate([39+M/2, 65+M/2, 0]) cube([16-M, 11-M, lower_h-M]); // Right screw plate
    };
}

module screw_holes()
{
    union() {
        translate([4.5, 15, 0]) union() {
            cylinder(d=3.25, h=20, center=true);
            translate([0, 0, 13]) cylinder(d=7, h=20, center=true);
        };
        translate([47, 71, 0]) {
            cylinder(d=3.25, h=20, center=true);
            translate([0, 0, 13]) cylinder(d=7, h=20, center=true);
        };
    };
}

module filament_holes() {
    translate([36, 0, 10])
        union() {
            translate([0, -0.25, 0]) rotate([-90, 0, 0]) tapered_cylinder(d0=filament_tube_d*2, d1=filament_tube_d, h=2);
            translate([0, 20.25, 0]) rotate([90, 0, 0]) tapered_cylinder(d0=filament_tube_d*2, d1=filament_tube_d, h=2);
            translate([-filament_tube_d/2, 0.875, -1.125]) cube([filament_tube_d, 18.5, 3]);
        };
}

module sensor_peep_hole() {
        P=4;
        translate([11, 3.5-P/2, 2.5]) cube([5, P, 1]); // cut down on the visible area to make the filament easier to spot
}

module sensor_holes() {
    translate([22.8, 1.5, 7]) union() {
        translate([6.6, 0, 0]) cube([5.125, 7, 10.5]);  // left sensor
        translate([14.675, 0, 0]) cube([5.125, 7, 10.5]); // right sensor
        translate([0, 0, 7.5]) cube([25.5, 7, 3.5]); // top cutout
        translate([3.5, 3.5, 0]) cylinder(d=3, h=20); // screw hole (left)
        translate([24.25-2, 3.5, 0]) cylinder(d=3, h=20); // screw hole (right)
        sensor_peep_hole();
    };
}

module generate_full_mount() {
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

module sensor_module_only() {
    translate([-20, 0, -8])
        difference() {
            translate([M/2, M/2, M/2]) minkowski() {
                sensor_mount();
                sphere([MM, MM, MM]);
            };
            filament_holes();
            sensor_holes();
            translate([-10, -10, -10]) cube([100, 100, 18]);
        }
    ;
}

module doit3() {
    union() {
        filament_holes();
        sensor_holes();
    };
}


//sensor_module_only();
generate_full_mount();