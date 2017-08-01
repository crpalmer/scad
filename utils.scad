include <utils_threads.scad>

module rounded_square(size, r=1) {
    x=size[0];
    y=size[1];
    union() {
	translate([r,r]) circle(r=r, $fn=50);
	translate([r,y-r]) circle(r=r, $fn=50);
	translate([x-r,r]) circle(r=r, $fn=50);
	translate([x-r,y-r]) circle(r=r, $fn=50);
	translate([0,r]) square([x,y-(r*2)]);
	translate([r,0]) square([x-(r*2),y]);
    }
}

module rounded_cube(size, r=1) {
    linear_extrude(height=size[2]) rounded_square(size);
}
