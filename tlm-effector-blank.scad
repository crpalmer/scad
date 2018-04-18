include <utils.scad>

// T - thickness of the effector
// arm_mount_len - the length of the threaded mounting points
// arm_spacing - distance between the mounting points
// arm_extension - length of the bump out to hold the mounting points, the mounting points will be centered on that bump out
// arm_offset - offset of the arms from the center of the effector

module blank_effector(T=10, arm_mount_len = 8, arm_spacing = 44, arm_extension = 12, arm_offset = 35) {
    // internally the arm spacing doesn't include the mount
    arm_spacing = arm_spacing - 2*arm_mount_len;
    // We are not including the extension in the offset here but should be externally
    arm_offset = arm_offset - arm_extension/2;

    function effector_arm(r_or_l, angle) = rotate_around(angle, [arm_spacing/2 * r_or_l, arm_offset + arm_extension]);

    function effector_body(r_or_l, angle) = rotate_around(angle, [ arm_spacing/2 * r_or_l, arm_offset ]);

    module rod_mount(r_or_l)
    {
	w = max(arm_extension, 10);
	h = 2;
	block_h = arm_mount_len - h;
	nut_h = arm_mount_len - (h + 3 + 2);

        translate([r_or_l * arm_spacing/2, arm_offset + arm_extension/2, T/2])
            rotate([0, r_or_l*90, 0])
	    difference() {
		union() {
		    translate([-T/2, -w/2, -0.01]) cube([T, w, block_h+0.01]);
		    translate([0, 0, block_h]) cylinder(d2=M4_through_hole_d()+2, d1=T, h=h);
		}
		cylinder(d=M4_through_hole_d(), h=arm_mount_len);
		translate([0, 0, nut_h]) rotate([0, 0, 30]) M4_nut_insert_cutout(h=3.1);
		translate([r_or_l < 0 ? -T/2 : 0, -4, nut_h]) cube([T/2, 8.1, 3.1]);
	    }
    }

    module plate()
    {
        linear_extrude(height=T) polygon([
             effector_body(-1, 0),
             effector_arm(-1, 0),
             effector_arm(1, 0),
             effector_body(1, 0),
             effector_body(-1, -120),
             effector_arm(-1, -120),
             effector_arm(1, -120),
             effector_body(1, -120),
             effector_body(-1, 120),
             effector_arm(-1, 120),
             effector_arm(1, 120),
             effector_body(1, 120)
        ]);
    }

    module rod_arm_mounts()
    {
        for (angle = [ 0, 120, -120 ]) {
            rotate([0, 0, angle]) rod_mount(-1);
            rotate([0, 0, angle]) rod_mount(1);
        }
    }
    
    plate();
    rod_arm_mounts();
}
