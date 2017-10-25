include <utils.scad>
include <utils_threads.scad>

$fn=100;

wall_thickness=2;
tube_d=20;
tube_len=20;
board_h=4;
nut_insert_height=3.25;
screw_d=4;

mounting_len=25;
mounting_w=12.5;
mounting_screw_d=5;
bracket_screw_d=3;
stake_len=inch_to_mm(3);

outer_tube_d = tube_d+wall_thickness*2;
outer_tube_d_top = outer_tube_d*sqrt(2)+wall_thickness*2;
board_w=outer_tube_d_top/sqrt(2);

echo(board_w);

module light_tube_shell() {
    translate([0, 0, 1])
    minkowski() {
        difference() {
            union() {
                cylinder(d=outer_tube_d, h=tube_len*.5);
                translate([0, 0, tube_len*.5]) tapered_cylinder(d0=outer_tube_d, d1=outer_tube_d_top, h=tube_len*.5);
                translate([-board_w/2, -board_w/2, tube_len]) cube([board_w, board_w, board_h+wall_thickness]);
            };
            // Trim the tube to the square top
            translate([board_w/2, -outer_tube_d, 0]) cube([board_w, outer_tube_d*2, tube_len]);
            translate([-board_w/2-board_w, -outer_tube_d, 0]) cube([board_w, outer_tube_d*2, tube_len]);
            translate([-outer_tube_d, board_w/2, 0]) cube([outer_tube_d*2, board_w, tube_len]);
            translate([-outer_tube_d, -board_w/2-board_w, 0]) cube([outer_tube_d*2, board_w, tube_len]);
        };
        sphere([1, 1, 1]);
    };
}

function light_tube_attachment_w() = nut_insert_height+wall_thickness;;
function light_tube_attachment_h() = light_tube_attachment_w()*1.5;

module light_tube_attachment_body() {
    w=light_tube_attachment_w();
    h=light_tube_attachment_h();
    steps=h*10;
    delta_x=w/steps;
    delta_z=h/steps;

    translate([1, 0, 0]) minkowski() {
        union() {
            for (i = [0:steps-1])
                translate([0, 0, delta_z*i])
                    cube([delta_x*(i+1), mounting_w, delta_z]);
            translate([0, 0, h])
                cube([w, mounting_w, nut_insert_height*3.5]);
        };
        sphere([1,1,1]);
    };
}

module light_tube_attachment() {
    w=light_tube_attachment_w();
    h=light_tube_attachment_h();

    difference() {
        light_tube_attachment_body();
        translate([0, mounting_w/2, h+nut_insert_height*2])
            rotate([0, 90, 0]) No6_nut_insert_cutout(h=nut_insert_height);
        translate([0, mounting_w/2, h+nut_insert_height*2])
            rotate([0, 90, 0]) cylinder(d=screw_d, h=w*10);
    };
}

module light_tube() {
    difference() {
            union() {
                light_tube_shell();
                translate([board_w/2-wall_thickness, -mounting_w/2, tube_len+board_h+wall_thickness-light_tube_attachment_h()]) light_tube_attachment();
            };
            cylinder(d=tube_d, h=tube_len);
            translate([-board_w/2+wall_thickness, -board_w/2+wall_thickness, tube_len]) cube([board_w-wall_thickness*2, board_w-wall_thickness*2, board_h*2]);
    };
}

module mounting_arm(mounting_len=mounting_len, mounting_h=wall_thickness) {
    union() {
        cube([mounting_w, mounting_len+wall_thickness, wall_thickness]);
        translate([mounting_w/2, mounting_len+wall_thickness, 0]) cylinder(d=mounting_w, h=mounting_h);
    }
}

module mounting_hole() {
    translate([mounting_w/2, mounting_len+wall_thickness, -wall_thickness]) cylinder(d=screw_d, h=wall_thickness*3);
}

module mounting_bracket(mounting_screw_d=mounting_screw_d, mounting_len=mounting_len, arm_len=mounting_len) {
    difference() {
        minkowski() {
            union() {
                cube([mounting_len+wall_thickness, mounting_w, wall_thickness]);
                cube([wall_thickness, mounting_w, arm_len+wall_thickness]);
                if (arm_len > 0) ranslate([0, mounting_w/2, arm_len+wall_thickness]) rotate([0, 90, 0]) cylinder(d=mounting_w, h=wall_thickness);
            };
            sphere([1,1,1]);
        };
        translate([(mounting_len+wall_thickness)/8*3, mounting_w/2, -wall_thickness]) cylinder(d=mounting_screw_d, h=wall_thickness*3);
        translate([(mounting_len+wall_thickness)/8*6, mounting_w/2, -wall_thickness]) cylinder(d=mounting_screw_d, h=wall_thickness*3);
        if (arm_len > 0) translate([-wall_thickness, mounting_w/2, arm_len+wall_thickness]) rotate([0, 90, 0]) cylinder(d=screw_d, h=wall_thickness*3);
    };
}

module drill_guide(mounting_screw_d=mounting_screw_d) {
    mounting_bracket(mounting_screw_d, arm_len = 0);
}

module mounting_stake() {
    difference() {
        minkowski() {
            union() {
                mounting_arm();
                linear_extrude(height=wall_thickness) polygon([[0, 0], [mounting_w, 0], [mounting_w/2, -stake_len], [0, 0]]);
            };
            sphere([1,1,1]);
        };
        mounting_hole();
    };
}

module cross_arm() {
    difference() {
        minkowski() {
            union() {
                mounting_arm(mounting_len = mounting_len + mounting_w, mounting_h=wall_thickness + nut_insert_height);
                rotate([90, 0, 90]) mounting_arm();
            }
            sphere([1,1,1]);
        }
        translate([0, mounting_w, 0]) mounting_hole();
        translate([mounting_w, 0, 0]) rotate([0, -90, -90]) mounting_hole();
        translate([mounting_w/2, mounting_w+mounting_len+wall_thickness, nut_insert_height]) No6_nut_insert_cutout(h=nut_insert_height);
    }
}

//light_tube();
//mounting_bracket();
//mounting_bracket(M3_tapping_hole_d());
drill_guide(M3_tapping_hole_d());
//mounting_stake();
//cross_arm();
