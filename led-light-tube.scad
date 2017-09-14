$fn=100;

wall_thickness=2;
tube_d=8;
tube_len=10;
board_h=4;
position_screw_d=3;
mounting_len=20;
bracket_screw_d=3;
bracket_len=20;

outer_tube_d = tube_d+wall_thickness*2;

module light_tube() {
    translate([outer_tube_d*2, outer_tube_d/2, 0])
    difference() {
        union() {
            translate([0, 0, tube_len/2 + board_h+wall_thickness])
                cylinder(r=outer_tube_d/2, h=tube_len, center=true);
            ;
            translate([-outer_tube_d/2, -outer_tube_d/2, 0])
                difference() {
                    cube([outer_tube_d, outer_tube_d, board_h+wall_thickness]);
                    translate([(outer_tube_d-tube_d)/2, (outer_tube_d-tube_d)/2, 0])
                        cube([tube_d, tube_d, board_h]);
                }
            ;
        };
        cylinder(r=tube_d/2, h=tube_len*10, center=true);
    };
}

module light_tube_bottom() {
    difference() {
        union() {
            cube([outer_tube_d, outer_tube_d, wall_thickness]);
            translate([outer_tube_d/2-wall_thickness/2, wall_thickness, 0])
                cube([wall_thickness, tube_d, mounting_len]);
        };
        translate([mounting_len/2, outer_tube_d/2, mounting_len/3*2]) rotate([0,90,0])
            cylinder(r=position_screw_d/2, h=wall_thickness*10, center=true);
    };
}

module mounting_bracket() {
    translate([-bracket_len-outer_tube_d, 0, 0])
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
    ;
}

light_tube();
light_tube_bottom();
mounting_bracket();