
$radial_error = 0.1;

$fn = $preview ? 24 : 128;

ISO262_COARSE_PITCH = [
	[1.0, 0.25],
	[1.2, 0.25],
	[1.4, 0.2],
	[1.6, 0.35],
	[1.8, 0.2],
	[2.0, 0.4],
	[2.5, 0.45],
	[3.0, 0.5],
	[3.5, 0.35],
	[4.0, 0.7],
	[5.0, 0.8],
	[6.0, 1.0],
	[7.0, 0.75],
	[8.0, 1.25],
	[10.0, 1.5],
	[12.0, 1.75],
	[14.0, 1.5],
	[16.0, 2.0],
	[30.0, 3.5],
	[42.0, 4.5],
	[56.0, 5.5]
];

function coarse_pitch(d) = lookup(d, ISO262_COARSE_PITCH);
function pitch_height(d) = coarse_pitch(d) * 0.866025;

function fudge_factor(fn=$fn) = 1/cos(180/fn);
function outer_radius(radius, fn=$fn, radial_error=$radial_error) = radius*fudge_factor(fn)+radial_error;

module sphere_outer(radius, fn=$fn, radial_error=$radial_error) {
	sphere(r=radius*fudge_factor(fn)+radial_error, $fn=fn);
}

module cylinder_outer(height, radius, fn=$fn, radial_error=$radial_error) {
	cylinder(h=height,r=radius*fudge_factor(fn)+radial_error, $fn=fn);
}

module cylinder_inner(height, radius, fn=$fn, radial_error=$radial_error) {
	cylinder(h=height,r=radius-radial_error,$fn=fn);
}

// Make a hole. The diameter is the size of the screw (e.g. 3 for M3). Depth is how far the hole should go for the thread, and inset is how far out there should be a hole for the head to go.
module hole(diameter=3, depth=6, inset=10, height=0) {
	cylinder_outer(depth, (diameter-height)/2);
	
	if (inset) {
		translate([0, 0, depth]) cylinder_outer(inset, diameter, 32);
	}
}

module threaded_hole(diameter=3, depth=6, inset=10) {
	hole(diameter, depth, inset, pitch_height(diameter));
}

module screw_hole(diameter = 3, depth = 16, inset = 10, thickness = 6) {
	insert = depth - thickness;
	height = pitch_height(diameter);
	
	// The part that the screw will thread into:
	cylinder_outer(insert, (diameter-height)/2);
	
	translate([0, 0, insert])
	hole(diameter, depth - insert, inset);
}

module countersunk_screw_hole(diameter = 3, depth = 16, inset = 10, thickness = 6) {
	insert = depth - thickness;
	height = pitch_height(diameter);
	
	// The part that the screw will thread into:
	cylinder_outer(insert, (diameter-height)/2);
	
	translate([0, 0, insert])
	countersunk_hole(diameter, depth - insert, inset);
}

module countersunk_hole(diameter=3, depth=6, inset=10, pitch=0, radial_error=$radial_error) {
	hole(diameter, depth, inset, pitch);
	translate([0, 0, depth-diameter/2]) cylinder(r1=diameter/2+radial_error, r2=diameter+radial_error, h=diameter/2);
}

module knurled_insert(diameter = 3, depth = 6, thickness = 1) {
	cylinder_inner(depth, diameter/2 + thickness);
}

module knurled_hole(diameter = 3, depth = 6, inset = 10, insert = 4, thickness = 1) {
	hole(diameter, depth, inset);
	
	knurled_insert(diameter, insert, thickness);
}

module countersunk_knurled_hole(diameter = 3, depth = 6, inset = 10, insert = 4, thickness = 1) {
	countersunk_hole(diameter, depth, inset);
	
	knurled_insert(diameter, insert, thickness);
}

// Make a hole for a bolt/screw combination.
module bolted_hole(diameter=3, depth=8, nut_offset=2, shaft_length=10, inset=10) {
	hole(diameter, depth, inset);
	hull() {
		shaft_width = diameter;
		translate([0, 0, nut_offset]) rotate(360/12, [0, 0, 1]) cylinder_outer(diameter, shaft_width, 6);
		translate([0, shaft_length, nut_offset]) rotate(360/12, [0, 0, 1]) cylinder_outer(diameter, shaft_width, 6);
	}
}

module countersunk_bolted_hole(diameter=3, depth=8, nut_offset=2, shaft_length=10, inset=10) {
	countersunk_hole(diameter, depth, inset);
	hull() {
		shaft_width = diameter;
		translate([0, 0, nut_offset]) rotate(360/12, [0, 0, 1]) cylinder_outer(diameter, shaft_width, 6);
		translate([0, shaft_length, nut_offset]) rotate(360/12, [0, 0, 1]) cylinder_outer(diameter, shaft_width, 6);
	}
}

module mounting_hole(diameter=3, depth=6, inset=10, outset=3) {
	difference() {
		cylinder_outer(depth, diameter/2+outset);
		hole(diameter=diameter, depth=depth, inset=inset);
	}
}

!render() rotate(90, [1, 0, 0]) difference() {
	cube([40, 10, 10]);
	translate([5, 5, 0]) screw_hole();
}

render() rotate(90, [1, 0, 0]) difference() {
	cube([40, 10, 10]);
	translate([5, 5, 0]) bolted_hole(diameter=3, depth=8);
	translate([15, 5, 0]) bolted_hole(diameter=4, depth=8);
	translate([25, 5, 0]) countersunk_hole(diameter=4, depth=8);
	translate([35, 5, 0]) knurled_hole();
}

render() rotate(90, [1, 0, 0]) difference() {
	cube([6*4, 12, 12]);
	translate([6, 6, 0]) hole(diameter=5, depth=8);
	translate([6*3, 6, 0]) hole(diameter=5.5, depth=8);
}
