//$fa = 1;
//$fs = 0.6;

include <utils.scad>

w=32;
h=60;
wall=2;

mount_bolt_through=8.45;
screw_slot_h1 = 10;
screw_slot_h2 = screw_slot_h1 + M4_through_hole_d()/2;
wire_hole_d = 5;
magnet_d = 10;
spring_len = inch_to_mm(1 + 3/8);
spring_pole_d = 7.5;
spring_pole_h = 6;
spring_post_d = spring_pole_d;
spring_post_h = 0;

// component heights
magnet_h = spring_post_h + spring_len/2;
min_bottom_h = screw_slot_h2 + M4_through_hole_d()/2 + wall;
bottom_h = h - spring_post_h*2 - spring_len;
echo("bottom_h: ", bottom_h, "min_bottom_h: ", min_bottom_h);
if (bottom_h < min_bottom_h) {
    echo("**** bottom_h too small");
}

module wire_hole() {
    translate([w/4, w/4, 0]) cylinder(d = wire_hole_d, h=wall);
}
    
module hall_sensor_guide() {
    hall = [3.25, 4.25, wall/2];
    translate([0, 0, wall-hall[2]/2]) rotate([0, 0, 45])
   cube(hall, center=true);
}

module zip_tie_slots() {
    for (dir = [1, -1]) {
        translate([2.5*dir, -2.5*dir, 0]) rotate([0, 0, -45]) translate([-1, 0, 0]) cube([2, 6, h]);
    }
}

module bottom() {
    module box() {
        translate([-w/2, -w/2, 0]) difference() {
            cube([w, w, bottom_h]);
            translate([wall, wall, wall]) cube([w-wall*2, w-wall*2, bottom_h-wall]);
        }
    }
    
    module spring_posts() {
        r = spring_post_d / 2;
        
        module corner_post() {
            translate([r, r, spring_post_d]) cylinder(d=spring_post_d, h=bottom_h - min_bottom_h - spring_post_d + spring_post_h);
            intersection() {
                linear_extrude(height = spring_post_d, scale = spring_post_d/wall) square([wall, wall]);
                translate([r, r, 0]) cylinder(d = spring_post_d, h=spring_post_d);
            }
            translate([r, r, bottom_h - min_bottom_h + spring_post_h]) cylinder(d = spring_pole_d, h = spring_pole_h);
        }
        
        translate([-w/2, -w/2, min_bottom_h]) corner_post();
        translate([w/2, -w/2, min_bottom_h]) rotate([0, 0, 90]) corner_post();
        translate([0, w/2 + wall, min_bottom_h]) rotate([0, 0, -135]) corner_post();
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
            spring_posts();
        }
        bolt_hole();
        wire_hole();
        screw_slot_holes();
    }
}

module top() {
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
    
    module magnet_mount() {
        mount = [ wall*2, magnet_d + wall*2, magnet_h + magnet_d/2 + wall ];

        module support() {
            translate([wall, 0, wall]) linear_extrude(height=wall, scale=[1/wall, 1]) square([mount[0]/2+wall, mount[1]]);
        }
        
    difference() {
            translate([-mount[0], -mount[1]/2, 0]) union() {
                cube(mount);
                support();
                translate([wall*2, 0, 0]) mirror([1, 0, 0]) support();
            }
            translate([0, 0, mount[2] - wall - magnet_d / 2]) rotate([0, -90, 0]) cylinder(d = magnet_d, h=mount[0]/2);
        }
    }
    
    box();
    for (dirs = [ [-1,-1], [1, -1], [0,1] ]) {
        spring_post(dirs);
    }
    magnet_mount();
}

module full_assembly(with_parts = true) {
    magnet_thick = 3;
    bottom();
    translate([0, 0, h]) rotate([0, 180, 0]) top();
    if (with_parts) {
        translate([wall, 0, h - magnet_h]) rotate([0, -90, 0]) cylinder(d=magnet_d, h = magnet_thick);
    }
}

full_assembly(true);
//bottom();
//top();