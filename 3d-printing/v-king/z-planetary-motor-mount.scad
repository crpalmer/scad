include <nema.scad>
include <v-slot.scad>
include <high-detail.scad>

wall=5;
belt_lock_hole_spacing = 28.125;
belt_lock_offset0 = 10.125;
len=45/2+wall + belt_lock_offset0 + belt_lock_hole_spacing + 4.625;

module v_slot_bracket() {
    module bracket() {
        difference() {
            cube([len, 20+wall, 20+wall*2]);
            translate([0, 0, wall]) cube([len, 20, 20]);
        }
        translate([0, 20-1.2, 20/2+ wall]) rotate([90, 0, 90]) vslot_insert(length = len, depth = 1.2);
    }

    translate([-45/2-wall, 0, 0]) bracket();
}

module mount() {
    translate([0, 45/2+wall + 20 + wall, 20+wall]) nema17_planetary_mount(wall=wall, right_wall = false);
    v_slot_bracket();
    translate([-45/2-wall, 20-wall, 20+wall*4]) rotate([0, 90, 0]) linear_extrude(height = 45+wall) polygon([[wall*2, wall*2], [wall*2, 0], [0, wall*2]]);
}

module belt_lock_holes() {
    translate([belt_lock_offset0, 0, 20/2+wall]) rotate([-90, 0, 0]) cylinder(d = 5.5, h=100);
    translate([belt_lock_offset0 + belt_lock_hole_spacing, 0, 20/2+wall]) rotate([-90, 0, 0]) cylinder(d = 5.5, h=100);
    translate([belt_lock_offset0 + belt_lock_hole_spacing, 0, 20/2+wall-5.5/2]) cube([10, 100, 5.5]);
}

module other_mounting_holes() {
    translate([len/2, 20/2, -wall*2]) cylinder(d = 5.5, h=100);
}

rotate([0, -90, 0])
difference() {
    mount();
    belt_lock_holes();
    translate([-45/2-wall, 0, 0]) other_mounting_holes();
}
