include <utils.scad>

$fa = 1;
$fs = 1;

box=[80, 80, 40];
plate=box[1]*.66;
wall=1.2;
wire_gasket_d = 15;
cat5_punch_out = [15, 20, wall];
screw_post_d = 10.4;
screw_post_clearance_d = 8;
screw_post_clearance_h = box[2] - 5;

dirs = [ [0, 0], [1, 0], [1, 1], [0, 1]];

module screw_post(dir) {
    translate([box[0]*dir[0], box[1]*dir[1], 0]) cylinder(d = screw_post_d, h = box[2]);
}

module screw_holes(dir) {
    translate([box[0]*dir[0], box[1]*dir[1], 0]) union() {
        cylinder(d = screw_post_clearance_d, h = screw_post_clearance_h);
        translate([0, 0, screw_post_clearance_h]) cylinder(d = M3_through_hole_d(), h = box[2] - screw_post_clearance_h);
    }
}

difference() {
    union() {
        difference() {
            cube(box);
            translate([wall, wall, wall]) cube(box - [2*wall, wall, wall]);
        }
        for (dir = dirs) {
            screw_post(dir);
        }
    }
    for (dir = dirs) {
        screw_holes(dir);
    }
}

translate([0, plate, 0]) rotate([90, 0, 0]) difference() {
    cube([box[0], box[2], wall]);
    d = (box[0] - wall*2 - cat5_punch_out[0]*2) / 3;
    translate([wall+d, box[2]/2-cat5_punch_out[1]/2, 0]) cube(cat5_punch_out);
    translate([wall+d*2+cat5_punch_out[0], box[2]/2-cat5_punch_out[1]/2, 0]) cube(cat5_punch_out);
    echo(d, cat5_punch_out[0]);
}