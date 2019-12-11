// Workflow:
// * generate the STL file
// * load it in slic3r for TLM (a delta printer with center at 0,0)
// * change any rotation that you need to change
// * save that stl to generate a clean and centered stl
// * run it through this

// Dimensions of your STL object
w = 101.48;	// Measured along X axis
d = 69.37;	// Measured along Y axis
h = 30.65;	// Measured along Z axis
z_offset = 3;

// STL file and transformation variables
fname = "/tmp/small med 25pct textured.stl";

// What to generate
what = "both";

// Mold-related variables
width_margin = 10;		// Margin along X axis
height_margin = 10;		// Margin along Y axis
depth_margin = 10;		// Margin along Z axis

// Pour hole variables
pour_hole_translate = [0,-1.3,0];
pour_hole_d1 = 20;
pour_hole_d2 = 4;
pour_hole_height = depth_margin;

if (what == "top") {
    top_half();
}

if (what == "bottom") {
    bottom_half();
}

if (what == "both") {
    offset = w/2+width_margin + 2;
    translate([-offset, 0, 0]) top_half();
    translate([offset, 0, 0]) bottom_half();
}

if (what == "stl") {
    import(fname);
}

module top_half() {
    box=[w+width_margin*2, d+depth_margin*2, h/2+height_margin - z_offset];
    keys=[box[0]/2 - width_margin/2, box[1]/2 - height_margin/2, box[2]];
    
    difference() {
        union() {
            translate([-box[0]/2, -box[1]/2, 0]) cube(box);
            translate(keys) cube([6, 6, 4], center=true);
        }

        for (xy = [ [-1, 1], [1, -1], [-1, -1] ]) {
            translate([keys[0]*xy[0], keys[1]*xy[1], keys[2]-2.05])
                sphere(r=4.1, $fn=128);
        }

        translate(pour_hole_translate) cylinder(h=pour_hole_height, d1 = pour_hole_d1, d2 = pour_hole_d2);
        translate([0, 0, h+height_margin]) rotate([0, 180, 0]) import(fname);
    }

}

module bottom_half() {
    box=[w+width_margin*2, d+depth_margin*2, h/2+height_margin + z_offset];
    keys=[box[0]/2 - width_margin/2, box[1]/2 - height_margin/2, box[2]];

    difference() {
        union() {
            translate([-box[0]/2, -box[1]/2, 0]) cube(box);
            for (xy = [ [-1, 1], [1, -1], [-1, -1] ]) {
                translate([keys[0]*xy[0], keys[1]*xy[1], keys[2]-2.05])
                    sphere(r=4, $fn=128);
            }
        }
        
        translate(keys) cube([6.4, 6.4, 4.25], center=true);
        translate([0, 0, height_margin]) import(fname);
    }
}
