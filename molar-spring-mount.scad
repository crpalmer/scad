$fa = 1;
$fs = 0.6;

include <utils.scad>

w=32;
h=56;
wall=1.8;

mount_bolt_through=8.45;
mount_bolt_h = 2;
screw_slot_h1 = 10;
screw_slot_h2 = screw_slot_h1 + M4_through_hole_d();
magnet_d = 10;
magnet_thick = 3;
magnet_x = w/2 - (magnet_thick + wall*2 + wall*2 - 5);
spring_len = inch_to_mm(1 + 3/8);
spring_pole_d = 7.5;
spring_pole_h = 6;
spring_post_d = 10;
spring_post_h = 0;
hall = [4.25, 3.25, wall/3];
wire_hole=[3, 8, wall];

// component heights
min_bottom_h = screw_slot_h2 + M4_through_hole_d()/2;
bottom_h = h - spring_len;
magnet_h = magnet_d/2 + spring_post_h + 4;
hall_h = h - (magnet_h + 5 + magnet_d/2) -bottom_h;

echo("bottom_h: ", bottom_h, "min_bottom_h: ", min_bottom_h);
if (bottom_h < min_bottom_h) {
    echo("**** bottom_h too small");
}

module wire_hole() {
    translate([-w/2 + wall*2, -wire_hole[1]/2, 0]) cube(wire_hole);
}
    
module hall_sensor_guide() {
    hall = [3.25, 4.25, wall/2];
    translate([0, 0, wall-hall[2]/2]) rotate([0, 0, 45])
   cube(hall, center=true);
}

module zip_tie_slot() {
    d = 1;
    h=5;
    translate([0, -w/2, 0]) cube([d, w, h]);
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
            base = screw_slot_h1 + M4_through_hole_d()/2 - wall;
            
            translate([0, 0, base]) intersection() {
                linear_extrude(height = spring_post_d, scale = spring_post_d/wall) square([wall, wall]);
                translate([r, r, 0]) cylinder(d = spring_post_d, h=spring_post_d);
            }
            translate([r, r, base + spring_post_d]) cylinder(d = spring_post_d, h = bottom_h - (base + spring_post_d));
            translate([r, r, bottom_h + spring_post_h ]) cylinder(d=spring_pole_d, h=spring_pole_h);
        }
        
        translate([-w/2, -w/2, 0]) corner_post();
        translate([w/2, -w/2, 0]) rotate([0, 0, 90]) corner_post();
        translate([0, w/2 + wall, 0]) rotate([0, 0, -135]) corner_post();
    }

    module hall_mount() {
        c = [wall*2, hall[0] + wall*2, bottom_h + hall_h  + hall[1] + wall];
        translate([-w/2, -c[1]/2, 0]) difference() {
            cube(c);
            translate([c[0] - hall[2], wall, bottom_h + hall_h]) cube([hall[2], hall[0], hall[1]]);
            translate([0, 0, bottom_h + (hall_h-5)/2]) zip_tie_slot();
        }
    }
 
    module bolt_body() {
        cylinder(d = mount_bolt_through+wall*4, h=mount_bolt_h);
    }

    module bolt_hole() {
        cylinder(d = mount_bolt_through, h=mount_bolt_h);
    }

    module screw_slot_holes() {
        translate([0, 0, screw_slot_h1]) rotate([90, 0, 0]) cylinder(d=M4_through_hole_d(), h=1000, center=true);
        translate([0, 0, screw_slot_h2]) rotate([0, 90, 0]) cylinder(d=M4_through_hole_d(), h=1000, center=true);
    }
    
    difference() {
        union() {
            box();
            spring_posts();
            hall_mount();
            bolt_body();
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
            x = magnet_x - mount[0] - mount[0] / 2;
            translate([x, -mount[1]/2, 0]) union() {
                cube(mount);
                support();
                translate([wall*2, 0, 0]) mirror([1, 0, 0]) support();
            }
            translate([x+mount[0]+.01, 0, mount[2] - wall - magnet_d / 2]) rotate([0, -90, 0]) cylinder(d = magnet_d, h=mount[0]/2);
        }
    }
    
    box();
    for (dirs = [ [-1,-1], [1, -1], [0,1] ]) {
        spring_post(dirs);
    }
    magnet_mount();
}

module full_assembly(with_parts = true) {
    bottom();
    translate([0, 0, h]) rotate([0, 180, 0]) top();
    if (with_parts) {
        translate([-magnet_x+magnet_thick, 0, h - magnet_h]) rotate([0, -90, 0]) cylinder(d=magnet_d, h = magnet_thick);
    }
}

full_assembly(true);
//bottom();
//top();