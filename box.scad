include <tabs.scad>;

ww = 55;
ow = ww + 2 * TW;
p = (ww - 41) / 2;
sp = (ww - 45) / 2;
bp = 9;
s = (41 - bp) / 2;

h = 4*TW;

module top() {
    difference() {
        square(ww);
        for (xi = [0:1]) {
            x = p + xi * (s + bp);
            sx = sp + xi * 45;
            for (yi = [0:1]) {
                y = p + yi * (s + bp);
                sy = sp + yi * 45;

                //offset(0.5)
                translate([x, y])
                square(s);

                translate([sx, sy])
                circle(r=s440, $fn=32);

            }
        }
    }

    translate([-TW, -TW, 0])
    tabs(3, ow, odd=0);
    translate([-TW, ww, 0])
    tabs(3, ow, odd=0);

    translate([-TW, -TW])
    tabs(3, ow, odd=0, vert=1);
    translate([ww, -TW])
    tabs(3, ow, odd=0, vert=1);
}

module side(odd=0) {
    translate([0, -TW])
    difference() {
        square([ww, h+2*TW]);
        translate([-TW, h+TW])
        tabs(3, ow, odd=0); // Top
        translate([-TW, 0])
        tabs(3, ow, odd=0); // Bottom
    }
    translate([-TW, -TW])
    tabs(2, h+2*TW, odd=odd, vert=1); // Left
    translate([ww, -TW])
    tabs(2, h+2*TW, odd=odd, vert=1); // Right
}

module bottom() {
    square(ww);
    translate([-TW, -TW, 0])
    tabs(3, ow, odd=0);
    translate([-TW, ww, 0])
    tabs(3, ow, odd=0);

    translate([-TW, -TW])
    tabs(3, ow, odd=0, vert=1);
    translate([ww, -TW])
    tabs(3, ow, odd=0, vert=1);
}

function gray(n) = [n, n, n];

module show3d() {
    color(gray(0.5))
    linear_extrude(height=TW)
    top();

    color(gray(0.3))
    translate([0, 0, -h])
    rotate([90, 0, 0])
    linear_extrude(height=TW)
    side();

    color(gray(0.4))
    translate([0, ow-TW, -h])
    rotate([90, 0, 0])
    linear_extrude(height=TW)
    side();

    translate([-TW, 0, -h])
    rotate([90, 0, 90])
    linear_extrude(height=TW)
    side(odd=1);

    translate([ww, 0, -h])
    rotate([90, 0, 90])
    linear_extrude(height=TW)
    difference() {
        side(odd=1);
        translate([(ww-12.04)/2, 3])
        square([12.04, 10.60]);
    }

    color(gray(0.9))
    translate([ww-16.10+TW, (ww-12.04)/2, -h+3])
    cube([16.10, 12.04, 10.60]);

    color(gray(0.2))
    translate([0, 0, -h-TW])
    linear_extrude(height=TW)
    bottom();
}

P = 1;

module show2d() {
    top();

    wp = ww + 2*TW + P;

    translate([wp, 0])
    top();

    translate([0, wp])
    bottom();

    translate([wp, wp])
    bottom();

    translate([wp, wp + 2 * (h + 2*TW + P)])
    side(odd=1);

    translate([0, wp + 2 * (h + 2*TW + P)])
    difference() {
        side(odd=1);
        translate([(ww-12.04)/2, 3])
        square([12.04, 10.60]);
    }

    translate([h + 2*wp, 0])
    rotate([0, 0, 90])
    side();

    translate([h + 2*wp, wp])
    rotate([0, 0, 90])
    side();


    /* translate([-TW, 0]) */
    /* side(odd=1); */

    /* translate([ww, 0]) */
}

offset(kerf)
show2d();
