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

tube_d = 5;
drive_d = 6;

translate([-8-tube_d/2, 0, 0]) rotate([0, 0, 180]) clip(d=tube_d);
translate([-8, -wall/2, 0]) cube([16, wall, h]);
translate([8+drive_d/2, 0, 0]) clip(d=drive_d);