$fn=100;

hole_d=4;
hole_h=10;
T=4;

module arm() {
    difference() {
        union() {
            cube([hole_d*3, hole_d*1.5 + hole_h, T]);
            translate([hole_d*1.5, hole_h + hole_d*1.5, 0]) cylinder(d=hole_d*3, h=T);
        }
        translate([hole_d*1.5, hole_h + hole_d*1.5, 0]) cylinder(d=hole_d, h=T);
    }
}

union() {
    translate([0, T/2, 0]) rotate([90, 0, 0]) arm();
    translate([0, 0, T]) rotate([0, 90, 0]) linear_extrude(hole_d*3) polygon([ [0, -1.5*T], [-T, -T*.5], [-T, T*.5], [0, 1.5*T], [0, -1.5*T] ]);
    difference() {
        base=[hole_d*3, (hole_d*3+T)*2, T];
        translate([0, -base[1]/2, 0]) cube(base);
        translate([base[0]/2, base[1]/2 - T - hole_d/2, 0]) cylinder(d=hole_d, h=T);
        translate([base[0]/2, -(base[1]/2 - T - hole_d/2), 0]) cylinder(d=hole_d, h=T);
    }
}
