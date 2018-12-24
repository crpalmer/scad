include <high-detail.scad>
//$fn=128;

h=35;
p1=10;
p2=2;
p3=7;
p4=5;
p=(p1+p2+p3+p4);
b1=h * p1/p;
scarf=h * p2/p;
b2=h * p3/p;
hat=h * p4/p;
nose_len = b2*.5;
nose_d = nose_len / 2;
brim=b2 + h/20;

function cut(h) = h / 8;

module ball(h, cut) {
    cut = cut == undef ? cut(h) : cut;
    full = h + cut*2;
    difference() {
        translate([0, 0, full/2 - cut]) sphere(d = full);
        translate([-full, -full, -full]) cube([2*full, 2*full, full]);
        translate([-full, -full, h]) cube([2*full, 2*full, full]);
    }
}

module body() {
    ball(b1);
    translate([0, 0, b1+scarf*0]) ball(b2);
}

module buttons() {
    translate([0, 0, b1/2])
    for (angle = [-1, 0, 1] * 20) {
        rotate([0, angle, 0]) translate([b1/2 + cut(b1), 0, 0]) sphere(d=b1*.15);
    }
}

module scarf() {
    offset = b1/2 - cut(b1);
    translate([0, 0, b1]) rotate_extrude() {
        translate([offset, 0, 0]) circle(d = scarf);
        translate([0, -scarf/2]) square([offset, scarf]);
    }
    rotate([0, 0, 40]) translate([b1/2-cut(b1) + scarf/2, 0, b1]) sphere(d=scarf);
}

module nose() {
    translate([b2/2, 0, b1 + b2/2]) rotate([0, 80, 0]) linear_extrude(height = nose_len, scale=[nose_d/nose_len, nose_d/nose_len]) circle(d=nose_d);
}

module eyes() {
    translate([0, 0, b1+b2/2]) for (angle1 = [-1, 1]*20) {
        rotate([0, -20, 0]) rotate([0, 0, angle1]) translate([b2/2 + cut(b2), 0, 0]) sphere(d = b2*.2);
    }
}

module hat() {
    brim_h = hat*.3;
    start = b2 - cut(b2)*2;
    transition = (brim - start)/4;
    echo(transition);
    echo(brim);
    translate([0, 0, b1+b2]) union() {
        linear_extrude(height = transition, scale = brim / start) circle(d = start);
        translate([0, 0, transition]) cylinder(d = brim, h = brim_h - transition);
        cylinder(d = start, h = hat);
    }
}

module white_part() {
    difference() {
        body();
        buttons();
        scarf();
        nose();
        eyes();
        hat();
    }
}

module black_part() {
    buttons();
    eyes();
    hat();
}

module red_part() {
    scarf();
}

module orange_part() {
    nose();
}

module visualize_it() {
    color("white") body();
    color("black") buttons();
    color("red") scarf();
    color("orange") nose();
    color("black") eyes();
    color("black") hat();
}

//white_part();
//black_part();
//red_part();
//orange_part();

visualize_it();