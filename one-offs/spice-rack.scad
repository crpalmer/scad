W=85;

step_depth=50;
step_lip=3.5;
step_lip_height=10;
step_height=40;
first_step=3.5;
wall=3.5;

module step(n)
{
    translate([0, n*(step_depth+step_lip), 0])
       union() {
           difference() {
               cube([W, step_depth+step_lip, first_step+n*step_height]);
               translate([wall, wall, 0]) cube([W-wall*2, step_depth+step_lip-wall, first_step+n*step_height - wall]);
               translate([0, step_depth/2, first_step+(n-0.5)*step_height]) rotate([0, 90, 0]) cylinder(d=4, h=W);
           }
           cube([W, step_lip, first_step+n*step_height+step_lip_height]);
       };
}

N=4;
for(i=[0:N-1]) step(i);
translate([0, N*(step_depth+step_lip), 0]) cube([W, wall, first_step+N*step_height]);