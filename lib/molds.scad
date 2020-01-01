// ************************
// *** 1 PART OPEN MOLD ***
// ************************


module 1_part_mold(h, wall=1.2, hull=true, bounding_box = false) {
    difference() {
        1_part_mold_form(h=h, wall=wall, hull=hull, bounding_box=bounding_box) children();
        children();
    }
}

module 1_part_mold_form(h, wall=1.2, hull=true, bounding_box=false) {
    module bounding_box() {
        // the extent of the children projection on x axis
        module xExtent() {
            hull() translate([0,0.5])
                projection() rotate([90,0,0])
                    linear_extrude(1) children();
        }
        
        module yExtent() {
            rotate([0, 0, -90]) xExtent() rotate([0, 0, 90]) children();
        }

        offset(-0.5) minkowski() {
            xExtent() children();
            yExtent() children();
        }
    }
    
    module conditional_hull() {
        if (hull) {
            hull() children();
        } else {
            children();
        }
    }

    module projected_form() {
        conditional_hull()
        projection()
        children();
    }
    
    module 2d_form() {
        if (bounding_box) {
            bounding_box() projected_form() children();
        } else {
            projected_form() children();
        }
    }

    linear_extrude(height = h) offset(delta = wall) 2d_form() children();
}


// ************************
// *** 2 PART OPEN MOLD ***
// ************************


module 2_part_open_mold_tabs(h, tabs, tab_size) {
    module do_tab(tab) {
        if (tab_size > 0) {
            translate(tab) rotate([0, 90, 0]) cylinder(d1 = tab_size, d2 = tab_size/2, h = tab_size);
        }
    }
    
    for (tab = tabs) {
        if (len(tab) == undef) {
            do_tab([0, tab, h/2]);
        } else if (len(tab) == 2) {
            do_tab([0, tab[0], tab[1]]);
        } else {
            do_tab(tab);
        }
    }
}

module 2_part_open_mold_form_left(h, tabs, cut_box = [100, 100], wall=10, hull=true, bounding_box = false, tab_size = 7.5) {
    difference() {
        1_part_mold_form(h, wall=wall, hull=hull, bounding_box=bounding_box) children();
        translate([0, -cut_box[1]/2]) cube([cut_box[0], cut_box[1], h]);
    }
    2_part_open_mold_tabs(h=h, tabs=tabs, tab_size = tab_size);
}

module 2_part_open_mold_form_right(h, tabs, cut_box = [100, 100], wall=10, hull=true, bounding_box = false, tab_size = 7.5) {
    difference() {
        intersection() {
            1_part_mold_form(h, wall=wall, hull=hull, bounding_box=bounding_box) children();
            translate([0, -cut_box[1]/2]) cube([cut_box[0], cut_box[1], h]);
        }
        2_part_open_mold_tabs(h=h, tabs=tabs, tab_size = tab_size + 0.2);
    }
}

module 2_part_open_mold_left(h, tabs, cut_box = [100, 100], wall=10, hull=true, bounding_box = false, tab_size = 7.5) {
    difference() {
        2_part_open_mold_form_left(h=h, tabs=tabs, cut_box=cut_box, wall=wall, hull=hull, bounding_box=bounding_box, tab_size=tab_size) children();
        children();
    }
    2_part_open_mold_tabs(h=h, tabs=tabs, tab_size = tab_size);
}

module 2_part_open_mold_right(h, tabs, cut_box = [100, 100], wall=10, hull=true, bounding_box = false, tab_size = 7.5) {
    difference() {
        2_part_open_mold_form_right(h=h, tabs=tabs, cut_box=cut_box, wall=wall, hull=hull, bounding_box=bounding_box, tab_size=tab_size) children();
        children();
    }
}

module 2_part_open_mold_box(h, wall=10, hull=true, bounding_box = false, box_wall = 2, delta = -0.1, box_width = 200, slot_d = 25) {
    module mold_form(height, offset) {
        linear_extrude(height = height) offset(delta = offset) projection() 1_part_mold_form(h=h, wall=wall, hull=hull, bounding_box=bounding_box) children();
    }
    
    difference() {
        mold_form(height = h + box_wall, offset = box_wall + delta) children();
        translate([0, 0, box_wall]) mold_form(height = h, offset = delta) children();
    }
}

// **************************
// *** 2 PART CLOSED MOLD ***
// **************************


module 2_part_mold_reference_tabs(tabs, h, center=[0, 0, 0], tab_size = 6) {
    for (tab = tabs) {
        translate(tab) if (tab == tabs[0]) {
            translate([-tab_size/2, -tab_size/2]) cube([tab_size, tab_size, h]);
        } else {
            cylinder(d = tab_size, h=h);
        }
    }
}

module 2_part_mold_bottom(tabs, parting_h, center=[0, 0, 0], wall=1.2, hull=true, pour_at, pour_h = 10, pour_d1 = 20, pour_d2 = 5) {
    h=parting_h+pour_h;
    difference() {
        1_part_mold_form(h=h, wall=wall, hull=hull)
            union() {
                children();
                2_part_mold_reference_tabs(tabs=tabs, h=h, center=center);
            }
        translate([0, 0, pour_h]) children();
        translate([0, 0, h - 10]) 2_part_mold_reference_tabs(tabs=tabs, h= 10, center=center);
        translate(pour_at == undef ? center : pour_at) cylinder(d1 = pour_d1, d2 = pour_d2, h = pour_h);
    }
}

module 2_part_mold_top(tabs, obj_h, parting_h, top_h = 10, center=[0, 0, 0], wall=1.2, hull=true, tab_size = 6, pour_at, pour_d1 = 20, pour_d2 = 5) {
    h=obj_h - parting_h + wall;
    rotate([0, 180, 0]) difference() {
        1_part_mold_form(h=h, wall=wall, hull=hull)
            union() {
                children();
                2_part_mold_reference_tabs(tab_size = tab_size+wall*2, tabs=tabs, h=h, center=center);
            }
        translate([0, 0, -parting_h]) children();
        2_part_mold_reference_tabs(tab_size = tab_size, tabs=tabs, h=10, center=center);
        }
}
