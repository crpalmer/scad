include <utils_threads.scad>

$fn=128;

wall = 5;
void_w = 78 - wall*2;
full_void_h = 60;
void_h = full_void_h - void_w/2;
mount_dim = [30, 30, 50];
base_dim = [mount_dim[0] + wall*2 + 4, mount_dim[1] + wall*2 + 4, 65 + wall];

module bolt_cutout(d=M4_through_hole_d()+0.2, l=10) {
    translate([250, 0, 0]) rotate([0, -90, 0]) union() {
        cylinder(d=d, h=500);
        translate([l, 0, 0]) cylinder(d=d, h=500);
        translate([0, -d/2, 0]) cube([l, d, 500]);
    }
}

module bolt_cutouts() {
    bolt_cutout();
    rotate([0, 0, 90]) bolt_cutout();
}

module void() {
    button_d = 12;
    button_h = 10;
    
    dim = [void_w, void_w, void_h];
    
    translate(-dim/2) cube(dim);
    cylinder(d=button_d, h=void_h/2 + void_w / 2 + button_h);
    translate([0, 0, void_h/2]) sphere(d=void_w);
}

module cutouts() {
    bolt_cutouts();
    void();
}

module mount() {
    module nut_cutout() {
        cylinder(d=M4_through_hole_d(), h=100);
        M4_nut_insert_cutout(d_delta=-0.1);
    }

    dim = mount_dim;
    
    difference() {
        cube(dim);
        translate([0, wall, wall]) cube(dim-[wall, wall*2, wall*2]);
        translate([dim[0]/2, dim[1]/2, wall]) cylinder(d=12, h=dim[2]);
        translate([dim[0]/2, dim[1]/2, 0]) cylinder(d=8, h=wall);
        translate([dim[0]/2, wall+0.001, 12.5]) rotate([90, 0, 0]) nut_cutout();
        translate([dim[0]/2, dim[1]-wall-0.001, 12.5]) rotate([-90, 0, 0]) nut_cutout();
        translate([dim[0]-wall-0.001, dim[1]/2, 12.5]) rotate([0, 90, 0]) nut_cutout();
    }
}

module alignment_grooves(delta = 0) {
    dim = [20+delta/2, 20+delta/4, 5+delta];
    translate([-dim[0]/2, -dim[1]/2, 0])
    difference() {
        cube(dim); 
        translate([2, 2, 0]) cube(dim - [4+delta, 2+delta, 0]);
    }
}

module base() {
    module shell() {
        translate([-base_dim[0]/2, -base_dim[1]/2, 0]) difference() {
            cube(base_dim);
            translate([wall, wall, 0]) cube(base_dim - [wall*2, wall*2, wall*2]);
            translate([base_dim[0]/2, base_dim[1]/2, 0]) cylinder(d=12,h=base_dim[2]-wall);
        }
    }
    
    difference() {
        union() {
            shell();
//            translate([0, 0, base_dim[2]]) alignment_grooves();
        }
        translate([0, 0, 12]) bolt_cutouts();
    }
}

rotate([0, 180, 0]) base();
//rotate([0, 90, 0]) mount();