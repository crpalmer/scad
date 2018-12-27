include <utils.scad>
include <high-detail.scad>

h=40;
wall=2;
lip = 8;
r=5;
delta=5;
card = [64, 90, 0];
card_box = [wall*2+delta, wall*2+delta, h] + card;

module card_tray() {
    module boxes(has_slots = false) {
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
            for (x = [-1, 0, 1] * card_box[0]) {
                if (has_slots) {
                    translate([x + lip, 0, wall]) cube([card_box[0] - lip*2, wall, h]);
                }
            }
        }
    }

    boxes(true);
    translate([0, card[1]+wall*2+5, 0]) boxes(false);
    translate([-card_box[0], card_box[1]/2, 0]) cube([wall, card_box[1], h]);
    translate([card_box[0]*2-wall, card_box[1]/2, 0]) cube([wall, card_box[1], h]);
    translate([-card_box[0], card_box[1]-wall, 0]) cube([card_box[0]*3, wall*2, h]);
}

module extra_storage() {
    box = card + [-lip, -lip, h/2];
    difference() {
        rounded_cube(box, r=r);
        translate([wall, wall, wall]) rounded_cube(box - [wall*2, wall*2, wall], r=r);
    }
}

//card_box();
extra_storage();
