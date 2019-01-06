include <enclosure.scad>

E=enclosure_define([80, 80, 50], thick=2);

module ssr_box() {
    enclosure_ssr_mount(E, at = [8, 8])
    enclosure_mounting_tabs(E, "left")
    enclosure_mounting_tabs(E, "right")
    enclosure_punch_circle(E, "front", [40, 25], 11.75)
    enclosure_punch_circle(E, "back", [20, 25], 17.5)
    enclosure_punch_circle(E, "back", [60, 25], 17.5)
    enclosure_box(E);
}

ssr_box();
// enclosure_lid(E);
