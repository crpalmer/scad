// Workflow:
// * generate the STL file
// * load it in slic3r for TLM (a delta printer with center at 0,0)
// * change any rotation that you need to change
// * save that stl to generate a clean and centered stl
// * run it through this

include <high-detail.scad>
include <molds.scad>

// for open molds (left/right/box) only size[2] is needed
parting_h = 10;
size = [0, 0, 34.6];

// what to generate
fname = "d:/temp/incut jug.stl";
what = "left";
wall = 1;       // use 5 for a closed mold?
cut_box = [ 400, 400 ];
bounding_box = true;

// Position the object
translation = [ 25, -25, 0 ];
rotation = [ 0, 0, 75];

// Do not change:
function tab(x, y) = [x * (size[0]/2 + wall), y * (size[1]/2 + wall)];
pour_mold_tabs = [ tab(-1, 0), tab(1, 0), tab(0, -1), tab(0, 1) ];
open_mold_tabs = [];

if (what == "top") {
    2_part_mold_bottom(tabs = pour_mold_tabs, parting_h = parting_h) stl();
}

if (what == "bottom") {
    2_part_mold_top(tabs = pour_mold_tabs, obj_h = size[2], parting_h = parting_h) stl();
}

if (what == "pour-box") {
    // todo
    2_part_mold_box(h = size[2] + 1, wall = wall) stl();
}

if (what == "left") {
    2_part_open_mold_left(tabs = open_mold_tabs, h = size[2] + 1, cut_box = cut_box, wall = wall, bounding_box = bounding_box) stl();
}

if (what == "right") {
    2_part_open_mold_right(tabs = open_mold_tabs, h = size[2] + 1, cut_box = cut_box, wall = wall, bounding_box = bounding_box) stl();
}

if (what == "open-box") {
    2_part_open_mold_box(h = size[2] + 1, wall = wall, bounding_box = bounding_box) stl();
}

if (what == "stl") {
    stl();
}

module stl() {
    if (fname != "") {
        translate(translation) rotate(rotation) import(fname);
    }
}