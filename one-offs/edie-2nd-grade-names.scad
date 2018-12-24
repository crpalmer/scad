girls = [ "ADELENA", "AMELIA", "ARIANA", "ASHLEY", "EDIE", "ELLEN", "ELLIOT", "HARPER", "JOSIE", "JULIA", "JULIET", "KIMANI", "KIT", "LENA", "LUISA", "MAE", "NAOMI", "RACHEL", "ROXIE", "PRIYASHA", "SYLVIE L.", "SYLVIE W." ];


width=290 / 2;
height = 270 / 11;

page = 0;
for (girl_i = [0:21]) {
    girl = girls[page*11 + girl_i];
    x = 10 + (girl_i % 2) * width;
    y = 10 + floor(girl_i / 2) * height;
    angle = 0;
    echo([x, y, angle]);
    translate([x, y]) rotate([0, 0, angle]) text(text=girl, font="Sherwood:style=Regular", size=15);
}
