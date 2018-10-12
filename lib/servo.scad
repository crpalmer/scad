include <utils_threads.scad>

$fa = 1;
$fs = 0.6;

module clamping_hub(id = inch_to_mm(3/8), spacing=inch_to_mm(0.7), wall=2, h=8, thread_d = M3_tapping_hole_d(), hole_d, extension_w = 8, clamp_ext) {
    
    hole_d = hole_d == undef ? thread_d : hole_d;
    clamp_ext = clamp_ext == undef ? wall*2 : clamp_ext;

    extension_l = thread_d + wall*2;
    
    d = spacing + wall*4 + thread_d*2;
    w = sqrt((d/2)*(d/2) / 2);
    w = sqrt(2)*d/2;
    big_h = h + wall * 2;
    extension = wall*4 + thread_d;
    clamp_d = d * 0.75;
    
    difference() {
        union() {
            translate([-w/2, -w/2, 0]) cube([w, w, h]);
            cylinder(d = id + wall*2, h = h + clamp_ext);
            translate([-extension_w, w/2, 0]) cube([extension_w*2, extension_l, h]);
        }
        cylinder(d = id, h = big_h);
        translate([-1, 0, 0]) cube([2, d, big_h]);
        for (angle = [45:90:360]) {
            rotate([0, 0, angle]) translate([spacing/2, 0, 0]) cylinder(d = hole_d, h = big_h);
        }
        translate([-extension, w/2+wall+thread_d/2, h/2]) rotate([0, 90, 0]) cylinder(d = thread_d, h = extension*2);
    }
}

module grub_hub(od = 25, id = inch_to_mm(3/8)+.1, h = 8, hole_d = M3_through_hole_d(), spacing = inch_to_mm(0.77), grub_d = M3_tapping_hole_d()) {
    difference() {
        cylinder(d = od, h = h);
        cylinder(d = id, h = h);
        for (angle = [45:90:360]) {
            rotate([0, 0, angle])         translate([spacing/2, 0, 0]) cylinder(d = hole_d, h = h);
        }
        for (angle = [0, 90]) {
            rotate([0, 0, angle]) translate([-od, 0, h/2]) rotate([0, 90, 0]) cylinder(d = grub_d, h = od*2);
        }
    }
}
