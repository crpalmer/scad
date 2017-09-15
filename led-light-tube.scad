include <utils.scad>

$fn=20;

wall_thickness=2;
tube_d=20;
tube_len=20;
board_h=8;
position_screw_d=3;
mounting_len=20;
bracket_screw_d=3;
bracket_len=20;

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
    
module light_tube() {
    difference() {
        light_tube_shell();
        cylinder(d=tube_d, h=tube_len);
        translate([-board_w/2+wall_thickness, -board_w/2+wall_thickness, tube_len]) cube([board_w-wall_thickness*2, board_w-wall_thickness*2, board_h*2]);
    };
}

module light_tube_bottom() {
    w=board_w-wall_thickness*2;
    difference() {
        union() {
            cube([w, w, wall_thickness]);
            translate([w/2-wall_thickness/2, wall_thickness, 0])
                cube([wall_thickness, w, mounting_len]);
        };
        translate([mounting_len/2, outer_tube_d/2, mounting_len/3*2]) rotate([0,90,0])
            cylinder(r=position_screw_d/2, h=wall_thickness*10, center=true);
        translate([10, 10, 0]) cylinder(d=5, h=wall_thickness);
    };
}

module mounting_bracket() {
    union() {
        difference() {
            cube([mounting_len, outer_tube_d, wall_thickness]);
            translate([mounting_len/3*2, outer_tube_d/4, 0]) cylinder(r=bracket_screw_d/2, h=wall_thickness);
            translate([mounting_len/3*2, outer_tube_d/4*3, 0]) cylinder(r=bracket_screw_d/2, h=wall_thickness);
        };
        difference() {
            cube([wall_thickness, outer_tube_d, mounting_len+bracket_len]);
            translate([0, outer_tube_d/2, mounting_len+bracket_len/2]) rotate([0, 90, 0]) cylinder(r=position_screw_d/2, h=wall_thickness*10);
            translate([0, outer_tube_d/4, mounting_len/2+wall_thickness]) rotate([0, 90, 0]) cylinder(r=bracket_screw_d/2, h=wall_thickness);
            translate([0, outer_tube_d/4*3, mounting_len/2+wall_thickness]) rotate([0, 90, 0]) cylinder(r=bracket_screw_d/2, h=wall_thickness);
        };
    };
}

light_tube();
//light_tube_bottom();
//mounting_bracket();