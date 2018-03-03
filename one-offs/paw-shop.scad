$fn=64;

module letter(L, is_stripe, height, size, scale) {
    font = "College Block 2.0";
    solid_h = 1;
//    rotate([180, 0, 180])
    union() {
        difference() {
            linear_extrude(height=height-solid_h) text(text=L, size=size, font=font);
            difference() {
                h = size * 1.2;  // why does it do this?
                w = size * scale;
                if (is_stripe != 0) {
                    cube([w, h, height]);
                }
                translate([h/2, w/2, 0]) resize([h, w, height]) import("paw-shop-stripes.stl");
            }
        }
        if (is_stripe != 0) {
//            translate([0, 0, -solid_h]) linear_extrude(height=solid_h) text(text=L, size=size, font=font);
        }
    }
}

module small_letters(is_stripe) {
    size=50;
    
    at = [ [-size, 1.5*size], [0, 1.5*size], [size, 1.5*size], [-1.5*size, 0], [-size*.5, 0], [size*.75, 0], [1.75*size, 0] ];
    text="PAWSHOP";

    union() {
        for (i = [0:len(text)-1]) {
            translate(at[i]) letter(text[i], is_stripe=is_stripe, height=5, size=size, scale=i==2?1.25 : 1.1);
        }
    }
}

small_letters(1);
