include <enclosure.scad>
include <utils.scad>
include <high-detail.scad>

power_E=enclosure_define([160, 238, 60], thick=2.4, n_posts=4, corner_posts=true, side_pattern = ENCLOSURE_PATTERN_SOLID);
duet_E=enclosure_define([124, 220, 50], thick=2.4, n_posts=4, corner_posts=true, side_pattern = ENCLOSURE_PATTERN_HONEYCOMB);

module punch_foot_holes(E) {
    delta=9;
    enclosure_mounts(E, [0, 0], [ [delta, delta], [enclosure_inner_x(E) - delta, delta], [delta, enclosure_inner_y(E) - delta], [enclosure_inner_x(E) - delta, enclosure_inner_y(E) - delta] ], through_hole = true, h = 0)
    children();
}
    
module punch_frame_mounting_holes(E) {
    foot_h = 8;
    hole_z = 21.25 - enclosure_thick(E) - foot_h;
    
    enclosure_punch_circle(E, "front", [20, hole_z], 5.5)
    enclosure_punch_circle(E, "front", [enclosure_x(E) - 20, hole_z], 5.5)
    children();
}

module duet_enclosure() {
    E=duet_E;

    z = enclosure_z(E) - 15;
    stepper_spacing = 25;

    module punch_ethernet() {
        enclosure_punch_square(E, "front", [80, z-2], [15, 20])
        children();
    }

    module punch_usb() {
        enclosure_punch_square(E, "front", [45, z-2], [9.5, 5])
        enclosure_punch_circle(E, "front", [45-27.5/2, z-2], M3_through_hole_d())
        enclosure_punch_circle(E, "front", [45.5+27.5/2, z-2], M3_through_hole_d())
        children();
    }

    module punch_z_steppers() {
        enclosure_punch_circle(E, "back", [75+stepper_spacing*1, z], 16)
        enclosure_label       (E, "back", [75+stepper_spacing*1+1, z-15], [14, 10], "Z3")
        enclosure_punch_circle(E, "back", [75+stepper_spacing*0, z], 16)
        enclosure_label       (E, "back", [75+stepper_spacing*0+1, z-15], [14, 10], "Z2")
        enclosure_punch_circle(E, "back", [25, z], 16)
        enclosure_label       (E, "back", [25+1, z-15], [14, 10], "Z1")
        children();
    }
    
    module punch_bed_thermistor() {
        enclosure_punch_circle(E, "back", [50, z], 16)
        enclosure_label       (E, "back", [50, z - 15], [16, 10], "bed")
        children();
    }

    module punch_xy_steppers() {
        enclosure_punch_circle(E, "right", [enclosure_inner_y(E) - 20 - stepper_spacing*1, z], 16)
        enclosure_label       (E, "right", [enclosure_inner_y(E) - 20 - stepper_spacing*1, z-15], [7, 10], "Y")
        enclosure_punch_circle(E, "right", [enclosure_inner_y(E) - 20 - stepper_spacing*0, z], 16)
        enclosure_label       (E, "right", [enclosure_inner_y(E) - 20 - stepper_spacing*0, z-15], [7, 10], "X")
        children();
    }
    
    module punch_extruder_steppers() {
        enclosure_punch_circle(E, "left", [enclosure_inner_y(E) - 20 - stepper_spacing*1, z], 16)
        enclosure_label       (E, "left", [enclosure_inner_y(E) - 20 - stepper_spacing*1, z-15], [7, 10], "E1")
        enclosure_punch_circle(E, "left", [enclosure_inner_y(E) - 20 - stepper_spacing*0, z], 16)
        enclosure_label       (E, "left", [enclosure_inner_y(E) - 20 - stepper_spacing*0, z-15], [7, 10], "E0")
        children();
    }
    
    module punch_fsr() {
        enclosure_punch_circle(E, "right", [75, z], 16)
        enclosure_label       (E, "right", [75, z-15], [7, 10], "fsr")
        children();
    }
    
    module punch_fans() {
        enclosure_punch_circle(E, "left", [125, z], 16)
        enclosure_label       (E, "left", [125, z-15], [7, 10], "fan")
        children();
    }
    
    module punch_end_stops() {
        enclosure_punch_circle(E, "left", [100, z], 16)
        enclosure_label       (E, "left", [100, z-15], [7, 10], "es")
        children();
    }

    module punch_hotends() {
        enclosure_punch_circle(E, "left", [50, z], 16)
        enclosure_label       (E, "left", [50, z-15], [7, 10], "th")
        enclosure_punch_circle(E, "left", [25, z], 16)
        enclosure_label       (E, "left", [25, z-15], [7, 10], "he")
        children();
    }

    module punch_power() {
        mid_y = enclosure_inner_y(E)/2;
        enclosure_punch_circle(E, "right", [mid_y, z], 16)
        enclosure_label       (E, "right", [mid_y, z-15], [7, 10], "pwr")
        children();
    }
    
    punch_foot_holes(E)
    punch_frame_mounting_holes(E)
    punch_ethernet()
    punch_usb()
    punch_z_steppers()
    punch_bed_thermistor()
    punch_foot_holes(E)
    punch_xy_steppers()
    punch_extruder_steppers()
    punch_fsr()
    punch_fans()
    punch_end_stops()
    punch_hotends()
    punch_power()
    enclosure_duet_mount(E, at = [10, 35], through_hole = true, h = 5)
    enclosure_box(E);
}

module 120mm_fan_cutout() {
    for (xy = [ [1, 1], [-1, 1], [-1, -1], [1, -1] ] * 52.5) {
        translate([xy[0], xy[1], 0]) circle(d = inch_to_mm(0.150));
    }
    difference() {
        for (d = [20:10:100]) {
            difference() {
                circle(d = d);
                circle(d = d - 5);
            }
        }
        for (angle = [0 : 60 : 320]) {
            rotate([0, 0, angle]) translate([-3/2, 0]) square([3, 100]);
        }
    }
}

module duet_lid() {
    E = duet_E;
    
    difference() {
        translate([-enclosure_x(E)/2, -enclosure_y(E)/2, 0]) enclosure_lid(E);
        linear_extrude(h = 10) 120mm_fan_cutout();
        translate([-13/2, 75, 0]) cube([13, 10, 10]);
    }
}
    
module power_enclosure() {
    E = power_E;
    
    mid_y = enclosure_y(E) / 2;
    mid_z = (enclosure_z(E) - enclosure_thick(E)) / 2;
    z = enclosure_z(E) - 12;

    module punch_power_entry() {
        enclosure_punch_square(E, "front", [42.5, z - 7.5], [47.25, 28])
        enclosure_punch_circle(E, "front", [42.5-56/2, z - 7.5], M3_through_hole_d())
        enclosure_punch_circle(E, "front", [42.5+56/2, z - 7.5], M3_through_hole_d())
        children();
    }
    
    module punch_bed_output() {
        enclosure_punch_circle(E, "back", [130, mid_z], 16)
        enclosure_label       (E, "back", [130, z - 30], [16, 10], "bed")
        children();
    }
    
    module power_supply_mounts() {
        enclosure_mounts(E, [55, 25], [ [9, 61], [9, 61+118], [88.5, 61], [88.5, 61 + 118]], [100, 200], h=0, through_hole = true, hole_d = 3.5)
        children();
    }
    
    module terminal_block_mounts() {
        enclosure_mounts(E, at = [20, 20], deltas = [ [11, 6], [11, 84] ], size = [ 22, 90 ], h=0, through_hole=true) children();
    }

    {
        punch_frame_mounting_holes(E)
        punch_foot_holes(E)
        punch_power_entry()
        punch_bed_output()
        enclosure_punch_circle(E, "left", [mid_y, mid_z], 16)
        terminal_block_mounts()
        power_supply_mounts()
        enclosure_ssr_mount(E, [0, 130], angle=90, h=0, through_hole=true)
        enclosure_box(E);
    }
}

//power_enclosure();
//enclosure_lid(power_E);
//duet_enclosure();
duet_lid();