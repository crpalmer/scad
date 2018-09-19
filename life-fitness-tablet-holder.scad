h=40;
id=39;
cutout_w=10;
tablet_d=8;
tablet_h=20;
wall=2;

$fa=1;
$fs=0.6;

union() {
    difference() {
        cylinder(d=id+wall*2, h=h);
        cylinder(d=id, h=h);
        translate([-cutout_w/2, -id/2-wall, 0]) cube([cutout_w, id/2, h]);
    }
    translate([-tablet_d/2-wall, id/2, 0]) difference() {
        cube([tablet_d+wall*2, tablet_h+wall, h]);
        translate([wall, wall, 0]) cube([tablet_d, tablet_h, h]);
    }
}

        
        