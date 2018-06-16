H=23;

union() {
    cylinder(d=17, h=23, $fn=100);
    translate([-8.5, 0, 0]) cube([17, 8.5, H]);
    translate([-9.5, 8.5, 0]) cube([19.5, 2, H]);
    translate([-9.5, 9.5, 0]) rotate([0, 0, 6.1]) cube([2, 15, H]);
    translate([8, 9.5, 0]) rotate([0, 0, -6.1]) cube([2, 15, H]);
}