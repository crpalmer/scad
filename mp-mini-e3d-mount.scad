include <utils_threads.scad>

$fn = 64;

module mount(){
    difference(){
        union(){    
            translate([-15,0,0]) cube([30, 27, 4]);
            translate([-15,27,0]) cube([36,12,19]);
            translate([-15,-5,0]) cube([30, 5, 4]);
            translate([16,39,0]) cube([5, 8, 19]);
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
                nut_cutout();
            }
        }
        translate([0,26,18.95]) e3dMount();
        translate([15.9,39+3.5,19-19.5/4]) rotate([0, 90, 0]) union() {
            M3_nut_insert_cutout(h=2.5);
            cylinder(d=M3_through_hole_d(), h=100);
        }
    }
}

module bracket() {
    difference(){
        union() {
            translate([-15,-20,0]) cube([36,12,12]);
            translate([16,-28,0]) cube([5, 8, 12]);
        }
      
        for (x = [ -10.5, 10.5 ]) {
            translate([x,-14,0]) union() {
                cylinder(d=M3_through_hole_d(),h=20);
                cylinder(d=6,h=9);
            }
        }
        
        translate([0,-21,11.95]) e3dMount();
    }
}

module nut_cutout() {
    rotate([0, 0, 90]) M3_nut_insert_cutout(h=2.5);
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


bracket();
mount();