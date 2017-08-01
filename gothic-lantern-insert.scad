include <utils.scad>

top=[20, 20, 20];
bottom=[10, 10, 5];
thick=1;

first = [ (top[0] - bottom[0]) / 2, (top[1] - bottom[1]) / 2, 0];

outer_bottom = [first, first + [bottom[0], 0, 0], first + [bottom[0], bottom[1], 0], first + [0, bottom[1], 0]];
outer_mid = [ [0, 0, bottom[2]], [top[0], 0, bottom[2]], [top[0], top[1], bottom[2]], [0, top[1], bottom[2]] ];
outer_top = [ [0, 0, top[2]], [top[1], 0, top[2]], top, [0, top[1], top[2]] ];

points = [
    outer_bottom[0], outer_bottom[1], outer_bottom[2], outer_bottom[3],
    outer_bottom[0] + [thick, thick, 0], outer_bottom[1] + [-2*thick, thick, 0], outer_bottom[2] + [-2*thick, -2*thick, 0], outer_bottom[3] + [thick, -2*thick, 0],
    outer_mid[0], outer_mid[1], outer_mid[2], outer_mid[3],
    outer_mid[0] + [thick, thick, 0], outer_mid[1] + [-2*thick, thick, 0], outer_mid[2] + [-2*thick, -2*thick, 0], outer_mid[3] + [thick, -2*thick, 0],
    outer_top[0], outer_top[1], outer_top[2], outer_top[3],
    outer_top[0] + [thick, thick, 0], outer_top[1] + [-2*thick, thick, 0], outer_top[2] + [-2*thick, -2*thick, 0], outer_top[3] + [thick, -2*thick, 0]    
];

faces = [ 
    [0, 1, 5, 4], [4, 5, 13, 12], [0, 4, 12, 8], [ 1, 5, 13, 9], [8, 9, 13, 12],
    [1, 2, 6, 5], [5, 6, 14, 13], [1, 5, 13, 9], [ 2, 6, 14, 10], [9, 10, 14, 13],
    [2, 3, 7, 6], [6, 7, 15, 14], [2, 6, 14, 10], [3, 7, 15, 11], [10, 11, 15, 14],
    [3, 0, 4, 0], [7, 4, 12, 15], [3, 7, 15, 11], [0, 4, 12, 8], [11, 8, 12, 15],
    [8, 9, 13, 12], [12, 13, 21, 20], [8, 12, 20, 16], [ 9, 13, 21, 17], [16, 17, 21, 20],
    [9, 10, 14, 13], [13, 14, 22, 21], [9, 13, 21, 17], [10, 14, 22, 18], [17, 18, 22, 21],
    [10, 11, 15, 14], [14, 15, 23, 22], [10, 14, 22, 18], [11, 15, 23, 19], [18, 19, 23, 22],
    [11, 8, 12, 15], [15, 12, 20, 23], [11, 15, 23, 19], [12, 12, 20, 20], [19, 20, 20, 23]

];
polyhedron(points=points, faces=faces);
