union() {
    translate([-11.5, 8.5, 0]) 
        difference() {
            cube([23, 12, 23]);
            translate([2, 2, 0]) cube([19, 10, 23]);
        }
    cylinder(d=17, h=23, $fn=100);
    translate([-8.5, 0, 0]) cube([17, 8.5, 23]);
}