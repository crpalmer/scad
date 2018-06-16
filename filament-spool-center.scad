$fn=100;

W=3;
inner_d=54.5;
H=25;

rim_delta_d=20;
inner_inner_d=inner_d-W*2;
rim_d=inner_d + rim_delta_d;
hole_big_d=11;
hole_little_d=8;
hole_center_d=19;

difference() {
    union () {
        cylinder(d=rim_d, h=W);
        difference() {
            cylinder(d=inner_d, h=H);
            cylinder(d=inner_inner_d, h=H);
        }
    }
    cylinder(d=hole_center_d, h=100);
    for (x = [-1, 1]) for (y = [-1, 1]) {
        translate([inner_inner_d/4*x, inner_inner_d/4*y]) cylinder(d=hole_big_d, h=100);
    }
    for (angle=[45, 135, 225, 315]) {
        rotate([0, 0, angle]) translate([inner_inner_d/4, inner_inner_d/4]) cylinder(d=hole_little_d, h=100);
    }
}