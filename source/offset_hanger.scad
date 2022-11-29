
use <bolts.scad>;
use <zcube.scad>;

thickness = 8;
length = 100;

base_thickness = 8;

roller_height = 26;
roller_offset = 48/2-10;

module reflect(axis) {
	children();
	mirror(axis) children();
}

module hole_locations() {
		for (i=[-1:1]) {
		translate([(i*length/3), -18, base_thickness/2]) rotate([0, 0, 180]) rotate([90, 0, 0]) children();
	}
}

module holes() {
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
					zcube([length-0.5, thickness-0.5, base_thickness]);
					translate([0, 0, roller_height]) zcube([25, thickness-0.5, thickness]);
				}
				
				translate([0, -thickness/2, roller_height]) rotate([90, 0, 0]) cylinder(r2=12/2, r1=thickness,h=6);
			}
			
			// +1 for carving out completely
			translate([0, thickness/2+0.5, roller_height]) rotate([90, 0, 0]) screw_hole(diameter=8,depth=thickness+12,inset=0, thickness=0);
			
			reflect([1, 0, 0])
			rotate([0, 45/2, 0])
			translate([-17, 0, roller_height-21])
			threaded_hole(3, 22);
			
			hole_locations() hole(4, 36, 2);
		}
		
		//zcube([length, thickness*2, thickness]);
	}
}

module attachment() {
	render() difference() {
		zcube([length+thickness*2, 36, base_thickness]);
		zcube([length+0.5, thickness+0.5,thickness+0.5]);
		
		hole_locations() threaded_hole(4, 36, 2);
	}
}

difference() {
	union() {
		//color("green") bracket();
		//roller();
		color("orange") attachment();
	}
	 
	color("white") holes();
}
