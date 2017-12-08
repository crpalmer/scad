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
        translate([-15.5, -14+W, 0]) difference() {
            cube([31, 14, W]);
            translate([5.5, 4, 0]) union() {
                cylinder(d=M3_through_hole_d(),h=100);
                cylinder(d=6,h=W-2);
            }
            translate([31-5.5, 4, 0]) union() {
                cylinder(d=M3_through_hole_d(), h=100);
                cylinder(d=6,h=W-2);
            }
        }
    }
}

module fan_mount() {
    translate([0, W*2, 0])
        rotate([45, 0, 0])
        translate([-20, 0, 0])
        difference() {
            cube([40, 40, W*sqrt(2)]);
            translate([1.25*W, 1.25*W, 0]) cube([40-2.5*W, 40-2.5*W, W*sqrt(2)]);
            for (delta = sides) {
                translate([20, 20, 0] + 16*delta) cylinder(d=M3_tapping_hole_d(), h=100, $fn=100);
            }
        }
}

module fan_mount_joint() {
    translate([20, W, 0])
        rotate([0, -90, 0])
        linear_extrude(height=40)
        hull() {
            point2d([0,0]);
            point2d([0, W]);
            point2d([W, 0]);
        }
}

module tube(d=0) {
    hull() {
        for (x = [-20+d, 20-d]) {
            for (y = [d, 40-d]) {
                rotate([45, 0, 0]) point([x, y+W*sqrt(2), 0]);
            }
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

module 40mm_fan_version() {
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

module 50mm_blower_shroud() {
    module 50mm_blower_shroud_exit() {
        module shroud_corner(d) {
            rotate([0, -90, 0]) cylinder(d=d,h=30);
            rotate([-90, 0, 0]) cylinder(d=d,h=30);
            sphere(d=d);
            translate([-30, 0, 0]) sphere(d=d);
        }

        difference() {
            union() {
                translate([15, -15, 0]) shroud_corner(4);
                translate([-15, 15, 0]) rotate([0, 0, 180]) shroud_corner(4);
            }
            union() {
                translate([15, -15, 0]) shroud_corner(2);
                translate([-15, 15, 0]) rotate([0, 0, 180]) shroud_corner(2);
            }
            translate([0, 0, -1]) cube([30, 20, 2], center=true);
            translate([0, 0, -1]) cube([20, 30, 2], center=true);
            translate([15, -14, -1]) cube([2, 20, 2]);
        }
    }
    module 50mm_blower_entry() {
        module entry_ramp(D) {
            hull() {
                point([D, D, 2]);
                point([D, 22-D, 2]);
                point([17-D, 22-D, 2]);
                point([17-D, D, 2]);
                point([D, D, 10]);
                point([D, 22-D, 10]);
                point([4-D, D, 10]);
                point([4-D, 22-D, 10]);
            }
        }
                
        union() {
            translate([8.5, 11, 1]) difference() {
                cube([17, 22, 2], center=true);
                cube([15, 20, 2], center=true);
            }
            difference() {
                entry_ramp(0);
                entry_ramp(1);
            }
        }
    }
    
    union() {
        translate([14, 15, 2]) 50mm_blower_shroud_exit();
        translate([40, 0, 0]) rotate([0, -90, 0]) 50mm_blower_entry();
    }
}

//rotate([-45, 0, 0])
//40mm_fan_version();

50mm_blower_shroud();
//shroud_corner();
