include <pvc.scad>

wall=2;

$fa=1;
$fs=0.6;

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

