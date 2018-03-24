// Command line arguments for generation:
is_big=0;
which=0;
letter="P";

$fn=64;

nozzle_d=0.4;
layer_h=0.2;

height = is_big ? 20 : 5;
size = (is_big ? 8 : 2) *25.4;

solid_h=height - 1;

module T2D(L) {
    font = "College Block 2.0";
    text(text=L, size=size, font=font, valign="center", halign="center");
}

module T(L, height=height) {
    linear_extrude(height=height) T2D(L);
}

module core(L) {
    linear_extrude(height=solid_h) T2D(L);
}

module stripes(L, negative=0) {
    scale = L == "W" ? 1.5 : 1.2;
    difference() {
        h = size * scale;
        w = size * scale;
        if (negative != 0) {
            translate([0, 0, height/2]) cube([w, h, height], center=true);
        }
        resize([h, w, height]) import("paw-shop-stripes.stl");
    }
}

module dark(L) {
    union() {
        difference() {
            T(L);
            translate([0, 0, solid_h]) stripes(L, negative=1);
        }
        core(L);
    }
}

module light(L) {
    difference() {
        translate([0, 0, solid_h]) T(L, height=height-solid_h);
        stripes(L);
        core(L);
    }
}

module letter(L, is_light) {
    union() {
        if (is_light == 0) {
            dark(L);
        }
        if (is_light != 0) {
            light(L);
        }
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

letter(letter, which);