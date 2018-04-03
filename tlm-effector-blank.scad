// Tevo Little Monster end-effector
// Markham Thomas   Jan 26th 2018
// Update: Feb 4th, 2018 properly fix bltouch width and moved offset closer to edge
// Update: Feb 3rd, 2018 fixed bltouch bolt width
// Update: Jan 27th changed to thru bolts + nuts and clamp for J-head
// rod screws:  6x of M4x25mm with nuts
// effector clamp screws:  M2.5 x 16 (14mm would work also)
// bltouch needs M3 x 12mm brass standoff and M3 x 10mm screw with lock-nut or nut
$fn = 116;     // if you have issues getting the J head into the cutout increase this

module blank_effector()
{
    
edist_flats = 54;
edist_across = 80;
e_thickness = 8;
sflat_wide = 16;
sflat_deep = 12;
bflat_wide = 33.5;
bflat_deep = 13;
jhead_round = 30;  
jhead_high = 5.96;     // fit E3Dv6 with shrouded fan
jhead_id = 16;    // hole size 
jhead_id_fix = 0.3;  // hole size + this fix to reduce amount of filing needed
jhead_inner_r = 12.2 + jhead_id_fix;   // jhead inner lip diameter

jhead_ring = jhead_round - jhead_inner_r;   // thickness of the j-head clamp ring

bar_w =7;       // width of rod connector flange that the screw hole sits on
// fan shrouds are measured from back small cutout, base of right rod connector contact point down
fan_shroud_hole_off = 14;     // the 2 holes at back of effector (offset from back small cutout)
fan_shroud_hole_space = 32;   // from back to shroud holes to front two
bltouch_hole_off = 5;           // from back small cutout inside wall to bltouch hole (y dist)
bltouch_hole_space = 18;        // distance between bltouch screws
rod_screw_base_d1 = e_thickness;
rod_screw_base_d2 = e_thickness-1;
rod_screw_base_h = 8;       // I measured 7mm but 8 seems to give a better "bite" for the m4 screw
rod_screw = 3.375; // 4;

// make a big square we can cut material from
module base_plate() {
    // make a square centered around origin to cut out pieces of
    difference() {
        translate([-edist_across*1.2/2,-edist_across*1.2/2,0]) cube([edist_across*1.2,edist_across*1.2,e_thickness]);
//        // back right hole
//        translate([sflat_wide/2+bar_w,edist_across/2-sflat_deep-fan_shroud_hole_off,0]) cylinder(h=e_thickness,r=1.5);
//        // front right hole
//        translate([sflat_wide/2+bar_w,-1*(edist_across/2-sflat_deep-fan_shroud_hole_off),0]) cylinder(h=e_thickness,r=1.5);        
//        // back left hole
//        translate([-1*(sflat_wide/2+bar_w),edist_across/2-sflat_deep-fan_shroud_hole_off,0]) cylinder(h=e_thickness,r=1.5);
//        // front left hole
//        translate([-1*(sflat_wide/2+bar_w),-1*(edist_across/2-sflat_deep-fan_shroud_hole_off),0]) cylinder(h=e_thickness,r=1.5);
//        // bltouch back right hole
//        translate([bltouch_hole_space/2,edist_across/2-sflat_deep-bltouch_hole_off,0]) cylinder(h=e_thickness,r=1.5);
//        // bltouch back left hole
//        translate([-1*(bltouch_hole_space/2),edist_across/2-sflat_deep-bltouch_hole_off,0]) cylinder(h=e_thickness,r=1.5);
    }
}

// generate the objects that will make the cuts out of the base_plate
module cuts_outer() {
    // make the first cut, a small sized cutout on the Y axis
    translate([-sflat_wide/2,edist_across/2-sflat_deep,0]) cube([sflat_wide,sflat_deep*3,e_thickness]);
    // trim the previous small flat up a bit
    translate([-1*(sflat_wide*3+sflat_wide/2+bar_w),edist_across/2-sflat_deep,0]) cube([sflat_wide*3,sflat_deep*3,e_thickness]);
    // keep trimming the first small flat
    translate([bar_w+sflat_wide/2,edist_across/2-sflat_deep,0]) cube([sflat_wide*3,sflat_deep*2,e_thickness]);
    // 1st large flat is 60 deg off Y axis, counter-clockwise
    rotate(a=60,v=[0,0,1]) translate([-bflat_wide/2,edist_across/2-bflat_deep,0]) cube([bflat_wide,bflat_deep*3,e_thickness]);
    // final large flat is another 120 deg from previous (continuing counter-clockwise)
    rotate(a=300,v=[0,0,1]) translate([-bflat_wide/2,edist_across/2-bflat_deep,0]) cube([bflat_wide,bflat_deep*3,e_thickness]);
    // trim outer bars
    translate([-sflat_wide*1.2,edist_across/2,0]) cube([sflat_wide*3,sflat_deep*3,e_thickness]);
    // left side holes, rod holes go thru effector flanges too
    translate([-1*(sflat_wide/2+4),edist_across/2-sflat_deep/2,e_thickness/2]) rotate(a=-90,v=[0,1,0]) cylinder(h=rod_screw_base_h,r1=rod_screw/2,r2=rod_screw/2,center=true);
    // right side holes, rod holes go thru effector flanges too
    translate([(sflat_wide/2+4),edist_across/2-sflat_deep/2,e_thickness/2]) rotate(a=-90,v=[0,1,0]) cylinder(h=rod_screw_base_h,r1=rod_screw/2,r2=rod_screw/2,center=true);

}

module cuts_inner() {
    // cut out the center
    cylinder(h=e_thickness,r=(jhead_id+jhead_id_fix)/2);
    translate([0,0,e_thickness-2]) cylinder(h=jhead_high,r=jhead_round/2+3);
    translate([-1*(jhead_id/2+2.5),5,0]) cylinder(h=e_thickness,r=1.5);
    translate([(jhead_id/2+2.5),5,0]) cylinder(h=e_thickness,r=1.5);
    translate([-1*(jhead_id/2+2.5),5-13,0]) cylinder(h=e_thickness,r=1.5);
    translate([(jhead_id/2+2.5),5-13,0]) cylinder(h=e_thickness,r=1.5);
}

// base rod connector
module rod_conn(hole) {
    if (hole) {
        cylinder(h=rod_screw_base_h,r1=rod_screw/2,r2=rod_screw/2,center=true);
    } else {
        cylinder(h=rod_screw_base_h,r1=rod_screw_base_d1/2,r2=rod_screw_base_d2/2,center=true);
    }
}

// left-hand side connector
module rod_conn_l(hole) {
    translate([-1*(sflat_wide+2),edist_across/2-sflat_deep/2,e_thickness/2]) rotate(a=-90,v=[0,1,0]) rod_conn(hole);
}
// cut out the hole for left connector
module rod_left() {
    difference() {
        rod_conn_l(false);
        rod_conn_l(true);
    }
}   

// right hand side connector
module rod_conn_r(hole) {
    translate([1*(sflat_wide+2),edist_across/2-sflat_deep/2,e_thickness/2]) rotate(a=90,v=[0,1,0]) rod_conn(hole);
}

// cut out the hole for right connector
module rod_right() {
    difference() {
        rod_conn_r(false);
        rod_conn_r(true);
    }
}   

// rotate objects into place after doing the cuts
module cut_out_plate() {
    difference () {
        base_plate();
        cuts_outer();
        rotate(a=120,v=[0,0,1]) cuts_outer();
        rotate(a=240,v=[0,0,1]) cuts_outer();
//        cuts_inner();
    }
}
module jhead_clamp() {
    difference() {
        //circle at top of effector where J-head clip goes
        cylinder(h=jhead_high,r=jhead_round/2+3);
        cylinder(h=jhead_high,r=jhead_inner_r/2);
    }
}

// left half
module left_clamp() {
    intersection() { 
        jhead_clamp();
        translate([-25,-50, 0]) cube([50,50,50]);
    }
    translate([jhead_inner_r/2,0,0]) cube([jhead_ring-5.8,jhead_round/3,jhead_high]);
    translate([-1*(jhead_inner_r+5.2),0,0]) cube([jhead_ring-5.8,jhead_round/3,jhead_high]);
}

module v6_clamp() {
    nut_cutout = 5 / 2 + 0.4;  // my M2.5 nuts were 5mm across, give a tiny bit of pad
    difference() {
        left_clamp();
        // bolt holes on the C clamp
        translate([-1*(jhead_id/2+2.5),5,0]) cylinder(h=jhead_high,r=1.5);
        // nut cutout for the above bolt hole
        translate([-1*(jhead_id/2+2.5),5,jhead_high-2]) cylinder(h=2,r=nut_cutout,$fn=6);
        translate([(jhead_id/2+2.5),5,0]) cylinder(h=jhead_high,r=1.5);
        // nut cutout for the above bolt hole
        translate([(jhead_id/2+2.5),5,jhead_high-2]) cylinder(h=2,r=nut_cutout, $fn=6);
        translate([-1*(jhead_id/2+2.5),5-13,0]) cylinder(h=jhead_high,r=1.5);
        // nut cutout
        translate([-1*(jhead_id/2+2.5),5-13,jhead_high-2]) cylinder(h=2,r=nut_cutout, $fn=6);
        translate([(jhead_id/2+2.5),5-13,0]) cylinder(h=jhead_high,r=1.5);
        // nut cutout
        translate([(jhead_id/2+2.5),5-13,jhead_high-2]) cylinder(h=2,r=nut_cutout, $fn=6);
        
        }
}
    
module effector() {
    // cut out the baseplate
    cut_out_plate();
    // generate all the left side connectors
    rod_left();
    rotate(a=120,v=[0,0,1]) rod_left();
    rotate(a=240,v=[0,0,1]) rod_left();
    // generate all the right side connectors
    rod_right();
    rotate(a=120,v=[0,0,1]) rod_right();
    rotate(a=240,v=[0,0,1]) rod_right();
}
 
effector();
//translate([65,jhead_round/2,0]) v6_clamp();
}
