$fn = 128;

d=13;
wall = 5;
h=20;

holder_d = d + wall*2;

module holder() {
    difference() {
        union() {
            cylinder(d = holder_d, h=h);
            translate([0, -holder_d/2, 0]) cube([d/2 + wall, holder_d, h]);
        }
        translate([0, 0, 4]) union() {
            cylinder(d=d, h=100);
            translate([0, -d/2, 0]) cube([100, d, 100]);
        }
    }
}

module holder_with_screw_holes() {
    difference() {
        screw_d = 20;
        union() {
            cylinder(d=holder_d + screw_d, h=4);
            holder();
        }
        for (xy = [ [0, 1], [-1, 0], [0, -1] ]) {
            delta = holder_d / 2 + screw_d / 4;
            translate([xy[0] * delta, xy[1] * delta, 0]) cylinder(d=6, h=100);
        }
    }
}

holder();
//holder_with_screw_holes();