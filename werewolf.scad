include <utils.scad>

$fn=100;

mount_screw_d=2.5;
arm_len=inch_to_mm(6);
screw_d=4;
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
    mount= [servo[0]+2*(T+mount_screw_d/2+hole_delta[0]), servo[1]+2*T, T];

    module mount() {
        difference() {
            cube(mount, center=true);
            cube([servo[0], servo[1], T] + clearance*2, center=true);
            for (i = [ [-1, -1], [-1, 1], [1, 1], [1, -1] ])
                translate([(servo[0]/2 + hole_delta[0]) * i[0], hole_delta[1] * i[1], 0])
                    cylinder(d=mount_screw_d, h=T, center=true);
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

//bracket();
//push_arm();
servo_mount();