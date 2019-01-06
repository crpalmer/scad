include <enclosure.scad>

E=enclosure_define([63, 100, 43], thick=2);

module box() {
    enclosure_ssr_mount(E, at = [.75, 25.5], angle=90)
    enclosure_mounting_tabs(E, "left")
    enclosure_mounting_tabs(E, "right")
    enclosure_punch_circle(E, "front", [30, 25], 12.3)
    enclosure_punch_circle(E, "back", [30, 25], 19.6)
    enclosure_box(E);
}

box();
//enclosure_lid(E);
