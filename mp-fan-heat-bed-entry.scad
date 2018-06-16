include <utils.scad>

$fn=100;

slot_l=18;
slot_w=6;
slot_offset=3;
wall=2;
inf=100;

holes = [ [4,4,0], [4, 36, 0], [36, 4, 0], [36, 36, 0] ];

module point(p) {
    translate(p) cube([0.01, 0.01, 0.01]);
}

difference() {
    translate([0, 0, 1]) minkowski() {
        union() {
            rounded_cube([40, 40, wall], 1);
            for (hole = holes) {
                translate(hole) cylinder(d=8, h=wall*4);
            }
            translate([slot_offset-wall, (40-(slot_l+wall*2))/2, 0]) cube([slot_w+wall*2, slot_l+wall*2, wall*4]);
        }
        sphere(d=1, $fn=0);
    }
    for (hole = holes) {
        translate(hole) cylinder(d=4, h=wall*3);
    }
    translate([slot_offset, (40-slot_l)/2, 0]) cube([slot_w, slot_l, inf]);
}
