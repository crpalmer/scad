mm_per_inch=4;
scale_pct=45/65.5;

echo(scale_pct);

board_thick=0.75 * mm_per_inch * scale_pct;

head_w=  14   * mm_per_inch * scale_pct;
head_l=   17   * mm_per_inch * scale_pct;
chest_w= 28    * mm_per_inch * scale_pct;
total_l=   65.5  * mm_per_inch * scale_pct;
foot_w=  14    * mm_per_inch * scale_pct;
height=   14    * mm_per_inch * scale_pct;

echo(head_w/mm_per_inch);
echo(chest_w / mm_per_inch);
echo(total_l/mm_per_inch);
echo(height/mm_per_inch);

module base() {
    linear_extrude(height=height) translate([-total_l/2, 0, 0]) polygon(points=[ [0, head_w/2], [head_l, chest_w/2], [total_l, foot_w/2], [total_l, -foot_w/2], [head_l, -chest_w/2], [0, -head_w/2], [0, head_w/2] ]);
}

difference() {
  base();
  translate([0, 0, board_thick]) scale([1 - board_thick*2 / total_l, 1 - board_thick*2 / chest_w, 1]) base();
};