E=enclosure_define([80, 80, 50], thick=2);
difference() {
    union() {
        enclosure_box(E);
        translate([11, 11, 0]) enclosure_ssr_mount(E);
    }
    enclosure_punch(E, "front", [40, 25], 11.75);
    enclosure_punch(E, "back", [20, 25], 17.5);
    enclosure_punch(E, "back", [60, 25], 17.5);
}