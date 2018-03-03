$fn=64;

fancy_w=1;

//height=20;
//size=8*25.4;
height=5;
size=2*25.4;

module T2D(L) {
    font = "College Block 2.0";
    text(text=L, size=size, font=font, valign="center", halign="center");
}

module T(L, height=height) {
    linear_extrude(height=height) T2D(L);
}

module core(L) {
    linear_extrude(height=height-fancy_w) offset(delta=-fancy_w) T2D(L);
}

module stripes(L, negative=0) {
    scale = L == "W" ? 1.5 : 1.2;
    difference() {
        h = size * scale;
        w = size * scale;
        if (negative != 0) {
            cube([w, h, height*2], center=true);
        }
        resize([h, w, height]) import("paw-shop-stripes.stl");
    }
}

module dark(L) {
    union() {
        difference() {
            T(L);
            stripes(L, negative=1);
        }
        core(L);
    }
}

module light(L) {
    difference() {
        T(L);
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

rotate([180, 0, 180])
all_letters(1);

//rotate([180, 0, 180])
//letter("P", 1);