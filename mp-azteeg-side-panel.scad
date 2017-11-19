include <Round-Anything/polyround.scad>

corners=[ [0,0,1], [183, 0,1], [183, 51, 1], [183-15, 66, 1], [62, 66, 1], [0, 13, 1] ];
holes=[ [7, 6], [183-8, 6], [183-8, 45], [183-21, 66-7.5], [69.5, 66-7.5] ];

module usb_cutout() {
    translate([113, 19, 0]) cube([14, 12, 100]);
}

module sdcard_cutout() {
    translate([96, 19, 0]) cube([15, 4, 100]);
}

module button_cutouts() {
    $fn=100;
    translate([81, 23, 0]) cylinder(d=5.5, h=100);
    translate([91, 23, 0]) cylinder(d=5.5, h=100);
}

module panel_with_screw_holes() {
    difference() {
        translate([0, 0, 0.1]) minkowski() {
            linear_extrude(height=2) polygon(polyRound(corners, 50));
            sphere(r=0.1);
        }
        for (hole = holes) {
            translate([hole[0], hole[1], -1]) cylinder(d=4, h=100, $fn=100);
        }
    }
}

module fan_cutout() {
    $fn=100;
    union() {
        difference() {
            cylinder(d=38, h=100);
            cylinder(d=18, h=100);
            linear_extrude(height=100) polygon([[-18, -18], [-14, -18], [18, 18], [14, 18], [-18, -18]]);
            linear_extrude(height=100) polygon([[-18, 18], [-14, 18], [18, -18], [14, -18], [-18, 18]]);
        }
        translate([-16, -16, 0]) cylinder(d=4, h=100);
        translate([-16, 16, 0]) cylinder(d=4, h=100);
        translate([16, -16, 0]) cylinder(d=4, h=100);
        translate([16, 16, 0]) cylinder(d=4, h=100);
    }
}

module left_side_panel() {
    difference() {
        panel_with_screw_holes();
        usb_cutout();
        sdcard_cutout();
        button_cutouts();
    }
}

module right_side_panel() {
    difference() {
        panel_with_screw_holes();
        translate([93, 30, 0]) fan_cutout();
    }
}

left_side_panel();
//rotate([0, 180, 0]) right_side_panel();
