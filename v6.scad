// Parametric Prosthetic Design v6
// All dimensions in mm

// ============ PARAMETERS ============
// First cylinder
cylinder_length_1 = 50;       // Length of first section
cylinder_diameter = 19;       // Diameter of cylinders

// Bend and second cylinder
bend_angle = 60;              // Bend angle in degrees
cylinder_length_2 = 32;       // Length after bend

// Bushing slot
slot_width = 14;              // Width of slot
slot_depth = 25/2 + 0.3;              // Depth of slot into cylinder

// Baro hole
bar_diameter = 5.1;
bar_length = 100;

// Radial holes
radial_hole_diameter = 4;     // Diameter of radial holes
radial_hole_count = 2;        // Number of radial holes
radial_hole_offset = (25/2) - 5;       // Distance from end of cylinder to hole center

// Sphere at start
sphere_diameter = 22;         // Sphere diameter

// ============ DERIVED VALUES ============
cylinder_radius = cylinder_diameter / 2;
sphere_radius = sphere_diameter / 2;

// Resolution
$fn = 100;

// ============ MAIN DESIGN ============
difference() {
    union() {
        // Sphere at the starting end
        sphere(r = sphere_radius);

        // First cylinder (50mm long, extending in Z direction)
        cylinder(h = cylinder_length_1, r = cylinder_radius);

        // Smooth bend transition using hull()
        translate([0, 0, cylinder_length_1])
            hull() {
                // End cap of first cylinder
                cylinder(h = 0.1, r = cylinder_radius);

                // Start cap of second cylinder (rotated)
                rotate([bend_angle, 0, 0])
                    cylinder(h = 0.1, r = cylinder_radius);
            }

        // Second cylinder after 45° bend
        translate([0, 0, cylinder_length_1])
            rotate([bend_angle, 0, 0])
                cylinder(h = cylinder_length_2, r = cylinder_radius);
    }

    // Cylindrical slot at the end of the second cylinder
    // 10mm diameter, 10mm deep
    translate([0, 0, cylinder_length_1])
        rotate([bend_angle, 0, 0])
            translate([0, 0, cylinder_length_2 - slot_depth])
                cylinder(h = slot_depth + 1, d = slot_width);
    
    // Cylindrical slot at the end of the second cylinder
    // 10mm diameter, 10mm deep
    translate([0, 0, cylinder_length_1])
        rotate([bend_angle, 0, 0])
            translate([0, 0, cylinder_length_2 - bar_length])
                cylinder(h = bar_length + 1, d = bar_diameter);

    // Two radial holes through the slot area, 90° apart
    translate([0, 0, cylinder_length_1])
        rotate([bend_angle, 0, 0])
            translate([0, 0, cylinder_length_2 - radial_hole_offset]) {
                // First radial hole
                rotate([0, 90, 0])
                    cylinder(h = cylinder_diameter, d = radial_hole_diameter, center = true);

                // Second radial hole (rotated 90°)
                rotate([0, 90, 90])
                    cylinder(h = cylinder_diameter, d = radial_hole_diameter, center = true);
            }
}
