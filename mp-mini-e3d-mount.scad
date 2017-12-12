include <utils_threads.scad>

$fn = 64;

module mount(){
    difference(){
        union(){    
             translate([-17,0,0])   
                cube([34, 27, 4]);

            translate([-17,27,0])
             cube([34,12,19]);
            
             translate([-17,-5,0])   
                cube([34, 5, 4]);
             
            translate([9,39,0])
                cube([8, 4, 18.75]);
        }
        translate([-17, -5, 0]) union() {
            difference() {
                cube([34, 100, 1]);
                translate([2, 0, 0]) cube([30, 100, 1]);
            }
            translate([32, 0, 1]) rotate([0, 90, 90]) linear_extrude(height=100) polygon([ [0, 0], [-2, -2], [0, -2], [0, 0]]);
            translate([2, 50, 1]) rotate([0, -90, 90]) linear_extrude(height=100) polygon([ [0, 0], [2, 2], [0, 2], [0, 0]]);
        }
        
    translate([10,7,2])    
        boltHole();
        
    translate([-10,7,2])    
        boltHole();
    
    translate([-11.5,33,0])    
        longBoltHole();
     
    translate([11.5,33,0])    
        longBoltHole();
      
    translate([0,26,18.95])
        e3dMount();

    translate([13,43.1,5.5]) rotate([90, 0, 0]) union() {
        M3_nut_insert_cutout();
        cylinder(d=M3_through_hole_d(), h=4);
    }
    }
}

module bracket(){
    
    difference(){
        translate([-17,-20,0]) union() {
            cube([34,12,12]);
            translate([26,-4,0]) cube([8, 4, 11.75]);
        }
      
        translate([-11.5,-14,-1])
            cylinder(d=M3_through_hole_d(),h=20);
        
        translate([11.5,-14,-1])
            cylinder(d=M3_through_hole_d(),h=20);
        
        translate([11.5,-14,-0])
            cylinder(d=6,h=9);
        
        translate([-11.5,-14,-0])
            cylinder(d=6,h=9);
        
        translate([0,-21,11.95])
            e3dMount();

        translate([13,-21,5.5]) rotate([90, 0, 0])
            M3_nut_insert_cutout();

        translate([13,-20.1,5.5]) rotate([90, 0, 0])
            cylinder(d=M3_through_hole_d(), h=4);
    }
}

module boltHole(){
    union(){
        M3_nut_insert_cutout();
        translate([0,0,-4])
            cylinder(d=M3_through_hole_d(), h=5);
        
    }    
    
}

module longBoltHole(){
    union(){
        translate([0,0,-.1])
        M3_nut_insert_cutout();
        translate([0,0,0])
            cylinder(d=M3_through_hole_d(), h=20);
        
    }    
    
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


//bracket();
mount();

