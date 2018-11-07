use <threads.scad>

util_threads_fake_heat_set_holes = false;

module recessed_screw_slot(d1, d2, h1, h2, len)
{
    module doit(d, h, len) {
	union() {
	    translate([0, 0, h/2]) cube([d, len-d, h], center=true);
	    translate([0, -len/2+d/2, 0]) cylinder(d=d, h=h);
	    translate([0, len/2-d/2, 0]) cylinder(d=d, h=h);
	}
    }
    
    union() {
	doit(d1, h1, len);
	translate([0, 0, h1]) doit(d2, h2-h1, len+d2-d1);
    }
}

module screw_slot(d, h=100, len)
{
    recessed_screw_slot(d1=d, d2=d, h1=h, h2=h, len=len);
}

module threaded_heat_set_hole(d, alt_d, h, hole_h, hole_d)
{
    d = util_threads_fake_heat_set_holes ? alt_d : d;
    c = 0.5;
    c_d  = d + c;

    union() {
	cylinder(d=d, h=h);
	linear_extrude(height=c, scale=d / c_d) circle(d=c_d);
	translate([0, 0, h-c]) linear_extrude(height=c, scale=c_d/d) circle(d=d);
	if (hole_h > h) {
	    translate([0, 0, h]) cylinder(d=hole_d, h = hole_h - h);
	}
    }
}

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

function No8_through_hole_d() = inch_to_mm(0.1770);
function quarter_twenty_through_hole_d() = inch_to_mm(0.2660);

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
function M3_tight_through_hole_d() = 3.15;
function M3_through_hole_d() = 3.5;
function M3_heat_set_hole_d() = 5.25;
function M3_heat_set_h() = 3.9;

module M3_through_hole(h=100)
{
    cylinder(d=M3_through_hole_d(), h=h);
}

module M3_heat_set_hole(h = 0)
{
    threaded_heat_set_hole(d = M3_heat_set_hole_d(), alt_d = M3_tapping_hole_d(), h = M3_heat_set_h(), hole_h = h, hole_d = M3_through_hole_d());
}

module M3_nut_insert_cutout(h=2.4)
{
    minkowski() {
	cylinder(d=6.2, h=h-0.01, $fn=6);
	cylinder(r=0.2, h=0.01);
    };
}

function M4_tapping_hole_d() = 3.375;
function M4_through_hole_d() = 4.4;
function M4_heat_set_hole_d() = 6.3;
function M4_heat_set_h() = 4.8;
function M4_long_heat_set_h() = 8.0;

module M4_heat_set_hole(h = 0)
{
    threaded_heat_set_hole(d = M4_heat_set_hole_d(), alt_d = M4_tapping_hole_d(), h = M4_heat_set_h(), hole_h = h, hole_d = M4_through_hole_d());
}

module M4_long_heat_set_hole(h = 0)
{
    threaded_heat_set_hole(d = M4_heat_set_hole_d(), alt_d = M4_tapping_hole_d(), h = 4, hole_h = h, hole_d = M4_through_hole_d());
    translate([0, 0, 4]) threaded_heat_set_hole(d = 5.3, alt_d = M4_tapping_hole_d(), h = M4_long_heat_set_h() - 4);
}

module M4_nut_insert_cutout(h=3, d_delta=0)
{
    minkowski() {
	cylinder(d=8.0+d_delta, h=h-0.01, $fn=6);
	cylinder(r=0.2, h=0.01);
    };
}

function M5_tapping_hole_d() = 4.2;
function M5_tight_through_hole_d() = 5.25;
function M5_through_hole_d() = 5.5;

module M3_recessed_through_hole(h=100)
{
    union() {
	cylinder(d=6.25, h=3.25);
	cylinder(d=M3_through_hole_d(), h=h);
    }
}

module M5_recessed_through_hole(h=100)
{
    union() {
	cylinder(d=M5_through_hole_d(), h=h);
	translate([0, 0, h-4]) cylinder(d=10, h=h);
    }
}

module M5_recessed_through_slot(len, h)
{
    recessed_screw_slot(d1=M5_through_hole_d(), d2=10, h1=h-4, h2=h, len=len);
}

module threads_test() {
    translate([10, 0, 0]) No6_nut();
    translate([20, 0, 0]) No6_hex_bolt(length=10);
    translate([30, 0, 0]) No6_tube(length=10);

    translate([15, 15, 0]) M6_nut();
    translate([30, 15, 0]) M6_hex_bolt(length=10);
}
