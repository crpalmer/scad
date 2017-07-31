use <Threading.scad>

function M2_5_pitch() = 0.45;
function M6_pitch() = 1;
function No6_pitch() = 0.7938;

function No6_d() = 3.5052;

module thread(length, pitch, d)
{
    threading(pitch = pitch, d=d, windings=length/pitch, full=true);
}

module nut(D, pitch, d) {
    Threading(D=D, pitch = pitch, d=d, windings=5, full=true, $fn=6);
}

module tube(D, pitch, d, length) {
    Threading(D=D, pitch = pitch, d=d, windings=length / pitch, full=true, $fn=100);
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

module No6_hex_bolt(length = 12, D=9, h=3)
{
    union() {
        thread(d=No6_d(), pitch=No6_pitch(), length=length+h);
        cylinder(d=D, h=h, $fn=6);
    }
}

module No6_nut(D=8)
{
    nut(D=D, pitch=No6_pitch(), d=No6_d());
}

module No6_thread(length=12)
{
    thread(length=length, pitch=No6_pitch(), d=No6_d());
}

module No6_tube(length=8, D=8)
{
    tube(D=D, pitch=No6_pitch(), d=No6_d(), length=length);
}

module threads_test() {
    translate([10, 0, 0]) No6_nut();
    translate([20, 0, 0]) No6_hex_bolt(length=10);
    translate([30, 0, 0]) No6_tube(length=10);

    translate([15, 15, 0]) M6_nut();
    translate([30, 15, 0]) M6_hex_bolt(length=10);
}
