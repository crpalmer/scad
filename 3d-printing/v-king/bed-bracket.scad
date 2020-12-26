include <v-slot.scad>
include <high-detail.scad>

wall = 4;
side1 = 20;
side2 = 20;

module side(len) {
    difference() {
        union() {
            cube([20, len, wall]);
            translate([10, -wall, wall + 1.9]) rotate([0, 90, 90]) vslot_insert(length=len - 10 - 7 + wall);
            translate([10, len - 3, wall + 1.9]) rotate([0, 90, 90]) vslot_insert(length=3);
        }
        translate([10, len - 10, 0]) cylinder(d = 5.5, h=100);
    }
}

translate([0, wall, wall]) rotate([0, -90, 0]) union() {
    translate([20, 0, wall]) rotate([0, 180, 0]) side(side2);
    translate([0, 0, 20]) rotate([0, 90, -90]) side(side1);
}
linear_extrude(height = wall + 0.01) polygon([[0, 0], [-20, 0], [-20, wall], [-wall, side2+wall], [0, side2+wall]]);