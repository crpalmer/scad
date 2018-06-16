$fn=128;

wall = 3;
h = 8;

module clip(d, h = h, cutout_pct = 0.7) {
    difference() {
        cylinder(d = d + wall*2, h=h);
        cylinder(d=d, h=100);
        clip_hole = d*cutout_pct;
        translate([0, -clip_hole/2, 0]) cube([100, clip_hole, 100]);
    }
}

clip_d = 8;
tube_d = 6.75;
notch_d = 4.75;
notch_h = 3;
w = clip_d + wall;

rotate([0, -90, 0])
difference() {
    union() {
        translate([0, -w/2, 0]) cube([22 - tube_d/2, w, h]);
        translate([22, 0, 0]) clip(tube_d, cutout_pct = 1);
        translate([22, 0, h/2 - notch_h/2]) clip(notch_d, notch_h, cutout_pct = 0.8);
        translate([0, -w/2, h]) cube([4, w, h+wall*2]);
    }
    translate([-50, 0, h + h/2 + wall]) rotate([0, 90, 0]) cylinder(d = 3.5, h=100);
}