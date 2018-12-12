include <utils_threads.scad>

function flatten(V) = [ for (a = V) for (b = a) b ];

module rounded_square(size, r=1, center=false) {
    x=size[0];
    y=size[1];
    translate([center ? -size[0]/2 : 0, center ? -size[1]/2 : 0]) union() {
	translate([r,r]) circle(r=r, $fn=50);
	translate([r,y-r]) circle(r=r, $fn=50);
	translate([x-r,r]) circle(r=r, $fn=50);
	translate([x-r,y-r]) circle(r=r, $fn=50);
	translate([0,r]) square([x,y-(r*2)]);
	translate([r,0]) square([x-(r*2),y]);
    }
}

module rounded_cube(size, r=1, center=false) {
    translate([0, 0, center ? -size[2]/2 : 0]) linear_extrude(height=size[2]) rounded_square(size=size, r=r, center=center);
}

module tapered_cylinder(d0, d1, h, steps=20) {
    linear_extrude(height=h, scale=d1/d0) circle(d=d0);
}

module hollow_cone(d1, d2, h, wall = 2) {
    difference() {
	cylinder(d1=d1, d2=d2, h);
	cylinder(d1=d1 - wall*2, d2 = d2 - wall*2, h);
    }
}

function dovetail_width(w, h, angle=8)  = w + triangle_opp_length_angle_adj(angle=angle, adj=h)*2;

module dovetail(w, h, len = 10, angle=8) {
    d =  triangle_opp_length_angle_adj(angle=angle, adj=h);
    linear_extrude(height = len) polygon([
	[-w/2, 0],
	[-(w/2 + d), h],
	[w/2 + d, h],
	[w/2, 0]
    ]);
}

function inch_to_mm(inch) = inch * 25.4;
function mm_to_inch(mm) = mm / 25.4;

module point(p, d=0.01) {
    if (len(p) == 2) {
        translate(p) square([d,d]);
    }
    if (len(p) == 3) {
        translate(p) cube([d,d,d]);
    }
}

function rotate_around(angle, point2d, origin = [0, 0]) =
   [ cos(angle) * (point2d[0] - origin[0]) - sin(angle) * (point2d[1] - origin[1]),
     sin(angle) * (point2d[0] - origin[0]) + cos(angle) * (point2d[1] - origin[1]) ];


function hyp_of(x, y) = sqrt(x*x + y*y);

function triangle_angle_adj_hyp(adj, hyp) = acos(adj / hyp);
function triangle_angle_opp_hyp(opp, hyp) = asin(opp / hyp);
function triangle_angle_opp_adj(opp, adj) = atan(opp / adj);

function triangle_hyp_length_angle_adj(angle, adj) = adj / cos(angle);
function triangle_hyp_length_angle_opp(angle, opp) = opp / sin(angle);
function triangle_opp_length_angle_hyp(angle, hyp) = hyp * sin(angle);
function triangle_opp_length_angle_adj(angle, adj) = adj * tan(angle);
function triangle_adj_length_angle_hyp(angle, hyp) = hyp * cos(angle);
function triangle_adj_length_angle_opp(angle, opp) = opp / tan(angle);

function triangle_side_length(hyp, side) = sqrt(hyp*hyp - side*side);
