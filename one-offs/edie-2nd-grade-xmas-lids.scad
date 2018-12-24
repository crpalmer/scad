include <high-detail.scad>

lid_h = 35;
thread_d = 66.5;
bottle_d = 59;
gasket_d = 54;
gasket_h = 1.5;
tolerance = 0.8;


module locator_ring() {
    difference() {
        union() {
            translate([0, 0, gasket_h]) cylinder(d = thread_d - tolerance, h = tolerance);
            cylinder(d = gasket_d, h = gasket_h + tolerance);
        }
        cylinder(d = gasket_d-tolerance, h = 100);
    }
}

module plate() {
    h = gasket_h + tolerance * 1.5;
    cylinder(d = gasket_d - tolerance*2, h = h);
    translate([0, 0, h]) cylinder(d = bottle_d - tolerance, h = lid_h - h);
}

//rotate([0, 180, 0]) locator_ring();
rotate([0, 180, 0]) plate();