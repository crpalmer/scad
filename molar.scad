module bolt_cutout(d=5, l=15) {
    translate([250, 0, 0]) rotate([0, -90, 0]) union() {
        cylinder(d=d, h=500);
        translate([l, 0, 0]) cylinder(d=d, h=500);
        translate([0, -d/2, 0]) cube([l, d, 500]);
    }
}

module bolt_cutouts() {
    bolt_cutout();
    rotate([0, 0, 90]) bolt_cutout();
}

module void(h=65, w=50) {
    translate([-w/2, -w/2, 0]) cube([w, w, h]);
    translate([0, 0, h]) sphere(d=w);
}

module cutouts() {
    translate([0, 0, 25]) bolt_cutouts();
    void();
}

//difference() {
//    import("stl/tooth-with-base.stl");
    cutouts();
//}