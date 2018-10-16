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