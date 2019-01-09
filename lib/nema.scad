include <utils_threads.scad>

module nema_mount_plate(size, hole_offset, hole_d, wall = 4) {
    difference() {
        translate([0, 0, wall/2]) cube([size, size, wall], center=true);
        for (xy = [ [-1, -1], [1, -1], [1, 1], [-1, 1] ] * hole_offset/2) {
            translate([xy[0], xy[1], 0]) cylinder(d = M3_through_hole_d(), h=wall*2);
        }
        cylinder(d = 23, h = wall*2) cylinder(d = 23, h=wall*2);
    }
}

module nema_mount(size, hole_offset, hole_d, wall = 4) {
    difference() {
        union() {
            nema_mount_plate(size=size, hole_offset=hole_offset, hole_d=hole_d, wall=wall);
            for (x = [-size/2 - wall, size/2]) {
                translate([x, -size/2-wall, wall]) linear_extrude(height = size, scale = [1, 1/size]) square([wall, size+wall]);
                translate([x, -size/2-wall, 0]) cube([wall, size+wall, wall]);
            }
            translate([-size/2-wall, -size/2-wall, 0]) cube([size+wall*2, wall, size+wall]);
        }
        translate([-size, -size, size]) cube([size*2, size*2, wall]);
    }
}

module nema17_mount_plate(wall = 4) {
    nema_mount_plate(size = 45, hole_offset = 31, hole_d = 23);
}

module nema17_mount(wall = 4) {
    nema_mount(size = 45, hole_offset = 31, hole_d = 23);
}

module nema17_planetary_mount_plate(wall = 4) {
    nema_mount_plate(size = 45, hole_offset = 19.8, hole_d = 23);
}

module nema17_planetary_mount(wall = 4) {
    nema_mount(size = 45, hole_offset = 19.8, hole_d = 23);
}
