
use <bolts.scad>;
use <zcube.scad>;

thickness = 8;
length = 100;

base_thickness = 8;

roller_height = 26;
roller_offset = 48/2-10;

module holes() {
	for (i=[-1:1]) {
		translate([(i*length/3), -18, base_thickness/2]) rotate([0, 0, 180]) rotate([90, 0, 0]) bolt(4, 36, 2);
	}
	
	offset = thickness + 2;
	
	for(i=[-1.5:1.0:1.5]) {
		translate([(i*length/3), -offset, 0]) countersunk_hole(4, depth=base_thickness);
		translate([(i*length/3), offset, 0]) countersunk_hole(4, depth=base_thickness);
	}
}

module roller(h=8) {
	translate([0, h/2-roller_offset, roller_height]) rotate([90, 0, 0]) cylinder(d=30,h=h);
}

module bracket() {
	render() union() {
		difference() {
			union() {
				hull() {
					zcube([length, thickness, base_thickness]);
					translate([0, 0, roller_height]) zcube([25, thickness, thickness]);
				}
				
				translate([0, -thickness/2, roller_height]) rotate([90, 0, 0]) cylinder(r2=12/2, r1=thickness,h=6);
			}
			
			// +1 for carving out completely
			translate([0, thickness/2+0.5, roller_height]) rotate([90, 0, 0]) hole(diameter=8,depth=thickness+6+1,inset=0);
		}
		
		//zcube([length, thickness*2, thickness]);
	}
}

module attachment() {
	render() difference() {
		zcube([length+thickness*2, 36, base_thickness]);
		zcube([length+0.5, thickness+0.5,thickness+0.5]);
	}
}

difference() {
	union() {
		color("green") bracket();
		//%roller();
		//color("orange") attachment();
	}
	 
	color("white") holes();
}