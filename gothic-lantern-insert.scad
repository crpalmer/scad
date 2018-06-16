include <utils.scad>

module generate(top_size, bottom_size) {
    delta_b = [ (top_size[0] - bottom_size[0]) / 2, (top_size[1] - bottom_size[1]) / 2 ];
    delta_t = [ top_size[0]/2, top_size[1]/2 ];
    top_b = 0;
    mid_z = bottom_size[2];
    top_z = bottom_size[2] + top_size[2];

    bottom = [
        [ -delta_b[0], -delta_b[1], top_b],
        [  delta_b[0], -delta_b[1], top_b],
        [  delta_b[0], delta_b[1], top_b],
        [ -delta_b[0], delta_b[1], top_b]
    ];

    top = [
        [ -delta_t[0], -delta_t[1], top_z],
        [  delta_t[0], -delta_t[1], top_z],
        [  delta_t[0], delta_t[1], top_z],
        [ -delta_t[0], delta_t[1], top_z]
    ];

    mid = [ for (t = top) [ t[0], t[1], mid_z ] ];

    function this_side(side) = side*4;
    function next_side(side) = (side < 3 ? side + 1 : 0);

    function faces_of_side(side) = [];

    points = concat(bottom, mid, top);

    faces_bottom = [ 0, 1, 2, 3 ];
    faces_top = [ 8, 9, 10, 11 ];

    faces_lower = [for (side=[0:3]) [side, next_side(side), next_side(side) + 4, side + 4 ]];
    faces_upper = [for (f=faces_lower) f + [4, 4, 4, 4]];

    faces=concat([faces_bottom], [faces_top], faces_lower, faces_upper);
    echo(points);
    echo(faces);
    polyhedron(points=points, faces=faces);
}

top=[20, 20, 20];
bottom=[8, 8, 5];
thick=1;

difference() {
    generate(top_size=top, bottom_size=bottom);
    translate([0, 0, thick]) generate(top_size=top - [thick*2, thick*2, 0], bottom_size=bottom);
}
