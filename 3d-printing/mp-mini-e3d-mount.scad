include <utils_threads.scad>

$fn = 64;

module mount(){
    module fan_mount() {
        difference() {
            union() {
                translate([10,39,0]) cube([5, 8, 10]);
                translate([15,31,10]) cube([7, 16, 9]);
                translate([15,31,4]) linear_extrude(height=6,scale=[28,1]) square([0.25,16]);
            }
            translate([14.9,39+4.5,19-19.5/4]) rotate([0, 90, 0]) union() {
                M3_nut_insert_cutout(h=2.5);
                cylinder(d=M3_through_hole_d(), h=100);
            }
        }
    }
    
    difference(){
        union(){    
            translate([-15,0,0]) cube([30, 27, 4]);
            translate([-15,27,0]) cube([30,12,19]);
            fan_mount();
        }
    
        for (x = [10, -10]) {
            translate([x,7,0]) union() {
                cylinder(d=M3_through_hole_d(), h=100);
                translate([0, 0, 4-2.4]) nut_cutout();
            }
        }
        for (x = [10.5, -10.5]) {
            translate([x,33,0]) union() {
                cylinder(d=M3_through_hole_d(), h=100);
                nut_cutout(h=5);
            }
        }
        translate([0,26,18.95]) e3dMount();
    }
}

module bracket() {
    difference(){
        union() {
            translate([-15,-20,0]) cube([30,12,12]);
            translate([15,-28,0]) cube([7, 16, 12]);
        }
      
        for (x = [ -10.5, 10.5 ]) {
            translate([x,-14,0]) union() {
                cylinder(d=M3_through_hole_d(),h=20);
                cylinder(d=6,h=9);
            }
        }
        
        translate([0,-21,11.95]) e3dMount();
        translate([14.9,-28+3.5,12-19.5/4]) rotate([0, 90, 0]) union() {
            M3_nut_insert_cutout(h=2.5);
            cylinder(d=M3_through_hole_d(), h=100);
        }
    }
}

module nut_cutout(h=2.5) {
    rotate([0, 0, 90]) M3_nut_insert_cutout(h);
}

module e3dMount(){
    rotate([-90,0,0]){
        union(){
        
            cylinder(d=16.2, h=4.1);
            translate([0,0,4])
                cylinder(d=12, h=6);
            translate([0,0,10])
                cylinder(d=16.2, h=6);
        
        }
    }
    
}

module assembled_bracket() {
    translate([0, 19, 31]) rotate([0, 180, 180]) bracket();
}

//bracket();
mount();