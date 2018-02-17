include <utils.scad>

$fn=64;

arm_mount_radius=34;
arm_spacing=45;
arm_taper_len=8;
arm_taper=[6.5, 8];
T=8;

module ball_mount() {
    arm_cube=[8, 13, T];
    difference() {
        union() {
            rotate([-90, 0, -90])tapered_cylinder(d0=arm_taper[1], d1=arm_taper[0], h=arm_taper_len);
        translate([-arm_cube[0], -arm_taper[1]/2, -T/2]) cube(arm_cube);            
        }
        translate([-50, 0, 0]) rotate([-90, 0, -90]) cylinder(d=M4_tapping_hole_d(), h=100);
    }  
}

module arm_connector() {
    translate([arm_spacing/2-arm_taper_len, 0, 0]) ball_mount();
}

module arm_connector_pair() {
    for (angle = [0, 180]) {
        rotate([0, angle, 0]) {
            arm_connector();
        }
    }
}

module arm_connectors() {
    for (angle = [0, 120, 240]) {
        rotate([0, 0, angle])
            translate([0, -arm_mount_radius, T/2])
            arm_connector_pair();
    }
}

module plate() {
    w=26;
    l=30;
    delta=atan((l/2) / w);
    
    points = [
        for (angle = [60-delta, 60+delta, 180-delta, 180+delta, 300-delta, 300+delta])
            l*[sin(angle), cos(angle)]
        ];
    linear_extrude(height=T) polygon(points);
}

module blank_effector() {
    union() {
        arm_connectors();
        plate();
    }
}

module chimera_top_mounting_holes(d=M3_through_hole_d()) {
    union() {
        for (dz = [ [d, -50], [6, T]]) {
            translate([-8.5, 9, dz[1]]) cylinder(d=dz[0], h=100);
            translate([8.5, 9, dz[1]]) cylinder(d=dz[0], h=100);
            translate([0, -3, dz[1]]) cylinder(d=dz[0], h=100);
        }
    }
}

module chimera_boden_holes(d=5) {
    union() {
        translate([-9, 0, -50]) cylinder(d=d, h=100);
        translate([9, 0, -50]) cylinder(d=d, h=100);
        translate([-9, 0, 0]) cylinder(d=12, h=T/2);
        translate([9, 0, 0]) cylinder(d=12, h=T/2);
    };
}

module chimera_effector() {
    difference() {
        blank_effector();
        chimera_top_mounting_holes();
        rotate([0, 0, 180]) chimera_boden_holes();
    }
}

module nimble_mount() {
    union() {
        translate([-5.732, -3, 0]) cube([11.8, 16.427, 3.7]);
        translate([-3.531, -3.073, 3.7]) cube([7.130, 5.065+3.073, 2.614]);
        translate([-5.73, -0.225, 3.7]) cube([11.8, 2.490, 2.5]);
    }
}

module nimble_holes() {
    union() {
        translate([8.3, -16, -4]) cylinder(d=10, h=100);
        translate([-2, -15, -50]) cylinder(d=M3_tapping_hole_d(), h=100);
        translate([14, 2, -50]) cylinder(d=M3_tapping_hole_d(), h=100);
    }
}
    
module chimera_dual_nimble_effector() {
    difference() {
        union() {
            blank_effector();
            translate([9, 0, T]) nimble_mount();
            translate([-9, 0, T]) mirror([1, 0, 0]) nimble_mount();
        }
        chimera_top_mounting_holes(d=4);
        chimera_boden_holes(d=3.5);
        translate([9, 0, T]) nimble_holes();
        translate([-9, 0, T]) mirror([1, 0, 0]) nimble_holes();
    }
}

chimera_dual_nimble_effector();
