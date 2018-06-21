include <utils_threads.scad>

$fn=128;

wall = 5;
void_w = 78 - wall*2;
full_void_h = 60;
void_h = full_void_h - void_w/2;
mount_dim = [30, 30, 50];
base_dim = [mount_dim[0] + wall*2 + 4, mount_dim[1] + wall*2 + 4, 65 + wall];
wire_d = 4;

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
    dim = mount_dim;
    
    module nut_cutout(d_delta=0) {
        translate([0, 0, -50]) cylinder(d=M4_through_hole_d(), h=100);
        M4_nut_insert_cutout(d_delta=d_delta, h=10);
    }
    
    module wire_cutout() {
        translate([wire_d, dim[1]/2, 0]) cylinder(d=wire_d, h=wall);
        translate([0, dim[1]/2 - wire_d/2, 0]) cube([wire_d, wire_d, wall]);
    }

    difference() {
        cube(dim);
        translate([0, wall, wall]) cube(dim-[wall, wall*2, wall*2]);
        translate([dim[0]/2, dim[1]/2, wall]) cylinder(d=12, h=dim[2]);
        translate([dim[0]/2, dim[1]/2, 0]) cylinder(d=8, h=wall);
        translate([dim[0]/2, 1, 12.5]) rotate([-90, 0, 0]) nut_cutout(-.35);
        translate([dim[0]/2, dim[1]-1, 12.5]) rotate([90, 0, 0]) nut_cutout(-.35);
        translate([dim[0]-1, dim[1]/2, 12.5]) rotate([0, -90, 0]) nut_cutout(-.1);
        wire_cutout();
    }
}

module alignment_grooves(delta = 0) {
    dim = [20+delta, 20+delta/2, 5+delta];
    translate([-dim[0]/2, -dim[1]/2, 0])
    difference() {
        cube(dim); 
        translate([2+delta/2, 2+delta/2, 0]) cube(dim - [4+delta, 2+delta/2, 0]);
    }
}

module alignment_grooves_cutout() {
    alignment_grooves(0.2);
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
        shell();
        translate([0, 0, base_dim[2]+0.001]) rotate([0, 180, 0]) alignment_grooves(delta=0.6);
        translate([0, 0, 12]) bolt_cutouts();
    }
}

module mallet_top() {
    d=inch_to_mm(5);
    wall=5;
    pole_d = 27.5;  // 3/4" thin wall pvc + glue space
    pole_ext = 30;

    difference() {
        union() {
            difference() {
                minkowski() {
                    cube([d/2, d/2, d/2], center=true);
                    sphere(d=d/2);
                }
                sphere(d=d-wall*2);
            }
            translate([0, 0, -d/2-pole_ext]) cylinder(d=pole_d+wall*2, h=d-wall+pole_ext);
        }
        translate([0, 0, -d/2-pole_ext]) cylinder(d=pole_d, h=d-wall+pole_ext);
    }
}

module mallet_bottom() {
    d=50;
    wall=5;
    pole_d = 27.5;
    h = 50;
    
    module base(h=10) {
        translate([-(d-5)/2, -(d-5)/2, 2.5]) minkowski() {
            cube([d-5, d-5, h]);
            sphere(d=5);
        }
    }
        
    difference() {
        union() {
            base();
            translate([0, 0, 10]) intersection() {
                base(h);
                cylinder(d1=d*1.5, d2=pole_d+wall*2, h=20);
            }
            cylinder(d=pole_d+wall*2, h=h);
        }
        translate([0, 0, wall]) cylinder(d=pole_d, h=h);
    }
}

//rotate([0, 180, 0]) base();
//rotate([0, 90, 0]) mount();
//alignment_grooves_cutout();
//alignment_grooves();
//rotate([0, 180, 0]) mallet_top();
mallet_bottom();