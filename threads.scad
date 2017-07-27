use <Threading.scad>

module M6_thread(windings = 16)
{
   Threading(pitch = 1, d=6, windings=windings, full=true);
}

module M6_nut(windings = 8)
{
   Threading(D=12, pitch = 1, d=6, windings=windings, full=true, $fn=6);  
}

module M6_tube(D=12, windings = 8)
{
  Threading(D=D, pitch = 1, d=6, windings=windings, full=true, $fn=100);  
}
