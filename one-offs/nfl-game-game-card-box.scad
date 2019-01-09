include <utils.scad>
include <high-detail.scad>

h=30;
wall=2;
lip = 8;
r=5;
delta=5;
card = [64, 90, 0];
card_box = [wall*2+delta, wall*2+delta, h] + card;

module card_tray(has_slots) {
    module boxes_no_slot() {
        for (x = [-1, 0, 1] * card_box[0]) {
            translate([x, 0, 0])
            difference() {
                rounded_cube(card_box, r=r);
                translate([wall, wall, wall]) rounded_cube(card_box - [wall*2, wall*2, wall], r=r);
                translate([wall+lip, wall+lip]) rounded_cube(card_box - 2*[wall + lip, wall + lip], r=r);
            }
        }
        translate([-r/2, 0, 0]) cube([r, card_box[1], h]);
        translate([card_box[0]-r/2, 0, 0]) cube([r, card_box[1], h]);
        translate([-card_box[0]/2, 0, 0]) cube([card_box[0]*2, wall, h]);
        translate([-card_box[0]/2, card_box[1]-wall, 0]) cube([card_box[0]*2, wall, h]);
    }
    
    difference() {
        boxes_no_slot();
        if (has_slots) {
            for (x = [-1, 0, 1] * card_box[0]) {
                for (y = [0, 1] * (card_box[1]-wall)) {
                    translate([x + lip, y, wall]) cube([card_box[0] - lip*2, wall, h]);
                }
            }
        }
    }
}

module extra_storage() {
    box = card + [-lip/2, -lip/2, h/2];
    difference() {
        rounded_cube(box, r=r);
        translate([wall, wall, wall]) rounded_cube(box - [wall*2, wall*2, wall], r=r);
    }
}

//card_tray(true);
//card_tray(false);
extra_storage();
