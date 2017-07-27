include <threads.scad>

function enclosure_define(L=115, W=78, H=34, thick=2.5, mount=12) = 
    [ L, W, H, thick, mount ];

function enclosure_L(obj) = obj[0];
function enclosure_W(obj) = obj[1];
function enclosure_H(obj) = obj[2];
function enclosure_thick(obj) = obj[3];
function enclosure_mount(obj) = obj[4];

function enclosure_wall(str) = str == "front" ? 0 : str == "left" ? 1 : str == "right" ? 2 : str == "back"?  3 : -1;
    
module enclosure_box(obj)
{
    L = enclosure_L(obj);
    W = enclosure_W(obj);
    H = enclosure_H(obj);
    thick = enclosure_thick(obj);
    mount = enclosure_mount(obj);
    
	module roundedsquare(r,w,h)
	{
		union()
		{
			translate([r,r]) circle(r=r, $fn=50);
			translate([r,w-r]) circle(r=r, $fn=50);
			translate([h-r,r]) circle(r=r, $fn=50);
			translate([h-r,w-r]) circle(r=r, $fn=50);
			translate([0,r]) square([h,w-(r*2)]);	
			translate([r,0]) square([h-(r*2),w]);
		}	
	}
	
	module mount()
	{
        union() {
           translate([0, 0, H-15-thick]) linear_extrude(height=thick) circle(r=mount/2, $fn=100);
           translate([0, 0, H-15]) M6_tube(D=mount, windings=16);
        }
	}

	difference()
	{	
	    linear_extrude(height=H) roundedsquare(r=thick*2,w=W,h=L);
		translate([thick, thick, thick]) linear_extrude(height=H+2) roundedsquare(r=thick,w=W-thick*2,h=L-thick*2);
    }
    
    translate([mount/2,W/2,0]) mount();
    translate([L-mount/2,W/2,0]) mount();
}

module enclosure_punch(obj, wall, D, horizontal, vertical) {
    L = enclosure_L(obj);
    W = enclosure_W(obj);
    thick = enclosure_thick(obj);
    wall_id = enclosure_wall(wall);
    translates = [ [horizontal, thick+0.5, vertical ],
                   [ -1, W - horizontal, vertical ],
                   [ L-2, horizontal, vertical],
                   [L-horizontal, W+1, vertical] ];
    rotations = [ [90, 0, 0], [0, 90, 0], [0, 90, 0], [90, 0, 0] ];
    translate(translates[wall_id]) rotate(rotations[wall_id])  linear_extrude(height=thick+2) circle(r=D/2, $fn=100) children();
}

enclosure = enclosure_define(L=115, W=78, H=60, thick=1.5);

difference() {
    enclosure_box(enclosure);
    union() {
        enclosure_punch(enclosure, wall="front", D=11.5, horizontal=enclosure_L(enclosure) / 2, vertical=enclosure_H(enclosure) / 2);
        enclosure_punch(enclosure, wall="left", D=14, horizontal=18, vertical=40);
        enclosure_punch(enclosure, wall="right", D=14, horizontal=60, vertical=40);
    }
}
