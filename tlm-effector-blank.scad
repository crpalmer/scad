include <utils.scad>

// T - thickness of the effector
// arm_mount_len - the length of the threaded mounting points
// arm_spacing - distance between the mounting points
// arm_extension - length of the bump out to hold the mounting points, the mounting points will be centered on that bump out
// arm_offset - offset of the arms from the center of the effector

module blank_effector(T=8, arm_mount_len = 8, arm_spacing = 44, arm_extension = 10, arm_offset = 35) {
    // internally the arm spacing doesn't include the mount
    arm_spacing = arm_spacing - 2*arm_mount_len;
    // We are not including the extension in the offset here but should be externally
    arm_offset = arm_offset - arm_extension/2;

    function effector_arm(r_or_l, angle) = rotate_around(angle, [arm_spacing/2 * r_or_l, arm_offset + arm_extension]);

    function effector_body(r_or_l, angle) = rotate_around(angle, [ arm_spacing/2 * r_or_l, arm_offset ]);

    module rod_mount(r_or_l)
    {
        translate([r_or_l * arm_spacing/2, arm_offset + arm_extension/2, T/2])
            rotate([0, r_or_l*90, 0])
            children();
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
            rotate([0, 0, angle]) rod_mount(-1) children();
            rotate([0, 0, angle]) rod_mount(1) children();
        }
    }
    
    plate();
    rod_arm_mounts() {
        difference() {
            // cylinder(d2=M4_tapping_hole_d()+2, d1=T, h=arm_mount_len);
            cylinder(d=T, h=arm_mount_len-2);
            translate([0, 0, M4_long_heat_set_h()-0.01]) rotate([0, 180, 0]) M4_long_heat_set_hole();
        }
    }
}
