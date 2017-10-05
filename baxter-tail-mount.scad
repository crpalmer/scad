$fn=100;

wall=2;
clearance=0.2;
arm_thickness=4;

// HS81
servo_len=29.8;
servo_w=12;
servo_hole_h=5.4;         // From edge of servo body to middle of hole
servo_hole_offset=3.125;  // From body to middle of mounting hole
servo_screw_d=2.5;       // M3 self tapping tap hole
servo_hole_to_bottom=20; // distance from the mounting hole to bottom of servo

mounting_screw_d=3.5;     // M3 self tapping through hole
mounting_extra_len=3;
mounting_screw_len=15;
servo_screw_len=5;

mount=[ servo_w + arm_thickness + clearance,
         servo_hole_to_bottom + clearance + wall + mounting_screw_d + wall,
         servo_len + 2 * (clearance + servo_hole_offset + servo_screw_d/2 + wall)
        ];

servo = [ servo_w + clearance, servo_hole_to_bottom + clearance, servo_len + clearance * 2 ];

module body() {
    difference() {
        translate([-mount[0]/2 + arm_thickness, 0, -mount[2]/2]) cube(mount);
        translate([-servo[0]/2, 0, -servo[2]/2]) cube(servo);
        translate([-mount[0]/2 + arm_thickness, arm_thickness, -mount[2] + mount[2]/2-mounting_screw_len+mounting_extra_len ]) cube(mount);
    };
}

module mounting_screw_extra() {
    tapered_cylinder(d0=mounting_screw_d + 0.5, d1=mounting_screw_d + 2*wall, h=mounting_extra_len);
}

module mounting_extra_body() {
    translate([-wall, mount[1] - wall*2 - mounting_screw_d, mount[2]/2]) cube([mount[0]/2 + arm_thickness + wall, mounting_screw_d + wall*2, mounting_extra_len]);
}

module servo_hole() {
    rotate([-90, 0, 0]) cylinder(d=servo_screw_d, h=servo_screw_len);
};

module full_mount() {
    difference() {
        union() {
            body();
            mounting_extra_body();
        }
        translate([0, 0, servo_len/2 + servo_hole_offset + clearance]) servo_hole();
        translate([0, 0, -(servo_len/2 + servo_hole_offset + clearance)]) servo_hole();
        translate([0, mount[1] - wall - mounting_screw_d/2, 0]) union() {
            cylinder(d=mounting_screw_d, h=mount[2] + mounting_extra_len);
            translate([arm_thickness + mounting_screw_d, 0, 0]) cylinder(d=mounting_screw_d, h=mount[2] + mounting_extra_len);
        };
    };
}

rotate([0, 90, 0]) 
full_mount();
