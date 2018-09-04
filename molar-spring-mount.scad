$fa = 1;
$fs = 0.6;

include <utils.scad>

w=32;
h=56;
wall=2;

// plate parameters
mount_bolt_through=8.45;
screw_slot_h1 = 10;
screw_slot_h2 = screw_slot_h1 + M4_through_hole_d()/2;
wire_hole_d = 5;
plate_screw_post_d = M3_tapping_hole_d() + wall*2;

// top/bottom parameters
button_body_d = 10;
button_mount_d = button_body_d + wall*2;
button_hole_d = 7;
button_h = 12.5 - wall;
magnet_d = 12.5;
spring_len = inch_to_mm(.75);
spring_pole_d = 7.5;
spring_pole_h = 6;
spring_post_d = (w - magnet_d)/2;
spring_post_h = 5/2 + wall;

// component heights
min_plate_h = screw_slot_h2 + M4_through_hole_d()/2 + wall;
plate_h = h - spring_post_h*2 - spring_len;
echo("plate_h: ", plate_h, "min_plate_h: ", min_plate_h);
if (plate_h < min_plate_h) {
    echo("**** plate_h too small");
}

plate_to_bottom_screw_at = w/2 - wall - M3_tapping_hole_d()/2;
;

module wire_hole() {
    translate([w/4, w/4, 0]) cylinder(d = wire_hole_d, h=wall);
}
    

module plate() {
    module box() {
        translate([-w/2, -w/2, 0]) difference() {
            cube([w, w, plate_h]);
            translate([wall, wall, wall]) cube([w-wall*2, w-wall*2, plate_h-wall]);
        }
    }
    
    module post(dirs) {
        d=plate_to_bottom_screw_at;
        translate([dirs[0]*d, dirs[1]*d, 0]) difference() {
            cylinder(d = M3_tapping_hole_d() + wall*2, h=plate_h);
            translate([0, 0, wall]) cylinder(d = M3_tapping_hole_d(), h = plate_h);
        }
    }
    
    module bolt_hole() {
        cylinder(d = mount_bolt_through, h=wall);
    }

    module screw_slot_holes() {
        translate([0, 0, screw_slot_h1]) rotate([90, 0, 0]) cylinder(d=M4_through_hole_d(), h=1000, center=true);
        translate([0, 0, screw_slot_h2]) rotate([0, 90, 0]) cylinder(d=M4_through_hole_d(), h=1000, center=true);
    }
    
    difference() {
        union() {
            box();
            for (dirs = [ [-1,-1], [-1,1], [1,-1], [1,1] ]) {
                post(dirs);
            }
        }
        bolt_hole();
        wire_hole();
        screw_slot_holes();
    }
}

module top_bottom_common() {
    module box() {
        translate([-w/2, -w/2, 0]) cube([w, w, wall]);
    }
    
    module spring_post(dirs) {
        d = w/2 - spring_post_d/2;
        translate([dirs[0]*d, dirs[1]*d, 0]) union() {
            cylinder(d = spring_post_d, h = spring_post_h);
            translate([0, 0, spring_post_h]) cylinder(d = spring_pole_d, h = spring_pole_h);
        }
    }
    
    union() {
        box();
        for (dirs = [ [1,0], [-1,0], [0,1], [0,-1] ]) {
            spring_post(dirs);
        }
    }
}

module bottom() {
    module hall_sensor_guide() {
        hall = [3.25, 4.25, wall/2];
        translate([0, 0, wall-hall[2]/2]) rotate([0, 0, 45])
       cube(hall, center=true);
    }

    module screw_hole(dirs) {
        d = plate_to_bottom_screw_at;
        translate([dirs[0]*d, dirs[1]*d, 0]) cylinder(d = M3_through_hole_d(), h = 10000);
    }

    module screw_holes() {
        for (dirs = [ [-1,-1], [-1,1], [1,-1], [1,1] ]) {
            screw_hole(dirs);
        }
    }
    
    module zip_tie_slots() {
        for (dir = [1, -1]) {
            translate([2.5*dir, -2.5*dir, 0]) rotate([0, 0, -45]) translate([-1, 0, 0]) cube([2, 6, h]);
        }
    }
    
    difference() {
        top_bottom_common();
        screw_holes();
        hall_sensor_guide();
        zip_tie_slots();
        wire_hole();
    }
}

module magnet_guide() {
    translate([0, 0, wall/2]) cylinder(d = magnet_d, h=wall/2);
}

module top() {
    difference() {
        top_bottom_common();
        magnet_guide();
    }
}

module full_assembly() {
    plate();
    translate([0, 0, plate_h]) bottom();
    translate([0, 0, h]) rotate([0, 180, 0]) top();
}

//full_assembly();
//plate();
bottom();
//top();