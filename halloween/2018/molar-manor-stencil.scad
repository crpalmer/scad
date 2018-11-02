include <high-detail.scad>

font="Mephisto™:style=Regular";
size=80;
h = 1;

module molar(part = 0) {
    text="MOLAR";

    linear_extrude(height=h)
    difference() {
        translate([-20, -40]) square([400, 140]);
        difference() {
            text(text, font=font, size=size);
            translate([90, 35]) square([70, 4]);
            translate([200, 42]) square([200, 4]);
        }
        if (part == 0) {
            translate([220.5, -40]) square([400, 140]);
        }
        if (part == 1) {
            translate([-20, -40]) square([20+220.5, 140]);
        }
    }
}

module manor(part = 0) {
    text="MANOR";

    module box() {
        translate([-20, -40]) square([400, 140]);
    }
    
    module cutout(slop=0) {
        cut=234.5;
        extra=5;
        difference() {
            translate([-20, -40]) square([20+cut+extra, 140]);
            translate([cut-extra-slop, 10-slop]) square([100, 60+slop*2]);
        }
    }
    
    linear_extrude(height=h)
    difference() {
        box();
        difference() {
            text(text, font=font, size=size);
            translate([90, 42]) square([70, 4]);
            translate([230, 33]) square([75, 4]);
            translate([300, 44]) square([200, 4]);
        }
        if (part == 0) {
            difference() {
                box();
                cutout(slop=0.1);
            }
        }
        if (part == 1) {
            cutout();
        }
    }
}

molar(1);
//manor(1);
