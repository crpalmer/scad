$fn=100;

guide_d=9;
guide_l=80;
guide_clearance=0.3;
screw_d=4;
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
    };
}

module generate_male_end() {
    union() {
        generate_end();
        guide_bars();
    };
};

//generate_female_end();
generate_male_end();