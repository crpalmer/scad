include <utils_threads.scad>
include <tlm-effector-blank.scad>

$fn=64;

module chimera_orientation_tabs()
{
    w=1.2;
    h=1.2;

    for (x = [-15.05-w, 15.05]) {
        translate([x, -5, -h]) cube([w, 16, h]);
    }
}

module chimera_top_mounting_holes(d=M3_through_hole_d(), inset_h=8) {
    union() {
        for (dz = [ [d, -50], [6, inset_h]]) {
            translate([-8.5, -9, dz[1]]) cylinder(d=dz[0], h=100);
            translate([8.5, -9, dz[1]]) cylinder(d=dz[0], h=100);
            translate([0, 3, dz[1]]) cylinder(d=dz[0], h=100);
        }
    }
}

module chimera_boden_holes(d=5) {
    union() {
        translate([-9, 0, -50]) cylinder(d=d, h=100);
        translate([9, 0, -50]) cylinder(d=d, h=100);
        translate([-9, 0, 0]) cylinder(d=10, h=3);
        translate([9, 0, 0]) cylinder(d=10, h=3);
    };
}

module chimera_effector() {
    difference() {
        blank_effector();
        chimera_orientation_tabs();
        chimera_top_mounting_holes();
        chimera_boden_holes();
    }
}

module nimble_mount() {
    pad_extra = 8.427;
    union() {
        translate([-6.068, -5 - pad_extra, 0]) cube([11.8, 8 + pad_extra, 3.7]);
        translate([-3.6, -5.065, 3.7]) cube([7.130, 5.065+3.073, 2.614]);
        translate([-6.07, -2.265, 3.7]) cube([11.8, 2.490, 2.5]);
    }
}

nimble_plate = [27, 40, 4];
nimble_plate_offset = [-8, -15, 0];

nimble_plate_holes = [ [-5, 20, 0], [12, -10, 0]];
nimble_holes = [ [-2, 15, 0], [14, -2, 0]];

module nimble_mounting_holes() {
    for (h = nimble_holes) {
        union() {
            translate(h) M3_heat_set_hole();
            translate(h) M3_through_hole();
        }
    }
}

module nimble_plate() {
    module plate_corner_nibble() {
        linear_extrude() polygon([[0, 25], [20, 3], [20, 25]]);
        linear_extrude() polygon([[13.75, -15], [19.25, -7], [19.5, -15]]);
    }
    
    difference() {
        union() {
            translate(nimble_plate_offset) cube(nimble_plate);
            translate([0, 0, nimble_plate[2]]) 
            nimble_mount(0);
        }
        plate_corner_nibble();
        nimble_mounting_holes();
        cylinder(d=5, h=100);
        for (hole = nimble_plate_holes) {
            translate(hole) M3_through_hole();
        }
    }
}

module nimble_plate_mounting_holes()
{
    for (h = nimble_plate_holes) {
        translate(h) M3_heat_set_hole();
        translate(h) M3_through_hole();
    }
}

module chimera_dual_nimble_effector() {
    difference() {
        union() {
            blank_effector(T=10);
            chimera_orientation_tabs();
        }
        chimera_top_mounting_holes(d=4, inset_h=6);
        chimera_boden_holes();
        translate([9, 0, 0]) nimble_plate_mounting_holes();
        translate([-9, 0, 0]) mirror([1, 0, 0]) nimble_plate_mounting_holes();
    }
}

module e3d_nimble_effector(do_effector) {
    clip_d = 34;
    clip_h = 5.9;
    e3d_throat_d = 12;
    
    clip_body_w = (clip_d - e3d_throat_d)/2;
    hole_offset = clip_body_w / 2 + e3d_throat_d/2;
    
    clip_holes = [ [-hole_offset, 0, 0],
                   [ 0, -hole_offset, 0],
                   [ 0, hole_offset, 0]];
    
    module e3d_clip_body() {
        difference() {
            intersection() {
                cylinder(d=clip_d, h=clip_h);
                translate([-clip_d/2, -clip_d/2, 0]) cube([clip_d*0.75, clip_d, 100]);
            }
            cylinder(d=e3d_throat_d, h=100);
            translate([0, -e3d_throat_d/2, 0]) cube([100, e3d_throat_d, 100]);
        }
    }
    
    module e3d_top_hole() {
        cylinder(d=16.1, h=100);
    }
    
    module effector() {
        difference() {
            blank_effector();
            linear_extrude(height=4) offset(delta=0.1) projection() e3d_clip_body();
            e3d_top_hole();
            for (hole = clip_holes) {
                translate(hole) cylinder(d=M3_through_hole_d(), h=100);
            }
            nimble_plate_mounting_holes();
        }
    }
    
    module clip() {
        difference() {
            e3d_clip_body();
            for (hole = clip_holes) {
                translate(hole) M3_heat_set_hole();
                translate(hole) cylinder(d=M3_through_hole_d(), h=100);
            }
        }
    }
    
    if (do_effector) {
        effector();
    }
    
    if (do_effector == false) {
        clip();
    }
}

// Effectors
// ----------
//blank_effector();
//chimera_effector();
chimera_dual_nimble_effector();
//e3d_nimble_effector(true);
//e3d_nimble_effector(false);

// Right hand plate
//nimble_plate();
// Left hand plate
//mirror([1, 0, 0]) nimble_plate();