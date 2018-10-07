w=20;
d=70;
h=13;
wall=4;
foot=5;

module wedge() {
    mirror([0, 1, 0])
        linear_extrude(scale=[1, h*10], height=h)
        square([w, 0.1]);
}

module v1() {
    side=20;
    difference() {
        union() {
            cube([w, h+side, wall]);
            translate([0, 0, wall]) cube([w, h, foot]);
            translate([0, h-wall, wall]) cube([w, wall, d]);
            translate([0, h, wall+d/2-h]) wedge();
            translate([0, 0, wall+d/2]) cube([w, h, wall]);
            translate([0, h, wall+d/2+h+wall]) mirror([0, 0, 1]) wedge();
            translate([0, h, wall+d-h-foot]) wedge();
            translate([0, 0, wall+d-foot]) cube([w,  h, foot]);
        }
        translate([w/4, 0, 0]) cube([w/2, h-wall, 10000]);
    }
}

difference() {
    union() {
        cube([w, d, wall]);
        cube([w, foot, h]);
        translate([0, d/2-foot/2, 0]) cube([w, foot, h]);
        translate([0, d-foot, 0]) cube([w, foot, h]);
    }
    translate([foot, 0, wall]) cube([w-foot*2, 10000, 1000]);
}
