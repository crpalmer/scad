include <enclosure.scad>

gap=.1;
E=enclosure_define([26+gap*2, 35+gap*2, 8+2+1], screw_len=8, thick=2, has_lid=false);

union() {
    enclosure_maestro_mount(E, at = [gap, gap])
    enclosure_box(E);
}
