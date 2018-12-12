include <utils.scad>

small_drawer = [ 55, 140, 39 ];
divider_delta = 5;

wall = 1.2;

module empty_drawer(drawer = small_drawer) {
    handle = [ drawer[0]/2, 12, 10 ];
    module box() {
        difference() {
            rounded_cube(drawer);
            translate([wall, wall, wall]) rounded_cube(drawer - wall*[2,2,1]);
        }
    }
    
    module handle() {
        difference() {
            linear_extrude(height = handle[2], scale=[1, .1 / handle[1] ]) rounded_square(handle+[0, wall, 0]);
            translate([wall, wall]) linear_extrude(height = handle[2]-wall, scale=[1, .1 / handle[1]]) rounded_square(handle - wall*[2, 2, 1]);
        }
    }
    
    box();
    translate([drawer[0]/2 - handle[0]/2, wall, drawer[2]/2])
    rotate([0, 180, 180]) handle();
}

module 2_compartment_drawer(drawer) {
    empty_drawer(drawer=drawer);
    translate([0, drawer[1]/2 - wall/2, 0]) cube([drawer[0], wall, drawer[2]-divider_delta]);
}

module 4_compartment_drawer(drawer) {
    2_compartment_drawer(drawer=drawer);
    translate([drawer[0]/2-wall/2, 0, 0]) cube([wall, drawer[1], drawer[2]-divider_delta]);
}

module 6_compartment_drawer(drawer) {
    4_compartment_drawer(drawer=drawer);
    translate([0, 1/4*drawer[1]-wall/2, 0]) cube([drawer[0], wall, drawer[2]-divider_delta]);
}

module 8_compartment_drawer(drawer) {
    4_compartment_drawer(drawer=drawer);
    for (y = [1/4, 3/4]) {
        translate([0, y*drawer[1]-wall/2, 0]) cube([drawer[0], wall, drawer[2]-divider_delta]);
    }
}

2_compartment_drawer(small_drawer);
