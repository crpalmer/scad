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
        translate([-8.5, 9, -50]) cylinder(d=d, h=100);
        translate([8.5, 9, -50]) cylinder(d=d, h=100);
        translate([0, -3, -50]) cylinder(d=d, h=100);
    }
}

module chimera_boden_holes(d=5) {
    union() {
        translate([-9, 0, -50]) cylinder(d=d, h=100);
        translate([9, 0, -50]) cylinder(d=d, h=100);
        translate([-9, 0, T/2]) cylinder(d=12, h=100);
        translate([9, 0, T/2]) cylinder(d=12, h=100);
    };
}

module chimera_effector() {
    difference() {
        blank_effector();
        chimera_top_mounting_holes();
        chimera_boden_holes();
    }
}

chimera_effector();
