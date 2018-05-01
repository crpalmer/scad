include <utils.scad>

//$fn=128;

top_h = 4;
mount_h = 5;

top_square = [39, 47, top_h];
top_d = 39;
mount_h = 10;
mount_d = 10;
inner_square = [14, 14, top_h];
inner_d = 14;

scroll_wheel_holes = [ [0, 18], [-12, -14], [12, -14]];
spacer_holes = [ [0, -top_square[1]/2 - mount_d], [0, top_square[1]/2 + mount_d] ];

bottom_square = [ 40, top_square[1] + mount_d*4, top_h];

module circle_square(d, s) {
    translate([-s[0]/2, -s[1]/2, 0]) cube(s);
    translate([0, -s[1]/2, 0]) cylinder(d = d, h = s[2]);
    translate([0, s[1]/2, 0]) cylinder(d = d, h = s[2]);
}

module top() {
    module plate() {
        module mount() {
            translate([0, 0, mount_h]) cube([mount_d, mount_d, top_h]);
            translate([mount_d/2, mount_d, 0]) cylinder(d=mount_d, h=mount_h+top_h);
        }
            
        translate([-top_square[0]/2, -top_square[1]/2, mount_h]) rounded_cube(top_square, r=10);
        translate([-mount_d/2, top_square[1]/2, 0]) mount();
        translate([-mount_d/2, -top_square[1]/2, 0]) mirror([0, 1, 0]) mount();
    }
    
    difference() {
        plate();
        for (hole = spacer_holes) {
            translate(hole) cylinder(d = M3_through_hole_d(), h=100);
        }
        translate([0, -2.5, mount_h]) circle_square(inner_d, inner_square);
        for (hole = scroll_wheel_holes) {
            translate(hole) cylinder(d = M3_through_hole_d(), h=100);
        }
    }
}

module extrusion_groove(mm, len=20) {
    translate([0, -mm/2, 0]) cube([len, mm-0.4, mm]);
}

module taz6() {
    difference() {
        union() {
            translate([-bottom_square[0]/2, -bottom_square[1]/2, 0]) cube(bottom_square);
            translate([-bottom_square[0]/2, 0, -5]) extrusion_groove(5, bottom_square[0]/2);
        }
        for (hole = spacer_holes) {
            translate(hole) M3_recessed_through_hole();
        }
    }
}
        
//rotate([0, 180, 0]) top();
taz6();