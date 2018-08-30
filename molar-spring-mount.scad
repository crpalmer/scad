include <utils.scad>

w=32;
h=60;
wall=2;

// plate parameters
mount_bolt_through=8.45;
screw_slot_h1 = 14;
screw_slot_h2 = screw_slot_h1 + M4_through_hole_d();
wire_hole_d = 5;
plate_screw_post_d = M3_tapping_hole_d() + wall*2;

// top/bottom parameters
top_bottom_gap = 1.25;
spring_pole_d = 4.25;
button_body_d = 10;
button_mount_d = button_body_d + wall*2;
button_hole_d = 7;
button_h = 12.5 - wall;

// component heights
plate_h = screw_slot_h2 + M4_through_hole_d()/2 + 15;
plate_mounting_screw_h = 20;
top_bottom_h = (h - plate_h - top_bottom_gap) / 2;
button_mount_h = top_bottom_h - button_h;
spring_pole_h = top_bottom_h - top_bottom_gap;

plate_to_bottom_screw_at = w/2 - wall - M3_tapping_hole_d()/2;
;

module plate() {
    $fn = 128;
    
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
            translate([0, 0, plate_h - plate_mounting_screw_h]) cylinder(d = M3_tapping_hole_d(), h = 1000);
        }
    }
    
    module bolt_hole() {
        cylinder(d = mount_bolt_through, h=1000);
    }

    module wire_hole() {
        translate([w/4, w/4, 0]) cylinder(d = wire_hole_d, h=1000);
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
        d = w/2 - spring_pole_d/2 - 2;
        translate([dirs[0]*d, dirs[1]*d, 0]) cylinder(d = spring_pole_d, h = spring_pole_h);
    }
    
    union() {
        box();
        for (dirs = [ [1,0], [-1,0], [0,1], [0,-1] ]) {
            spring_post(dirs);
        }
    }
}

module button_mount() {
    cylinder(d=button_mount_d, h=button_mount_h);
}

module button_mount_cutouts() {
    cylinder(d=button_body_d, h=button_mount_h - wall);
    cylinder(d=button_hole_d, h=1000);
}

module strain_relief_cutouts() {
    cutout = [1, 3.4];
    for (angle = [-30, -60]) {
        translate([0, 0, wall+.1])
        rotate([0, 0, angle])
        translate([-cutout[0]/2, 0, 0])
        cube([cutout[0], 1000, cutout[1]]);
    }
}

module bottom() {
    $fn = 128;

    module screw_hole(dirs) {
        d = plate_to_bottom_screw_at;
        translate([dirs[0]*d, dirs[1]*d, 0]) cylinder(d = M3_through_hole_d(), h = 10000);
    }

    module screw_holes() {
        for (dirs = [ [-1,-1], [-1,1], [1,-1], [1,1] ]) {
            screw_hole(dirs);
        }
    }
    
    difference() {
        union() {
            top_bottom_common();
            button_mount();
        }
        screw_holes();
        button_mount_cutouts();
        strain_relief_cutouts();
    }
}

module pusher() {
    extra = button_mount_h < wall ? wall - button_mount_h : 0;
    cylinder(d = button_hole_d, h=top_bottom_h - extra);
}

module top() {
    $fn=128;
    top_bottom_common();
    pusher();
}

plate();
//bottom();
//top();