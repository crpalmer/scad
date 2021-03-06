include <utils_threads.scad>

function pvc_od_3_4in() = inch_to_mm(1.050);
function pvc_od_1in() = inch_to_mm(1.315);
function pvc_od_2in() = inch_to_mm(2.375);

module pvc_screw_holes(h, screw_d) {
    for (angle = [0, 90]) {
		rotate([0, 0, angle]) translate([-100, 0, h/2]) rotate([0, 90, 0]) cylinder(d = screw_d, h = 200);
    }
}

module pvc_tapered_cutout(od = pvc_od_1in(), h=20, d2 = 0) {
    taper = (od - d2) / 2;
    taper_h = taper;
    cylinder(d=od, h=h - taper_h);
    translate([0, 0, h - taper_h]) cylinder(d1=od, d2=d2, h=taper_h);
}

module pvc_tapered_holder(od = pvc_od_1in(), h=20, d2=0, wall=2, screw_d) {
    difference() {
	cylinder(d = od + wall*2, h=h);
	pvc_tapered_cutout(od = od, h = h, d2 = d2);
	if (screw_d != undef) {
        pvc_screw_holes(h = h/2, screw_d = screw_d);
	}
    }
}

module pvc_holder(od = pvc_od_1in(), h=20, wall=2, screw_d) {
    pvc_tapered_holder(od=od, h=h, wall=wall, d2=od, screw_d=screw_d);
}

module pvc_coupler(od1 = pvc_od_1in(), od2 = pvc_od_1in(), h=15, wall = 2, screw_d) {
    translate([0, 0, od1 < od2 ? h*2 : 0, 0]) rotate([od1 < od2 ? 180 : 0, 0, 0]) union() {
        pvc_tapered_holder(od1, d2=od1 - wall*2, h=h, wall=wall, screw_d = screw_d);
        translate([0, 0, h*2]) rotate([180, 0, 0]) pvc_tapered_holder(od2, d2 = od2 - wall*2, h=h, wall=wall, screw_d = screw_d);
    }
}

module pvc_mount(od = pvc_od_1in(), base_d = 60, wall = 2, h = 10, screw_d = M3_through_hole_d(), hole_d) {
    hole_d = hole_d == undef ? screw_d : hole_d;
    holder_d = od + wall*2;
    difference() {
        union() {
            cylinder(d = base_d, h = wall);
            translate([0, 0, wall]) pvc_tapered_holder(od = od, wall = wall, h = h, screw_d = screw_d, d2 = od);
        }
        for (angle = [0, 90, 180, 270]) {
            rotate([0, 0, angle]) translate([(base_d - holder_d) / 4 + holder_d/2, 0, 0]) cylinder(d = hole_d, h = wall);
        }
    }
}

module pvc_angle_connector(od = pvc_od_1in(), angle=45, wall=2.4, h = 20, screw_d = M3_through_hole_d(), screw_d = M3_through_hole_d(), slop=1) {
    od = od + slop;
    d = od + wall*2;

    h2 = h + triangle_opp_length_angle_adj(angle=90-angle, adj=d);

    module part(d = d, h=h) {
        cylinder(d = d, h=h);
        intersection() {
            translate([0, 0, h]) rotate([0, angle, 0]) cylinder(d = d, h=h*2, center=true);
            cylinder(d = d, h = h*2);
        }
        translate([0, 0, h]) rotate([0,angle, 0]) cylinder(d = d, h=h);
    }

    difference() {
        part(d = d);
        part(d = od, h=h+.1);
        pvc_screw_holes(h = h/2, screw_d=screw_d);
        translate([0, 0, h]) rotate([0, angle, 0]) pvc_screw_holes(h = h - wall - screw_d/2, screw_d = screw_d);
    }
    
}
