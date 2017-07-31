use <threads.scad>

function M2_5_pitch() = 0.45;
function M6_pitch() = 1;

module thread(length, pitch, d)
{
    metric_thread(pitch = pitch, diameter=d, length=length);
}

module nut(D, pitch, d) {
    h=pitch*5;
    difference() {
        cylinder(d=D, h=h, $fn=6);
        metric_thread(pitch = pitch, diameter=d, length=h, internal=true);  
    }
}

module tube(D, pitch, d, length) {
    difference() {
        cylinder(d=D, h=length, $fn=100);
        metric_thread(pitch = pitch, diameter=d, length=length, internal=true);  
    }
}

module M2_5_nut(D=5)
{
    nut(D, pitch=M2_5_pitch(), d=2.5);
}

module M2_5_hex_bolt(length = 16, D=6, h=2)
{
    union() {
        thread(d=2.5, pitch=M2_5_pitch(), length=length+h);
        cylinder(d=D, h=h, $fn=6);
    }
}

module M2_5_thread(length = 16)
{
    thread(length=length, pitch=M2_5_pitch(), d=2.5);
}

module M2_5_tube(length=16, D=6)
{
    tube(D=D, pitch = M2_5_pitch(), d=2.5, length=length);
}

module M6_hex_bolt(length = 16, D=12, h=3)
{
    union() {
        thread(d=6, pitch=M6_pitch(), length=length+h);
        cylinder(d=D, h=h, $fn=6);
    }
}

module M6_nut(D=12)
{
    nut(D=D, pitch=M6_pitch(), d=6);
}

module M6_thread(length = 16)
{
    thread(length=length, pitch=M6_pitch(), d=6);
}

module M6_tube(length = 8, D=12)
{
    tube(D=D, pitch = M6_pitch(), d=6, length=length);
}

module threads_test() {
    translate([0, 0, 0]) M2_5_thread(length=10);
    translate([10, 0, 0]) M2_5_nut();
    translate([20, 0, 0]) M2_5_hex_bolt();
    translate([30, 0, 0]) M2_5_tube(length=10);

    translate([0, 15, 0]) M6_thread(length=10);
    translate([15, 15, 0]) M6_nut();
    translate([30, 15, 0]) M6_hex_bolt();
    translate([45, 15, 0]) M6_tube(length=10);
}
