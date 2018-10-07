include <utils_threads.scad>

$fn=64;

wall = 1.2;

full_h = 47.5;

shroud_h = 12 + wall*2;  // Just a little more than the fan entry hole size of 14.1411`

chimera_hole_x = 4.5;
chimera_hole_h = 38;

fan_offset = 2.1;
fan_hole = [25, 16, 2.5];

x_len=48;
y_len=28;
x_hole_len = x_len/2 - wall*4;
y_hole_len = y_len - wall*2;

exit_hole_d = 4;
exit_hole_h = 2;

ir_probe_holes = [ 18, 6, 11.2 ];

shroud_flat = 4;
points = [ [0, 0], [0, shroud_h], [shroud_h, shroud_h], [shroud_h, shroud_h - shroud_flat], [shroud_flat, 0] ];

module profile() {
    difference() {
        polygon(points);
        offset(delta=-wall) polygon(points);
    }
}

module tube(len) {
    translate([len, 0, 0]) rotate([0, -90, 0]) 
    difference() {
        linear_extrude(height=len+2) profile();
        translate([0, 0, -2]) cube([100, 100, 2]);
        translate([0, 0, len]) cube([100, 100, 2]);
    }
}

module x_tube() {
    translate([-x_len/2, y_len/2, 0]) tube(x_len);
}

module y_tube() {
    rotate([0, 0, 90]) translate([-y_len/2, x_len/2, 0]) tube(y_len);
}

module corner(which) {
    deltas = [ [-100, 0], [0, 0], [-100, -100], [0, -100] ];
    
    difference() {
        rotate_extrude() rotate([0, 0, 90]) mirror([0, 1, 0]) profile();
        difference() {
            translate([-100, -100, 0]) cube([200, 200, 100]);
            translate(deltas[which]) cube([100, 100, 100]);
        }
    }
}

module ir_probe_mount() {
    tab = 6;
    
    module side() {
        difference() {
            translate([-x_len/2, 0, 0]) linear_extrude(height=shroud_h, scale=[shroud_h / cos(35), 1]) square([1, tab]);
        }
    }
    
    translate([0, y_len/2 + shroud_h - tab, 0]) 
    union() {
        for (dir = [ -1, 1]) {
            translate([dir * ir_probe_holes[0]/2 - 3, -(ir_probe_holes[1]-tab)/2, ir_probe_holes[2] - tab/2]) cube([tab, ir_probe_holes[1], tab]);
        }
        translate([-x_len/2, 0, shroud_h - tab - 2]) cube([x_len, tab, tab+2]);
        side();
        mirror([1, 0, 0]) side();
    }
}

module ir_probe_mount_holes() {
    translate([0, y_len/2+shroud_h-ir_probe_holes[1]-25, ir_probe_holes[2]]) 
    union(){
        translate([ir_probe_holes[0]/2, 0, 0]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=50);
        translate([-ir_probe_holes[0]/2, 0, 0]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=50);
    }
}

module chimera_mount() {
    w=4;
    chimera_w = 30;
    chimera_d = shroud_h + (y_len - 18) / 2;

    module chimera_holes() {
        hole = [ chimera_hole_x, -0.1, chimera_hole_h ];
        for (dir = [-1, 1]) {
            translate([hole[0]*dir, hole[1], hole[2]]) rotate([-90, 0, 0]) union() {
                cylinder(d=M3_through_hole_d(), h=100);
                cylinder(d=6, h=chimera_d-3);
            }
        }
    }    

    module fan_holes(){
        for (at = [ [-17.5, -50, full_h - 2.5], [17.5, -50, full_h - 2.5]]) {
            translate(at) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=100);
        }
    }
    
    translate([0, -y_len/2-shroud_h, 0]) difference() {
        translate([-40/2, 0, 0]) union() {
            translate([0, 0, shroud_h]) cube([40, w, full_h - shroud_h]);
            offset = chimera_d - w;
            start_h = chimera_hole_h - offset - wall*5;
            translate([0, w, start_h]) linear_extrude(height=offset, scale=[1, offset*100]) square([40, 0.01]);
            translate([0, w, start_h + offset]) cube([40, offset, full_h - (start_h + offset)]);
        }
        chimera_holes();
        fan_holes();
    }
}

module end_cap()
{
    rotate([0, -90, 0]) linear_extrude(height=wall) polygon(points);
}

module body() {
    union() {
        rotate([0, 0, 180]) x_tube();
        y_tube();
        rotate([0, 0, 180]) y_tube();

        translate([-x_len/2, y_len/2, 0]) corner(0);
        translate([x_len/2, y_len/2, 0]) corner(1);
        translate([-x_len/2, -y_len/2, 0]) corner(2);
        translate([x_len/2, -y_len/2, 0]) corner(3);

        translate([x_len/2, y_len/2, 0]) end_cap();
        translate([-x_len/2, y_len/2, 0]) end_cap();

//        ir_probe_mount();
        chimera_mount();
    }
}

module hole(len) {
    translate([0, 0, -1]) cube([len, exit_hole_d+1, exit_hole_h+1]);
}

module x_holes() {
    union() {
        translate([-x_hole_len - wall, -y_len/2-exit_hole_d, 0]) hole(x_hole_len);
        translate([wall, -y_len/2-exit_hole_d, 0]) hole(x_hole_len);
    }
}

module y_holes() {
    union() {
        translate([x_len/2-1, y_hole_len/2, 0]) rotate([0, 0, -90]) hole(y_hole_len);
    }
}

module exit_holes() {
    union() {
        x_holes();
        y_holes();
        rotate([0, 0, 180]) y_holes();
    }
}

module entry_hole() {
    translate([-x_len/2, -y_len/2 - shroud_h, wall])
        cube([x_len, wall*2, full_h - 40 - wall*2]);
}

module fan_entry() {
    fan_hole_start = [ 20 - fan_offset, fan_hole[1] + 1.5, full_h - 40 ];
    module air_box() {
        translate([-x_len/2, -fan_hole_start[1] - wall*2, 0]) difference() {
            cube([x_len, fan_hole_start[1] + wall*3, fan_hole_start[2]]);
            translate([wall, wall, wall]) cube([x_len - wall*2, 100, fan_hole_start[2] - wall*2]);
        }
    }

    module support_posts() {
        for (xy = [ [ 0, 0 ], [ fan_hole[0], 0], [ fan_hole[0], fan_hole[1] ], [0, fan_hole[1]], [fan_hole[0]/2, 0], [fan_hole[0]/2, fan_hole[1]] ]) {
            translate([-fan_hole_start[0] + xy[0], -fan_hole_start[1] + xy[1], 0]) cube([1.2, 1.2,  fan_hole_start[2]]);
        }
    }
    
    module lip() {
        translate([-fan_hole_start[0], -fan_hole_start[1], fan_hole_start[2]]) difference() {
            cube(fan_hole);
            translate([wall, wall, 0]) cube(fan_hole - [wall*2, wall*2, 0]);
        }
    }
    
    translate([0, -y_len/2 - shroud_h, 0]) difference() {
        union() {
            air_box();
            support_posts();
            lip();
        }
        translate([-fan_hole_start[0]+wall, -fan_hole_start[1]+wall, wall]) cube([fan_hole[0]-wall*2, fan_hole[1]-wall*2, 100]);
    }
}

union() {
    difference() {
        body();
        entry_hole();
        exit_holes();
//        ir_probe_mount_holes();
    }
    fan_entry();
}
