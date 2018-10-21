use <threads.scad>

translate([0, 0, 10]) metric_thread(pitch = 3, diameter=15, length=50);
cylinder(d=22, h=10, $fn=6);
