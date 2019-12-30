// Workflow:
// * generate the STL file
// * use 3d builder to orient it correctly, add any bolt holes, etc. that you want to it and save it
// * get the height by loading it into kisslicer
// * generate the mold blank with this script
// * load the mold blank into 3d builder (with the original object)
// * lower the original object a tiny bit (e.g. 0.01 mm) and subtract it from the mold

include <high-detail.scad>
include <molds.scad>

1_part_mold_form(h = 0.5 + 46.8, wall=1.2, hull=true)
    rotate([0, 0, 0]) import("d:/temp/bear paw hold textured.stl");
