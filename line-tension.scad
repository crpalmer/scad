$fn=100;

guide_d=9;
guide_l=80;
guide_clearance=0.3;
screw_d=4;
hole_d=1;


end=([guide_d*6+screw_d, guide_d, guide_d*3]);

module generate_end() {
    difference() {
        cube(end);
        translate([guide_d/2, 0, guide_d]) rotate([-90, 0, 0]) cylinder(hole_d/2, h=guide_d*3);
        translate([guide_d/2, 0, guide_d*2]) rotate([-90, 0, 0]) cylinder(hole_d/2, h=guide_d*3);
        translate([end[0]-guide_d/2, 0, guide_d*2]) rotate([-90, 0, 0]) cylinder(hole_d/2, h=guide_d*3);
        translate([guide_d*3+screw_d/2, 0, guide_d*1.5]) rotate([-90, 0, 0]) cylinder(r=guide_d/2, h=guide_d*3);
    };
}

module guide_holes() {
    translate([guide_d-guide_clearance, 0, guide_d-guide_clearance]) cube([guide_d+guide_clearance*2, guide_d, guide_d+guide_clearance*2]);
    translate([end[0]-guide_d*2-guide_clearance, 0, guide_d-guide_clearance]) cube([guide_d+guide_clearance*2, guide_d, guide_d+guide_clearance*2]);
}

module guide_bars() {
    translate([guide_d, 0, guide_d]) cube([guide_d, guide_l, guide_d]);
    translate([end[0]-guide_d*2, 0, guide_d]) cube([guide_d, guide_l, guide_d]);
}

module generate_female_end() {
    difference() {
        generate_end();
        guide_holes();
    };
}

module generate_male_end() {
    union() {
        translate([0, guide_l, 0]) generate_end();
        guide_bars();
    };
};

generate_female_end();
translate([0, 10, 0])  generate_male_end();