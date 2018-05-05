include <utils.scad>

$fn = 128;

arm_d = 30;
arm_l = 80;

end_d = 50;
end_l = 5;


mount = [10, arm_d, 75];

module arm() {
    translate([0.01, 0, 0]) difference() {
        translate([0, 0, arm_d/4]) rotate([0, -90, 0]) union() {
            cylinder(d=end_d, h=end_l);
            translate([0, 0, end_l]) cylinder(d=arm_d, h=arm_l);
            translate([0, 0, arm_l+end_l]) cylinder(d=end_d, h=end_l);
        }
        translate([-arm_l*2, -arm_d*2, -arm_d]) cube([arm_l*4, arm_d*4, arm_d]);
    }
}

module bracket() {
    translate([0, -mount[1]/2, 0]) cube(mount - [0, 0, mount[1]/2]);
    translate([0, 0, mount[2] - mount[1]/2]) rotate([0, 90, 0]) cylinder(d=mount[1], h=mount[0]);
}

module t_insert(mm=5.9, len = arm_d) {
    translate([mount[0], -mm/2, 0]) cube([8, mm, len]);
}

module screw_hole(d = M3_through_hole_d()) {
    translate([-0.01, 0, mount[2] - d*5]) rotate([0, 90, 0]) union() {
        cylinder(d=d, h=100);
        cylinder(d=d*3, h=mount[0]-2);
    }
}

difference() {
    union() {
        arm();
        bracket();
        t_insert();
    }
    screw_hole();
}
