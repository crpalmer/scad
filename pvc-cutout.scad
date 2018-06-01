include <utils.scad>

$fn=64;

H=50;
D=33.5; // 1" pvc + 0.1mm

union() {
    cylinder(d=D, h=H);
    translate([0, 0, H]) tapered_cylinder(d0=D, d1=1, h=D/4);
}
