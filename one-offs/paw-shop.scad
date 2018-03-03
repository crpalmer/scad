$fn=64;

module hollow_text(text, size, font, width=1) {
    difference() {
        text(text=text, size=size, font=font);
        offset(r=-width) text(text=text, size=size, font=font);
    }
}

module el_wire_text(text, size, font, height=10, offset=1, d=2.25) {
    difference() {
        linear_extrude(height=height) text(text=text, size=size, font=font);
        translate([0, 0, height-d]) linear_extrude(height=d) union() {
            difference() {
                hollow_text(text=text, size=size, font=font, width=offset+d);
                hollow_text(text=text, size=size, font=font, width=offset);
            }
        }
    }
}

//el_wire_text("W", font="Anton", size=200, offset=2, d=2.25);

//difference() {
//    linear_extrude(height=10) text("PAW", size=48);
//    linear_extrude(height=10) offset(delta=-1) { text("PAW", size=48); }
//}

//difference() {
//    hollow_text("PAW", size=48, width=4);
//    hollow_text("PAW", size=48);
//}

//linear_extrude(height=7, convexity=10) 
//offset(r=0.75) 
//text("PAW", size=16, 
//spacing=1, direction="ltr",$fn=60); 

stripe_w=5;
height=5;
start=1;
size=50;

at = [ [-size, 1.5*size], [0, 1.5*size], [size, 1.5*size], [-1.5*size, 0], [-size*.5, 0], [size*.75, 0], [1.75*size, 0] ];
text="PAWSHOP";

union() {
x=1;
translate([-80, 50+x, 0]) cube([1, 1, 0.25]);
translate([130, 50+x, 0]) cube([1, 1, 0.25]);
translate([75+x, -5, 0]) cube([1, 1, 0.25]);
translate([75+x, 140, 0]) cube([1, 1, 0.25]);

for (i = [0:len(text)-1]) {
    translate(at[i]) 
difference() {
    linear_extrude(height=height) text(text=text[i], size=50, font="College Block 2.0");
    a = size*(i == 2 ? 1.25 : 1.25);
    difference() {
        cube([a, a, height]);
        translate([a/2, a/2, 0]) resize([a, a, height]) import("paw-shop-stripes.stl");
    }
//    for (i = [start:2:400/stripe_w]) {
//        translate([-50 + i*stripe_w/cos(45), 0, 0]) rotate([0, 0, -45]) cube([stripe_w, 500, height]);
//    }
}
}

//union() {
//    for (i = [0:2:400/stripe_w]) {
//        translate([-50 + i*stripe_w/cos(45), 0, 0]) rotate([0, 0, -45]) cube([stripe_w, 500, height+0*10]);
//    }
//    for (i = [1:2:400/stripe_w]) {
//        translate([-50 + i*stripe_w/cos(45), 0, 0]) rotate([0, 0, -45]) cube([stripe_w, 500, height+1*10]);
//    }
//}

}