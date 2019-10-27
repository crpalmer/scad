include <utils.scad>
include <utils_threads.scad>

// Command line arguments for generation:
is_big=0;
which=1;
letter="O";
drill_guide=0;
drill_guide_hole_d=1;
drill_guide_thick=1;

$fn=64;

nozzle_d=0.6;
layer_h=0.2;

height = is_big ? 20 : 5;
size = (is_big ? 8 : 2) *25.4;

solid_h=height - 1;

// Use outer_w > 0 to carry the stripes down the outside of the print to make
// it look like the stripes go all the way down without having to print the
// stripe all the way through it
//outer_w=1.2;
outer_w = 0;

module T2D(L) {
    font = "College Block 2.0";
    text(text=L, size=size, font=font, valign="center", halign="center");
}

module T(L, height=height, delta=0) {
    linear_extrude(height=height) offset(delta=delta) T2D(L);
}

module stripes(L, negative=0) {
    scale = L == "W" ? 1.5 : 1.2;
    difference() {
        h = size * scale;
        w = size * scale;
        if (negative != 0) {
            translate([0, 0, height/2]) cube([w, h, height], center=true);
        }
        resize([h, w, height]) import("stl/paw-shop-stripes.stl");
    }
}

module dark(L,height) {
    difference() {
        T(L, height);
        stripes(L, negative=1);
    }
}

module light(L, height) {
    difference() {
        T(L, height);
        stripes(L);
    }
}

module letter(L, which) {
    if (which == 0) {
        // dark letter, stripes in outer_w, no outer_w, bottom
        T(L, solid_h, -outer_w);
        difference() {
            dark(L, solid_h);
            T(L, solid_h, -outer_w);
        }
        // dark stripes, upper
        translate([0, 0, solid_h]) dark(L, height - solid_h);
    }
    if (which == 1) {
        // light stripes, only outer_w, bottom
        difference() {
            light(L, solid_h);
            T(L, solid_h, -outer_w);
        }
        // light stripes, upper
        translate([0, 0, solid_h]) light(L, height - solid_h);
    }
    if (which == 10) {
        // full dark
        dark(L, height);
    }
    if (which == 11) {
        // full light
        light(L, height);
    }
}

module mounting_holes(L, D = drill_guide ? drill_guide_hole_d : M3_heat_set_hole_d()) {
    module hole(x_pct, y_pct) {
        translate([x_pct/100 * size, y_pct/100 * size, 0]) union() {
            cylinder(d=D, h=6);
            if (! drill_guide) cylinder(d=M3_through_hole_d(), h = 10);
        }
    }

    if (L == "P") {
        hole(-20, 46);
        hole(10, 46);
        hole(-20, -30);
    } else if (L == "A") {
        hole(-4, 40);
        hole(-25, -42);
        hole(15, -42);
    } else if (L == "W") {
        hole(-42, 45);
        hole(34, 45);
        hole(-25, -40);
        hole(18, -40);
    } else if (L == "S") {
        hole(18, 30);
        hole(-2, 0);
        hole(-25, -35);
    } else if (L == "H") {
        hole(-25, 45);
        hole(17, 45);
        hole(-25, -42);
        hole(17, -42);
    } else if (L == "O") {
        hole(-25, 0);
        hole(18, 0);
        hole(-5, 45);
        hole(-5, -45);
    }
}

module all_letters(is_light) {
    at = [ [-size, 1.5*size], [0, 1.5*size], [size, 1.5*size], [-1.5*size, 0], [-size*.5, 0], [size*.75, 0], [1.75*size, 0] ];
    text="PAWSHOP";

    union() {
        for (i = [0:len(text)-1]) {
            translate(at[i])
            letter(text[i], is_light);
        }
    }
}

//rotate([0, 180, 0]) 
//all_letters(0);

difference() {
    if (drill_guide) {
        T(letter, height=drill_guide_thick);
    } else {
        letter(letter, which);
    }
    mounting_holes(letter);
}
