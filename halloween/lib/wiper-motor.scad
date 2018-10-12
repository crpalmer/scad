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

module wiper_motor_motor_mount_common(top) {
    wall=4;
    d=61+wall*2;
    h=12;
    x=quarter_twenty_through_hole_d()*3;
    
    module half2d() {
        difference() {
            union() {
                circle(d=d);
                translate([-d/2-x, -wall]) square([d+2*x, wall]);
                if (! top) {
                    translate([-d/2-x, -d/2]) square([d+2*x, wall]);
                    translate([-d/5*2, -d/2]) square([d/5*4, wall*4]);
                }
            }
            circle(d=d-wall*2);
            translate([-d/2, 0]) square([d, d]);
        }
    }
    
    module half() {
        difference() {
            linear_extrude(height=h) half2d();
            for (x = [-d/2-x/2, d/2+x/2]) {
                translate([x, wall/2, h/2]) rotate([90, 0, 0]) cylinder(d=quarter_twenty_through_hole_d(), h=wall*2);
                if (! top) {
                    translate([x, -wall*2, h/2]) rotate([90, 0, 0]) cylinder(d=inch_to_mm(0.1770), h=d);
                }
            }
        }

    }
    
    half();
}

module wiper_motor_motor_mount_top() {
    wiper_motor_motor_mount_common(true);
}

module wiper_motor_motor_mount_bottom() {
    wiper_motor_motor_mount_common(false);
}

//include <high-detail.scad>
//wiper_motor_motor_mount_top();
//wiper_motor_motor_mount_bottom();x
