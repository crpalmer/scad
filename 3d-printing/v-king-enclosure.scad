include <enclosure.scad>
include <utils.scad>
//include <high-detail.scad>

E=enclosure_define([200, 200, 60], thick=2, n_posts=4, corner_posts=true, side_pattern = ENCLOSURE_PATTERN_HONEYCOMB);

z = enclosure_z(E) - 12;

// todo:
// * ethernet port
// * power in
// * sensors: 2 endstops, 1 z
// * thermistors: hotend1, bed, hotend2?
// * stepper for chimera?

n_steppers = 7;
stepper_spacing = (enclosure_y(E) - 40) / (n_steppers-1);
n_fans = 3;
n_endstops = 4;
n_thermistors = 2;
sensor_spacing = (enclosure_y(E) - 40) / (n_fans + n_thermistors + n_endstops - 1);


enclosure_punch_square(E, "back", [90, z - 10], [inch_to_mm(0.95), inch_to_mm(0.95)])
    enclosure_label       (E, "back", [88, z - 30], [16, 10], "bed")
    enclosure_punch_square(E, "back", [150, z - 10], [15, 20])  // ethernet
    enclosure_punch_circle(E, "back", [125, z - 10], 16)
    enclosure_label       (E, "back", [123, z - 30], [16, 10], "bed")
    enclosure_punch_circle(E, "right", [20+sensor_spacing*8, z], 16)
    enclosure_label       (E, "right", [20+sensor_spacing*8+.5, z-15], [14, 10], "zpr")
    enclosure_punch_circle(E, "right", [20+sensor_spacing*7, z], 16)
    enclosure_label       (E, "right", [20+sensor_spacing*7+.5, z-15], [14, 10], "th2")
    enclosure_punch_circle(E, "right", [20+sensor_spacing*6, z], 16)
    enclosure_label       (E, "right", [20+sensor_spacing*6+.5, z-15], [14, 10], "th1")
    enclosure_punch_circle(E, "right", [20+sensor_spacing*5, z], 16)
    enclosure_label       (E, "right", [20+sensor_spacing*5+.5, z-15], [14, 10], "esZ")
    enclosure_punch_circle(E, "right", [20+sensor_spacing*4, z], 16)
    enclosure_label       (E, "right", [20+sensor_spacing*4+.5, z-15], [14, 10], "esY")
    enclosure_punch_circle(E, "right", [20+sensor_spacing*3, z], 16)
    enclosure_label       (E, "right", [20+sensor_spacing*3+.5, z-15], [14, 10], "esX")
    enclosure_punch_circle(E, "right", [20+sensor_spacing*2, z], 16)
    enclosure_label       (E, "right", [20+sensor_spacing*2+.5, z-15], [14, 10], "F3")
    enclosure_punch_circle(E, "right", [20+sensor_spacing*1, z], 16)
    enclosure_label       (E, "right", [20+sensor_spacing*1+.5, z-15], [14, 10], "F2")
    enclosure_punch_circle(E, "right", [20+sensor_spacing*0, z], 16)
    enclosure_label       (E, "right", [20+sensor_spacing*0+.5, z-15], [14, 10], "F1")
    enclosure_punch_circle(E, "left", [20+stepper_spacing*6, z], 16)
    enclosure_label       (E, "left", [20+stepper_spacing*6+1, z-15], [14, 10], "Z3")
    enclosure_punch_circle(E, "left", [20+stepper_spacing*5, z], 16)
    enclosure_label       (E, "left", [20+stepper_spacing*5+1, z-15], [14, 10], "Z2")
    enclosure_punch_circle(E, "left", [20+stepper_spacing*4, z], 16)
    enclosure_label       (E, "left", [20+stepper_spacing*4+1, z-15], [14, 10], "Z1")
    enclosure_punch_circle(E, "left", [20+stepper_spacing*3, z], 16)
    enclosure_label       (E, "left", [20+stepper_spacing*3, z-15], [7, 10], "Y")
    enclosure_punch_circle(E, "left", [20+stepper_spacing*2, z], 16)
    enclosure_label       (E, "left", [20+stepper_spacing*2, z-15], [7, 10], "X")
    enclosure_punch_circle(E, "left", [20+stepper_spacing*1, z], 16)
    enclosure_label       (E, "left", [20+stepper_spacing*1+.5, z-15], [14, 10], "E1")
    enclosure_punch_circle(E, "left", [20+stepper_spacing*0, z], 16)
    enclosure_label       (E, "left", [20+stepper_spacing*0+.5, z-15], [14, 10], "E0")
    union() {
        enclosure_box(E);
        enclosure_duet_mount(E, at = [5, 35]);
    }
