$fn=100;

screw_d=3.5;
mount_screw_d=2.5;
hole_delta = [ 4.5, 5 ];
clearance=[ 0.1, 0.1, 0 ];
attach_delta=18;
attach_extra=4;
T=4;
infinity=100;

servo = [40.4, 19.8, 27 ];
mount= [servo[0]+2*(T+mount_screw_d/2+hole_delta[0]), servo[1]+2*T, T];

module servo_mount() {
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

module doit() {
    union() {
        servo_mount();
        translate([mount[0]/2, -mount[1]/2, -mount[2]/2]) attachment();
    }
}

doit();

