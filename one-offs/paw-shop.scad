$fn=64;

module letter(L, is_stripe, height, size) {
    difference() {
        linear_extrude(height=height) text(text=L, size=size, font="College Block 2.0");
        a = size*1.25;
        difference() {
            if (is_stripe != 0) {
                cube([a, a, height]);
            }
            translate([a/2, a/2, 0]) resize([a, a, height]) import("paw-shop-stripes.stl");
        }
    }
}

module small_letters(is_stripe) {
    size=50;
    
    at = [ [-size, 1.5*size], [0, 1.5*size], [size, 1.5*size], [-1.5*size, 0], [-size*.5, 0], [size*.75, 0], [1.75*size, 0] ];
    text="PAWSHOP";

    union() {
        for (i = [0:len(text)-1]) {
            translate(at[i]) letter(text[i], is_stripe=is_stripe, height=5, size=size);
        }
    }
}

small_letters(0);
