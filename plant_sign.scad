include <utils.scad>

module label() {
    label=[22,39,0.7];
    translate([-label[0]/2, -label[1]/2, 0.5]) rounded_cube(label, r=2.5);
}

module outer() {
    difference() {
        import("stl/plant_label.stl");
        label();
    }
}

module _text(text) {
    translate([0,0,0.75]) rotate([0, 0, 90]) linear_extrude(height=1) text(font="OptimusPrinceps:style=Regular", text=text, size=4, halign="center", valign="center");
}

//outer();
//label();
_text("Husky Cherry");