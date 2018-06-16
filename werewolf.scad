include <utils.scad>
include <utils_threads.scad>
include <servo-arm.scad>

$fn=100;

arm_len=inch_to_mm(6);
screw_d=No6_through_hole_d();
hole_h=10;
T=4;
arm_T=T*2;

// Servo data
servo = [40.4, 19.8, 27 ];
hole_delta = [ 4.5, 5 ];
clearance=[ 0.15, 0.15, 0 ];
attach_delta=18;
attach_extra=4;

infinity=100;


module bracket() {
    module arm() {
        difference() {
            union() {
                cube([screw_d*3, screw_d*1.5 + hole_h, T]);
                translate([screw_d*1.5, hole_h + screw_d*1.5, 0]) cylinder(d=screw_d*3, h=T);
            }
            translate([screw_d*1.5, hole_h + screw_d*1.5, 0]) cylinder(d=screw_d, h=T);
        }
    }

    union() {
        translate([0, T/2, 0]) rotate([90, 0, 0]) arm();
        translate([0, 0, T]) rotate([0, 90, 0]) linear_extrude(screw_d*3) polygon([ [0, -1.5*T], [-T, -T*.5], [-T, T*.5], [0, 1.5*T], [0, -1.5*T] ]);
        difference() {
            base=[screw_d*3, (screw_d*3+T)*2, T];
            translate([0, -base[1]/2, 0]) cube(base);
            translate([base[0]/2, base[1]/2 - T - screw_d/2, 0]) cylinder(d=screw_d, h=T);
            translate([base[0]/2, -(base[1]/2 - T - screw_d/2), 0]) cylinder(d=screw_d, h=T);
        }
    }
}

module push_arm() {
    attacher=[arm_T*2+T*3, screw_d*3 + arm_T + arm_T*2, arm_T];

    difference() {
        union() {
            translate([-arm_T/2, 0, 0]) cube([arm_T, arm_len, arm_T]);
            translate([-attacher[0]/2, 0, 0]) cube(attacher);
        }
        translate([-attacher[0]/2+arm_T, 0, 0]) cube(attacher - [2*arm_T, arm_T, 0]) ;
        translate([50, screw_d*1.5, screw_d]) rotate([0, -90, 0]) cylinder(d=screw_d, h=100);
        translate([50, arm_len - screw_d * 1.5, screw_d]) rotate([0, -90, 0]) cylinder(d=screw_d, h=100);
    }
}

module servo_mount() {
    mount= [servo[0]+2*(T+M3_tapping_hole_d()/2+hole_delta[0]), servo[1]+2*T, T];

    module mount() {
        difference() {
            cube(mount, center=true);
            cube([servo[0], servo[1], T] + clearance*2, center=true);
            for (i = [ [-1, -1], [-1, 1], [1, 1], [1, -1] ])
                translate([(servo[0]/2 + hole_delta[0]) * i[0], hole_delta[1] * i[1], 0])
                    cylinder(d=M3_tapping_hole_d(), h=T, center=true);
        }
    }

    module attachment() {
        module attachment_arm() {
            union() {
                cube([T, mount[1], attach_delta + screw_d/2 + 2*T]);
                translate([T, 0, attach_delta]) cube([attach_extra, mount[1], 2*T+screw_d/2]);
                translate([T, mount[1], attach_delta]) rotate([90, 90, 0]) linear_extrude(mount[1]) polygon([ [0, 0], [0, attach_extra], [attach_extra, 0], [0,0]]);
            }
        }
        difference() {
            union() {
                translate([T, 0, 0]) attachment_arm();
                // I have a funky tiny gap, hack around it
                translate([-T, 0, 0]) cube([3*T, mount[1], T]);
                translate([T, 0, T]) rotate([-90, 0, 0]) linear_extrude(mount[1]) polygon([ [0,0], [0,-2*T], [-T,0], [0,0] ]);
            }
            translate([0, mount[1]/2 + hole_delta[1], attach_delta + T]) rotate([0, 90, 0]) cylinder(d=screw_d, h=infinity);
            translate([0, mount[1]/2 - hole_delta[1], attach_delta + T]) rotate([0, 90, 0]) cylinder(d=screw_d, h=infinity);
        }
    }

    union() {
        mount();
        translate([mount[0]/2, -mount[1]/2, -mount[2]/2]) attachment();
    }
}

module werewolf_servo_arm() {
    servo_arm(
        action_len = inch_to_mm(2),
        arm_thickness = T,
        attachment_hole_d = No6_through_hole_d()
    );
}

module mounting_point(tube_h=inch_to_mm(1), screw_height = 8) {
    inner_d = 27;
    wall = 3;
    screw_height = 8;
    difference() {
        cylinder(d=inner_d+wall*2, h=tube_h + screw_height);
        translate([0, 0, screw_height]) cylinder(d=inner_d, h=tube_h);
        translate([-8, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=screw_height);
        translate([8, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=screw_height);
        if (tube_h > M3_through_hole_d()) translate([0, 0, screw_height + tube_h / 2]) rotate([0, 90, 0]) cylinder(d=M3_through_hole_d(), h=infinity, center=true);
    }
}

module mounting_point_drill_guide() {
    mounting_point(tube_h = 0);
}

module coupler() {
    difference() {
        union() {
            translate([0, 0, 0.1]) rotate([180, 0, 0]) mounting_point(screw_height=1);
            mounting_point(screw_height=1);
        }
        cylinder(d=25, h=infinity, center=true);
    }
}

module eye() {
    $fn=100;
    
    points = [
        [6, 8], [8, 10], [11, 14], [24, 18], [40, 19], [50, 14], [53, 12], [55, 0], [53, -12], [50, -14], [40, -17], [24, -16], [12, -11], [8, -11], [6, -8], [0, 0] ];

    hull() {
        translate([0, 0, 2]) linear_extrude(height=2, scale=0.01) polygon(points);
        linear_extrude(height=2)
            minkowski() {
                polygon(points);
                circle(d=10);
            }
    };
}

//bracket();
//push_arm();
//servo_mount();
//werewolf_servo_arm();
//eye();
//mounting_point();
mounting_point_drill_guide();
//coupler();