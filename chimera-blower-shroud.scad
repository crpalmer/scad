include <utils_threads.scad>

$fn=64;
fan_hole_offset = [20-1.5, 8, 8];

module chimera_holes() {
    for (at = [ [-4.5, 10, 0], [4.5, 10, 0]]) {
        translate(at) union() {
            cylinder(d=M3_through_hole_d(), h=100);
            translate([0, 0, 5]) cylinder(d=6, h=100);
        }
    }
}

module fan_holes() {
    for (at = [ [-17.5, 2.5, 0], [17.5, 2.5, 0]]) {
        translate(at) cylinder(d=M3_tapping_hole_d(), h=100);
    }
}

module mount() {
    plate = [44, 14, 14.25 + fan_hole_offset[1]];
    difference() {
        union() {
            translate([-plate[0]/2, 0, 0]) cube(plate);
        }
        chimera_holes();
        fan_holes();
    }
}

module profile() {
    points = [ [0, 0], [12, 0], [12, 4], [4, 12], [0, 12] ];

    difference() {
        polygon(points);
        offset(delta=-1) polygon(points);
    }
}

module tube(len) {
    // The -7.5 and -4.5 are to get it aligned with the older version tube
    // This should be cleaned up!
    translate([len/2, -7.5, -4.5]) rotate([0, -90, 0]) 
    difference() {
        linear_extrude(height=len+2) profile();
        translate([0, 0, -2]) cube([100, 100, 2]);
        translate([0, 0, len]) cube([100, 100, 2]);
    }
}

module shroud() {
    fan_hole = [25, 16.1, 2];

    corner_len=9;
    entry_h = 9;
    x_len=55;
    y_len=36;
    hole_angle=30;
    x_hole_len=(x_len - corner_len*2)/2 - 2;
    y_hole_len=(y_len - corner_len*2) - 2;
    W=2;
    
    module corner(which) {
        deltas = [ [-100, 0], [0, 0], [-100, -100], [0, -100] ];
        
        translate([0, 0, -4.5]) difference() {
            rotate_extrude() translate([-16.5, 0, 0]) profile();
            difference() {
                translate([-100, -100, 0]) cube([200, 200, 100]);
                translate(deltas[which]) cube([100, 100, 100]);
            }
        }
    }
    
    module body() {
        union() {
            translate([0, y_len/2, 0]) mirror([0, 1, 0]) tube(x_len-corner_len*2);
            translate([0, -y_len/2, 0]) tube(x_len-corner_len*2);
            translate([-x_len/2, 0, 0]) rotate([0, 0, -90]) tube(y_len-corner_len*2);
            translate([x_len/2, 0, 0]) rotate([0, 0, 90]) tube(y_len-corner_len*2);
            
            translate([-x_len/2+corner_len, y_len/2-corner_len, 0]) corner(0);
            translate([x_len/2-corner_len, y_len/2-corner_len, 0]) corner(1);
            translate([-x_len/2+corner_len, -y_len/2+corner_len, 0]) corner(2);
            translate([x_len/2-corner_len, -y_len/2+corner_len, 0]) corner(3);
        }
    }
    
    module hole(len) {
        translate([-len/2, 0, 0]) union() {
            rotate([hole_angle, 0, 0]) cube([len, 8, 4]);
            cube([len, 3, 4]);
        }
    }

    module x_holes() {
        union() {
            translate([-x_hole_len/2-2, y_len/2-5, -5]) hole(x_hole_len);
            translate([x_hole_len/2+2, y_len/2-5, -5]) hole(x_hole_len);
        }
    }
    
    module y_holes() {
        union() {
            translate([x_len/2-5, 0, -5]) rotate([0, 0, -90]) hole(x_hole_len);
        }
    }
    
    module entry_hole() {
        translate([-fan_hole_offset[0], -1, 1]) 
            cube([fan_hole[0], 1*2, fan_hole_offset[2]-1*2]);
    }
    
    module exit_holes() {
        union() {
            x_holes();
            rotate([0, 0, 180]) x_holes();
            y_holes();
            rotate([0, 0, 180]) y_holes();
        }
    }

    module fan_entry() {
        lip=2;

        module fan_entry_shaft() {
            translate([-fan_hole_offset[0], -fan_hole_offset[1], 0])
            difference() {
                C = [ fan_hole[0], fan_hole_offset[1], fan_hole_offset[2]];
                translate([-lip, 0, 0]) cube(C + [lip*2, 0, 0]);
                translate([1, 0, 1]) cube(C - [ 2, 0, 2]);
            }
        }

        module fan_entry_insert() {
            translate([-fan_hole_offset[0], -fan_hole_offset[1]-fan_hole[1], 0])
            difference() {
                union() {
                    cube(fan_hole + [0, 0, fan_hole_offset[2]]);
                    translate([-lip, -lip, 0]) cube([fan_hole[0] + lip*2, fan_hole[1] + lip, fan_hole_offset[2]]);
                }
                translate([1, 1, 1]) cube(fan_hole + [-2, -2, fan_hole_offset[2]]);
                translate([1, fan_hole[1]-1, 1]) cube([fan_hole[0]-2, 1, fan_hole_offset[2]-2]);
            }
        }

        union() {
            fan_entry_shaft();
            fan_entry_insert();
        }
    }
    
    module mounting_point() {
        D = 7;
        M = [D, fan_hole_offset[1]-1, D+fan_hole_offset[2]];
        translate([(17.5 - M[0]/2), -M[1], 0]) difference() {
            cube(M);
            translate([M[0]/2, -M[1]*2, fan_hole_offset[2] + 2.5]) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=100);
        }
    }
    
    union() {
        difference() {
            translate([0, y_len/2 + 7.25, 4.5]) difference() {
                body();
                exit_holes();
            }
            entry_hole();
        }
        mounting_point();
        fan_entry();
    }
}

//mount();
shroud();
