include <utils_threads.scad>

$fn=100;

guide_d=6;
guide_l=40;
guide_clearance=0.3;
screw_d=3;
screw_head_d=9;
screw_head_h=2.5;
screw_cap_d=screw_head_d+4;
screw_cap_h=screw_head_h+2;
screw_driver_d=6;
hole_d=1;


end=([guide_d*6+screw_d, guide_d*3, guide_d]);

module generate_end() {
    difference() {
        cube(end);
        translate([guide_d/2, guide_d, 0]) cylinder(hole_d/2, h=guide_d*3);
        translate([guide_d/2, guide_d*2], 0) cylinder(hole_d/2, h=guide_d*3);
        translate([end[0]-guide_d/2, guide_d*2, 0]) cylinder(hole_d/2, h=guide_d*3);
        translate([guide_d*3+screw_d/2, guide_d*1.5, 0]) cylinder(r=guide_d/2, h=guide_d*3);
    };
}

module guide_holes() {
    translate([guide_d-guide_clearance, guide_d-guide_clearance, 0]) cube([guide_d+guide_clearance*2, guide_d, guide_d+guide_clearance*2]);
    translate([end[0]-guide_d*2-guide_clearance, guide_d-guide_clearance, 0]) cube([guide_d+guide_clearance*2, guide_d, guide_d+guide_clearance*2]);
}

module guide_bars() {
    translate([guide_d, guide_d, 0]) cube([guide_d, guide_d, guide_l]);
    translate([end[0]-guide_d*2, guide_d, 0]) cube([guide_d, guide_d, guide_l]);
}

module generate_female_end() {
    difference() {
        generate_end();
        guide_holes();
        translate([guide_d*3+screw_d/2, guide_d*1.5, end[2]-3.25]) No6_nut_insert_cutout(h=100);
    };
}

module generate_male_end() {
    difference() {
        union() {
            generate_end();
            guide_bars();
        };
        translate([end[0]/2 - screw_cap_d/2, 0, 0]) cube([1.3, end[1], 1.3]);
        translate([end[0]/2 + screw_cap_d/2 - 1.3, 0, 0]) cube([1.3, end[1], 1.3]);
    };
};

module generate_screw_cap() {
    difference() {
        union() {
            cube([screw_cap_d, end[1], screw_cap_h]);
            translate([0, 0, screw_cap_h]) cube([1, end[1], 1]);
            translate([screw_cap_d-1, 0, screw_cap_h]) cube([1, end[1], 1]);
        };
        translate([screw_cap_d/2, end[1]/2, 0]) cylinder(d=screw_driver_d, screw_cap_h - screw_head_h);
        translate([screw_cap_d/2, end[1]/2, screw_cap_h - screw_head_h]) cylinder(d=screw_head_d, screw_head_h);
        translate([0, (screw_cap_d - screw_head_d)/2 - 0.05, screw_cap_h/2]) rotate([0, 90, 0]) cylinder(d=hole_d, h=screw_cap_d);

    };
}

//generate_female_end();
//generate_male_end();
generate_screw_cap();