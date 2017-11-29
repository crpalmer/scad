include <utils_threads.scad>

$fn=100;

W=5;
H=50;
exit_D=10+W;
exit_H=5+W;
sides = [ [1,1,0], [1,-1,0], [-1,1,0], [-1,-1,0] ];

module point2d(p) {
    translate(p) square([0.1, 0.1]);
}

module point(p) {
    translate(p) cube([0.1, 0.1, 0.1]);
}


module print_head_mount() {
    union() {
        translate([-15.5, -16+W, 0]) difference() {
            cube([31, 16, W]);
            translate([5.5, 4, 0]) union() {
                cylinder(d=3.1,h=100);
                cylinder(d=6,h=W-2);
            }
            translate([31-5.5, 4, 0]) union() {
                cylinder(d=3.1, h=100);
                cylinder(d=6,h=W-2);
            }
        }
    }
}

module fan_mount() {
    translate([0, W*2, 0])
        rotate([45, 0, 0])
        translate([-15, 0, 0])
        difference() {
            cube([30, 30, W*sqrt(2)]);
            translate([W, W, 0]) cube([30-2*W, 30-2*W, W*sqrt(2)]);
            for (delta = sides) {
                translate([15, 15, 0] + 12*delta) cylinder(d=2, h=100, $fn=100);
            }
        }
}

module fan_mount_joint() {
    translate([15, W, 0])
        rotate([0, -90, 0])
        linear_extrude(height=30)
        hull() {
            point2d([0,0]);
            point2d([0, W]);
            point2d([W, 0]);
        }
}

module tube(d=0) {
    hull() {
        for (x = [-15+d, 15-d]) {
            point([x, d, W]);
            point([x, W+d, W]);
            point([x, W+(30-d)/sqrt(2)-.1, W+(30-d)/sqrt(2)-.1]);
        }
        for (x = [-exit_D/2+d, exit_D/2-d]) {
            point([x, d, W+H+d]);
            point([x, exit_D/2*sqrt(2)-d, W+H-d+exit_D/2*sqrt(2)]);
        }
    }
}

module exit(d=0) {
    translate([0, 0, H+W])
        hull() {
            for (x = [-exit_D/2+d, exit_D/2-d]) {
                point([x, d, d]);
                point([x, exit_D/2*sqrt(2)-d, -d+exit_D/2*sqrt(2)]);
                point([x, 0, exit_D-exit_H+d]);
                point([x, 0, exit_D-d]);
            }
        }
}

module it() {
    union() {
        print_head_mount();
        fan_mount();
        fan_mount_joint();
        difference() {
            tube();
            tube(d=W/2);
        }
        difference() {
            exit();
            exit(d=W/2);
        }
    }
}

rotate([-45, 0, 0])
it();
