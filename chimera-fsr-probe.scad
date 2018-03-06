include <utils_threads.scad>

$fn=64;

W=17;
screw_block_h=6;
screw_block_d=8;

module back() {
    L=45;
    difference() {
        union() {
            cube([W, L, 3]);
            translate([0, 7, 2]) cube([W, 6, 10]);
            translate([0, L-screw_block_h, 0]) cube([W, screw_block_h, screw_block_d]);
        }
        translate([W/2-4.5, 10, 0]) cylinder(d=M3_through_hole_d(), h=100);
        translate([W/2+4.5, 10, 0]) cylinder(d=M3_through_hole_d(), h=100);
        translate([W*.25, L-screw_block_h, screw_block_d/2]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=10);
        translate([W*.75, L-screw_block_h, screw_block_d/2]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=10);
    }
}

module front() {
    L=14;
    difference() {
        union() {
            cube([W, L, 3]);
            translate([0, L-screw_block_h, 0]) cube([W, screw_block_h, screw_block_d]);
        }
        translate([W*.25, L-screw_block_h, screw_block_d/2]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=7);
        translate([W*.75, L-screw_block_h, screw_block_d/2]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=7);
    }
}

module bottom() {
    back_to_chimera=2+10;
    L=back_to_chimera+18+10;
    P=0.4*4;
    difference() {
        union() {
            translate([-screw_block_d/2, 0, 0]) cube([screw_block_d, L, 5]);
            translate([-W/2, 0, 0]) cube([W, screw_block_d, 5]);
            translate([-W/2, L-screw_block_d, 0]) cube([W, screw_block_d, 5]);
            translate([-P/2, back_to_chimera+5-P/2, 0]) cube([P, P, 6]);
        }
        translate([-W/4, screw_block_d/2, 0]) M3_recessed_through_hole();
        translate([W/4, screw_block_d/2, 0]) M3_recessed_through_hole();
        translate([-W/4, L-screw_block_d/2, 0]) M3_recessed_through_hole();
        translate([W/4, L-screw_block_d/2, 0]) M3_recessed_through_hole();
    }
}

translate([15, 0, 0]) back();
translate([-30, 0, 0]) front();
bottom();
