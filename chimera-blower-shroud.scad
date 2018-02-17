include <utils_threads.scad>

$fn=64;

plate = [44, 5, 39];
fan_hole = [31, 20.5, 10];
fan_hole_offset = 3.5;

layer_height = 0.08;

module spacer() {
    T=4.5;
    translate([-7, plate[1], 31]) rotate([-90, 0, 0]) for (i = [ 0:layer_height:T ]) {
        translate([0, 0, i]) cube([14, 21-i, layer_height]);
    }
}

module chimera_holes() {
    for (at = [ [-4.5, -0.1, 29], [4.5, -0.1, 29], [0, -0.1, 19]]) {
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

module tube(d_out, d_in, len) {
    translate([0, 0, -len/2]) difference() {
        cylinder(d=d_out, len);
        cylinder(d=d_in, len);
    }
}

// Make the tube longer and cut it to avoid weird lengths due to openscad rotations
module x_tube(d_out, d_in, len) {
    difference() {
        rotate([0, -90, 0]) tube(d_out, d_in, len+5);
        translate([len/2, -d_out, -d_out]) cube([10, d_out*2, d_out*2]);
        translate([-len/2-10, -d_out, -d_out]) cube([10, d_out*2, d_out*2]);
    }
}

// Make the tube longer and cut it to avoid weird lengths due to openscad rotations
module y_tube(d_out, d_in, len) {
    difference() {
        rotate([-90, 0, 0]) tube(d_out, d_in, len+5);
        translate([-d_out, len/2, -d_out]) cube([d_out*2, 10, d_out*2]);
        translate([-d_out, -len/2-10, -d_out]) cube([d_out*2, 10, d_out*2]);
    }
}

module shroud() {
    d_out=9;
    d_in=7;
    x_len=55;
    y_len=36;
    hole_angle=15;
    x_hole_len=(x_len - d_out*2)/2 - 2;
    y_hole_len=(y_len - d_out*2) - 2;
    W=2;
    
    module corner() {
        difference() {
            rotate_extrude(angle=90) translate([d_out, 0, 0]) circle(d=d_out);
            rotate_extrude(angle=90) translate([d_out, 0, 0]) circle(d=d_in);
        }
    }
    
    module body() {
        union() {
            translate([0, y_len/2, 0]) x_tube(d_out, d_in, x_len-d_out*2);
            translate([0, -y_len/2, 0]) x_tube(d_out, d_in, x_len-d_out*2);
            translate([-x_len/2, 0, 0]) y_tube(d_out, d_in, y_len-d_out*2);
            translate([x_len/2, 0, 0]) y_tube(d_out, d_in, y_len-d_out*2);
            
            translate([x_len/2-d_out, y_len/2-d_out, 0]) corner();
            translate([-x_len/2+d_out, y_len/2-d_out, 0]) mirror([1, 0, 0]) corner();
            translate([x_len/2-d_out, -y_len/2+d_out, 0]) mirror([0, 1, 0]) corner();
            translate([-x_len/2+d_out, -y_len/2+d_out, 0]) mirror([0, 1, 0]) mirror([1, 0, 0]) corner();
        }
    }
    
    module hole(len) {
        translate([-len/2, 0, 0]) rotate([hole_angle, 0, 0]) cube([len, d_out/2, 2]);
    }

    module x_holes() {
        union() {
            translate([-x_hole_len/2-2, y_len/2-d_out/2, -d_out/2]) hole(x_hole_len);
            translate([x_hole_len/2+2, y_len/2-d_out/2, -d_out/2]) hole(x_hole_len);
        }
    }
    
    module y_holes() {
        union() {
            translate([x_len/2-d_out/2, 0, -d_out/2]) rotate([0, 0, -90]) hole(x_hole_len);
        }
    }
    
    module holes() {
        union() {
            x_holes();
            rotate([0, 0, 180]) x_holes();
            y_holes();
            rotate([0, 0, 180]) y_holes();
        }
    }

    module fan_entry() {
        z=(d_out-d_in)/2;
        translate([-plate[0]/2-W+fan_hole_offset, -y_len/2-W*2-fan_hole[1], -d_out/2]) difference() {
            cube(fan_hole + [W*2, W*2, z]);
            translate([W, W, z]) cube(fan_hole+[0,0,1]);
            translate([W+fan_hole[0], W, fan_hole[2]+z-2]) cube([W, fan_hole[1], 2]);
            translate([0, W+fan_hole[1], z]) cube([fan_hole[0]+W*2, 100, d_in]);
        }
    }
    
    translate([0, y_len/2 + W, -d_out/2])
    union() {
        difference() {
            body();
            holes();
            translate([-plate[0]/2+fan_hole_offset, -y_len/2-d_out, -100]) cube([fan_hole[0], d_out, 200]);
        }
        fan_entry();
    }
}

union() {
    mount();
    shroud();
}