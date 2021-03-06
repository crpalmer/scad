include <utils.scad>

// T - thickness of the effector
// arm_mount_len - the length of the threaded mounting points
// arm_spacing - distance between the mounting points
// arm_extension - length of the bump out to hold the mounting points, the mounting points will be centered on that bump out
// arm_offset - offset of the arms from the center of the effector

module blank_effector_rod_arm_mount_cutout(r_or_l, T, x, y)
{
    nut_h = 5;
    hole_len = 11;

    translate([r_or_l * (x + 0.01), y, T/2])
	rotate([0, r_or_l*-90, 0])
	union() {
	    cylinder(d=3.1, h=hole_len);
	    translate([0, 0, nut_h]) rotate([0, 0, 30]) M3_nut_insert_cutout(h=1.9);
	    rotate([0, 0, r_or_l > 0 ? 180 : 0]) translate([0, -3.25, nut_h]) cube([100, 6.5, 1.9]);
	}
}

module blank_effector(T=10, arm_mount_len = 8, arm_spacing = 45, arm_extension = 12, arm_offset = 35, fan_bumpout = 0, fan_bumpout_w = 24) {
    // internally the arm spacing doesn't include the mount
    arm_spacing = arm_spacing - 2*arm_mount_len;
    // We are not including the extension in the offset here but should be externally
    arm_offset = arm_offset - arm_extension/2;

    function effector_arm(r_or_l, angle) = rotate_around(angle, [arm_spacing/2 * r_or_l, arm_offset]);

    function effector_arm_extension(r_or_l, angle, t_or_b) = rotate_around(angle, [(arm_spacing/2 + arm_mount_len) * r_or_l, arm_offset + t_or_b * arm_extension]);

    function effector_fan_bumpout(r_or_l, angle, t_or_b) = rotate_around(angle, [r_or_l * fan_bumpout_w / 2, arm_offset + arm_extension + t_or_b * fan_bumpout]);

    function effector_body(r_or_l, angle) = rotate_around(angle, [ arm_spacing/2 * r_or_l, arm_offset ]);

    module plate()
    {
        linear_extrude(height=T) polygon([
             effector_body(-1, 0),
             effector_arm(-1, 0),
	     effector_arm_extension(-1, 0, 0),
	     effector_arm_extension(-1, 0, 1),
	     effector_fan_bumpout(-1, 0, 0),
	     effector_fan_bumpout(-1, 0, 1),
	     effector_fan_bumpout(1, 0, 1),
	     effector_fan_bumpout(1, 0, 0),
	     effector_arm_extension(1, 0, 1),
	     effector_arm_extension(1, 0, 0),
             effector_arm(1, 0),
             effector_body(1, 0),
             effector_body(-1, -120),
             effector_arm(-1, -120),
	     effector_arm_extension(-1, -120, 0),
	     effector_arm_extension(-1, -120, 1),
	     effector_arm_extension(1, -120, 1),
	     effector_arm_extension(1, -120, 0),
             effector_arm(1, -120),
             effector_body(1, -120),
             effector_body(-1, 120),
             effector_arm(-1, 120),
	     effector_arm_extension(-1, 120, 0),
	     effector_arm_extension(-1, 120, 1),
	     effector_arm_extension(1, 120, 1),
	     effector_arm_extension(1, 120, 0),
             effector_arm(1, 120),
             effector_body(1, 120)
        ]);

    }

    difference() {
	plate();
	for (angle = [ 0, 120, -120 ]) {
	    x = arm_spacing/2 + arm_mount_len;
	    y = arm_offset + arm_extension/2;
	    rotate([0, 0, angle]) blank_effector_rod_arm_mount_cutout(-1, T, x, y);
	    rotate([0, 0, angle]) blank_effector_rod_arm_mount_cutout(1, T, x, y);
	}
    }
}

module blank_effector_carriage_adaptor(arm_spacing = 45) {
    w=4;
    difference() {
	union() {
	    translate([-(45+2*w)/2, -10/2, 15]) union() {
		cube([45+2*w, 10, w]);
		translate([0, 0, w]) cube([w, 10, 10]);
		translate([45+w, 0, w]) cube([w, 10, 10]);
		translate([0, 0, 10+w]) cube([45+2*w, 10, w]);
	    }
	    translate([-arm_spacing/2, -5, 0]) cube([12, 10, 15]);
	    translate([arm_spacing/2 - 12, -5, 0]) cube([12, 10, 15]);
	}
	blank_effector_rod_arm_mount_cutout(1, T = 10, x = arm_spacing/2, y = 0);
	blank_effector_rod_arm_mount_cutout(-1, T = 10, x = arm_spacing/2, y = 0);
	translate([-100, 0, 15+10/2+w]) rotate([0, 90, 0]) cylinder(d = M4_through_hole_d(), h=200);
    }
}
