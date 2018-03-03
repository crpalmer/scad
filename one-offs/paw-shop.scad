$fn=64;

fancy_w=1;
height=5;
size=50;

module T(L, height=height) {
    font = "College Block 2.0";
    linear_extrude(height=height) text(text=L, size=size, font=font, valign="center", halign="center");
}

module stripes(scale, negative=0) {
    difference() {
        h = size * scale;
        w = size * scale;
        if (negative != 0) {
            cube([w, h, height]);
        }
        resize([h, w, height]) import("paw-shop-stripes.stl");
    }
}

module dark(L, scale) {
    union() {
        difference() {
            T(L);
            stripes(scale, negative=1);
        }
    }
}

module light(L, scale) {
    union() {
        difference() {
            T(L);
            stripes(scale);
        }
    }
}

module small_letters(is_stripe) {
    size=50;
    
    at = [ [-size, 1.5*size], [0, 1.5*size], [size, 1.5*size], [-1.5*size, 0], [-size*.5, 0], [size*.75, 0], [1.75*size, 0] ];
    text="PAWSHOP";

    union() {
        for (i = [0:len(text)-1]) {
            scale = i == 2 ? 1.5 : 1.2;
            translate(at[i])
//                dark(text[i], scale);
                light(text[i], scale);
        }
    }
}

//rotate([180, 0, 180])
small_letters(1);
//light("P", scale=1.2);