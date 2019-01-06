include <utils.scad>
include <utils_threads.scad>

ENCLOSURE_PATTERN_SOLID = 0;
ENCLOSURE_PATTERN_HONEYCOMB = 1;
ENCLOSURE_PATTERN_DIAMOND = 2;
ENCLOSURE_PATTERN_CIRCLE = 3;

function enclosure_define(size, thick=2.5, mount=9, lip=true, screw_d=M3_tapping_hole_d(), screw_len=8, has_lid=true, n_posts=2, corner_posts=false, side_pattern = ENCLOSURE_PATTERN_SOLID, side_pattern_size) =
    [ size[0], size[1], size[2], thick, mount, lip, screw_d, screw_len, has_lid, n_posts, corner_posts, side_pattern, side_pattern_size];

function enclosure_x(obj) = obj[0];
function enclosure_y(obj) = obj[1];
function enclosure_z(obj) = obj[2];
function enclosure_thick(obj) = obj[3];
function enclosure_mount(obj) = obj[4];
function enclosure_lip(obj) = obj[5];
function enclosure_screw_d(obj) = obj[6];
function enclosure_screw_len(obj) = obj[7];
function enclosure_has_lid(obj) = obj[8];
function enclosure_n_posts(obj) = obj[9];
function enclosure_corner_posts(obj) = obj[10];
function enclosure_side_pattern(obj, wall) = obj[11][0] == undef ? obj[11] : (len(obj[11]) <= wall ? obj[11][len(obj[11])-1] : obj[11][wall]);
function enclosure_side_pattern_size(obj) = obj[12] == undef ? min(enclosure_x(obj), enclosure_y(obj)) / 25 : obj[12];

function enclosure_inner_x(obj) = enclosure_x(obj) - enclosure_thick(obj) * 2;
function enclosure_inner_y(obj) = enclosure_y(obj) - enclosure_thick(obj) * 2;

function enclosure_wall(str) = str == "front" ? 0 : str == "left" ? 1 : str == "right" ? 2 : str == "back"?  3 : -1;

module enclosure_mount_points(obj)
{
    x = enclosure_x(obj);
    y = enclosure_y(obj);
    thick = enclosure_thick(obj);
    mount = enclosure_mount(obj);
    screw_len = enclosure_screw_len(obj);
    screw_d = enclosure_screw_d(obj);
    n_posts = enclosure_n_posts(obj);
    corner_posts = enclosure_corner_posts(obj);

    if (corner_posts) {
        delta = mount/2 + thick/2;
        if (n_posts > 0) translate([delta, delta, 0]) children();
        if (n_posts > 1) translate([x - delta, y - delta, 0]) children();
        if (n_posts > 2) translate([delta, y - delta, 0]) children();
        if (n_posts > 3) translate([x - delta, delta, 0]) children();
    } else {
        if (n_posts > 0) translate([mount/2, y/2, 0]) children();
        if (n_posts > 1) translate([x - mount/2, y/2, 0]) children();
        if (n_posts > 2) translate([x/2, mount/2, 0]) children();
        if (n_posts > 3) translate([x/2, x - mount/2, 0]) children();
    }
}

module enclosure_box(obj)
{
    x = enclosure_x(obj);
    y = enclosure_y(obj);
    z = enclosure_z(obj);
    thick = enclosure_thick(obj);
    mount = enclosure_mount(obj);
    screw_len = enclosure_screw_len(obj);
    screw_d = enclosure_screw_d(obj);

    module mount() {
        if (enclosure_has_lid(obj)) {
            difference() {
            cylinder(d=mount, h=z);
            translate([0, 0, z-screw_len]) cylinder(d=screw_d, h=screw_len);
            }
        }
    }

    module box() {
        module side_pattern(pattern, len) {
            size = enclosure_side_pattern_size(obj);
            
            module do_pattern() {
                rotate([90, 0, 0]) 
                for (x = [5 + size/2 : size + thick : len - 5 - size/2]) {
                    for (y = [thick + 5 + size/2: size + thick : z - 5 - size/2]) {
                        delta_x = floor(y/ (size + thick)) % 2 == 1 ? (size+thick)/2 : 0;
                        translate([x + delta_x, y, -thick*2]) children();
                    }
                }
            }

            if (pattern == ENCLOSURE_PATTERN_HONEYCOMB) {
                do_pattern() rotate([0, 0, 90]) cylinder(d = size, h=thick*4, $fn=6);
            } else if (pattern == ENCLOSURE_PATTERN_DIAMOND) {
                diagonal_size = triangle_adj_length_angle_hyp(45, size/2)*2;
                echo([size, diagonal_size]);
                do_pattern() rotate([0, 0, 45]) translate([0, 0, thick*2]) cube([diagonal_size, diagonal_size, thick*4], center=true);
            } else if (pattern == ENCLOSURE_PATTERN_CIRCLE) {
                do_pattern() cylinder(d = size, h = thick*4);
            }
        }
        
        union() {
            difference() {
                rounded_cube([x, y, z], r=thick*2);
                translate([thick, thick, thick]) rounded_cube([x-thick*2, y-thick*2, z], r=thick*2);
                for (wall = [0:3]) {
                    translate([wall == 2 ? x - thick : 0, wall == 3 ? y - thick : 0, 0]) rotate([0, 0, wall == 1 || wall == 2 ? 90 : 0]) side_pattern(enclosure_side_pattern(obj, wall), wall == 1 || wall == 2 ? y : x);
                }
            }
            enclosure_mount_points(obj) mount();
        }
    }
    
    module lip() {
        if (enclosure_has_lid(obj)) {
            if (enclosure_lip(obj)) {
                translate([thick/2, thick/2, z-thick])
                rounded_cube(size=[x - thick,y - thick, thick], r=thick*2);
            }
        }
    }

    difference() {
        box();
        lip();
    }
}

module enclosure_punch_circle(obj, wall, at, D) {
    thick = enclosure_thick(obj);
    union() {
        difference() {
            children();
            enclosure_punch_common(obj, wall, at) cylinder(h=thick+2, d=D);
        }
        difference() {
            enclosure_punch_common(obj, wall, at, extra=0) cylinder(d=D + thick*2, h=thick);
            enclosure_punch_common(obj, wall, at) cylinder(h=thick+2, d=D);
        }
    }           
}

module enclosure_punch_square(obj, wall, at, size) {
    thick = enclosure_thick(obj);
    union() {
        difference() {
            children();
            enclosure_punch_common(obj, wall, at) translate([0, 0, thick]) cube([size[0], size[1], thick*2], center=true);
        }
        difference() {
            enclosure_punch_common(obj, wall, at, extra=0) translate([0, 0, thick/2]) cube([size[0]+thick*2, size[1]+thick*2, thick], center=true);
            enclosure_punch_common(obj, wall, at) translate([0, 0, thick]) cube([size[0], size[1], thick*2], center=true);
        }
    }
}

module enclosure_place_square(obj, wall, at, size) {
    thick = enclosure_thick(obj);
    children();
    enclosure_punch_common(obj, wall, at, extra=0) translate([0, 0, thick/2]) cube([size[0]+thick*2, size[1]+thick*2, thick], center=true);
}

module enclosure_label(obj, wall, at, size, text, depth = 0.3)
{
    thick = enclosure_thick(obj);
    difference() {
        enclosure_place_square(obj, wall, at, size) children();
        enclosure_punch_common(obj, wall, at) color("green") translate(-[size[0]/2 + thick/2, size[1]/2 + thick/2, -thick-1], extra = 1) linear_extrude(height = depth + 1) text(text, size=size[1]-thick);
    }
}

module enclosure_punch_common(obj, wall, at, extra) {
    at_x = at[0];
    
    at_y = at[1];
    e_x = enclosure_x(obj);
    e_y = enclosure_y(obj);
    thick = enclosure_thick(obj);
    wall_id = enclosure_wall(wall);
    extra = extra == undef ? min(1, thick) : extra;
    
    translates = [ [ at_x, thick+extra, at_y ],
                   [ thick+extra,  e_y - at_x, at_y ],
                   [ e_x-(thick+extra), at_x, at_y ],
                   [ e_x-at_x, e_y-thick-extra, at_y ] ];
    rotation1 = [ 0, -90, 90, 180 ];
    rotations2 = [ [90, 0, 0], [0, -90, 0], [0, 90, 0], [-90, 0, 0] ];
    translate(translates[wall_id]) rotate(rotations2[wall_id]) rotate([0, 0, rotation1[wall_id]]) children();
}

module enclosure_mounting_tabs(obj, wall, hole_d=5) {
    e_x = enclosure_x(obj);
    e_y = enclosure_y(obj);
    thick = enclosure_thick(obj);
    wall_id = enclosure_wall(wall);
    D = hole_d + thick * 2;
    r = thick*2;

    module tab() {
        difference() {
            cube([D, D, thick*2]);
            translate([thick + hole_d / 2, thick + hole_d / 2, 0]) cylinder(d=hole_d, h=thick*2);
        }
    }

    mounts = [ [ [r, -D, 0], [e_x - D - r, -D, 0] ],
                [ [-D, r, 0], [-D, e_y - D - r, 0] ],
                [ [e_x, r, 0], [e_x, e_y - D - r, 0] ],
                [ [r, e_y, 0], [e_x - D - r, e_y, 0] ] ];

    translate(mounts[wall_id][0]) tab();
    translate(mounts[wall_id][1]) tab();
    children();
}

module enclosure_lid(obj) {
    x = enclosure_x(obj);
    y = enclosure_y(obj);
    thick = enclosure_thick(obj);
    mount = enclosure_mount(obj);
    screw_d = enclosure_screw_d(obj);

    clearance = 0.1;

    module hole() {
        cylinder(d=screw_d + 0.5, h=thick*2);
    }

    module lip() {
        if (enclosure_lip(obj)) {
            difference() {
                rounded_cube(r=thick*2, size=[x, y, thick/2]);
                translate([thick/2+clearance, thick/2+clearance, 0]) rounded_cube(r=thick*2, size=[x-thick-clearance*2, y-thick-clearance*2, thick/2]);
            }
        }
    }

    difference() {
        rounded_cube(r=thick*2, size=[x, y, thick*2]);
        enclosure_mount_points(obj) hole();
        lip();
    }
}

module enclosure_pi_mount(obj) {
    thick = enclosure_thick(obj);
    L = thick*.1;

    module outline() {
        translate([thick, thick, thick*.9])
        difference() {
            rounded_cube([85, 56, L], r=3);
            translate([L, L, 0]) rounded_cube([85-L*2, 56-L*2, L], r=3);
        }
    }

    module mount() {
            cylinder(d=2.5, h=3);
    }

    module mounts() {
        translate([thick + 3.5, thick+3.5, thick])
        union() {
            mount();
            translate( [58, 0, 0] ) mount();
            translate( [0, 49, 0] ) mount();
            translate( [58, 49, 0] ) mount();
        }
    }

    union() {
        outline();
        mounts();
    }
}

module tube(obj) {
    screw_d = enclosure_screw_d(obj);
    screw_len = enclosure_screw_len(obj);
    thick = enclosure_thick(obj);

    cylinder(d=screw_d + thick*2, h=screw_len);
}

module enclosure_ssr_mount(obj, at = [0, 0], angle = 0, through_hole = false, h)
{
    ssr_size = [57.3, 44.5];
    deltas = concat([ [4.75, 22.25], [47.6 + 4.75, 22.25] ], h == 0 ? [] : [ [4.75 + 24, 22.25 + 14], [4.75 + 24, 22.25 - 14]]);
    enclosure_mounts(obj, at=at, deltas = deltas, size = ssr_size, angle=angle, through_hole = through_hole, h = h) children();
}

module enclosure_maestro_mount(obj, at = [0, 0]) {
    thick = enclosure_thick(obj);

    enclosure_mounts(E, at = at, deltas = [ [19.6, 3.5], [2.5, 17.9], [19.6, 17.9]]) children();
}

// this is broken:
module enclosure_relay_module_mount(obj) {
    screw_d = enclosure_screw_d(obj);
    screw_len = enclosure_screw_len(obj);
    thick = enclosure_thick(obj);

    module_size = [ 27, 34 ];
    hole_offset = [ 8, 5 ];
    deltas = [+1, -1];

    for (hole = [ [0, 0], [0, 1], [1, 0], [1, 1] ]) {
	x = module_size[0] * hole[0] + deltas[hole[0]] * hole_offset[0];
	y = module_size[1] * hole[1] + deltas[hole[1]] * hole_offset[1];
	translate( [ x, y, thick ]) self_tap_tube(obj);
    }
}

module enclosure_mounts(obj, at = [0, 0], deltas, size, h, hole_d, post_d, through_hole = false, angle = 0)
{
    thick = enclosure_thick(obj);
    h = h == undef ? enclosure_screw_len(obj) : h;
    hole_d = hole_d == undef ? enclosure_screw_d(obj) : hole_d;
    post_d = post_d == undef ? hole_d + thick*2 : post_d;
    
    offset_at = size != undef ? -size/2 : at;
    offset = size != undef ? at + size/2 : [0, 0];
   
    module place(delta, start_z=thick) {
        translate([offset[0] + thick, offset[1] + thick, start_z])
            rotate([0, 0, angle])
            translate([offset_at[0] + delta[0], offset_at[1] + delta[1], 0])
            children();
    }
    
    difference() {
        union() {
            children();
            if (size != undef) {
                place([0, 0]) color("red") cube([size[0], size[1], 0.2]);
            }
            for (delta = deltas) {
                place(delta) cylinder(d = post_d, h = h);
            }
        }
        for (delta = deltas) {
            place(delta, through_hole ? 0 : thick) cylinder(d = hole_d, h = h + thick*2);
        }
    }
}

module enclosure_duet_mount(obj, at = [0, 0], h, angle = 0, through_hole = false)
{
    size = [100, 130];
    deltas = [ [4.119, 4], [96.119, 4], [4.4, 119], [96.4, 119] ];
    enclosure_mounts(obj, at = at, deltas = deltas, size = size, h = h, angle = angle, through_hole = through_hole) children();
}
