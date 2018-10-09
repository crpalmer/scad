include <pvc.scad>

$fa=1;
$fs=0.6;

module v1() {
    wall=2;
    od=pvc_od_1in();
    id=inch_to_mm(0.4);
    slop=1;
    h=inch_to_mm(1.5);
    slop_h = 4;

    difference() {
        cylinder(d=od-slop, h=h);
        translate([0, 0, wall]) cylinder(d=id+slop, h = h -  slop_h - wall);
        translate([0, 0, h - slop_h]) cylinder(d=id, h=slop_h);
        translate([0, 0, h - slop_h]) cylinder(d1=id, d2=id+slop, h=slop);
    }
}


module v2() {
    od=pvc_od_1in();
    rod_d=inch_to_mm(3/8);
    plate_d = od + 50;
    inner_h = 15;
    rod_h = 20;
    wall = 2;
    screw_d = M3_through_hole_d();

    difference() {
        cone_h = (od - (rod_d+wall*2))/2;
        union() {
            cylinder(d = plate_d, h = wall);
            cylinder(d = od, h = wall+inner_h);
            translate([0, 0, wall+inner_h]) hollow_cone(d1=od, d2=rod_d+wall*2, h=cone_h);
            translate([0, 0, wall+inner_h+cone_h]) cylinder(d=rod_d + wall*2, h=rod_h);
        }
        cylinder(d = od - wall*2, h=wall+inner_h);
        cylinder(d = rod_d, h = wall + inner_h + cone_h + rod_h);
        for (angle = [0:90:270]) {
            rotate([0, 0, angle]) translate([plate_d/2 - wall*2 - screw_d/2, 0, 0]) cylinder(d = screw_d, h = wall);
        }
    }
}

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
    cylinder(d = od - wall*2, h=wall+inner_h);
    for (angle = [0:90:270]) {
        rotate([0, 0, angle]) translate([plate_d/2 - wall*2 - screw_d/2, 0, 0]) cylinder(d = screw_d, h = wall);
    }
}
cylinder(d=rod_d, h = wall+inner_h+cone_h);
