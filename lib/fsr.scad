module fsr2d(probe=true, lead=true) {
    fsr_D=19;
    lead_W=6;
    lead_L=30;
    gateway_W=9;
    gateway_L=7;
    union() {
        if (probe) circle(d=fsr_D);
        if (lead) {
            translate([-gateway_W/2, fsr_D/2 -2 , 0]) square([gateway_W, gateway_L + 2]);
            translate([-lead_W/2, fsr_D/2 - 2, 0]) square([lead_W, lead_L + 2]);
        }
    }
}

module fsr_cutout() {
    translate([0, 0, -1.2]) linear_extrude() fsr2d();
    translate([0, 0, -2.75]) linear_extrude() fsr2d(probe = false);
}
