MM=1.5;
M=MM;
$fn=100;

module base_frame()
{
    union() {
        cube([55-M, 20-M, 10-M]);
        translate([50+M/2, 0, 0]) cube([5-M, 76-M, 10-M]);
        translate([39+M/2, 65+M/2, 0]) cube([16-M, 11-M, 10-M]);
    };
}

module screw_holes()
{
    union() {
        translate([4.9, 15, 0]) union() {
            cylinder(d=3.25, h=20, center=true);
            translate([0, 0, 10]) cylinder(d=6.25, h=10, center=true);
        };
        translate([47, 71, 0]) {
            cylinder(d=3.25, h=20, center=true);
            translate([0, 0, 10]) cylinder(d=6.25, h=10, center=true);
        };
        translate([47, 15, 0]) cylinder(d=8, h=20, center=true);
    };
}

difference() {
    translate([M/2, M/2, M/2]) minkowski() {
        sphere([MM, MM, MM]);
        base_frame();
    };
    screw_holes();
};