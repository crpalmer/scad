include <utils_threads.scad>

$fn=64;

H=6;
corner_H=10 + H;
corner_L=20;
corner_W=4;
screw_mount_offset= - 5;
screw_mount_W=45;
screw_mount_L=23.7+M5_through_hole_d()*1.5;

module corner(H) {
    arm = [corner_L*cos(30), corner_L*sin(30)];
    arm2 = [-arm[0], arm[1] ];
    
    points = [
        [0, 0],
        arm,
        arm2
    ];
     

    difference() {
        translate([0, -corner_W, 0]) linear_extrude(height=corner_H) polygon(points);
        translate([0, 0, H]) linear_extrude(height=corner_H) polygon(points);
    }
}

module screw_mount() {
    W=screw_mount_W;
    L=screw_mount_L;
    
    difference() {
        translate([-W/2 + screw_mount_offset, 2, 0]) cube([W, L, H]);
        translate([0, L-M5_through_hole_d()*1.5, 0]) M5_recessed_through_hole(H);
    }
}

module fsr2d() {
    fsr_D=19;
    lead_W=6;
    lead_L=30;
    gateway_W=9;
    gateway_L=7;
    union() {
        circle(d=fsr_D);
        translate([-lead_W/2, 0, 0]) square([lead_W, lead_L + fsr_D/2]);
        translate([-gateway_W/2, 0, 0]) square([gateway_W, gateway_L + fsr_D/2]);
    }
}

module fsr_mount(H=6, lip_H=3, extra=0) {
    fsr_H=H - lip_H;
    union() {
        difference() {
            linear_extrude(height=H) offset(delta=2) fsr2d(); 
            translate([0, 0, fsr_H]) linear_extrude() fsr2d();
        }
    }
}

module corner_mount_for_fsr() {
    difference() {
        union() {
            corner(H=6);
            screw_mount();
        }
        translate([0, 11, 6-1.2]) rotate([0, 0, 60]) linear_extrude() fsr2d();
    }
}

module board_mount() {
    screw_delta=3.3/2+1.1;
    board_W=30.5;
    mounting_delta=7.5;
    difference() {
        union() {
            cube([board_W, 14, 5]);
            cube([board_W, 3.2, 20]);
            translate([0, 14-2.5, 0]) cube([board_W, 2.5, 20]);
        }
        $fn=64;
        translate([screw_delta, mounting_delta, 0]) cylinder(d=M3_tapping_hole_d(), h=1000);
        translate([board_W-screw_delta, mounting_delta, 0]) cylinder(d=M3_tapping_hole_d(), h=1000);
        translate([5, -5, 10]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=10);
        translate([board_W-5, -5, 10]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=10);
    }
}

corner_mount_for_fsr();
//board_mount();
//fsr_mount(9, 1);
//rotate([0, 0, 90]) pillar_mount_for_fsr();