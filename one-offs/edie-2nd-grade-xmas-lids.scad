include <high-detail.scad>

lid_h = 35;
side_w = 2;
glue_d = 20;
top_h = 2;
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
    difference() {
        union() {
            cylinder(d = gasket_d - tolerance*2, h = h);
            translate([0, 0, h]) cylinder(d = bottle_d - tolerance, h = lid_h - h);
        }
        cylinder(d = gasket_d - tolerance*2 - side_w * 2, h = lid_h - top_h);
    }
    cylinder(d = glue_d, h = lid_h);
}

//rotate([0, 180, 0]) locator_ring();
rotate([0, 180, 0]) plate();





