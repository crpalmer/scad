include <threads.scad>
include <utils.scad>

function enclosure_define(size, thick=2.5, mount=12, lip=true) = 
    [ size[0], size[1], size[2], thick, mount, lip ];

function enclosure_x(obj) = obj[0];
function enclosure_y(obj) = obj[1];
function enclosure_z(obj) = obj[2];
function enclosure_thick(obj) = obj[3];
function enclosure_mount(obj) = obj[4];
function enclosure_lip(obj) = obj[5];

function enclosure_wall(str) = str == "front" ? 0 : str == "left" ? 1 : str == "right" ? 2 : str == "back"?  3 : -1;
    
module enclosure_box(obj)
{
    x = enclosure_x(obj);
    y = enclosure_y(obj);
    z = enclosure_z(obj);
    thick = enclosure_thick(obj);
    mount = enclosure_mount(obj);
    
	module mount()
	{
        if (z >= 16 - thick) {
            union() {
               translate([0, 0, z-16-thick]) linear_extrude(height=thick) circle(r=mount/2, $fn=100);
               translate([0, 0, z-16]) M6_tube(D=mount, windings=16);
            }
        }
	}

    module box() {
        union() {
            difference() {
                rounded_cube([x, y, z], r=thick*2);
                translate([thick, thick, thick]) rounded_cube([x-thick*2, y-thick*2, z-thick], r=thick*2);
            }
            translate([mount/2, y/2, 0]) mount();
            translate([x - mount/2, y/2, 0]) mount();
        }
    }

    module lip() {
        if (enclosure_lip(obj)) {
            translate([thick/2, thick/2, z-thick/2])
            rounded_cube(size=[x - thick,y - thick, thick/2], r=thick*2);
        }
    }

    difference() {
        box();
        lip();
    }
}

module enclosure_punch(obj, wall, at, D) {
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
    translate(translates[wall_id]) rotate(rotations[wall_id]) cylinder(h=thick+2, r=D/2, $fn=100);
}

module enclosure_lid(obj) {
    x = enclosure_x(obj);
    y = enclosure_y(obj);
    thick = enclosure_thick(obj);
    mount = enclosure_mount(obj);
    
    module hole() {
        cylinder(r=6.6/2, h=thick, $fn=100);
        cylinder(r=10/2, h=thick/2, $fn=100);
    }
    
    module lip() {
        if (enclosure_lip(obj)) {
            translate([0, 0, thick/2])
            difference() {
                rounded_cube(r=thick*2, size=[x, y, thick]);
                translate([thick/2, thick/2, 0]) rounded_cube(r=thick*2, size=[x-thick, y-thick, thick/2]);
            }
        }
    }

    difference() {
        rounded_cube(r=thick*2, size=[x, y, thick]);
        union() {
            translate([mount/2,y/2,0]) hole();
            translate([x-mount/2,y/2,0]) hole();
            lip();
        }
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

    module mounts() {
        translate([thick + 3.5, thick+3.5, thick])
        union() {
            M2_5_tube();
            translate( [58, 0, 0] ) M2_5_tube();
            translate( [0, 49, 0] ) M2_5_tube();
            translate( [58, 49, 0] ) M2_5_tube();
        }
    }
    
    union() {
        outline();
        mounts();
    }
}

module enclosure_ssr_mount(obj) {
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
            M6_tube();
            translate([47.6, 0, 0]) M6_tube();
            translate([24, 14, 0]) M6_tube();
            translate([24, -14, 0]) M6_tube();
        }
    }
}
E = enclosure_define([63, 50, 1], thick=1);
enclosure_box(E);
translate([2, 2, 0]) enclosure_ssr_mount(E);
