girls = [ "ADELENA", "AMELIA", "ARIANA", "ASHLEY", "EDIE", "ELLEN", "ELLIOT", "HARPER", "JOSIE", "JULIA", "JULIET", "KIMANI", "KIT", "LENA", "LUISA", "MAE", "NAOMI", "RACHEL", "ROXIE", "PRIYASHA", "SYLVIE L.", "SYLVIE W." ];


width=290 / 2;
height = 270 / 7;

page = 1;
for (girl_i = [0:10]) {
    girl = girls[page*11 + girl_i];
    x = girl_i > 7 ? (165 + (girl_i - 7)* 35) : 10;
    y = girl_i > 7 ? 290 : (girl_i * height);
    angle = girl_i > 7 ? -90 : 0;
    echo([x, y, angle]);
    translate([x, y]) rotate([0, 0, angle]) text(text=girl, font="Sherwood:style=Regular", size=31);
}
