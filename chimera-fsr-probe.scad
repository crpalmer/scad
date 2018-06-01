include <utils_threads.scad>

$fn=64;

module bad_probe_attached_to_chimera()
{
    thick=5;
    W=17;
    screw_block_h=6;
    screw_block_d=8;

    module back() {
        L=46;
        translate([-W/2, -L, 0])
        difference() {
            union() {
                cube([W, L, thick]);
                translate([0, 7, thick]) cube([W, 6, 10]);
            }
            translate([W/2-4.5, 10, 0]) cylinder(d=M3_through_hole_d(), h=100);
            translate([W/2+4.5, 10, 0]) cylinder(d=M3_through_hole_d(), h=100);
        }
    }

    module bottom() {
        back_to_chimera=thick+10;
        back_to_nozzle=back_to_chimera + 6;
        L=back_to_nozzle + 2;
        P=0.4*4;
        union() {
            translate([-screw_block_d/2, 0, 0]) cube([screw_block_d, thick, L]);
            translate([-W/2, 0, 0]) cube([W, thick, screw_block_d]);
            translate([0, thick, back_to_nozzle-P/2-P]) linear_extrude(height=P, scale=[50, 100]) square([P/100, P/100]);
            translate([0, thick, back_to_nozzle-P/2-P]) mirror([1, 0, 0]) linear_extrude(height=P, scale=[50, 100]) square([P/100, P/100]);
            translate([-P/2, thick, back_to_nozzle-P/2]) cube([P, P, P]);
        }
    }

    back();
    bottom();
}

module chimera_base()
{
    difference() {
        translate([-12, -6, 0]) cube([24, 18, 6]);
        translate([0,-3, 0]) cylinder(d=M3_tapping_hole_d(), h=6);
        translate([-8.5, 9,  0]) cylinder(d=M3_tapping_hole_d(), h=6);
        translate([8.5, 9,  0]) cylinder(d=M3_tapping_hole_d(), h=6);
    }
}

module fsr_poking_stick()
{
    union() {
        chimera_base();
        linear_extrude(height=49, scale=0.8/10) square([10, 10], center=true);
    }
}

module ir_calibration_mount()
{
    difference() {
        union() {
            chimera_base();
            translate([-12, -4, 0]) cube([24, 4, 40]);
        }
        translate([-6, -50, 48-20]) cube([12, 100, 100]);
        translate([-9, -50, 48-15.2]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=100);
        translate([9, -50, 48-15.2]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=100);        
    }
}
module tlm_ir_mount()
{
    h = 53;
    difference() {
        union() {
            translate([-12, 0, 0]) cube([24, 10, 5]);
            translate([-12, 8, 0]) cube([24, 4, 52-10]);
        }
        translate([-9, 5, 0]) cylinder(d=M3_through_hole_d(), h=100);
        translate([9, 5, 0]) cylinder(d=M3_through_hole_d(), h=100);
        translate([-6, -50, 25]) cube([12, 100, 100]);
        translate([-9, -50, h-15.2]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=100);
        translate([9, -50, h-15.2]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=100);        
    }
}

//fsr_poking_stick();
//ir_calibration_mount();
tlm_ir_mount();