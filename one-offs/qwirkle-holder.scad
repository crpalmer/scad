
include <utils.scad>

//Scrabble letter holder
mm_inch = 25.4;
slot_angle = 30; //degrees
slot_height = .155 * mm_inch;

//Scrabble letter piece size:
letter_height = 19;
letter_width = 19;
letter_thick = 6;

//Holder Dimensions:
holder_length = 6 * (letter_width+.5);
holder_depth = 24;

//Little lip to keep your pieces from falling off
lip_dia = 0.125 * mm_inch;
lip_rad = lip_dia/2;

//Oversize over letter thickness by this much
slot_space = 0.025 * mm_inch;
slot_thick = slot_space + letter_thick;

lip_y = slot_height + sin(slot_angle) * (slot_thick + lip_dia);
lip_x = tan(slot_angle) * lip_y;
slot_offset = lip_x + cos(slot_angle) * (slot_thick + lip_dia);

//Set this so there's just enough room for a rounded lip on the top.
holder_height = slot_height + (holder_depth - slot_offset - (1 + 1/cos(slot_angle)) * lip_rad)/tan(slot_angle);

holder_height_to_bevel = holder_height + sin(slot_angle) * lip_rad;
holder_depth_to_bevel = holder_depth - (1 + cos(slot_angle)) * lip_rad;

frontBevel_angle = (90 - slot_angle)/2;
frontBevel_x = lip_rad/tan(frontBevel_angle);
frontBevel_y = lip_rad;

module end_bevels(){
    //End bevels
    hull(){
	//lower front
	translate([0, frontBevel_x, frontBevel_y])
	sphere(r = lip_rad, center=true, $fn = 50);    
	
	//lip
	translate([0,lip_x,lip_y])
	rotate([-slot_angle,0,0])
	translate([0,lip_rad,0])
	sphere(r = lip_rad, center=true, $fn = 50);
    }
    
    hull(){
	//lower front
	translate([0, frontBevel_x, frontBevel_y])
	sphere(r = lip_rad, center=true, $fn = 50);    
	
	//Just below lip ( so we don't have a lip on the side edge, the piece can hang over
	translate([0,lip_x,lip_y])
	rotate([-slot_angle,0,0])
	translate([0,lip_rad,-lip_rad])
	sphere(r = lip_rad, center=true, $fn = 50);
	
	//Bottom point inline with slot angle
	translate([0,
		lip_x - sin(slot_angle)* lip_rad + (lip_y - lip_rad - cos(slot_angle) * lip_rad)/tan(slot_angle),
		lip_rad])
	sphere(r = lip_rad, center=true, $fn = 50);
    }
    
    hull(){
	//lower rear
	translate([0, holder_depth - lip_rad,lip_rad])
	sphere(r=lip_rad, center=true, $fn = 50);
	
	//TopBevel
	translate([0, holder_depth - lip_rad, holder_height])
	sphere(r = lip_rad, center=true, $fn = 50);
	
	//Bottom point inline with downward angle
	translate([0, holder_depth - lip_rad -(tan(slot_angle) * (holder_height - lip_rad)),lip_rad])
	sphere(r = lip_rad, center=true, $fn = 50);
    }
}

rotate([-90,180,-90])
linear_extrude(height = holder_length, center = true, $fn = 50){
    union(){
	//Main tray
	difference(){
	    union(){
		square([holder_depth, holder_height]);
		square([holder_depth_to_bevel, holder_height_to_bevel]);
	    }
	    union(){
		mirror([1,0,0]){
		    //Remove a square int he lower rear corner to replace with a circle
		    translate([-holder_depth,0])
		    square([lip_rad,lip_rad]);
		    
		    //Make space for the front bevel
		    translate([-frontBevel_x,0])
		    rotate([0,0,-frontBevel_angle])
		    square([frontBevel_x + 1, lip_dia]);

		    //Dig out the slot for the letters
		    rotate([0,0,slot_angle])
		    square([holder_depth, holder_height * 2]);
		    translate([-slot_offset,slot_height,0])
		    rotate([0,0,slot_angle])    
		    square([holder_depth, holder_height * 2]);
		}
	    }
	}
	
	//Front Bevel
	translate([frontBevel_x, frontBevel_y])
	circle(r = lip_rad, center=true, $fn = 50);    

	//lip
	translate([lip_x,lip_y])
	rotate([0,0,-slot_angle])
	translate([lip_rad,0])
	circle(r = lip_rad, center=true, $fn = 50);
	
	//TopBevel
	translate([holder_depth - lip_rad, holder_height])
	circle(r = lip_rad, center=true, $fn = 50);    

	//lower rear corner bevel
	translate([holder_depth - lip_rad,lip_rad])
	circle(r=lip_rad, center=true, $fn = 50);
    }
}
translate([-holder_length/2, 0,0])
end_bevels();
mirror([1,0,0])
translate([-holder_length/2, 0,0])
end_bevels();

//Add 6 letters to give an idea
/*
//spacing between letters (1/2 space one ach side, equal space between)
spacing = (holder_length - (letter_width * 6))/6;

echo(holder_length,letter_width,spacing);

color("red"){
    translate([-holder_length/2, 0, 0])
    mirror([0,1,0])
    translate([0,-slot_offset,slot_height])
    rotate([slot_angle, 0, 0])    
    for(i=[0:5]){
	translate([spacing * (i + 0.5) + letter_width * i, 0, 0])
	cube([letter_width, letter_thick, letter_height]);
    }
}
*/