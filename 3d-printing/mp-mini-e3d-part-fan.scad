include <utils_threads.scad>

$fn=32;

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

module 50mm_blower_shroud(tube_inner=6, tube_outer=8, wall=2) {
    space_x = 30;
    space_y = 24;
    tube_middle_delta_x=space_x+tube_outer;
    tube_middle_delta_y=space_y+tube_outer;
    tube_outer_delta_x=tube_middle_delta_x+tube_outer;
    tube_outer_delta_y=tube_middle_delta_y+tube_outer;
    entry_h=20+wall*2;
    entry_w=15.5+wall*2;
    entry_d=15;
    fan_entry_d=6;
    
    module 50mm_blower_shroud_exit() {
        module shroud_corner(d,delta) {
            rotate([0, -90, 0]) cylinder(d=d,h=tube_middle_delta_x);
            rotate([-90, 0, 0]) cylinder(d=d,h=tube_middle_delta_y);
            sphere(d=d);
            translate([-tube_middle_delta_x, 0, 0]) sphere(d=d);
        }

        difference() {
            union() {
                translate([tube_middle_delta_x/2, -tube_middle_delta_y/2, 0]) shroud_corner(tube_outer);
                translate([-tube_middle_delta_x/2, tube_middle_delta_y/2, 0]) rotate([0, 0, 180]) shroud_corner(tube_outer);
            }
            union() {
                translate([tube_middle_delta_x/2, -tube_middle_delta_y/2, 0]) shroud_corner(tube_inner);
                translate([-tube_middle_delta_x/2, tube_middle_delta_y/2, 0]) rotate([0, 0, 180]) shroud_corner(tube_inner);
            }
            // Hole opposite the fan
            translate([-tube_middle_delta_x/2, -space_y/2+wall, -tube_outer/2]) cube([tube_outer, space_y-wall*2, tube_outer/4]);
            // Two holes at the fan entry
            translate([0, -space_y/2+wall, -tube_outer/2]) cube([tube_middle_delta_x/2, space_y/4, tube_outer/4]);
            translate([0, space_y/2-wall-space_y/4, -tube_outer/2]) cube([tube_middle_delta_x/2, space_y/4, tube_outer/4]);
            // Two holes on both of the other two sides
            translate([-space_x/4, 0, -tube_inner/2]) cube([10, tube_middle_delta_y, tube_outer/2], center=true);
            translate([space_x/4, 0, -tube_inner/2]) cube([10, tube_middle_delta_y, tube_outer/2], center=true);
            // Hole for the fan entry itself
            translate([(tube_middle_delta_x)/2+tube_inner, 0, 0]) cube([tube_outer, 20, tube_outer], center=true);
        }
    }
    
    module 50mm_blower_entry() {
        module entry_ramp(D) {
            hull() {
                if (D == 0) {
                    union() {
                    point([entry_h, 0, entry_d]);
                    point([entry_h, entry_w, entry_d]);
                    echo([entry_h, 0, entry_d]);
                    echo([entry_h, entry_w, entry_d]);
                    }
                }
                point([D, D, fan_entry_d]);
                point([D, entry_w-D, fan_entry_d]);
                point([entry_h-D, entry_w-D, fan_entry_d]);
                point([entry_h-D, D, fan_entry_d]);
                point([D, D, entry_d]);
                point([D, entry_w-D, entry_d]);
                point([tube_outer-D, D, entry_d]);
                point([tube_outer-D, entry_w-D, entry_d]);
            }
        }
                
        union() {
            difference() {             
                cube([entry_h, entry_w, fan_entry_d]);
                translate([wall, wall, 0]) cube([entry_h-wall*2, entry_w-wall*2, fan_entry_d]);
                translate([wall, entry_w/2, fan_entry_d/2]) cube([wall*2, 3, fan_entry_d], center=true);
            }
            difference() {
                entry_ramp(0);
                entry_ramp(wall);
            }
        }
    }
    
    module 50mm_blower_entry_and_mount() {
        union() {
            50mm_blower_entry();
            difference() {
                translate([0, 0, -10]) cube([57, wall, 10]);
                translate([49, 10, -5]) rotate([90, 0, 0]) cylinder(d=No6_through_hole_d(), h=wall*100);
            }
            difference() {
                translate([tube_outer, 0, entry_d-wall*2]) cube([70-tube_outer, entry_w, wall*2]);
                translate([65, entry_w*.25, 0]) cylinder(d=M3_through_hole_d(), h=wall*100);
                translate([65, entry_w*.75, 0]) cylinder(d=M3_through_hole_d(), h=wall*100);
            }
            translate([entry_h, 0, 0]) cube([57-entry_h, wall, entry_d]);
        }
    }

    union() {
        translate([tube_outer_delta_x/2, tube_outer_delta_y/2, tube_outer/2]) 50mm_blower_shroud_exit();
        translate([tube_middle_delta_x+tube_outer/2+entry_d, tube_outer_delta_y/2-entry_w/2, 0]) rotate([0, -90, 0]) 50mm_blower_entry_and_mount();
    }
}

//rotate([-45, 0, 0])
//40mm_fan_version();

50mm_blower_shroud();
