scale=.75;
d=115 * scale;
h=120 * scale;
bh=12 * scale;
gap=1;
thick=1.25;
b_thick=1;
extruder=0.3;
reduction=0.6;

D=d-gap*2;

union() {
    translate([0,0,bh]) difference() {
        cylinder(d=D, h=h-gap*2, $fn=6);
        cylinder(d=D-thick*2, h = h - gap*2, $fn=6);
    }
    for (i = [extruder:extruder:bh]) translate([0,0,bh-i]) difference() {
        cylinder(d=D-i/extruder*reduction, h=extruder, $fn=6);
        cylinder(d=D-i/extruder*reduction-thick*2, h = extruder, $fn=6);
    }
    difference() {
        union() {
            cylinder(d=D-bh/extruder*reduction, h=b_thick, $fn=6);
            translate([0, 0, 1]) cube(size=[32, 32, 2], center=true);
        }
        translate([0,0,1]) cube(size=[30,30,2], center=true);
    }
}