include <utils_threads.scad>

module clamping_hub(id = inch_to_mm(3/8), spacing=inch_to_mm(0.7), wall=2, h=8, thread_d = M3_tapping_hole_d(), thread_through = M3_through_hole_d(), hole_d, hole_h, recessed_d, extension_w = 8, clamp_ext) {
    
    hole_d = hole_d == undef ? thread_d : hole_d;
    clamp_ext = clamp_ext == undef ? wall*2 : clamp_ext;

    extension_l = thread_d + wall*2;
    
    d = spacing + wall*4 + hole_d;
    w = sqrt((d/2)*(d/2) / 2);
    w = sqrt(2)*d/2;
    big_h = h + wall * 2;
    hole_h = hole_h == undef ? big_h : hole_h;
    recessed_d = recessed_d == undef ? hole_h : recessed_d;
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
            rotate([0, 0, angle]) translate([spacing/2, 0, 0]) union() {
                cylinder(d = hole_d, h = hole_h);
                translate([0, 0, hole_h]) cylinder(d = recessed_d, h = big_h);
            }
        }
        translate([0, w/2+wall+thread_d/2, h/2]) union() {
	    rotate([0, -90, 0]) cylinder(d = thread_through, h = extension);
            rotate([0, 90, 0]) cylinder(d = thread_d, h = extension);
	}
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

module round_hub(od, id = inch_to_mm(3/8), spacing=inch_to_mm(0.7), wall=2, h=8, thread_d = M3_tapping_hole_d(), thread_through = M3_through_hole_d(), hole_d, hole_h, recessed_d, clamp_side_d = 4) {
    
    hole_d = hole_d == undef ? thread_d : hole_d;

    od = od == undef ? spacing + wall*4 + hole_d : od;
    big_h = h + wall * 2;
    hole_h = hole_h == undef ? big_h : hole_h;
    recessed_d = recessed_d == undef ? hole_d : recessed_d;
    clamp_d = od * 0.75;
    slit = id / 4;
    
    difference() {
        union() {
            cylinder(d = od, h = hole_h);
            cylinder(d = id + wall*2, h = h);
        }
        cylinder(d = id, h = big_h);
        rotate([0, 0, 180]) translate([-slit/2, 0, 0]) cube([slit, od, big_h]);
        for (angle = [0:90:180]) {
            rotate([0, 0, angle]) translate([spacing/2, 0, 0]) union() {
                cylinder(d = hole_d, h = big_h);
                translate([0, 0, hole_h]) cylinder(d = recessed_d, h = big_h);
            }
        }
        translate([0, -(id + wall*2)/2 - thread_through/2, hole_h / 2]) union() {
            rotate([0, -90, 0]) cylinder(d = thread_through, h = od);
            rotate([0, 90, 0]) cylinder(d = thread_d, h = od);
            cutoff_y = thread_through + wall*2;
            translate([-od/2, -cutoff_y/2, -big_h/2]) cube([od/2 - slit / 2 - clamp_side_d, cutoff_y, big_h]);
            translate([slit/2 + clamp_side_d, -cutoff_y/2, -big_h/2]) cube([od/2, cutoff_y, big_h]);
        }
        translate([-od/2, -od/2, 0]) cube([od, od/2 - (id+wall*2)/2 - thread_through - wall, big_h]);
    }
}

module standard_servo() {
    A=19.82;
    B=13.47;
    C=33.79;
    D=10.17;
    E=9.66;
    F=30.22;
    G=11.68;
    H=26.67;
    K=9.35;
    J=52.82;
    L=4.38;
    M=39.88;
    
    center_to_end = E + (J-M)/2;
    bump_h = G - K;
    block_h = K + H;
    ext = (J-M)/2;
    
    difference() {
        union() {
            cylinder(d=inch_to_mm(0.265), h=3.05);
            translate([0, 0, -bump_h]) cylinder(d=13, h=bump_h);
            translate([-E, -A/2, -bump_h - block_h]) cube([M, A, block_h]);
            translate([-center_to_end, -A/2, -G]) cube([J, A, 2.5]);
        for (x = [-E-ext, F]) {
            translate([x, -.75, -G+2.5]) cube([ext, 1.5, 1.6]);
        }
        }
        for (x = [-B, C]) {
            for (y = [D/2, -D/2]) {
                translate([x, y, -block_h]) cylinder(d=L, h=block_h);
            }
        }
    }
}

module standard_servo_cutout_raw(slop=0.1) {
    A=19.82;
    B=13.47;
    C=33.79;
    D=10.17;
    E=9.66;
    F=30.22;
    G=11.68;
    H=26.67;
    K=9.35;
    J=52.82;
    L=4.38;
    M=39.88;
    
    bump_h = G - K;
    block_h = K + H;
    full_h = block_h + bump_h;
    bottom = G-full_h;
    ext = (J-M)/2;
    
    union() {
        translate([-E-slop, -A/2-slop, bottom]) cube([M+slop*2, A+slop*2, full_h]);
        for (x = [-B, C]) {
            for (y = [D/2, -D/2]) {
                translate([x, y, bottom]) cylinder(d=M3_tapping_hole_d(), h=full_h);
            }
        }
        for (x = [-E-ext-slop, F]) {
            translate([x, -.75-slop/2, 2.5]) cube([ext+slop, 1.5+slop, 1.6+slop]);
        }
    }
}

module standard_servo_cutout_drop_in() {
    standard_servo_cutout_raw();
}

module standard_servo_cutout_push_up() {
    translate([0, 0, -2.5]) standard_servo_cutout_raw();
}

module standard_servo_mount_of(wall=2, h=2) {
    A=19.82;
    E=9.66;
    J=52.82;
    M=39.88;
    
    ext = (J-M)/2;
    
    difference() {
        translate([-E-wall-ext, -A/2-wall, 0]) cube([M+wall*2+ext*2, A+wall*2, h]);
        children();
    }
}

module standard_servo_drop_in_mount(wall=2, h=2) {
    standard_servo_mount_of(wall, h) standard_servo_cutout_drop_in();
}

module standard_servo_push_up_mount(wall=2, h=2) {
    standard_servo_mount_of(wall, h) standard_servo_cutout_push_up();
}

// distance from center to each end in x
function standard_servo_delta_x() = [-9.66 - (52.82-39.88)/2, 30.22 + (52.82-39.88)/2 ];

// distance from center to either side in y
function standard_servo_delta_y() = 19.82 / 2;

// distance from the base of the spline to the [0] bottom of the mount [1] top of the mount
function standard_servo_delta_h() = [ 11.68, 11.68 - 2.5];
