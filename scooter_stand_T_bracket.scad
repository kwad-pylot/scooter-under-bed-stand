// Scooter Under Bed Stand - T BRACKET VERSION
// Modified L-bracket with base extending both left and right from vertical wall
// Default: 200mm length, 95mm right base, 40mm left base, 95mm height

// Parameters (in mm)
length = 200;               // Length of the bracket (extrusion direction)
base_width_right = 80;     // Width of base extending to the RIGHT of vertical wall
base_width_left = 40;      // Width of base extending to the LEFT of vertical wall
height = 105;               // Height of the vertical wall
wall_thickness = 10;       // Thickness of the walls

// ========== FILLET CONTROL ==========
add_fillets = false;       // Enable/disable all rounded corners and edges
fillet_radius = 3;         // Outer fillet radius (in mm)
inner_fillet_radius = 3;   // Inner corner fillet radius (in mm)
// =====================================

// ========== GUSSET REINFORCEMENT ==========
add_gussets = true;        // Enable corner gussets
gusset_size = 80;          // Size of triangular gusset (mm)
gusset_margin = 5;         // Gap between gusset edge and base/wall edge (mm)
gusset_rib_width = 20;     // Width of diagonal rib (material to keep along hypotenuse)
num_gussets = 3;           // Number of gussets along the length
// ==========================================

// Resolution for smooth curves
$fn = 40;

// Basic T-shape profile (2D)
// The vertical wall sits on top of a base that extends both directions
module T_profile_2D() {
    difference() {
        // Outer T shape
        polygon(points = [
            // Start from bottom left of left base
            [-base_width_left, 0],
            // Go to bottom right of right base
            [base_width_right, 0],
            // Go up to wall thickness
            [base_width_right, wall_thickness],
            // Go left to the vertical wall right edge
            [wall_thickness, wall_thickness],
            // Go up the vertical wall
            [wall_thickness, height],
            // Go left to vertical wall left edge
            [0, height],
            // Go down to base level
            [0, wall_thickness],
            // Go left to left base edge
            [-base_width_left, wall_thickness],
            // Close the polygon back to start
        ]);
    }
}

// T-shape with rounded outer edges (2D)
module T_profile_rounded_2D() {
    offset(r = fillet_radius)
        offset(r = -fillet_radius)
            T_profile_2D();
}

// Simple T bracket extruded (no fillets)
module T_bracket_simple() {
    linear_extrude(height = length)
        T_profile_2D();
}

// T bracket with filleted inner corners
module T_bracket_filleted() {
    r = inner_fillet_radius;
    fr = fillet_radius;

    // Use minkowski to round all edges including the ends
    minkowski() {
        // Shrink the profile and length to compensate for minkowski expansion
        translate([fr, fr, fr])
            linear_extrude(height = length - 2*fr) {
                offset(r = -fr)
                    T_profile_2D();
            }

        // Sphere adds rounding to all edges and corners
        sphere(r = fr);
    }

    // Add inner corner fillets (rounded inside corners for strength)
    // Right corner (between vertical wall and right base)
    translate([wall_thickness, wall_thickness, fr])
        difference() {
            cube([r, r, length - 2*fr]);
            translate([r, r, -1])
                cylinder(h = length - 2*fr + 2, r = r);
        }

    // Left corner (between vertical wall and left base)
    translate([0, wall_thickness, fr])
        difference() {
            cube([r, r, length - 2*fr]);
            translate([0, r, -1])
                cylinder(h = length - 2*fr + 2, r = r);
        }
}

// Triangular gusset module with inner cutout (can be rectangular triangle)
module gusset(width, height, thickness) {
    // Triangle in the XY plane with cutout for weight reduction, extruded along Z
    linear_extrude(height = thickness) {
        difference() {
            // Original outer triangle
            polygon(points = [
                [0, 0],
                [width, 0],
                [0, height]
            ]);

            // Inner cutout triangle - leaves gusset_rib_width material along hypotenuse
            // Calculate the cutout size to leave the desired rib width
            hyp = sqrt(width*width + height*height);  // Hypotenuse length
            offset_val = width*height - gusset_rib_width*hyp;  // Offset calculation
            cutout_base_x = offset_val / height;  // X point on base
            cutout_vert_y = offset_val / width;   // Y point on vertical

            // Only add cutout if there's enough material
            if (cutout_base_x > 0 && cutout_vert_y > 0) {
                polygon(points = [
                    [0, 0],
                    [cutout_base_x, 0],
                    [0, cutout_vert_y]
                ]);
            }
        }
    }
}

// T bracket with gusset reinforcements
module T_bracket_with_gussets() {
    gusset_thickness = 5;  // Thickness of each gusset
    usable_length = add_fillets ? length - 2*fillet_radius : length;  // Account for rounded ends if fillets enabled
    gusset_spacing = usable_length / (num_gussets + 1);
    gusset_offset = add_fillets ? fillet_radius : 0;  // Offset gussets if fillets are enabled

    // Calculate actual gusset dimensions based on available space with margin
    max_gusset_width = base_width_right - wall_thickness - gusset_margin;  // Available space on right base
    max_gusset_height = height - wall_thickness - gusset_margin;  // Available space on vertical wall
    actual_gusset_width = min(gusset_size, max_gusset_width);  // Limit by base width and gusset_size
    actual_gusset_height = max_gusset_height;  // Always follow the wall height (no gusset_size limit)

    union() {
        // Base T bracket - choose filleted or simple based on add_fillets parameter
        if (add_fillets) {
            T_bracket_filleted();
        } else {
            T_bracket_simple();
        }

        // Add gussets along the right inner corner (right base side only)
        if (add_gussets) {
            for (i = [1:num_gussets]) {
                translate([wall_thickness, wall_thickness, gusset_offset + i * gusset_spacing - gusset_thickness/2])
                    gusset(actual_gusset_width, actual_gusset_height, gusset_thickness);
            }
        }
    }
}

// Render the T bracket
T_bracket_with_gussets();

// Preview info
echo(str("T Bracket dimensions:"));
echo(str("  Length: ", length, "mm (", length/10, "cm)"));
echo(str("  Base width RIGHT: ", base_width_right, "mm (", base_width_right/10, "cm)"));
echo(str("  Base width LEFT: ", base_width_left, "mm (", base_width_left/10, "cm)"));
echo(str("  Total base width: ", base_width_right + base_width_left, "mm (", (base_width_right + base_width_left)/10, "cm)"));
echo(str("  Height: ", height, "mm (", height/10, "cm)"));
echo(str("  Wall thickness: ", wall_thickness, "mm"));
echo(str("  Fillets: ", add_fillets ? "ENABLED" : "DISABLED"));
echo(str("  Gussets: ", add_gussets ? "ENABLED" : "DISABLED"));
