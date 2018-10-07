include <utils.scad>

$fn=128;

top_h = 4;
top_d = 39;
mount_h = 4;
mount_d = 10;
bottom_h = 4;

top_square = [39, 47, top_h];
inner_square = [14, 14, top_h];
inner_d = 14;

clearance_holes = [[-13.5, 11], [13.5, 11]];
scroll_wheel_holes = [ [0, 18], [-13, -13], [13, -13]];
spacer_hole = [0, -top_square[1]/2 - mount_d];

bottom_square = [ 20, top_square[1] + mount_d*4, bottom_h];

module circle_square(d, s) {
    translate([-s[0]/2, -s[1]/2, 0]) cube(s);
    translate([0, -s[1]/2, 0]) cylinder(d = d, h = s[2]);
    translate([0, s[1]/2, 0]) cylinder(d = d, h = s[2]);
}

module top() {
    angles = [ 0, 45, 90, 135, 180, -135, -90, -45];

    module mount_translate(angle) {
        translate([0, abs(angle) == 90 ? mount_d : abs(angle) == 270 ? -mount_d : 0, 0]) children();
    }

    module plate() {
        module mount() {
            translate([0, -mount_d*.5, mount_h]) cube([mount_d, mount_d*1.5, top_h]);
            translate([mount_d/2, mount_d, 0]) cylinder(d=mount_d, h=mount_h+top_h);
        }
        
        translate([-top_square[0]/2, -top_square[1]/2, mount_h]) rounded_cube(top_square, r=10);
        for (angle = angles) {
            mount_translate(angle)
            rotate([0, 0, angle])
            translate([-mount_d/2, top_square[1]/2, 0])
            mount();
        }
    }
    
    difference() {
        plate();
        for (angle = angles) {
            mount_translate(angle)
            rotate([0, 0, angle])
            translate(spacer_hole)
            cylinder(d = M3_through_hole_d(), h=100);
        }
        translate([0, -2.5, mount_h]) circle_square(inner_d, inner_square);
        for (hole = scroll_wheel_holes) {
            translate(hole) cylinder(d = M3_through_hole_d(), h=100);
        }
        for (hole = clearance_holes) {
            translate(hole) cylinder(d = 7, h=100);
        }
    }
}

module extrusion_groove(mm, len=20) {
    translate([-mm/2, 0, 0]) cube([mm, len, 5]);
}

module extrusion_mount(mm=6.5) {
    difference() {
        union() {
            translate([-bottom_square[0]/2, -bottom_square[1]/2, 0]) cube(bottom_square);
            translate([0, -top_square[1]/3, -5]) extrusion_groove(mm, top_square[1]/3*2);
        }
        for (angle = [0, 180]) {
            rotate([0, 0, angle]) translate(spacer_hole) M3_recessed_through_hole();
        }
        translate([0, bottom_square[1]/4, 0]) cylinder(d=M3_through_hole_d(), h=100);
        translate([0, -bottom_square[1]/4, 0]) cylinder(d=M3_through_hole_d(), h=100);
    }
}

module taz_mount() {
    extrusion_mount(5-.1);
}

module screw_mount(mm=M3_through_hole_d()) {
    difference() {
        translate([-bottom_square[0]/2, -bottom_square[1]/2, 0]) cube(bottom_square);
        for (angle = [0, 180]) {
            rotate([0, 0, angle]) translate(spacer_hole) M3_recessed_through_hole();
        }
        for (dir = [-1, 0, 1]) {
            translate([0, dir*bottom_square[1]/5, 0]) cylinder(d=mm, h=100);
        }
    }
}

//rotate([0, 180, 0]) top();
rotate([0, 180, 0]) extrusion_mount();
//rotate([0, 180, 0]) taz_mount();
//rotate([0, 180, 0]) screw_mount();
//rotate([0, 180, 0]) screw_mount(6);