include <utils.scad>
include <high-detail.scad>

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

module bearing_plate() {
    top_wall = 2;
    bearing_h = 7;
    bearing_hole_d = 16;
    bearing_d = 22;
    
    h = top_wall + bearing_h;
    w = bearing_d + 2*4;
    
    module plate() {
        translate([spacer_hole[0] - w/2, -abs(spacer_hole[1])]) cube([w, abs(spacer_hole[1])*2, h]);
        translate(spacer_hole) cylinder(d = w, h = h);
        rotate([0, 0, 180]) translate(spacer_hole) cylinder(d = w, h = h);
    }
    
    module spacer_holes() {
        translate(spacer_hole) cylinder(d = M3_through_hole_d(), h = h);
        rotate([0, 0, 180]) translate(spacer_hole) cylinder(d = M3_through_hole_d(), h = h);
    }

    module bearing_cutout() {
        translate([0, 0, top_wall]) cylinder(d = bearing_d, h = h);
        cylinder(d = bearing_hole_d, h = h);
    }
    
    difference() {
        plate();
        spacer_holes();
        bearing_cutout();
    }
}

module bearing_mounting_bracket_tlm() {
    wall = 4;
    hole_to_spacer = 30;
    bearing_plate_h = 9;
    bearing_h = abs(spacer_hole[1]) + wall*2;
    spacer_d = 13;
    spacer_h = 5;
    mount_spacing = 20;
    
    base = [hole_to_spacer + bearing_plate_h + spacer_h + wall*2 + M3_through_hole_d() / 2, mount_spacing + wall * 2, wall];
    bearing_wall = [ wall, base[1], wall + bearing_h + M5_through_hole_d()/2 + wall];
    
    module base() {
        difference() {
            translate([0, -base[1]/2, 0]) cube(base);
            translate([base[0] - wall - M3_through_hole_d()/2, 0, 0]) for (y = [1, -1] * mount_spacing/2) {
                translate([0, y, 0]) cylinder(d = M3_through_hole_d(), h = base[2]);
            }
        }
    }
    
    module bearing_wall() {
        difference() {
            union() {
                translate([0, -bearing_wall[1]/2, 0]) cube(bearing_wall);
                translate([0, 0, bearing_h + wall]) rotate([0, 90, 0]) cylinder(d = spacer_d, h = spacer_h + wall);
            }
            translate([0, 0, bearing_h + wall]) rotate([0, 90, 0]) cylinder(d = M5_through_hole_d(), h = spacer_h + wall);
        }
    }
    
    module brace() {
        translate([0, -bearing_wall[1]/2, 0]) linear_extrude(height = wall*3, scale=[1/(wall*3), 1]) square([wall*3, bearing_wall[1]]);
    }
    
    base();
    bearing_wall();
    brace();
}

//rotate([0, 180, 0]) top();
//rotate([0, 180, 0]) extrusion_mount();
//rotate([0, 180, 0]) taz_mount();
//rotate([0, 180, 0]) screw_mount();
//rotate([0, 180, 0]) screw_mount(6);

//translate([20, 0, 0]) bearing_plate();
rotate([0, -90, 0]) bearing_mounting_bracket_tlm();