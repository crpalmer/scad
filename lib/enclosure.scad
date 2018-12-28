include <utils.scad>

function enclosure_define(size, thick=2.5, mount=9, lip=true, screw_d=2.5, screw_len=8, has_lid=true, n_posts=2, corner_posts=false) =
    [ size[0], size[1], size[2], thick, mount, lip, screw_d, screw_len, has_lid, n_posts, corner_posts ];

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
        union() {
            difference() {
                rounded_cube([x, y, z], r=thick*2);
                translate([thick, thick, thick]) rounded_cube([x-thick*2, y-thick*2, z-thick], r=thick*2);
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

module enclosure_punch(obj, wall, at, D) {
    thick = enclosure_thick(obj);
    enclosure_punch_common(obj, wall, at) cylinder(h=thick+2, r=D/2);
}

module enclosure_punch_square(obj, wall, at, size) {
    thick = enclosure_thick(obj);
    enclosure_punch_common(obj, wall, at) translate([-size[0]/2, -size[1]/2, 0]) cube([size[0], size[1], thick*2]);
}

module enclosure_punch_common(obj, wall, at) {
    at_x = at[0];
    
    at_y = at[1];
    e_x = enclosure_x(obj);
    e_y = enclosure_y(obj);
    thick = enclosure_thick(obj);
    wall_id = enclosure_wall(wall);
    translates = [ [ at_x, thick+0.5, at_y ],
                   [ -1,  e_y - at_x, at_y ],
                   [ e_x-(thick+1), at_x, at_y ],
                   [ e_x-at_x, e_y+1, at_y ] ];
    rotations = [ [90, 0, 0], [0, 90, 0], [0, 90, 0], [90, 0, 0] ];
    translate(translates[wall_id]) rotate(rotations[wall_id]) children();
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

module self_tap_tube(obj) {
    screw_d = enclosure_screw_d(obj);
    screw_len = enclosure_screw_len(obj);
    thick = enclosure_thick(obj);

    difference() {
	tube(obj);
	cylinder(d=screw_d, h=screw_len);
    }
}

module enclosure_ssr_mount(obj) {
    screw_d = enclosure_screw_d(obj);
    screw_len = enclosure_screw_len(obj);
    thick = enclosure_thick(obj);

    ssr_size = [57.3, 44.5, 22.6];
    T = thick*.1;

    module outline() {
        difference() {
            cube(size = [ssr_size[0], ssr_size[1], T]);
            translate([T, T,0]) cube([ssr_size[0] - T*2, ssr_size[1] - T*2], T);
        }
    }

    translate([thick, thick, thick])
    union() {
        outline();
        translate([4.75, 22.25, 0]) union() {
            self_tap_tube(obj);
            translate([47.6, 0, 0]) self_tap_tube(obj);
            translate([24, 14, 0]) tube(obj);
            translate([24, -14, 0]) tube(obj);
        }
    }
}

module enclosure_maestro_mount(obj) {
    thick = enclosure_thick(obj);

    translate([thick, thick, thick])
    union() {
	translate([19.6, 3.5, 0]) self_tap_tube(obj);
	translate([2.5, 17.9, 0]) self_tap_tube(obj);
	translate([19.6, 17.9, 0]) tube(obj);
    }
}

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
echo( [ module_size[0], hole[1], deltas[hole[0]], hole_offset[0] ]);
	translate( [ x, y, thick ]) self_tap_tube(obj);
    }
}

