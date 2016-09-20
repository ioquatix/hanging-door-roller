
use <bolts.scad>;
use <zcube.scad>;

thickness = 12;
length = 100;
height = 50;

roller_outset = 8;

module lateral_holes() {
	//for (i=[0:2]) {
		rotate(180, [0, 0, 1]) rotate(90, [1, 0, 0]) bolt(4, 30, 10);
	//}
}

module roller(h=8) {
	translate([0, h/2, height]) rotate(90, [1, 0, 0]) cylinder(d=30,h=h);
}

module bracket() {
	render() union() {
		translate([0, roller_outset, 0]) difference() {
			union() {
				translate([0, thickness/2, 0]) hull() {
					zcube([length, thickness, thickness]);
					translate([0, 0, height]) zcube([25, thickness, thickness]);
				}
				
				translate([0, 0, height]) rotate(90, [1, 0, 0]) cylinder(r2=9/2, r1=thickness,h=4);
			}
			
			translate([0, thickness, height]) rotate(90, [1, 0, 0]) cylinder(d=8,h=thickness+4);
		}
		
		//zcube([length, thickness*2, thickness]);
	}
}

module attachment() {
	render() translate([0, roller_outset+thickness/2-thickness, 0]) difference() {
		zcube([length+thickness*2, thickness*4, thickness]);
		translate([0, thickness, 0]) zcube([length+2, thickness+2,thickness+2]);
	}
}

//color("white") lateral_holes();

color("green") bracket();
color("white") roller();
color("orange") attachment();