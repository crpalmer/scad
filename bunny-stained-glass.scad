$fn=9;
minkowski() {
    difference() {
        rotate([0, 90, 0]) sphere([1.25,1.25,7]);
        translate([-2.5, -2.5, -5]) cube([5, 5, 5], center=false);
    }
    import("/home/crpalmer/Downloads/bunny-stained-glass.stl");
}
