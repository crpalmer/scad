include <enclosure.scad>

E=enclosure_define([63, 100, 43], thick=2);

module box() {
    difference() {
        union() {
            enclosure_box(E);
            translate([7.25, 80, 0]) rotate([0, 0, -90]) enclosure_ssr_mount(E);
            enclosure_mounting_tabs(E, "left");
            enclosure_mounting_tabs(E, "right");
        }
        enclosure_punch(E, "front", [30, 25], 12.3);
        enclosure_punch(E, "back", [30, 25], 19.6);
    }
}

//box();
enclosure_lid(E);
