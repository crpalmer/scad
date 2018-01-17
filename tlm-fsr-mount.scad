include <utils_threads.scad>

corner_H=10;
corner_L=20;
corner_W=4;
screw_mount_W=15;
screw_mount_L=corner_W+23.7+M5_through_hole_d()*1.5;
H=6;

module corner() {
    arm = [corner_L*sin(60), corner_L*cos(60)];
    arm2 = [-arm[0], arm[1] ];
    
    points = [
        [0, -corner_W],
        arm+[corner_W, -corner_W],
        arm,
        [0, 0],
        arm2,
        arm2-[corner_W, corner_W]
    ];
     
    linear_extrude(height=corner_H+H) polygon(points);
}

module screw_mount(screw_H=4) {
    W=screw_mount_W;
    L=screw_mount_L;
    
    points = [
        [ 0, 0 ],
        [ W/2*sin(60), W/2*cos(60) ],
        [ W/2, L],
        [ -W/2, L],
        [ -W/2*sin(60), W/2*cos(60) ]
    ];

    difference() {
        linear_extrude(height=H) polygon(points);
        echo(L-M5_through_hole_d()*1.5);
        translate([0, L-M5_through_hole_d()*1.5, 0]) cylinder(d=M5_through_hole_d(), h=H, $fn=64);
        translate([0, L-M5_through_hole_d()*1.5, H-screw_H]) cylinder(d=10, h=H, $fn=64);
    }
}

module fsr_mount() {
    fsr_D=19;
    fsr_H=3.0 - 0.5;
    lead_W=6;
    lead_L=30;
    W=fsr_D+4;
    L=2+fsr_D+lead_L;
    H=4;
    gateway_W=9;
    gateway_L=7;
    difference() {
        translate([-W/2, 0, 0]) cube([W, L, 6]);
        translate([0, 2+fsr_D/2, 3]) cylinder(d=fsr_D, h=1000);
        translate([-lead_W/2, 2+fsr_D/2, 3]) cube([lead_W, lead_L+fsr_D/2, 1000]);
        translate([-gateway_W/2, 2+fsr_D/2, 3]) cube([gateway_W, gateway_L+fsr_D/2, 1000]);
    }
}

union() {
    translate([0, corner_W, 0]) corner();
    screw_mount();
    # If I don't include the -.1 the slicer thinks they aren't attached
    translate([0, screw_mount_L-.1, 0]) fsr_mount();
}