use <utils.scad>
use <threads.scad>

function thread_d_delta() = +.1;
function internal_d_delta() = +.65;

function M2_5_pitch() = 0.45;
function M6_pitch() = 1;

function No6_d() = 0.13;
function No6_through_hole_d() = inch_to_mm(0.1495);
function No6_tpi() = 32;
function quarter_twenty_d() = 0.25;
function quarter_twenty_tpi() = 20;

module m_thread(length, pitch, d)
{
    metric_thread(pitch = pitch, diameter=d+thread_d_delta(), length=length);
}

module m_nut(D, pitch, d) {
    h=pitch*5;
    difference() {
        cylinder(d=D, h=h, $fn=6);
        metric_thread(pitch = pitch, diameter=d+internal_d_delta(), length=h, internal=true);
    }
}

module m_tube(D, pitch, d, length) {
    difference() {
        cylinder(d=D, h=length, $fn=100);
        metric_thread(pitch = pitch, diameter=d+internal_d_delta(), length=length, internal=true);
    }
}

module e_thread(length, tpi, d)
{
   english_thread(threads_per_inch = tpi, diameter=d+thread_d_delta()/25.4, length=length / 25.4);
}

module e_nut(D, tpi, d) {
    h_in=5 / tpi;
    h_mm = h_in * 25.4;
    difference() {
        cylinder(d=D, h=h_mm, $fn=6);
        english_thread(threads_per_inch = tpi, diameter=d+internal_d_delta()/25.4, length=h_in, internal=true);
    }
}

module e_tube(D, tpi, d, length) {
    difference() {
        cylinder(d=D, h=length, $fn=100);
        english_thread(threads_per_inch = tpi, diameter=d+internal_d_delta()/25.4, length=length/25.4, internal=true);
    }
}

module M2_5_nut(D=5)
{
    m_nut(D, pitch=M2_5_pitch(), d=2.5);
}

module M2_5_hex_bolt(length = 16, D=6, h=2)
{
    union() {
        m_thread(d=2.5, pitch=M2_5_pitch(), length=length+h);
        cylinder(d=D, h=h, $fn=6);
    }
}

module M2_5_thread(length = 16)
{
    m_thread(length=length, pitch=M2_5_pitch(), d=2.5);
}

module M2_5_tube(length=16, D=6)
{
    m_tube(D=D, pitch = M2_5_pitch(), d=2.5, length=length);
}

module M6_hex_bolt(length = 16, D=12, h=3)
{
    union() {
        m_thread(d=6, pitch=M6_pitch(), length=length+h);
        cylinder(d=D, h=h, $fn=6);
    }
}

module M6_nut(D=12)
{
    m_nut(D=D, pitch=M6_pitch(), d=6);
}

module M6_thread(length = 16)
{
    m_thread(length=length, pitch=M6_pitch(), d=6);
}

module M6_tube(length = 8, D=12)
{
    m_tube(D=D, pitch = M6_pitch(), d=6, length=length);
}

module No6_hex_bolt(length = 12, D=9, h=3)
{
    union() {
        e_thread(d=No6_d(), tpi=No6_tpi(), length=length+h);
        cylinder(d=D, h=h, $fn=6);
    }
}

module No6_nut(D=8.8)
{
    e_nut(D=D, tpi=No6_tpi(), d=No6_d());
}

module No6_thread(length=12)
{
    e_thread(length=length, tpi=No6_tpi(), d=No6_d());
}

module No6_tube(length=8, D=8)
{
    e_tube(D=D, tpi=No6_tpi(), d=No6_d(), length=length);
}

module No6_nut_insert_cutout(h=3.25)
{
    minkowski() {
        cylinder(d=8.8, h=h-0.01, $fn=6);
        cylinder(r=0.2, h=0.01);
    };
}

module quarter_twenty_hex_bolt(length = 12, D=12.5, h=4)
{
    union() {
        e_thread(d=quarter_twenty_d(), tpi=quarter_twenty_tpi(), length=length+h);
        cylinder(d=D, h=h, $fn=6);
    }
}

module quarter_twenty_nut(D=12.5)
{
    e_nut(D=D, tpi=quarter_twenty_tpi(), d=quarter_twenty_d());
}

module quarter_twenty_thread(length=12)
{
    e_thread(length=length, tpi=quarter_twenty_tpi(), d=quarter_twenty_d());
}

module quarter_twenty_tube(length=8, D=8)
{
    e_tube(D=D, tpi=quarter_twenty_tpi(), d=quarter_twenty_d(), length=length);
}

function M3_tapping_hole_d() = 2.5;
function M3_through_hole_d() = 3.5;

module M3_nut_insert_cutout(h=2.4)
{
    minkowski() {
        cylinder(d=6.2, h=h-0.01, $fn=6);
        cylinder(r=0.2, h=0.01);
    };
}

function M4_tapping_hole_d() = 3.375;
function M4_through_hole_d() = 4.4;

function M5_through_hole_d() = 5.5;

module threads_test() {
    translate([10, 0, 0]) No6_nut();
    translate([20, 0, 0]) No6_hex_bolt(length=10);
    translate([30, 0, 0]) No6_tube(length=10);

    translate([15, 15, 0]) M6_nut();
    translate([30, 15, 0]) M6_hex_bolt(length=10);
}
