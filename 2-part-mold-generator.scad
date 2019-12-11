/*************************************************
 Parametric two-part mold generator
 Author: Jason Webb
 Website: http://cs.unk.edu/~webb
 Last update: 10/1/2012

 A parametric two-part mold generator that constructs two-
 part molds with registration marks based on STL files.

 USAGE:
 - Update the OBJECT_* variables to reflect the actual size
   of your STL model
 - Update the object_* variables to import, rotate, translate
   and scale your STL model to center and situation your
   model as you wish.

 TIPS:
 - Try to avoid undercuts. They can print just fine, but will
   make casting more difficult / limited.
 - Sometimes a model works better as a mold when the
   seam line is in a different spot - use the object_*
   variables to create as simple a mold as you can.
*************************************************/
// Dimensions of your STL object
OBJECT_WIDTH = 50;	// Measured along X axis
OBJECT_HEIGHT = 50;	// Measured along Y axis
OBJECT_DEPTH = 60;	// Measured along Z axis

// STL file and transformation variables
object_filename = "Sample inputs/supershape-2.stl";
object_rotation_vector = [90,0,0];
object_translation_vector = [0,OBJECT_HEIGHT/2-4,0];
object_scale_factor = 1;

// Mold-related variables
width_margin = 10;		// Margin along X axis
height_margin = 10;		// Margin along Y axis
depth_margin = 10;		// Margin along Z axis

// Pour hole variables
pour_hole_translate = [0,-1.3,OBJECT_DEPTH/2];
pour_hole_r1 = 2;
pour_hole_r2 = 10;
pour_hole_height = 10;

side_by_side();

/****************************************
 Rotate and place both halves side by side 
 along the X axis for easy single-plate printing
*****************************************/
module side_by_side() {
	// Rotate about the Z axis to align parts with X axis - helps when printing
	rotate(a = [0,0,90]) {
		// Scoot the left half over a bit
		translate(v = [0, -OBJECT_HEIGHT+height_margin, OBJECT_DEPTH/2+depth_margin])
			bottom_half();
		
		// Rotate the top half, then scoot it over a bit
		rotate(a = [0,180,0])
			translate(v = [0, OBJECT_HEIGHT-height_margin, -OBJECT_DEPTH/2-depth_margin])
				top_half();	
	}
}

/*******************************************
 Bottom half of the mold
********************************************/
module bottom_half() {
	// Create the mold form with negative keys
	difference() {

		// Create the basic mold form by subtracting the STL from a cube half it's size
		difference() {
			translate(v = [-OBJECT_WIDTH/2-width_margin,-OBJECT_HEIGHT/2-height_margin,-OBJECT_DEPTH/2-depth_margin])
				cube(size = [OBJECT_WIDTH+width_margin*2,OBJECT_HEIGHT+height_margin*2,OBJECT_DEPTH/2+depth_margin]);
	
			translate(v = object_translation_vector)
				rotate(object_rotation_vector)
					scale(object_scale_factor)
						import( object_filename );
		}

		// Negative key 1
		translate(v = [-OBJECT_WIDTH/2, -OBJECT_HEIGHT/2, 0])
			sphere(r = 4.1, $fn = 30);

		// Negative key 2
		translate(v = [OBJECT_WIDTH/2, OBJECT_HEIGHT/2, 0])
			sphere(r = 4.1, $fn = 30);
	}

	// Positive key 1
	translate(v = [-OBJECT_WIDTH/2, OBJECT_HEIGHT/2, 0])
		sphere(r = 4, $fn = 30);

	// Positive master key
	translate(v = [OBJECT_WIDTH/2, -OBJECT_HEIGHT/2, 0])
		cube(size = [6,6,4], center = true);
}

/*******************************************
 Top half of the mold
********************************************/
module top_half() {
	// Create the mold form with negative keys
	difference() {

		// Create the mold form by subtracting the STL from a cube half it's size
		difference() {
			translate(v = [-OBJECT_WIDTH/2-width_margin,-OBJECT_HEIGHT/2-height_margin,0])
				cube(size = [OBJECT_WIDTH+width_margin*2,OBJECT_HEIGHT+height_margin*2,OBJECT_DEPTH/2+depth_margin]);

			translate(v = object_translation_vector)
				rotate(object_rotation_vector)
					scale(object_scale_factor)
						import( object_filename );
		}

		// Negative master key
		translate(v = [OBJECT_WIDTH/2, -OBJECT_HEIGHT/2, 0])
			cube(size = [6.4,6.4,4], center = true);

		// Negative key 2
		translate(v = [-OBJECT_WIDTH/2, OBJECT_HEIGHT/2, 0])
			sphere(r = 4.1, $fn = 30);

		// Pour hole
		translate(pour_hole_translate)
			cylinder(pour_hole_height, pour_hole_r1, pour_hole_r2);
	}

	// Positive key 1
	translate(v = [OBJECT_WIDTH/2, OBJECT_HEIGHT/2, 0])
		sphere(r = 4, $fn = 30);

	// Positive key 2
	translate(v = [-OBJECT_WIDTH/2, -OBJECT_HEIGHT/2, 0])
		sphere(r = 4, $fn = 30);
}
