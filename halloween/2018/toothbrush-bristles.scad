include <high-detail.scad>

num = [ 1, 3, 5, 5, 5, 7, 7, 7, 9, 9, 7, 7, 5 ];

spacing = 8;
height = 45;
d=4.25;
base_height = 1;

module bristles2d() {
    for (i = [0:len(num)-1]) {
        n = num[i];
        translate([-floor(n/2) * spacing, i * spacing, 0]) for (j = [0:n-1]) {
            translate([spacing*j, 0, 0]) circle(d=d);
        }
    }
}

linear_extrude(height=base_height) offset(r = 2) hull()
    bristles2d();

translate([0, 0, base_height]) linear_extrude(height = height - base_height) bristles2d();
