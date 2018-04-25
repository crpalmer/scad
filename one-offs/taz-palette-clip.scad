$fn=128;

wall = 3;
h = 8;

module clip(d) {
    difference() {
        cylinder(d = d + wall*2, h=h);
        cylinder(d=d, h=100);
        clip_hole = d*0.7;
        translate([0, -clip_hole/2, 0]) cube([100, clip_hole, 100]);
    }
}

clip_d = 5;
w = clip_d + wall;

difference() {
    union() {
        translate([0, -w/2, 0]) cube([22 - clip_d/2, w, h]);
        translate([22, 0, 0]) clip(6.75);
        translate([0, -w/2, h]) cube([4, w, h+wall*2]);
    }
    translate([-50, 0, h + h/2 + wall]) rotate([0, 90, 0]) cylinder(d = 3.5, h=100);
}