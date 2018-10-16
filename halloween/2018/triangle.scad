include <servo.scad>
include <high-detail.scad>

mount_x = 58;
mount_y = 80;
mount_offset_y = 35;
connection_wall_x = 43;
servo_mounting_plate_h = 6;

bearing_h = 8;
screw_h = 18.7;
hub_h = 13;
servo_screw_h = 1.8;
servo_mount_h = 14.2;
servo_mount_spacing = [47, 10];
alum_horn_h = 4.84;
alum_horn_d = 20;

bearing_split_x = 45;
bearing_split_holes = [
    [-mount_offset_y + 2.5, 4],
    [1, 4],
    [mount_y - mount_offset_y-2.5, 4],
    [-mount_offset_y + 2.5, -hub_h - alum_horn_h],
    [mount_y - mount_offset_y-2.5, -hub_h - alum_horn_h]
];

servo_mount_holes = [
    [ mount_x - connection_wall_x + 2.5, -mount_offset_y + 2.5 ],
    [ connection_wall_x - 10, -mount_offset_y + 2.5 ],
    [ mount_x - 2.5, 0 ],
    [ mount_x - connection_wall_x + 2.5, mount_y - mount_offset_y - 2.5 ],
    [ connection_wall_x - 10, mount_y - mount_offset_y - 2.5 ]
];

module scan() {
    translate([35, 0, 3]) rotate([57, 75, 0]) translate([-75, -43, -470]) import("stl/skeleton-arm-joint-low-draft.stl");
}

module scan_for_cutout() {
    scan();
    translate([30, -21, 0]) cube([20, 17, 10]);
    translate([30, 6, 0]) cube([20, 17, 10]);
}

module hub() {
    round_hub(
        id = inch_to_mm(1/4),
        spacing = 14,
        wall = (12 - inch_to_mm(1/4))/2,
        h=hub_h,
        thread_d = M3_heat_set_hole_d(),
        hole_d = M3_through_hole_d(),
        hole_h = hub_h-4,
        recessed_d = 6
    );
}

module bearing_holder_in(h) {
    od=30;
    id=22;
    iid=14;
    
    difference() {
        union() {
            cylinder(d = od, h = h);
            children();
        }
        cylinder(d = id, h = h-1);
        cylinder(d = iid, h = h);
    }
}

module bearing_mount_no_cutout() {
    wall = 5;
    
    // openscad screws up rounding this in some way, fake it with a constant value
//    wall_z = hub_h + alum_horn_h + standard_servo_delta_h()[1] - servo_mounting_plate_h + bearing_h;
//echo (wall_z);
    wall_z = 29;
    
    bearing_holder_in(bearing_h) translate([0, -mount_offset_y, -(wall_z - bearing_h)])
    difference() {
        cube([mount_x, mount_y, wall_z]);
        cube([mount_x - connection_wall_x, mount_y, wall_z - bearing_h]);
        translate([0, wall, 0]) cube([mount_x - wall, mount_y - wall*2, wall_z - bearing_h]);
        for (h = servo_mount_holes) {
            translate([h[0], h[1] + mount_offset_y, -1]) cylinder(d = M3_tapping_hole_d(), h=15);
        }
    } 
}

module bearing_mount() {
    difference() {
        bearing_mount_no_cutout();
        translate([0, 0, -10]) linear_extrude(height=20) polygon([ [0, -15], [mount_x - connection_wall_x, -mount_offset_y], [0, -mount_offset_y] ]);
    }
}

module bearing_mount_part(hole_d) {
    difference() {
        bearing_mount();
        scan_for_cutout();
        children();
        for (h = bearing_split_holes) {
            translate([bearing_split_x - 10, h[0], h[1]]) rotate([0, 90, 0]) cylinder(d = hole_d, h=30);
        }
    }
}

module bearing_mount_part1() {
    bearing_mount_part(M3_through_hole_d())
        translate([-20, -mount_offset_y, -50]) cube([20+bearing_split_x, mount_y, 100]);
}

module bearing_mount_part2() {
    bearing_mount_part(M3_tapping_hole_d()) translate([bearing_split_x, -mount_offset_y, -50]) cube([mount_x, mount_y, 100]);
}

module servo_mount() {
    ext_x = mount_x - standard_servo_delta_x()[1];
    h = servo_mounting_plate_h;
    
    translate([0, 0, -hub_h - alum_horn_h - standard_servo_delta_h()[1]])
    difference() {
        union() {
            standard_servo_push_up_mount(wall=4, h = h);
            translate([mount_x - ext_x, -mount_offset_y, 0]) cube([ext_x, mount_y, h]);
            translate([mount_x - connection_wall_x, -mount_offset_y, 0]) cube([connection_wall_x, mount_offset_y - standard_servo_delta_y() - 1, h]);
            translate([mount_x - connection_wall_x, standard_servo_delta_y()+1, 0]) cube([connection_wall_x, mount_y - (mount_offset_y + standard_servo_delta_y()) - 1, h]);
        }
        for (h = servo_mount_holes) {
            translate([h[0], h[1], -1]) cylinder(d = M3_through_hole_d(), h=100);
        }
    }
}

module full_mount() {
    difference() {
        union() {
            bearing_mount_part1();
            bearing_mount_part2();
            servo_mount();
        }
    }
}

module mock_up() {
    translate([0, 0, -(screw_h - bearing_h)]) cylinder(d = inch_to_mm(1/4), h = screw_h);
    difference() {
        cylinder(d = 20, h = 7);
        cylinder(d = 10, h = 7);
    }
    rotate([0, 0, -90]) translate([0, 0, -hub_h]) hub();
    translate([0, 0, -hub_h]) cylinder(d = 5.5, h = servo_screw_h);
    translate([0, 0, -hub_h - alum_horn_h]) cylinder(d=10, h=alum_horn_h);
    translate([0, 0, -hub_h - 1]) cylinder(d = alum_horn_d, h=1);
    translate([0, 0, -hub_h - alum_horn_h]) standard_servo();
}

//full_mount();
//mock_up();
//scan();

//rotate([0, 90, 0]) 
//bearing_mount_part1();

//rotate([0, 180, 0]) 
//bearing_mount_part2();

//rotate([0, 180, 0])
//servo_mount();

hub();