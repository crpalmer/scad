include <utils.scad>

function wiper_motor_cap_h(solid_h = 4, nut_h = 6) = nut_h * 2 + solid_h;

module wiper_motor_common(outer_d = 35, solid_h = 4, shaft_d = inch_to_mm(0.255), recessed_h = 0, which) {
    nut_d = 18;
    nut_h = 6;

    module screw_holes(d, h) {
        for (angle = [ 0, 90, 180, 270 ]) {
            rotate([0, 0, angle]) translate([0, outer_d/2 - (outer_d - nut_d)/4, 0]) union() {
                cylinder(d = d, h=h-recessed_h);
                translate([0, 0, h-recessed_h]) cylinder(d = d*2, h = recessed_h);
            }
        }
    }

    module motor() {
        difference() {
            bolt_d = 6;
            base_h = 5;
            cylinder(d=outer_d, h=base_h + solid_h);
            cylinder(d1 = 10, d2 = 8.75, h=base_h);
            cylinder(d=6, h=100);
            screw_holes(M3_tapping_hole_d(), h=base_h + solid_h);
        }
    }

    module cap() {
        difference() {
            cylinder(d = outer_d, h = wiper_motor_cap_h(nut_h=nut_h, solid_h=solid_h));
            cylinder(d = nut_d, h = nut_h * 2);
            screw_holes(M3_through_hole_d(), h=wiper_motor_cap_h());
        }
    }

    if (which == 0) {
        motor();
    }
    if (which == 1) {
        cap();
    }
}

module wiper_motor_mount(outer_d = 35, solid_h = 4) {
    wiper_motor_common(outer_d=outer_d, solid_h=solid_h, which=0);
}

module wiper_motor_cap(outer_d = 35, solid_h = 4, recessed_h=0) {
    wiper_motor_common(outer_d=outer_d, solid_h=solid_h, recessed_h = recessed_h, which=1);
}