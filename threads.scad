use <Threading.scad>

module M2_5_thread(windings = 16)
{
   Threading(pitch = 0.45, d=6, windings=windings, full=true);
}

module M2_5_nut(windings = 8)
{
   Threading(D=12, pitch = 0.45, d=4.5, windings=windings, full=true, $fn=6);
}

module M2_5_tube(D=12, windings = 8)
{
  Threading(D=D, pitch = 0.45, d=4.5, windings=windings, full=true, $fn=100);
}

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
