include <utils_threads.scad>

$fn=64;

wall = 1.2;

shroud_h = 12 + wall*2;  // Just a little more than the fan entry hole size of 14.1411`

chimera_hole_x = 4.5;
chimera_hole_h = 36.5;

fan_hole = [25, 16.1, 2.5];

entry_h = 9;
x_len=48;
y_len=28;
x_hole_len = x_len/2 - wall*4;
y_hole_len = y_len - wall*2;

exit_hole_d = 4;
exit_hole_h = 2;

ir_probe_holes = [ 18, 8, 15.2 ];

points = [ [0, 0], [0, shroud_h], [shroud_h, shroud_h], [shroud_h, shroud_h - 4], [4, 0] ];

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
    spacer = 2.5;
    translate([0, y_len/2+shroud_h-ir_probe_holes[1] + spacer, ir_probe_holes[2] - 3]) 
    union() {
        for (dir = [ -1, 1]) {
            translate([dir * ir_probe_holes[0]/2 - 3, 0, 0]) union() {
                cube([6, ir_probe_holes[1] + spacer, 6]);
                translate([0, 0, -spacer]) linear_extrude(height = spacer, scale=[1, 100]) square([6, 0.1]);
            }       
        }
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
    w=wall*3.5;
    chimera_w = 30;
    chimera_h = chimera_hole_h + wall*3;
    chimera_d = shroud_h + (y_len - 18) / 2;

    module chimera_holes() {
        hole = [ chimera_hole_x, -0.1, chimera_hole_h-3 ];
        for (dir = [-1, 1]) {
            translate([hole[0]*dir, hole[1], hole[2]]) rotate([-90, 0, 0]) union() {
                cylinder(d=M3_through_hole_d(), h=100);
                cylinder(d=6, h=chimera_d-3);
            }
        }
    }

    translate([0, -y_len/2-shroud_h, 0]) difference() {
        translate([-chimera_w/2, 0, 0]) union() {
            translate([0, 0, shroud_h]) cube([chimera_w, w, chimera_h - shroud_h]);
            offset = chimera_d - w;
            start_h = chimera_hole_h - offset - wall*5;
            translate([0, w, start_h]) linear_extrude(height=offset, scale=[1, offset*100]) square([chimera_w, 0.01]);
            translate([0, w, start_h + offset]) cube([chimera_w, offset, chimera_h - (start_h + offset)]);
        }
        chimera_holes();
    }
}

module body() {
    union() {
        rotate([0, 0, 180]) x_tube();
        x_tube();
        y_tube();
        rotate([0, 0, 180]) y_tube();

        translate([-x_len/2, y_len/2, 0]) corner(0);
        translate([x_len/2, y_len/2, 0]) corner(1);
        translate([-x_len/2, -y_len/2, 0]) corner(2);
        translate([x_len/2, -y_len/2, 0]) corner(3);
        
        ir_probe_mount();
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
        rotate([0, 0, 180]) x_holes();
        y_holes();
        rotate([0, 0, 180]) y_holes();
    }
}

module entry_hole() {
    translate([-fan_hole[0]/2, -y_len/2 - shroud_h, wall]) 
        cube([fan_hole[0], wall*2, shroud_h - wall*2]);
}

module fan_entry() {
    l = sin(45)*fan_hole[1] + wall*2;
    tube_len = 5;

    module fan_entry_tube() {
        difference() {
            cube([fan_hole[0]+wall*4, tube_len, shroud_h]);
            translate([wall*2, 0, wall]) cube([fan_hole[0], tube_len, l-wall*2]);
        }
    }
    
    module fan_entry_45() {
        difference() {
            cube([fan_hole[0]+wall*4, l, l]);
            translate([wall*2, wall, wall]) cube([fan_hole[0], l-wall, l-wall*2]);
            rotate([45, 0, 0]) cube([fan_hole[0]+wall*4, l*10, l]);
        }
    }

    fan_hole_offset = 14;
    
    module fan_mount() {
        extension = 5;
        
        module fan_seat() {
            translate([fan_hole_offset, 0, 0]) union() {
                difference(){
                    translate([-wall*2, 0,  0]) cube([fan_hole[0]+wall*4, fan_hole[1]+wall*4+wall*2, extension]);
                    translate([0, wall*2, 0]) cube([fan_hole[0], fan_hole[1], extension]);
                }
                translate([-wall, wall, extension])
                difference() {
                    cube(fan_hole+[wall*2, wall*2, 0]);
                    translate([wall, wall, 0]) cube(fan_hole);
                }
            }
        }

        module fan_mount_holes() {
            for (at = [ [-17.5, -10, 37], [17.5, -10, 37]]) {
                translate(at) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=100);
            }
        }

        translate([-fan_hole_offset+wall*2, 0, 0]) difference(){
            connector = 10;
            union() {
                translate([0, fan_hole[1] + wall*4, extension-connector]) union() {
                    cube([40+wall, wall*2, 40+wall+connector]);
                    translate([0, 0, 40+wall+connector-6]) cube([6, 6, 6]);
                    translate([40+wall-6, 0, 40+wall+connector-6]) cube([6, 6, 6]);
                }
                fan_seat();
            }
            translate([(40+wall)/2, 0, extension]) fan_mount_holes();
            translate([-100, -100, -100]) cube([200, 100, 200]);
        }
    }

    difference() {
        translate([-(fan_hole[0]+wall*2)/2, -y_len/2-shroud_h, 0]) union() {
            translate([0, -tube_len, 0]) fan_entry_tube();
            translate([0, -(tube_len + l), 0]) fan_entry_45();
            translate([0, -(tube_len + l), 0]) rotate([45, 0, 0]) fan_mount();
        }
        translate([0, -100, chimera_hole_h]) union() {
            translate([-chimera_hole_x, 0, 0]) rotate([-90, 0, 0]) cylinder(d=6, h=200);
            translate([chimera_hole_x, 0, 0]) rotate([-90, 0, 0]) cylinder(d=6, h=200);
        }
    }
}

union() {
    difference() {
        body();
        entry_hole();
        exit_holes();
        ir_probe_mount_holes();
    }
    fan_entry();
}
