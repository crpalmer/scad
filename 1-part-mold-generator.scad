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
h = 20.27;

translation = [ 0, 0, -2.5 ];
rotation = [ 0, 0, 0];

// STL file and transformation variables
fname = "d:/temp/greenie textured settled cut.stl";

// What to generate
style = "square";

// Mold-related variables
width_margin = 4;		// Margin along X axis
depth_margin = 4;		// Margin along Y axis
height_margin = 2;		// Margin along Z axis

box=[w+width_margin*2, d+depth_margin*2];

translate([0, 0, h()]) rotate([0, 180, 0]) single_part();

module stl() {
    if (fname != "") {
        translate(translation) rotate(rotation) import(fname);
    }
}

function h() = (h + height_margin);

module mold_body() {
    if (style == "square") {
        translate([-box[0]/2, -box[1]/2, 0]) cube([box[0], box[1], h()]);
    } else {
        d = min(box[0], box[1]);
        linear_extrude(height=h()) scale([box[0]/d, box[1]/d]) circle(d=d);
    }
}

module single_part() {
    difference() {
        mold_body();
        stl();
    }
}
