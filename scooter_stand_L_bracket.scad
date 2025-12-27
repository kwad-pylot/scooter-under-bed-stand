// Scooter Under Bed Stand - L BRACKET VERSION
// Based on box dimensions: 200mm (L) x 95mm (W) x 95mm (H)

// Parameters (in mm)
length = 200;               // Length of the bracket (extrusion direction)
width = 95;                // Width of the L (horizontal leg)
height = 95;               // Height of the L (vertical leg)
wall_thickness = 10;       // Thickness of the L walls
fillet_radius = 3;         // Outer fillet radius (in mm)
inner_fillet_radius = 3;   // Inner corner fillet radius (in mm)

// ========== GUSSET REINFORCEMENT ==========
add_gussets = true;        // Enable corner gussets
gusset_size = 80;          // Size of triangular gusset (mm)
num_gussets = 4;           // Number of gussets along the length
// ==========================================

// Resolution for smooth curves
$fn = 40;

// Basic L-shape profile (2D)
module L_profile_2D() {
    difference() {
        // Outer L shape
        polygon(points = [
            [0, 0],
            [width, 0],
            [width, wall_thickness],
            [wall_thickness, wall_thickness],
            [wall_thickness, height],
            [0, height]
        ]);
    }
}

// L-shape with rounded outer edges (2D)
module L_profile_rounded_2D() {
    offset(r = fillet_radius)
        offset(r = -fillet_radius)
            L_profile_2D();
}

// L-shape with both inner and outer rounding (2D)
module L_profile_full_rounded_2D() {
    difference() {
        // Outer rounded L
        offset(r = fillet_radius)
            offset(r = -fillet_radius)
                L_profile_2D();

        // Round the inner corner
        translate([wall_thickness, wall_thickness, 0])
            circle(r = inner_fillet_radius);
    }

    // Fill back the inner corner with rounded version
    translate([wall_thickness + inner_fillet_radius, wall_thickness + inner_fillet_radius, 0])
        difference() {
            square([width, height]);  // Large square to intersect
            circle(r = inner_fillet_radius);
        }
}

// Simple L bracket extruded
module L_bracket_simple() {
    linear_extrude(height = length)
        L_profile_2D();
}

// L bracket with rounded edges
module L_bracket_rounded() {
    linear_extrude(height = length)
        L_profile_rounded_2D();
}

// L bracket with filleted inner corner AND rounded ends
module L_bracket_filleted() {
    r = inner_fillet_radius;
    fr = fillet_radius;

    // Use minkowski to round all edges including the ends
    minkowski() {
        // Shrink the profile and length to compensate for minkowski expansion
        translate([fr, fr, fr])
            linear_extrude(height = length - 2*fr) {
                offset(r = -fr)
                    L_profile_2D();
            }

        // Sphere adds rounding to all edges and corners
        sphere(r = fr);
    }

    // Add inner corner fillet (rounded inside corner for strength)
    translate([wall_thickness, wall_thickness, fr])
        difference() {
            cube([r, r, length - 2*fr]);
            translate([r, r, -1])
                cylinder(h = length - 2*fr + 2, r = r);
        }
}

// Triangular gusset module
module gusset(size, thickness) {
    // Triangle in the XY plane, extruded along Z
    linear_extrude(height = thickness)
        polygon(points = [
            [0, 0],
            [size, 0],
            [0, size]
        ]);
}

// L bracket with gusset reinforcements
module L_bracket_with_gussets() {
    gusset_thickness = 5;  // Thickness of each gusset
    usable_length = length - 2*fillet_radius;  // Account for rounded ends
    gusset_spacing = usable_length / (num_gussets + 1);

    union() {
        // Base L bracket
        L_bracket_filleted();

        // Add gussets along the inner corner
        if (add_gussets) {
            for (i = [1:num_gussets]) {
                translate([wall_thickness, wall_thickness, fillet_radius + i * gusset_spacing - gusset_thickness/2])
                    gusset(gusset_size, gusset_thickness);
            }
        }
    }
}

// Render the L bracket
// Options: L_bracket_simple(), L_bracket_rounded(), L_bracket_filleted(), L_bracket_with_gussets()
L_bracket_with_gussets();

// Preview info
echo(str("L Bracket dimensions:"));
echo(str("  Length: ", length, "mm (", length/10, "cm)"));
echo(str("  Width: ", width, "mm (", width/10, "cm)"));
echo(str("  Height: ", height, "mm (", height/10, "cm)"));
echo(str("  Wall thickness: ", wall_thickness, "mm"));
