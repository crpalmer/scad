include <utils.scad>

top=[100, 100, 200];
bottom=[60, 60, 20];
thick=2;

module render_bottom()
{
    first = [ (top[0] - bottom[0]) / 2, (top[1] - bottom[1]) / 2, 0];
    
    outer_bottom = [first, first + [bottom[0], 0, 0], first + [bottom[0], bottom[1], 0], first + [0, bottom[1], 0]];
    points = [
        outer_bottom,
        [0, 0, bottom[2]], [top[0], 0, bottom[2]], [top[0], top[1], bottom[2]], [0, top[1], bottom[2]]
    ];
    faces = [ [0, 1, 5, 4], [1, 2, 6, 5], [2, 3, 7, 6], [3, 0, 4, 7] ];
    polyhedron(points=points, faces=faces);
}

difference() {
    render_bottom(0);
    // translate([thick, thick, 0]) render_bottom(bottom - [thick*2, thick*2, 0]);
}

difference() {
    translate([0, 0, bottom[2]]) cube(size=top);
    translate([thick, thick, bottom[2]]) cube(size=top - [thick*2, thick*2, 0]);
}
