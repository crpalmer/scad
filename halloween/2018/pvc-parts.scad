include <pvc.scad>

$fa = 1;
$fs = .6;

module girl_pipe_base() {
    pvc_mount(od = inch_to_mm(1.5), base_d = inch_to_mm(4), wall = 4, h = 20, screw_d = No8_through_hole_d(), hole_d = inch_to_mm(3/8) + 5);
}

module edie_orc_mount() {
    coupler(od1 = pvc_od_3_4in(), od2 = pvc_od_3_4in(), screw_d = M3_through_hole_d());
}
