include <utils.scad>
include <v-slot.scad>

$fn = 128;

arm_d = 30;
arm_l = 80;

end_d = 50;
end_l = 5;


mount = [10, 39, arm_d];
extension = [ 10, 120, arm_d ];

module cut_tube(d, w, pct = .75, angle=90) {
    big = (d+w)*2;
    difference() {
        translate([0, 0, d*(1-pct)]) rotate([0, angle, 0]) cylinder(d = d, h = w);
        translate([-big, -big, -big]) cube([big*2, big*2, big]);
    }
}
        
module arm() {
    translate([0.01, 0, 0]) union() {
        cut_tube(d = end_d, w = end_l, angle = -90);
        translate([-end_l, 0, 0]) cut_tube(d = arm_d, w = arm_l, angle = -90);
        translate([-end_l-arm_l, 0, 0]) cut_tube(d = end_d, w = end_l, angle = -90);
    }
}

t_insert_mm = 6.5;
t_insert_mid = mount[1]/2 - 7 - t_insert_mm/2;

module t_insert(mm=t_insert_mm, len = arm_d) {
    translate([mount[0], t_insert_mid - mm / 2, 0]) cube([5, mm, len]);
}

module bracket_extension(extension=extension) {
    cube(extension);
    translate([0, extension[1], 0]) cut_tube(d = end_d, w = extension[0]);
}

module bracket_body() {
    translate([0, -mount[1]/2, 0]) cube(mount);
    t_insert();
    bracket_extension();
}

module screw_hole(d = M3_through_hole_d()) {
    translate([-0.01, t_insert_mid - 20, mount[2]/2]) rotate([0, 90, 0]) union() {
        cylinder(d=d, h=100);
        cylinder(d=d*3, h=mount[0]-2);
    }
}

module bracket() {
    translate([0, -extension[1], 0]) difference() {
        bracket_body();
        screw_hole();
    }
}

module dual_bracket(extension = [ extension[0], 30, extension[2] ]) {
    difference() {
        union() {
            translate([0, -extension[1]-end_d/2, 0]) cube([extension[0], extension[1]*2+end_d, extension[2]]);
            cut_tube(d = end_d, w = extension[0]);
            translate([extension[0]+1.9, end_d/2, extension[2]/2]) rotate([90, 0, 0]) mirror([1, 0, 0])  vslot_insert(length = end_d);
        }
        translate([50, end_d/2 + extension[1]/2, extension[2]/2]) rotate([0, -90, 0]) cylinder(d = M5_through_hole_d(), h=100);
        translate([50, -(end_d/2 + extension[1]/2), extension[2]/2]) rotate([0, -90, 0]) cylinder(d = M5_through_hole_d(), h=100);
    }
}

module right_hang() {
    arm();
    bracket();
}

module center_hang() {
    arm();
    dual_bracket();
}

module left_hang() {
    rotate([0, 180, 0]) mirror([0, 0, 1]) right_hang();
}

module taz() {
    difference() {
        union() {
            arm();
            translate([-4, -10, 0]) cube([4, 20, 60]);
            translate([0, -(5-.1)/2, 0]) cube([5, 5-.1, arm_d]);
        }
        translate([0, 0, 50]) rotate([0, -90, 0]) cylinder(d=M3_through_hole_d(), h=100);
    }
}

module wall_mount() {
    mount = [8, 100, 30];
    difference() {
        union() {
            arm();
            translate([-4, -mount[1]/2, 0]) rounded_cube(mount);
        }
        translate([mount[0], -mount[1]/2 + 10, mount[2]/2]) rotate([0, -90, 0]) cylinder(d = 8, h = 100);
        translate([mount[0], mount[1]/2 - 10, mount[2]/2]) rotate([0, -90, 0]) cylinder(d = 8, h = 100);
    }
}

//right_hang();
center_hang();
//left_hang();
//taz();
//wall_mount();