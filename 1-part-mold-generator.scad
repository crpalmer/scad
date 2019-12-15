// Workflow:
// * generate the STL file
// * use 3d builder to orient it correctly, add any bolt holes, etc. that you want to it and save it
// * get the height by loading it into kisslicer
// * generate the mold blank with this script
// * load the mold blank into 3d builder (with the original object)
// * lower the original object a tiny bit (e.g. 0.01 mm) and subtract it from the mold

include <high-detail.scad>

h = 0.5 + 19.61 ;
translation = [ 0, 0, 0 ];
rotation = [ 0, 0, 0];
shape_fname = "d:/temp/crimp sloper textured.stl";

// Mold-related variables
wall = 1.2;
do_hull = true;

linear_extrude(height = h) 
    offset(wall)
    conditional_hull()
    projection()
    rotate(rotation)
        import(shape_fname);

module conditional_hull() {
    if (do_hull) {
        hull() children();
    } else {
        children();
    }
}
