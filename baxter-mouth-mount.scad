include <utils.scad>
include <utils_threads.scad>

$fn=100;

wall=2;
bottom=4;
clearance=0.2;
drill_guide_h=8;

// From the HS81 specs:
// servo_len=inch_to_mm(1.17);
// servo_w=inch_to_mm(0.47);
// servo_hole_h=inch_to_mm(0.47)/2;

// Measured from Futuba s3107:
// servo_len=21.75;
// servo_w=11.10;
// servo_hole_h=5.4;        // From edge of servo body to middle of hole
// servo_hole_offset=2.75;  // From body to middle of mounting hole
// servo_screw_d=2.5;        // M3 self tapping tap hole

// HS81
servo_len=29.8;
servo_w=12;
servo_hole_h=5.4;         // From edge of servo body to middle of hole
servo_hole_offset=3.125;  // From body to middle of mounting hole
servo_screw_d=2.5;       // M3 self tapping tap hole


mounting_screw_d=3.5;     // M3 self tapping through hole
mounting_extra_len=3;

mount=[
    servo_len + 2*(clearance+servo_hole_offset + servo_screw_d + wall + wall + mounting_screw_d + wall),
    wall + max(servo_screw_d, mounting_screw_d) + wall,
    servo_w + clearance + mounting_extra_len + bottom
];

drill_guide = [ mount[0], mount[1], drill_guide_h ];

module mounting_hole_left(d=mounting_screw_d) {
    translate([-mount[0]/2 + wall + mounting_screw_d/2, mount[1]/2, 0]) cylinder(d=d, h=mount[2]);
}

module mounting_hole_right(d=mounting_screw_d) {
    translate([mount[0]/2 - wall - mounting_screw_d/2, mount[1]/2, 0]) cylinder(d=d, h=mount[2]);
}

module remove_mount_extra_len(mount=mount) {
    translate([-mount[0]/2+wall*2+mounting_screw_d, 0, mount[2] - mounting_extra_len]) cube([mount[0]-2*(wall*2+mounting_screw_d), mount[1], mounting_extra_len]);
}

module mount() {
    difference() {
        translate([0, mount[1]/2, mount[2]/2]) cube(mount, center=true);
        // Create arm below servo
        translate([-servo_len/2-clearance, 0, 0])
            union() {
                // Remove servo body
                translate([0, 0, bottom]) cube([servo_len+clearance*2, mount[1], mount[2]]);
            };
        // Servo screw hole (left)
        translate([-(servo_len/2+servo_hole_offset), 0, servo_hole_h+bottom])
            rotate([-90, 0, 0]) cylinder(d=servo_screw_d, h=mount[1]);
        mounting_hole_left();
        // Servo screw hole (right)
        translate([+(servo_len/2+servo_hole_offset), 0, servo_hole_h+bottom])
            rotate([-90, 0, 0]) cylinder(d=servo_screw_d, h=mount[1]);
        mounting_hole_right();
        remove_mount_extra_len();
    };
}

module drill_guide() {
    difference() {
        translate([0, drill_guide[1]/2, drill_guide[2]/2]) cube(drill_guide, center=true);
        mounting_hole_left(d=servo_screw_d);
        mounting_hole_right(d=servo_screw_d);
        remove_mount_extra_len(mount=drill_guide);
    };
}

// mount();
drill_guide();