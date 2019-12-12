// Workflow:
// * generate the STL file
// * load it in slic3r for TLM (a delta printer with center at 0,0)
// * change any rotation that you need to change
// * save that stl to generate a clean and centered stl
// * run it through this

include <high-detail.scad>

// Dimensions of your STL object
//w = 101.48;	// Measured along X axis
//d = 69.37;	// Measured along Y axis
//h = 30.65;	// Measured along Z axis
//z_offset = -1.75; // 5;
w = 119.25;
d = 71.56;
h = 21.81;
z_offset = -2.1;

translation = [ 0, 5, -2.1 ];
rotation = [ 0, 0, 0];

// STL file and transformation variables
fname = "d:/temp/greenie med 50pct settled.stl";
//fname = "d:/temp/3DBenchy.stl";
//fname = "";

// What to generate
style = "square";
what = "single";

is_single = what == "single";

// Mold-related variables
width_margin = (is_single ? 4 : 10);		// Margin along X axis
depth_margin = (is_single ? 4 : 10);		// Margin along Y axis
height_margin = (is_single ? 1 : 5);		// Margin along Z axis

// Pour hole variables
pour_hole_top = false;
pour_hole_translate = [-15, 10,0];
pour_hole_d1 = 20;
pour_hole_d2 = 4;
pour_hole_height = depth_margin+50;

// Keys
dot_d = 5;
cube_d = dot_d;

box=[w+width_margin*2, d+depth_margin*2];
keys=[box[0]/2 - width_margin/2, box[1]/2 - height_margin/2];

if (what == "top") {
    top_half();
}

if (what == "bottom") {
    bottom_half();
}

if (what == "both") {
    offset = w/2+width_margin + 2;
    translate([-offset, 0, 0]) top_half();
    translate([offset, 0, 0]) bottom_half();
}

if (what == "single") {
    translate([0, 0, h(true)]) rotate([0, 180, 0]) single_part();
}

if (what == "stl") {
    stl();
}

module stl() {
    if (fname != "") {
        translate(translation) rotate(rotation) import(fname);
    }
}
function h(is_top) = what == "single" ? (h + height_margin) : (h/2+height_margin + z_offset * (is_top ? +1 : -1));

module mold_body(is_top) {
    if (style == "square") {
        translate([-box[0]/2, -box[1]/2, 0]) cube([box[0], box[1], h(is_top)]);
    } else {
        d = min(box[0], box[1]);
        linear_extrude(height=h(is_top)) scale([box[0]/d, box[1]/d]) circle(d=d);
    }
}

module reference_cube(is_top) {
    this_d = cube_d + (is_top ? 0 : 0.25);
    this_h = cube_d / 2 + (is_top ? 0 : 0.25);
    translate([0, -keys[1], h(is_top)]) cube([this_d, this_d, this_h], center=true);
}

module reference_dots(is_top) {
    this_d = dot_d + (is_top ? 0 : 0.1);
    for (xy = [ [0, 1], [1, 0], [-1, 0] ]) {
        translate([keys[0]*xy[0], keys[1]*xy[1], h(is_top)])
            sphere(d=this_d);
    }
}

module pour_hole() {
    translate(pour_hole_translate) union() {
        cylinder(h=height_margin, d1 = pour_hole_d1, d2 = pour_hole_d2);
        translate([0, 0, height_margin]) cylinder(h=pour_hole_height - height_margin, d = pour_hole_d2);
    }
}

module top_half() {
    difference() {
        union() {
            mold_body(true);
            reference_cube(true);
        }

        reference_dots(true);

        if (pour_hole_top) {
            pour_hole();
        }
        
        translate([0, 0, h+height_margin]) rotate([0, 180, 0]) stl();
    }
}

module bottom_half() {
    box_h = h/2+height_margin + z_offset;

    difference() {
        union() {
            mold_body(false);
            reference_dots(false);
        }
        reference_cube(false);
        
        if (! pour_hole_top) {
            pour_hole();
        }

        translate([0, 0, height_margin]) stl();
    }
}

module single_part() {
    difference() {
        mold_body(true);
        stl();
    }
}
