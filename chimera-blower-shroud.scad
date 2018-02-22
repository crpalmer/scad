include <utils_threads.scad>

$fn=64;

plate = [44, 5, 39];
fan_hole = [31, 20.5, 10];
fan_hole_offset = 3.5;

layer_height = 0.08;

profile_points = [ [0, 0], [12, 0], [12, 4], [4, 12], [0, 12] ];
    
module spacer() {
    T=10.75;
    translate([-7, plate[1], 31.5]) rotate([-90, 0, 0]) for (i = [ 0:layer_height:T ]) {
        translate([0, 0, i]) cube([14, 21-i, layer_height]);
    }
}

module chimera_holes() {
    for (at = [ [-4.5, -0.1, 29.5], [4.5, -0.1, 29.5], [0, -0.1, 19.5]]) {
        translate(at) rotate([-90, 0, 0]) union() {
            cylinder(d=M3_through_hole_d(), h=100);
            cylinder(d=6, h=4);
        }
    }
}

module fan_holes() {
    for (at = [ [-17.5, -5, 35], [17.5, -5, 35]]) {
        translate(at) rotate([-90, 0, 0]) cylinder(d=M3_tapping_hole_d(), h=100);
    }
}

module mount() {
    difference() {
        union() {
            translate([-plate[0]/2, 0, 0]) cube(plate);
            spacer();
        }
        chimera_holes();
        translate([0, 1, 0]) fan_holes();
    }
}

module profile() {
    difference() {
        polygon(profile_points);
        offset(delta=-1) polygon(profile_points);
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
        translate([-plate[0]/2+fan_hole_offset, -y_len/2-W*2-fan_hole[1]-3, -4.5]) 
            cube(fan_hole + [0, 1, 0]);
    }
    
    module holes() {
        union() {
            x_holes();
            rotate([0, 0, 180]) x_holes();
            y_holes();
            rotate([0, 0, 180]) y_holes();
            entry_hole();
        }
    }

    module fan_entry() {
        z=1;
        translate([-plate[0]/2-W+fan_hole_offset, -y_len/2-W*2-fan_hole[1]-5.5+1.25, -4.5]) difference() {
            cube(fan_hole + [W*2, W*2, z]);
            translate([W, W, z]) cube(fan_hole+[0,0,1]);
            translate([W+fan_hole[0], W, fan_hole[2]+z-2]) cube([W, fan_hole[1], 2]);
            translate([0, W+fan_hole[1], z]) cube([fan_hole[0]+W*2, 100, 100]);
        }
    }
    
    translate([0, y_len/2 + 7.25, -4.5])
    union() {
        difference() {
            body();
            holes();
        }
        fan_entry();
    }
}

union() {
    mount();
    shroud();
}
