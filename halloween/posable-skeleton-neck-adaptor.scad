include <pvc.scad>

//$fa = 1;
//$fs = 0.6;

wall=2;
//od=pvc_od_1in();
od=pvc_od_3_4in();
h=20;
gap_d=34;
gap_h=8;
screw_d = No8_through_hole_d();

module scan() {
    translate([-23.5, -29.5, 0]) import("stl/posable-skeleton-neck-low-cut-reduced.stl");
}

module gap() {
    cur_d = od + wall*2;
    gap_fill = cur_d < gap_d ? gap_d - cur_d : 0;
    gap_fill_h = (gap_d - cur_d) / 2;
    cylinder(d1=cur_d, d2=gap_d, h=gap_fill_h);
    translate([0, 0, gap_fill_h]) linear_extrude(height = gap_h - gap_fill_h) projection() scan();
}

module adaptor_body() {
    translate([0, 0, h+gap_h]) scan();
    translate([0, 0, h]) gap();
    pvc_tapered_holder(od = od, wall = wall, h = h, d2=gap_h*2);
}

module scan_post_hole() {
    post_h = 9;
    post_d = 10;
    translate([-od, 0, h+gap_h+post_h]) rotate([0, 90, 0]) cylinder(d=post_d, h=od*2);
}

module screw_holes() {
    for (angle = [0, 90]) {
        rotate([0, 0, angle]) translate([-od, 0, h/4+screw_d/2]) rotate([0, 90, 0]) cylinder(d = screw_d, h = od*2);
    }
}

difference() {
    adaptor_body();
    screw_holes();
    scan_post_hole();
}