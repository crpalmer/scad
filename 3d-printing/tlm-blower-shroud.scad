include <utils_threads.scad>

$fn=64;

wall = 1.2;
full_h = 59;

fan_hole = [25, 16, 2.5];

shroud_h = 10 + wall*2;
shroud_flat = 4;

points = [ [0, 0], [0, shroud_h], [shroud_h, shroud_h], [shroud_h, shroud_h - shroud_flat]];

module profile() {
    difference() {
        polygon(points);
        offset(delta=-wall) polygon(points);
    }
}


module exit_holes() {
    union() {
        x_holes();
        y_holes();
        rotate([0, 0, 180]) y_holes();
    }
}


shroud_d = 35;
fan_mount_d = 22+12/2;
effector_T = 10;
mounting_wall_T = 5;

fan_entry_box = [ fan_hole[0] + wall*8, fan_mount_d + wall*4 + fan_hole[1] + mounting_wall_T, shroud_h ];

fan_mount_wall = [ fan_entry_box[0], mounting_wall_T, full_h - fan_entry_box[2]];

fan_hole_at = [-fan_hole[0]/2, -fan_entry_box[1] + wall*2, fan_entry_box[2] ];

entry_hole_at = fan_hole_at + [ wall, wall, -wall ];

module full_shroud_of() {
    rotate_extrude() translate([shroud_d/2, 0, 0]) rotate([0, 0, 90]) mirror([0, 1, 0]) children();
}

module full_shroud() {
    full_shroud_of() profile();
}

module mounting_wall() {
    extra = fan_mount_d - (shroud_d / 2 + (shroud_h - shroud_flat));
    extra_h = 3*extra;
    translate([-fan_mount_wall[0]/2, -fan_mount_d - fan_mount_wall[1], fan_entry_box[2]]) union() {    translate([0, fan_mount_wall[1], 0]) linear_extrude(height=extra_h, scale=[1, .4 / extra_h]) square([fan_mount_wall[0], extra]);
        cube(fan_mount_wall);
    }
}
    
module fan_lip() {
    translate(fan_hole_at - [0, 0, wall+0.8]) difference() {
        cube(fan_hole + [0, 0, wall+0.8]);
        translate([wall, wall, 0]) cube(fan_hole - [wall*2, wall*2, -100]);
    }
}

module entry_box_helper() {
    translate([0, 0.01, 0]) difference() {
        translate([-fan_entry_box[0]/2, -fan_entry_box[1], 0]) children();
        rotate_extrude() square([shroud_h + shroud_d/2, shroud_h]);
    }
}

module entry_box() {
    entry_box_helper() cube(fan_entry_box);
}   

module entry_box_interior() {
    translate([wall, wall*2, wall]) entry_box_helper() cube(fan_entry_box - [wall*2, 0, wall*2]);
}

module entry_box_hole() {
    translate(entry_hole_at) cube([fan_hole[0] - wall*2, fan_hole[1] - wall*2, wall]);
}

module fan_mounting_hole() {
    translate([-fan_hole[0]/2 - 0.4, 0, 37.5 + fan_entry_box[2]]) rotate([90, 0, 0]) cylinder(d = M3_tapping_hole_d(), h=100);
}

module effector_mounting_holes() {
    translate([-7, 0, full_h - effector_T/2]) rotate([90, 0, 0]) cylinder(d = M3_through_hole_d(), h=100);
    translate([+7, 0, full_h - effector_T/2]) rotate([90, 0, 0]) cylinder(d = M3_through_hole_d(), h=100);
}

module fan_exits() {
    full_shroud_of() translate([0, wall*1.5, 0]) square([wall, 3]);
}

module shroud_front_cutoff() {
    translate([-50, 12 - wall, 0]) cube([100, 100, 100]);
}

module shroud_front_caps() {
    intersection() {
        full_shroud_of() polygon(points);
        translate([-50, 12 - wall, 0]) cube([100, wall, 100]);
    }
}

module entry_hole_supports() {
    for (xy = [ [0, 0], [0, 1], [1, 0], [1, 1] ]) {
        translate([fan_hole_at[0] + xy[0] * (fan_hole[0] - wall), fan_hole_at[1] + xy[1] * (fan_hole[1] - wall), 0]) cube([1.2, 1.2, fan_entry_box[2]]);
    }
}

union() {
    difference() {
        union() {
            full_shroud();
            entry_box();
            mounting_wall();
        }
        entry_box_interior();
        entry_box_hole();
        fan_mounting_hole();
        effector_mounting_holes();
        shroud_front_cutoff();
        fan_exits();
    }
    entry_hole_supports();
    fan_lip();
    shroud_front_caps();
}
