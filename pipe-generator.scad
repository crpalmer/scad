include <utils.scad>

$fa=1;
$fs=1;

base_od=20;
global_od=inch_to_mm(0.75);
scale=global_od / base_od;

wall=1.2;
taz_h = 280;
tlm_h = 500;
printer_h = tlm_h;

function ring_h(od=global_od) = od/4;
function id(od=global_od) = od - wall*2;
function street_elbow_offset(od=global_od) = od/2 + od;
function bulb_cutoff(od=global_od, factor=1.5) = od*factor/2 - sqrt(od/2*od/2*factor*factor - od/2*od/2);
function bulb_h(od=global_od, factor=1.5) = od*factor - 2*bulb_cutoff(od, factor);

module connector_female_of(delta=global_od/4) {
    linear_extrude(height=wall)
    difference() {
        projection() children();
        offset(delta=-delta) projection() children();
    }
}

module connector_male_of(delta=global_od/4, h=10, tolerance=0.5) {
    connector_female_of(delta+tolerance) children();
    linear_extrude(height=h)
        difference() {
            offset(delta=-delta-tolerance) projection() children();
            offset(delta=-delta-tolerance-wall*2) projection() children();
        }    
}

module connector_insert_of(delta=global_od/4, h=global_od*.5, tolerance=0.5) {
    difference() {
        union() {
//            linear_extrude(height=wall) offset(delta=-delta + 4) projection() children();
            linear_extrude(height=h) offset(delta=-delta-tolerance) projection() children();
        }
        linear_extrude(height=h) offset(delta=-delta-tolerance-wall*2) projection() children();
    }    
}
    
module connector_male(od=global_od, h=10, tolerance=.5) {
    connector_male_of(h=h, tolerance=tolerance) cylinder(d=od, h=1);
}

module connector_female(od=global_od) {
    connector_female_of() cylinder(d=od, h=1);
}

module rivet_sphere(d=global_od/5, h=global_od/20) {
    r = (d/2*d/2 + h*h) / (2*h);
    sd = (r + h)*2;
    translate([0, -(sd/2-h), 0]) sphere(d=sd);
}

module bolt_sphere(d=global_od/4, h=global_od/10) {
    r = (d/2*d/2 + h*h) / (2*h);
    sd = (r + h)*2;
    difference() {
        translate([0, -(sd/2-h), 0]) sphere(d=sd);
        translate([0, h/2, 0]) rotate([0, 90, 0]) rotate([-90, 0,  0]) cylinder(d=sd/2, h=h/2, $fn=6);
    }
}

module pipe(len, od=global_od, id=-1, rivets, bolts) {
    id = id < 0 ? id(od) : id;
    difference() {
        union() {
            cylinder(d=od, h=len);
            for (rivet = rivets) {
                rotate([0, 0, rivet[1]]) translate([0, od/2, rivet[0]]) rivet_sphere();
            }
            for (bolt = bolts) {
                rotate([0, 0, bolt[1]]) translate([0, od/2, bolt[0]]) bolt_sphere();
            }
        }
        cylinder(d=id, h=len);
    }
}

module ring(od=global_od) {
    x=ring_h(od);
    cut=0;
    rotate_extrude()
        translate([-od/2, 0]) difference() {
            circle(d=x);
            translate([0, -x/2]) square([x, x]);
            translate([-x/2, -x/2]) square([x/2, cut]);
            translate([-x/2, x/2-cut]) square([x/2, cut]);
        }
}

module half_ring(od=global_od, top=true) {
    intersection() {
        ring(od=od);
        translate([-od, -od, top ? 0 : -od]) cube([od*2, od*2, od]);
    }
}

module flange(len, od=global_od, factor=1.25) {
    id=id(od);
    od=od*factor;
    w=.1*od;
    difference() {
        union() {
            ring(od=od);
            translate([0, 0, len]) ring(od=od);
            translate([0, 0, -ring_h(od)/2]) pipe(len=len+ring_h(od), od=od, id=id);
        }
        for (angle = [0:60:359]) {
            rotate([0, 0, angle]) translate([(id + (od-id)/2)/2+0.1, -w/2, len/6]) cube([od-id, w, len/3*2]);
        }
    }
}

module street_elbow(od=global_od) {
    rotate([90, 0, -90]) rotate_extrude(angle=90)
        translate([od/2+od, 0, 0])
        difference() {
            circle(d=od);
            circle(d=id(od));
        };
}

module bulb(od=global_od, factor=1.5) {
    d=od*factor;
    cut_off=bulb_cutoff(od, factor);
    intersection() {
        translate([0, 0, d/2-cut_off]) difference() {
            sphere(d=d);
            sphere(d=id(d));
        }
        translate([-d/2, -d/2, 0]) cube([d, d, d - 2*cut_off]);
    }
}

module crown(od=global_od, h=global_od*1.25) {
    od1=od;
    od2=od*1.75;
    id1=.9*od1;
    id2=.9*od2;
    difference() {
        cylinder(d1=od1, d2=od2, h=h);
        cylinder(d1=id1, d2=id2, h=h);
        factor=100;
        base=od/2/factor;
        linear_extrude(height=h, scale=[1, factor]) translate([-od1, -base/2]) square([od1*2, base]);
        linear_extrude(height=h, scale=[factor, 1]) translate([-base/2, -od1]) square([base, od1*2]);
    }
}

module smoke_stack() {
    module full_pipe0() {
        translate([0, street_elbow_offset(), -street_elbow_offset()]) union() {
            translate([0, 40*scale, 0]) rotate([-90, 0, 0]) half_ring(top=false);
            translate([0, 20*scale, 0]) rotate([-90, 0, 0]) pipe(20*scale);
            translate([0, 20*scale, 0]) rotate([-90, 0, 0]) ring();
            rotate([-90, 0, 0]) flange(20*scale);
            translate([0, 0, street_elbow_offset()]) rotate([90, 0, 0]) street_elbow();
        }
        ring();
        rivets = [ for (h = [20, 30, 40]) for (angle = [0, 90, 180, 270]) [h*scale, angle] ];
        bolts = [ for (angle = [45:90:360]) [65*scale, angle] ];
        pipe(80*scale, rivets=rivets, bolts=bolts);
        translate([0, 0, 10*scale]) ring();
        translate([0, 0, 50*scale]) ring();
        translate([0, 0, 80*scale]) ring();
        translate([0, 0, 80*scale]) bulb();
        translate([0, 0, 80*scale+bulb_h()]) crown();
    }

    module full_pipe() {
        translate([0, 0, ring_h()/2]) full_pipe0();
    }

    module full_pipe_bottom() {
        difference() {
            full_pipe();
            translate([-1000, -1000, 0]) cube([2000, 2000, 2000]);
        }
        connector_male();
    }


    module part12(angle) {
        difference() {
            rotate([0, angle, 0]) full_pipe_bottom();
            translate([-1000, -1000, -2000]) cube([2000, 2000, 2000]);
        }
    }

    module part1() {
        part12(-90);
        connector_female_of() part12(-90);
    }

    module part2() {
        part12(90);
        connector_female_of() part12(90);
    }

    module part34() {
        difference() {
            full_pipe();
            translate([-1000, -1000, -2000]) cube([2000, 2000, 2000]);
        }
    }

    module part3() {
        difference() {
            part34();
            translate([-1000, -1000, printer_h]) cube([2000, 2000, printer_h]);
        }
        connector_female();
    }

    //connector_insert_of() part1();
    part1();
    //part2();
    //part3();
}
