include <utils_threads.scad>

module servo_arm(
            action_len = 42,
            horn_thickness = 4,
            arm_thickness = 4,
            arm_width = 14,
            attachment_hole_d = 2
        )
{
    center_hole_d=6;
    mount_d = 28;
    mount_offsets = [ 9.1, 9.95 ];
    infinity=1000;

    $fn = 100;

    module arm() {
        union() {
            cylinder(d=mount_d, h = horn_thickness);
            translate([0, -arm_width/2, 0]) cube([action_len, arm_width, arm_thickness]);
            translate([action_len, 0, 0]) cylinder(d=arm_width, h=arm_thickness);
        }
    }

    module tensioner() {
        module cutout() {
            union() {
                cylinder(d=attachment_hole_d*2, h=infinity);
                translate([0, -atachment_hole_d/2, 0]) cube([infinity, attachment_hole_d, infinity]);
            }
        }

        difference() {
            cylinder(d=arm_width, h=arm_thickness);
            translate([arm_thickness/2, 0, 0]) cutout();
            translate([-arm_thickness/2, 0, 0]) rotate([0, 0, 180]) cutout();
        }
    }

    module center_hole() {
        cylinder(d=center_hole_d, h=infinity);
    }

    module arm_to_hub_holes() {
        union() {
            for (delta = [ [-1, 0], [1, 0], [0, 1], [0, -1] ])
                translate([mount_offsets[0] * delta[0], mount_offsets[1] * delta[1], 0]) cylinder(d=M3_through_hole_d(), h=infinity);
        }
    }

    module string_hole() {
        translate([action_len, 0, 0]) cylinder(d=attachment_hole_d, h=infinity);
    }

    difference() {
        union() {
            arm();
            //translate([action_len-arm_width/2, -arm_width*.75]) tensioner();
        }
        center_hole();
        arm_to_hub_holes();
        string_hole();
    }
}
