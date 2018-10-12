include <pvc.scad>

$fa = 1;
$fs = .6;

angle=90-48.2;
wall=4;
od=pvc_od_1in();
mount_d=od + wall*2;
screw_d = No8_through_hole_d();
base_d = mount_d + screw_d + 20*2;
base_screw_radius = mount_d/2 + screw_d/2 + 10;
holder_h = 40;
holder_offset = 20;

module base() {
    rotate([-angle, 0, 0]) cylinder(d = base_d, h = wall);
}

module oversized_cutoff() {
    cutoff=50;
    rotate([-angle, 0, 0]) translate([0, 0, -wall*0 - cutoff]) cylinder(d = base_d, h = cutoff);
}

module holder() {
    difference() {
        translate([0, 0, -holder_offset]) pvc_holder(od = od, h = holder_h + holder_offset, wall=wall);
        for (angle = [0, 90]) {
            rotate([0, 0, angle]) translate([-50, 0, holder_h - screw_d/2 - wall*2]) rotate([0, 90, 0]) cylinder(d=screw_d, h=150);
        }
    }
}

module oversized_mount() {
    base();
    holder();
}

module base_screw_holes() {
    for (a = [0, 90, 180]) {
        rotate([-angle, 0, 0]) rotate([0, 0, a]) translate([base_screw_radius, 0, -100]) cylinder(d = screw_d, h=200);
    }
}

rotate([angle, 0, 0])
difference() {
    oversized_mount();
    oversized_cutoff();
    base_screw_holes();
}