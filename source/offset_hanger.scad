
use <bolts.scad>;
use <zcube.scad>;

$fn = $preview ? 24 : 128;
thickness = 8;
length = 100;

base_thickness = 10;

roller_length = length - 16;
roller_height = 26;
roller_offset = 48/2-10;

module reflect(axis) {
	children();
	mirror(axis) children();
}

module hole_locations() {
		for (i=[-1:1]) {
			translate([(i*roller_length/3), -18, base_thickness/2])
			rotate([0, 0, 180])
			rotate([90, 0, 0])
			children();
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
					zcube([roller_length, thickness, thickness / 2]);
					translate([0, 0, roller_height]) zcube([25, thickness, thickness]);
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

module cutout() {
		hull() {
			translate([0, thickness-0.1, 0]) {
				zcube([roller_length+0.5, thickness*3, thickness / 2 + 0.5]);
				translate([0, 0, roller_height]) zcube([25, thickness*3, thickness]);
			}
		}
		
		offset = 0;
		
		translate([-offset/2, 36/2 + thickness/2, 0])
		zcube([roller_length+0.5-offset, 36, base_thickness]);
}

module attachment() {
	render() difference() {
		zcube([length+thickness*2, 36, base_thickness]);
		#cutout();
		
		hole_locations() #threaded_hole(4, 36, 2);
	}
}

render() difference() {
	union() {
		//color("green") render() bracket();
		//roller();
		color("orange") render() attachment();
	}
	 
	color("white") holes();
}
