W=85;

step_depth=50;
step_lip=3.5;
step_lip_height=10;
step_height=40;
first_step=3.5;
wall=3.5;

module arch(v)
{
    x=v[0];
    y=v[1];
    z=v[2];
    hyp=x/sqrt(2);
    union() {
        cube([x, y, z - x]);
        translate([x/2, 0, z-x]) rotate([0, 45, 0]) translate([-hyp/2, 0, -hyp/2]) cube([hyp, y, hyp]);
    };
}

module step(n)
{
    H=first_step+n*step_height;
    translate([0, n*(step_depth+step_lip), 0])
    union() {
        cube([W, step_depth+step_lip*2, H]);
        translate([0, 0, H]) cube([W, step_lip, step_lip_height]);
        translate([0, step_depth+step_lip, H]) cube([W, step_lip, step_lip_height]);
    };
}

module cut_front(n) {
    H=first_step+n*step_height;
    translate([0, n*(step_depth+step_lip)+step_lip, 0])
    if (n >= 2) {
        for (i=[0:1])
            translate([W/5*(i*2+1), 0, 0])
            arch([W/5, step_depth+step_lip*2, H-step_height/2]);
    };
}

module cut_side(n) {
    H=first_step+n*step_height;
    translate([-W, (n+1)*(step_depth+step_lip), 0])
    rotate([0, 0, -90]) arch([step_depth-step_lip, W*2, H+step_height/2]);
}

module doit() {
N=4;
difference() {
    union() {
        for(i=[1:N-1]) step(i);
    };
    for(i=[0:N-1]) cut_side(i);
    for(i=[0:N-1]) cut_front(i);
};
}

doit();
//arch([2, 3, 8]);