include <utils.scad>

$fn=20;

wall_thickness=2;
tube_d=20;
tube_len=20;
board_h=4;
nut_insert_height=5;
screw_d=4;

mounting_len=50;
mounting_width=25;
bracket_screw_d=3;


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

module nut_insert_cutout() {
    minkowski() {
        cylinder(d=8.8, h=nut_insert_height-wall_thickness, $fn=6);
        cylinder(r=0.2, h=wall_thickness);
    };
}

module nut_insert() {
    difference() {
        minkowski() {
            cylinder(d=8.8, h=nut_insert_height-wall_thickness, $fn=6);
            cylinder(r=wall_thickness, h=wall_thickness);
        };
        nut_insert_cutout();
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
            rotate([0, 90, 0]) nut_insert_cutout();
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

module mounting_bracket() {
    difference() {
        minkowski() {
            union() {
                cube([mounting_len+wall_thickness, mounting_width, wall_thickness]);
                cube([wall_thickness, mounting_width, mounting_len+wall_thickness]);
                translate([0, mounting_width/2, mounting_len+wall_thickness]) rotate([0, 90, 0]) cylinder(d=mounting_width, h=wall_thickness);
            };
            sphere([1,1,1]);
        };
        translate([(mounting_len+wall_thickness)/3*2, mounting_width/4, -wall_thickness]) cylinder(d=screw_d, h=wall_thickness*3);
        translate([(mounting_len+wall_thickness)/3*2, mounting_width/4*3, -wall_thickness]) cylinder(d=screw_d, h=wall_thickness*3);
        translate([-wall_thickness, mounting_width/2, mounting_len+wall_thickness]) rotate([0, 90, 0]) cylinder(d=screw_d, h=wall_thickness*3);
    };
}
//light_tube();
mounting_bracket();
