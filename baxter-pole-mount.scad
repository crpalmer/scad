include <utils_threads.scad>

$fn=100;

d=10;
bar_h = 8;
bar_gap = 3;
screw_d=3;
servo_screw_len=8;
nut_d=8.8 + 0.25*2;
gap=0.25;
hole_delta = [ 4.6, 4 ];
hole_offset=nut_d/2 + screw_d;
servo_clearance=[ 0.1, 0.1, 0 ];

servo = [40.4, 19.8, 29 ];
min_mount=[screw_d*3+nut_d*2, d+screw_d*3+nut_d*2, d/2 + screw_d - gap/2];
servo_mount = [ servo[0] + screw_d * 4 + hole_delta[0] * 2,
                  servo[1], servo[2] ];
mount = [ max(servo_mount[0], min_mount[0]), min_mount[1], min_mount[2] ];

module mount_screw_holes(h=mount[2]) {
    union() {
        translate([hole_offset, hole_offset, 0]) cylinder(d=screw_d, h=h);
        translate([mount[0] - hole_offset, hole_offset, 0]) cylinder(d=screw_d, h=h);
        translate([hole_offset, mount[1]-hole_offset, 0]) cylinder(d=screw_d, h=h);
        translate([mount[0] - hole_offset, mount[1]-hole_offset, 0]) cylinder(d=screw_d, h=h);
    }
}

module mount_nut_holes() {
        translate([hole_offset, hole_offset, 0]) No6_nut_insert_cutout();
        translate([mount[0] - hole_offset, hole_offset, 0]) No6_nut_insert_cutout();
        translate([hole_offset, mount[1]-hole_offset, 0]) No6_nut_insert_cutout();
        translate([mount[0] - hole_offset, mount[1]-hole_offset, 0]) No6_nut_insert_cutout();
}

module common_mount(mount=mount) {
    difference() {
        cube(mount);
        translate([0, mount[1]/2, mount[2]+gap]) rotate([0, 90, 0]) cylinder(d=d, h=mount[0], center=false);
    }
}

module bottom() {
    difference() {
        common_mount();
        mount_screw_holes();
        mount_nut_holes();
    }
}

module servo_mount() {
    module servo_mount_holes() {
        union() {
            for (dir=[ [1, 1], [1, -1], [-1, 1], [-1, -1] ])
                translate([dir[0]*(servo[0]/2 + hole_delta[0]), dir[1]*hole_delta[1], 0]) cylinder(d=screw_d, h=servo_mount[2]);
        }
    }
    
    translate(servo_mount/2) difference() {
        cube(servo_mount, center=true);
        cube(servo + servo_clearance, center=true);
        translate([0, 0, -servo_screw_len]) cube(servo_mount, center=true);
        servo_mount_holes();
        translate([servo[0]/2 + hole_delta[0], -hole_delta[1], 0]) cylinder(d=screw_d, h=servo_mount[2]);
    }
}

module top() {
    union() {
        servo_mount();
        translate([0, 0, servo[2]]) rotate([180, 0, 0])
            difference() {
                common_mount(mount=[mount[0], mount[1], servo[2]]);
                mount_screw_holes(h=servo[2]);
            }
    }
}

module bottom_to_print() {
    rotate([0, -90, 0]) bottom();
}

module top_to_print() {
    rotate([0, 180, 0]) top();
}

//bottom_to_print();
top_to_print();