include <pvc.scad>
include <high-detail.scad>

wall = 2;
screw_d = M3_through_hole_d();
od=pvc_od_1in();
rod_d=inch_to_mm(3/8);
plate_d = od + wall*10 + screw_d;
inner_h = inch_to_mm(3/8);

cone_h = (od - (rod_d+wall*2))/2;

difference() {
    union() {
        cylinder(d = plate_d, h = wall);
        cylinder(d = od, h = wall+inner_h);
        translate([0, 0, wall+inner_h]) hollow_cone(d1=od, d2=rod_d+wall*2, h=cone_h);
        translate([0, 0, wall+inner_h+cone_h]) cylinder(d = rod_d + wall*2, h=wall);
    }
    translate([-plate_d, wall*3 + screw_d/2, 0]) cube([plate_d*2, plate_d, wall+inner_h+cone_h]);
    cylinder(d = od - wall*2, h=wall+inner_h);
    for (angle = [0:90:270]) {
        rotate([0, 0, angle]) translate([plate_d/2 - wall*2 - screw_d/2, 0, 0]) cylinder(d = screw_d, h = wall);
    }
}
cylinder(d=rod_d, h = wall+inner_h+cone_h);
