action_len = 70;
center_hole_d=3.5;
screw_d = 3;
mount_d = 28;
string_d = 1;
mount_offsets = [ 9, 10 ];
arm_w=15;
arm_h=5;
arm_separation=8;
infinity=1000;

$fn = 100;

module arm() {
    union() {
        cylinder(d=mount_d, h = arm_separation + arm_h);
        translate([0, -arm_w/2, 0]) cube([action_len, arm_w, arm_h]);
        translate([action_len, 0, 0]) cylinder(d=arm_w, h=arm_h);
    }
}

module center_hole() {
    cylinder(d=center_hole_d, h=infinity);
}

module arm_to_hub_holes() {
    union() {
        for (delta = [ [-1, 0], [1, 0], [0, 1], [0, -1] ])
            translate([mount_offsets[0] * delta[0], mount_offsets[1] * delta[1], 0]) cylinder(d=screw_d, h=infinity);
    }
}

module string_hole() {
    translate([action_len, 0, 0]) cylinder(d=string_d, h=infinity);
}

module do_it() {
    difference() {
        arm();
        center_hole();
        arm_to_hub_holes();
        string_hole();
    }
}

do_it();
