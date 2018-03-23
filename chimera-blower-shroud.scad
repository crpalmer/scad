include <utils_threads.scad>

$fn=64;

full_height = 48.5;
fan_wall = 1;
fan_hole_offset = [20-1.5, 8, 8];
full = [42, full_height - fan_hole_offset[2], 14.25 + fan_hole_offset[1]];

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

module connectors() {
    W=5;
    translate([-plate[0]/2, 0, fan_hole_offset[2]]) 
    union() {
        h = full_height - fan_hole_offset[2] - plate[1];
        cube([plate[0], W, h]);
        linear_extrude(height=h, scale=[1, plate[2]-fan_hole_offset[1] + fan_wall]) square([plate[0], 1]);
        translate([plate[0], 0, 0]) rotate([0, 0, 180]) linear_extrude(height=h, scale=[1, fan_hole_offset[1] + fan_wall - 2]) square([plate[0], 1]);
    }
}

module mount() {
    module cutout(w) {
        h = full[1] - 5;
        translate([-full[0], 0, 0]) difference() {
            cube([full[0]*2, w, h]);
            linear_extrude(height=h, scale=[1, w*10]) square([full[0]*2, 0.1]);
        }
    }
    
    difference() {
        translate([0, full[2] - fan_hole_offset[1] + fan_wall, full[1]])
        rotate([-90, 0, 180])
        difference() {
            translate([-full[0]/2, 0, 0]) cube(full);
            chimera_holes();
            fan_holes();
        }
        translate([0, 2, 0]) cutout(full[2] + fan_wall - 2);
        translate([0, -2, 0]) mirror([0, 1, 0]) cutout(fan_hole_offset[1] + fan_wall - 2);
    }
}

module profile() {
    points = [ [0, 0], [12, 0], [12, 2], [6, 12], [0, 12] ];

    difference() {
        polygon(points);
        offset(delta=-1) polygon(points);
    }
}

module tube(len) {
    // The -7.5 and -4.5 are to get it aligned with the older version tube
    // This should be cleaned up!
    translate([-len/2, -7.5, -4.5]) rotate([90, 0, 90]) 
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
        translate([-len/2, 0, -5]) cube([len, 3, 2]);
    }

    module x_holes() {
        union() {
            translate([-x_hole_len/2-2, y_len/2-5, 0]) hole(x_hole_len);
            translate([x_hole_len/2+2, y_len/2-5, 0]) hole(x_hole_len);
        }
    }
    
    module y_holes() {
        union() {
            translate([x_len/2-5, 0, 0]) rotate([0, 0, -90]) hole(x_hole_len);
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
        M = [D, fan_hole_offset[1]-fan_wall, D+fan_hole_offset[2]];
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

union() {
    translate([0, 0, fan_hole_offset[2]])
        mount();
    shroud();
}
