include <utils_threads.scad>
include <pulleys.scad>
include <wiper-motor.scad>
include <high-detail.scad>

wall=2;
pvc_od=27;      // sch 40 pvc, 3/4" id
hole=quarter_twenty_through_hole_d();

bearing_h = 7;
bearing_inner_d = 16;
bearing_d = 22.05;

module nut(h = 7, d=12.5) {
    linear_extrude(height=h) difference() {
        offset(delta=wall) circle(d=d, $fn=6);
        circle(d=d, $fn=6);
    }
}

module cap(h=5, base=wall) {
    id=pvc_od;
    difference() {
        cylinder(d=id+wall*2, h=h);
        translate([0, 0, base]) cylinder(d=id, h=h);
    }
}    

module pvc_mount() {
    difference() {
        cap(h=5+wall, base=wall*2);
        cylinder(d=hole, h=wall*2);
    }
}

module bearing_mount() {
    base=[75, wall*2, bearing_h + wall];
    outer_d = bearing_d + wall*2;
    hole_d=inch_to_mm(0.177);

    module square_body() {
        translate([-base[0]/2, 0, 0]) cube(base);
        translate([0, base[1]+outer_d/2, 0]) cylinder(d=outer_d, h=base[2]);
        translate([-outer_d/2, base[1], 0]) cube([outer_d, outer_d/2, base[2]]);
    }
    
    module body() {
        difference() {
            minkowski() {
                square_body();
                sphere(d=2);
            }
            translate([-base[0], -5, -5]) cube([base[0]*2, 5, base[2]*2]);
            translate([-base[0], 0, -5]) cube([base[0]*2, (base[1]+outer_d)*2, 5]);
        }
    }
    
    module bearing_holes() {
        cylinder(d = bearing_inner_d, h=base[2]);
        translate([0, 0, wall]) cylinder(d = bearing_d, h=base[2]);
    }
    
    module screw_holes() {
        for (at = [-base[0]/3, base[0]/3]) {
            translate([at, 0, base[2]/2]) rotate([-90, 0, 0]) cylinder(d=hole_d, h=100);
        }
    }
    
    difference() {
        body();
        translate([0, outer_d/2 + base[1], 0]) bearing_holes();
        screw_holes();
    }
}

module drill_guide() {
    module mount_guide() {
        delta=(inch_to_mm(0.177) - inch_to_mm(7/64))/2;
        linear_extrude(height=wall*2) translate([0, delta]) offset(delta=delta) projection() rotate([-90, 0, 0]) bearing_mount();
    }
    
    translate([0, 10, 0]) mount_guide();
    mirror([0, 1, 0]) translate([0, 10, 0]) mount_guide();
    translate([-30, -10, 0]) cube([60, 20, wall]);
    translate([-30, -wall, 0]) cube([60, wall, inch_to_mm(0.75)]);
}

module drill_guide_spacer() {
    cube([50, 50, wall]);
    translate([25-wall, 0, 0]) cube([wall, 50, inch_to_mm(0.75)]);
    translate([0, 50, 0]) cube([50, wall, inch_to_mm(0.75)]);
}

module pvc_drive_pulley() {
    pulley(profile = PULLEY_XL, teeth = 12, motor_shaft=quarter_twenty_through_hole_d(), pulley_b_dia=27, pulley_b_ht=10, no_of_nuts=2);
}

motor_mount_d = 35;

module motor_pulley() {
    translate([0, 0, -wiper_motor_cap_h()]) wiper_motor_cap(outer_d = motor_mount_d, recessed_h = wiper_motor_cap_h()-2);
    pulley(profile = PULLEY_XL, teeth = 12, motor_shaft=0, pulley_b_ht=0);    
}

module bearing_insert() {
    difference() {
        union() {
            cylinder(d=8+wall*2, h=1);
            cylinder(d=8, h=8);
        }
        cylinder(d=quarter_twenty_through_hole_d(), h=8);
    }
}

//pvc_mount();
//bearing_mount();
//drill_guide();
//drill_guide_spacer();
pvc_drive_pulley();
//rotate([0, 180, 0]) wiper_motor_mount(outer_d = motor_mount_d);
//motor_pulley();
//bearing_insert();
