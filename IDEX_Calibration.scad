/*
Calibration print for tool offsets for an Dual Independent X axis (IDEX) printer such as the experimental BigBox Idex:
https://forum.e3d-online.com/index.php?threads/bigbox-dual-x-carriages.2184/

This use this to generate two seperate STL files, I with regular spaced lines on X and Y
1 with varyingly spaced lines.

Selecting which lines on X and Y most closely match will alow you to determine the tool offset accurately.
e.g.
3 lines spaced 10 mm apart, located with 3 lines centered at the middle and spaced at 9.5 and 10.5 either side. If the 10.5 line is lined up the the second head is 0.5-, if the 9.5 line lines up it is 0.5+ of the center line. For best results extend the number of lines and reduce the size of the spacing.

You may need a course and fine test, 1 to get within 0.5mm and one to get <0.05mm

*/

numLines = 11; //number of calibration lines must be an odd number
lineSpacing = 5; //line spacing in mm for the regular lines
variation = 0.1; // step for varying lines
lineHeight = 2.2; //set to your calibration layer height.
lineWidth = 0.42; //set to the first layer line width your slicer generates
lineLength = 30;  //the length of the printed lines
gap=1;


module regularGrid() {
    for(i=[-((numLines-1)/2) : 1 : ((numLines-1)/2)]){
        translate([i*lineSpacing ,gap/2,lineHeight/2])
        color("black") 
        hull() {
            cube([lineWidth,0.1,lineHeight],center=true);
            translate([0,lineLength,0])
                cube([lineSpacing/2-0.2,0.1,lineHeight],center=true);
        }
    }
    
}

module varyingGrid() {
    for(i=[-((numLines-1)/2): 1 : ((numLines-1)/2)]){
        translate([i*lineSpacing-variation*i,-gap/2,lineHeight/2])
        color("red")
        hull(){
            cube([lineWidth,0.1,lineHeight],center=true);
            translate([0,-lineLength,0])
                cube([lineSpacing/2-0.2,0.1,lineHeight],center=true);
        }
    }
    
}

//create STLs for regular and varying grid seperately anc combine them in your slicer
//regularGrid();
varyingGrid();


