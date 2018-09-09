use <utils.scad>
use <spline.scad>

$fa = 1;
$fs = 0.6;

base_od=20;
global_od=inch_to_mm(1);
scale=global_od / base_od;

wall=1.2;
taz_h = 280;
tlm_h = 500;
printer_h = tlm_h;

function ring_h(od=global_od) = od/4;
function id(od=global_od) = od - wall*2;
function od_of_id(id = id(global_od)) = id + wall*2;
function elbow_offset(od=global_od) = od/2 + od/2;
function street_elbow_offset(od=global_od) = od/2 + od;
function bulb_cutoff(od=global_od, factor=1.5) = od*factor/2 - sqrt(od/2*od/2*factor*factor - od/2*od/2);
function bulb_h(od=global_od, factor=1.5) = od*factor - 2*bulb_cutoff(od, factor);
function valve_h() = 20*scale+bulb_h();
function connector_h() = 1;

module connector_female_of(delta=global_od/4) {
    linear_extrude(height=wall)
    difference() {
        offset(delta=0.01) projection() children();
        offset(delta=-delta) projection() children();
    }
}

module part_and_female_connector() {
    children();
    connector_female_of() children();
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
    connector_male_of(h=h, tolerance=tolerance) cylinder(d=od, h=connector_h());
}

module connector_female(od=global_od, support = false) {
    connector_female_of() cylinder(d=od, h=connector_h());
    if (support) {
        d=od/2;
        h=(od-d)/2;
        translate([0, 0, -h]) difference() {
            cylinder(d=od, h=h);
            cylinder(d1=od, d2=d, h=h);
        }
    }
}

module top_or_bottom_of(top) {
    difference() {
        children();
        if (top == 0 || top == 1) {
            translate([-1000, -1000, top == 0 ? 0 : -1000]) cube([2000, 2000, 1000]);
        }
    }
}

module top_of() {
    top_or_bottom_of(1) children();
}

module bottom_of() {
    top_or_bottom_of(0) children();
}

module rivet_sphere(d=global_od/5, h=global_od/20, factor=1) {
    d=d*factor;
    h=h*factor;
    r = (d/2*d/2 + h*h) / (2*h);
    sd = (r + h)*2;
    translate([0, -(sd/2-h), 0]) sphere(d=sd);
}

module bolt_sphere(d=global_od/4, h=global_od/10, factor=1) {
    d=d*factor;
    h=h*factor;
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

module elbow(od=global_od) {
    rotate([90, 0, -90]) rotate_extrude(angle=90)
        translate([elbow_offset(od), 0, 0])
        difference() {
            circle(d=od);
            circle(d=id(od));
        };
}

module street_elbow(od=global_od) {
    rotate([90, 0, -90]) rotate_extrude(angle=90)
        translate([street_elbow_offset(od), 0, 0])
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

module valve() {
    h=valve_h();
    
    module mounting_stem() {
        stem_h = 15*scale;
        difference() {
            union() {
                linear_extrude(height=stem_h) union() {
                    square([7*scale, 0.5*scale], center=true);
                    square([0.5*scale, 7*scale], center=true);
                }
                cylinder(d=3*scale, h=stem_h);
            }
            cylinder(d=M3_tapping_hole_d(), h=stem_h);
        }
    }

    module mount() {
        ring();
        translate([0, 0, -ring_h()/2]) cylinder(d=global_od, h=ring_h()*1.75);
        translate([0, 0, ring_h()]) union() {
            ring();
            translate([0, 0, ring_h()/2]) for (angle = [0:40:359]) {
                rotate([0, 0, angle]) translate([0, global_od/2, 0]) rotate([90, 0, 0]) bolt_sphere(factor=0.5);
            }
            translate([0, 0, 1.25*scale]) cube([7.5*scale, 7.5*scale, 2.5*scale], center=true);
            translate([0, 0, 2.5*scale]) union() {
                for (angle = [45:90:359]) {
                    rotate([0, 0, angle]) translate([0, 4*scale, 0]) rivet_sphere(factor=0.35);
                }
                mounting_stem();
            }
        }
    }
        
    ring();
    pipe(h);
    translate([0, 0, 10*scale]) bulb();
    translate([0, 0, h]) ring();
    translate([0, bulb_h()/2, h/2]) rotate([-90, 0, 0]) mount();
}

module valve_handle(od = global_od, factor=1.5) {
    small_d = od / 5;
    big_d = od / 2.5;
    d = od*factor;
    difference() {
        union() {
            translate([0, 0, -d]) rotate_extrude() translate([d, d]) circle(d=big_d);
            for (angle = [ 0, 90, 180, 270 ]) {
                rotate([0, 0, angle]) rotate([0, -90, 0]) cylinder(d1 = small_d/2, d2 = small_d * 2, h=d);
            }
            translate([0, 0, -5*scale+2*scale]) cylinder(d=big_d, h=5*scale);
            for (angle = [0:30:359]) rotate([0, 0, angle]) translate([0, d+big_d/2, 0]) rivet_sphere();
        }
        translate([0, 0, -d]) cylinder(d=M3_through_hole_d(), h=2*d);
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
        bottom_of() full_pipe();
        connector_male();
    }


    module part12(angle) {
        top_of() rotate([0, angle, 0]) full_pipe_bottom();
    }

    module part1() {
        part12(-90);
        connector_female_of() part12(-90);
    }

    module part2() {
        part12(90);
        connector_female_of() part12(90);
    }

    module part3() {
        top_of(); full_pipe();
        connector_female();
    }

    //connector_insert_of() part1();
    part1();
    //part2();
    //part3();
}

module valve_pipe() {
    module elbow_part() {
        translate([0, -street_elbow_offset(), -street_elbow_offset()]) half_ring();
        translate([0, 0, -street_elbow_offset()]) street_elbow();
    }
    
    module straight_part() {
        rotate([-90, 0, 0]) union() {
            connector_female();
            bolts = [ for (h = [65, 75]) for (angle = [0, 90, 180, 270]) [h*scale, angle] ];
            pipe(140*scale, bolts = bolts);
            translate([0, 0, ring_h()/2]) ring();
            translate([0, 0, 55*scale]) ring();
            translate([0, 0, 85*scale]) ring();
            translate([0, 0, 140*scale]) ring();
            translate([0, 0, 140*scale]) connector_female(support=true);
        }
    }
    
    module side_pipe() {
        elbow_part();
        straight_part();
    }

    module left_side_pipe() {
        translate([0, -140*scale -valve_h()/2, 0]) side_pipe();
    }
    
    module valve_part() {
        translate([0, -ring_h()/2+connector_h(), 0]) rotate([90, 0, 0]) connector_male();
        rotate([-90, 0, 0]) rotate([0, 0, 180]) valve();
        translate([0, valve_h()+ring_h()/2-connector_h(), 0]) rotate([-90, 0, 0]) connector_male();
    }
    
    module full_pipe() {
        left_side_pipe();
        translate([0, -valve_h()/2, 0]) valve_part();
        rotate([0, 0, 180]) left_side_pipe();
        rotate([0, 0, 45]) translate([0, 0, 35*scale]) valve_handle();
    }
    
    module elbow12() {
        rotate([0, 90, 0]) elbow_part();
    }
    
    module elbow1() {
        part_and_female_connector() top_of() elbow12();
        top_of() rotate([-90, 0, 0]) connector_male();

    }
    
    module elbow2() {
        part_and_female_connector() bottom_of() elbow12();
        bottom_of() rotate([-90, 0, 0]) connector_male();
    }
    
    module straight() {
        rotate([90, 0, 0]) straight_part();
    }
        
    module valve1() {
        part_and_female_connector() top_of() valve_part();
    }
    
    module valve2() {
        rotate([0, 180, 0]) part_and_female_connector() bottom_of() valve_part();
    }
    
//    full_pipe();
//    elbow1();
//    rotate([180, 0, 0]) elbow2();
//    straight();
//    valve1();
//    valve2();
//    valve_handle();
}

function holder_h(od=global_od, factor=2, layer=0.2) = od/5 + sqrt(od*factor - id(od));

module holder(od=global_od, factor=2, layer=0.2) {
    id = id(od);

    h1 = od/5;
    h2 = sqrt(od*factor - id);
    h = holder_h(global_od, factor, layer);
    
    difference() {
        union() {
            cylinder(d = od*factor, h=h1);
            for (h = [0:layer:h2]) {
                d = od*factor - h*h;
                translate([0, 0, h+h1]) difference() {
                    cylinder(d = d, h=layer);
                    cylinder(d = id, h=layer);
                }
            }
            cylinder(d=od, h=h);
        }
        cylinder(d = id, h=h);
    }
}

module distribution_pipe() {
    function corner_h(od=global_od) = 40*scale + elbow_offset(od);
    function corner_offset(od=global_od) = elbow_offset(od);

    module corner(od = global_od) {
        pipe(40*scale);
        translate([0, 0, 40*scale]) ring(od);
        translate([0, elbow_offset(), 40*scale]) {
            elbow();
            translate([0, 0, elbow_offset()]) rotate([-90, 0, 0]) ring();
        }
    }

    holder();
    translate([0, 0, holder_h()]) corner();
    translate([0, corner_offset(), holder_h() + corner_h()]) rotate([-90, 0, 0]) union() {
            pipe(30*scale);
            translate([0, 0, 30*scale]) corner();
        }
    translate([0, corner_offset() + corner_h() + 30*scale, 0]) pipe(40*scale+holder_h());
    translate([0, corner_offset() + corner_h() + 30*scale, 0]) rotate([-180, 0, 0]) corner();
    translate([0, 30*scale+elbow_offset(), -corner_h()]) rotate([-90, 0, 0]) union() {
        holder();
        pipe(30*scale+holder_h());
    }
}

module distribution_pipe_part() {
    part_and_female_connector() top_of() rotate([0, -90, 0]) distribution_pipe();
}


distribution_pipe_part();