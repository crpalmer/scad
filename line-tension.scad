include <utils_threads.scad>

$fn=100;

guide_d=6;
guide_l=20;
clearance=0.3;
screw_d=3;
screw_head_d=7;
screw_head_h=2;
screw_cap_lip=1;
screw_driver_d=4;
hole_d=1;


end=([guide_d*6+screw_d, guide_d*3, guide_d]);
screw_cap=[screw_head_d + 4 + 2*(screw_cap_lip+clearance), end[1] + 2*(screw_cap_lip+clearance), screw_head_h + 2*screw_cap_lip];

module generate_end() {
    difference() {
        cube(end);
        translate([guide_d/2, guide_d, 0]) cylinder(d=hole_d, h=guide_d*3);
        translate([guide_d/2, guide_d*2], 0) cylinder(d=hole_d, h=guide_d*3);
        translate([end[0]-guide_d/2, guide_d*2, 0]) cylinder(d=hole_d, h=guide_d*3);
        translate([guide_d*3+screw_d/2, guide_d*1.5, 0]) cylinder(d=screw_d, h=guide_d*3);
    };
}

module guide_holes() {
    translate([guide_d-clearance, guide_d-clearance, 0]) cube([guide_d+clearance*2, guide_d, guide_d+clearance*2]);
    translate([end[0]-guide_d*2-clearance, guide_d-clearance, 0]) cube([guide_d+clearance*2, guide_d, guide_d+clearance*2]);
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
        translate([end[0]/2 - screw_cap[0]/2-.15, 0, 0]) cube([1.3, end[1], 1.3]);
        translate([end[0]/2 + screw_cap[0]/2 - 1.15, 0, 0]) cube([1.3, end[1], 1.3]);
    };
};

module generate_screw_cap() {
    difference() {
        translate([0, 0, screw_cap[2]/2]) cube(screw_cap, center=true);
        translate([0, 0, -screw_cap_lip]) cube(screw_cap - [screw_cap_lip*2, screw_cap_lip*2, screw_cap_lip], center=true);
        cylinder(d=screw_d, h=screw_cap[2]);
        cylinder(d=screw_head_d, h=screw_head_h);
        translate([-screw_cap[0]/2, screw_cap[1]/4, screw_cap[2]/2]) rotate([0, 90, 0]) cylinder(d=hole_d, h=screw_cap[1]*2);
    };
}

generate_female_end();
//generate_male_end();
//rotate([0, 180, 0]) generate_screw_cap();