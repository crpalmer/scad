include <utils.scad>

top=[20, 20, 20];
bottom=[10, 10, 5];
thick=1;

first = [ (top[0] - bottom[0]) / 2, (top[1] - bottom[1]) / 2, 0];

offset = [ [thick, thick, 0], [-thick, thick, 0], [-thick, -thick, 0], [thick, -thick, 0] ];
outer_bottom = [first, first + [bottom[0], 0, 0], first + [bottom[0], bottom[1], 0], first + [0, bottom[1], 0]];
outer_mid = [ [0, 0, bottom[2]], [top[0], 0, bottom[2]], [top[0], top[1], bottom[2]], [0, top[1], bottom[2]] ];
outer_top = [ [0, 0, top[2]], [top[1], 0, top[2]], top, [0, top[1], top[2]] ];

function this_side(side) = side*6;
function next_side(side) = (side < 3 ? side + 1 : 0) * 6;

function faces_of_side(side) = [];

points = flatten([ 
    for (side = [0:3]) 
       [ outer_bottom[side], outer_bottom[side] + offset[side], outer_mid[side] + offset[side], outer_mid[side], outer_top[side], outer_top[side] + offset[side] ]
]);

faces = flatten([
    for (side = [0:3])
        [
            [this_side(side),    next_side(side),   next_side(side)+1, this_side(side)+1],   // base
            [this_side(side)+1, next_side(side)+1, next_side(side)+2, this_side(side)+2],   // inner lower wall
            [this_side(side),    next_side(side),   next_side(side)+3, this_side(side)+3],   // outer lower wall
            [this_side(side)+2, next_side(side)+2, next_side(side)+5, this_side(side)+5],   // inner upper wall
            [this_side(side)+3, next_side(side)+3, next_side(side)+4, this_side(side)+4],   // outer upper wall
            [this_side(side)+4, next_side(side)+4, next_side(side)+5, this_side(side)+5],   // top
        ]
]);
    
echo(faces);

polyhedron(points=points, faces=faces);
