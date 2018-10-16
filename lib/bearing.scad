include <utils.scad>

module bearing_holder_in(od, id, iid, h) {
    difference() {
        union() {
            cylinder(d = od, h = h);
            children();
        }
        cylinder(d = id, h = h-1);
        cylinder(d = iid, h = h);
    }
}

module bearing_8mm_holder_in(h = 7) {
    bearing_holder_in(od=30, id=22, iid=14, h=h) children();
}

module bearing_3_8in_holder_in(h = inch_to_mm(9/32)) {
    bearing_holder_in(od=inch_to_mm(7/8), id=inch_to_mm(5/8), iid=inch_to_mm(3/8), h=h);
}

module bearing_1_4in_holder_in(h = inch_to_mm(9/32)) {
    bearing_holder_in(od=inch_to_mm(3/4), id=inch_to_mm(1/2), iid=inch_to_mm(1/4), h=h);
}