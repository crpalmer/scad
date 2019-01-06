include <v-slot.scad>
include <high-detail.scad>

wall = 4;

module side(len) {
    difference() {
        union() {
            cube([20, len, wall]);
            translate([10, -wall, wall + 1.9]) rotate([0, 90, 90]) vslot_insert(length=len/2 - 7 + wall);
            translate([10, len - (len / 2 - 7), wall + 1.9]) rotate([0, 90, 90]) vslot_insert(length=len / 2 - 7);
        }
        translate([10, len/2, 0]) cylinder(d = 5.5, h=100);
    }
}

translate([0, wall, wall]) rotate([0, -90, 0]) union() {
    translate([20, 0, wall]) rotate([0, 180, 0]) side(25);
    translate([0, 0, 20]) rotate([0, 90, -90]) side(20);
}
linear_extrude(height = wall + 0.01) polygon([[0, 0], [-20, 0], [-20, wall], [-wall, 25+wall], [0, 25+wall]]);