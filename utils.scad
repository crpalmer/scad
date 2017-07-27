module rounded_square(r,w,h) {
    union() {
	translate([r,r]) circle(r=r, $fn=50);
	translate([r,w-r]) circle(r=r, $fn=50);
	translate([h-r,r]) circle(r=r, $fn=50);
	translate([h-r,w-r]) circle(r=r, $fn=50);
	translate([0,r]) square([h,w-(r*2)]);	
	translate([r,0]) square([h-(r*2),w]);
    }	
}
