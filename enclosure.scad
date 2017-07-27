include <threads.scad>

module enclosure(L=115, W=78, H=34, thick=2.5, mount=12)
{
	module roundedsquare(r,w,h)
	{
		union()
		{
			translate([r,r]) circle(r=r, $fn=50);
			translate([r,w-r]) circle(r=r, $fn=50);
			translate([h-r,r]) circle(r=r, $fn=50);
			translate([h-r,w-r]) circle(r=r, $fn=50);
			translate([0,r]) square([h,w-(r*2)]);	
			translate([r,0]) square([h-(r*2),w]);
		}	
	}
	
	module mount()
	{
        union() {
           translate([0, 0, H-15-thick]) linear_extrude(height=thick) circle(r=mount/2, $fn=100);
           translate([0, 0, H-15]) M6_tube(D=mount, windings=16);
        }
	}

	difference()
	{	
	    linear_extrude(height=H) roundedsquare(r=thick*2,w=W,h=L);
		translate([thick, thick, thick]) linear_extrude(height=H+2) roundedsquare(r=thick,w=W-thick*2,h=L-thick*2);
    }
    
    translate([mount/2,W/2,0]) mount();
    translate([L-mount/2,W/2,0]) mount();
}

difference() {
    enclosure(L=115, W=78, H=60, thick=1.5);
    union() {
        translate([30, 3, 30]) rotate([90, 0, 0]) linear_extrude(height=5) circle(r=11.5/2, $fn=100); 
        translate([-1, 60, 40]) rotate([0, 90, 0]) linear_extrude(height=5) circle(r=14/2, $fn=100); 
        translate([115-1, 60, 40]) rotate([0, 90, 0]) linear_extrude(height=5) circle(r=14/2, $fn=100); 
    }
}
