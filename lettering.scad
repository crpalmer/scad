include <utils.scad>

module mytext2d(string, font="OptimusPrinceps") {
    resize([min(270, len(string) * 59), inch_to_mm(4.5)]) text(string, font=font, size=inch_to_mm(5), valign="bottom");
}

module mytext(string) {
    linear_extrude(height=2.5) mytext2d(string);
}

//mytext("LOWER");
//mytext2d("LOWER");
//mytext("SCHOOL");
//mytext2d("SCHOOL");

//mytext("LOBBY");
//mytext2d("LOBBY");
//mytext("C. 2017");
//mytext2d("C. 2017");

//mytext("ARBUT");
//mytext2d("ARBUT");
//mytext("HNOT");
//mytext2d("HNOT");

//mytext("HOUSE");
//mytext2d("HOUSE");
//mytext("C. 1959");
//mytext2d("C. 1959");
//mytext("T.5E");

//mytext("FIRST");
//mytext2d("FIRST");
//mytext("GRADE");
//mytext2d("GRADE");

//mytext("CLASS");
//mytext2d("CLASS");
//mytext("ROOM");
//mytext2d("ROOM");

//mytext("C. 2017");
//mytext2d("C. 2017");

//mytext("MILLE");
//mytext2d("MILLE");
//mytext("NNIUM");
//mytext2d("NNIUM");

//mytext("DINER");
//mytext2d("DINER");
//mytext("C. 2000");
//mytext2d("C. 2000");

//mytext("CAFE");
//mytext2d("CAFE");
//mytext("TERIA");
//mytext2d("TERIA");

//mytext("C. 2017");
//mytext2d("C. 2017");

//mytext("MIDDLE");
//mytext2d("MIDDLE");
//mytext("SCHOOL");
//mytext2d("SCHOOL");

//mytext("HOUSE");
//mytext2d("HOUSE");
//mytext("GAMES");
//mytext2d("GAMES");

//mytext("C. 2013");
//mytext2d("C. 2013");
//mytext("-TODAY");
mytext2d("-TODAY");
