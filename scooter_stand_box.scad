// Scooter Under Bed Stand Box
// Dimensions: 200mm (L) x 95mm (W) x 95mm (H)

// Parameters (in mm)
length = 20;              // 20 cm
width = 95;                // 9.5 cm
height = 95;               // 9.5 cm
wall_thickness = 3;        // Wall thickness for hollow design
fillet_radius = 3;        // Outer fillet radius (in mm)
inner_fillet_radius = 3;  // Inner fillet radius (in mm)

// Set to true for hollow (lighter, less filament)
// Set to false for solid block
hollow = true;

// Resolution for smooth curves
$fn = 40;

// Module to create a rounded box with flat/blunt ends
// Uses cylinders along length so ends are flat, only long edges are rounded
module rounded_box(l, w, h, r) {
    hull() {
        // Four cylinders running along the length for rounded long edges
        translate([0, r, r])
            rotate([0, 90, 0]) cylinder(h = l, r = r);
        translate([0, w - r, r])
            rotate([0, 90, 0]) cylinder(h = l, r = r);
        translate([0, r, h - r])
            rotate([0, 90, 0]) cylinder(h = l, r = r);
        translate([0, w - r, h - r])
            rotate([0, 90, 0]) cylinder(h = l, r = r);
    }
}

module solid_box() {
    rounded_box(length, width, height, fillet_radius);
}

// Module for rounded tunnel (cylinder-based for inner corners)
module rounded_tunnel(l, w, h, r) {
    hull() {
        // Four rounded corners running along the length
        translate([-1, r, r])
            rotate([0, 90, 0]) cylinder(h = l + 2, r = r);
        translate([-1, w - r, r])
            rotate([0, 90, 0]) cylinder(h = l + 2, r = r);
        translate([-1, r, h - r])
            rotate([0, 90, 0]) cylinder(h = l + 2, r = r);
        translate([-1, w - r, h - r])
            rotate([0, 90, 0]) cylinder(h = l + 2, r = r);
    }
}

module hollow_box() {
    inner_width = width - 2*wall_thickness;
    inner_height = height - 2*wall_thickness;

    difference() {
        // Outer rounded shell
        rounded_box(length, width, height, fillet_radius);

        // Inner rounded tunnel cutout - open on both ends with rounded inside corners
        translate([0, wall_thickness, wall_thickness])
            rounded_tunnel(length, inner_width, inner_height, inner_fillet_radius);
    }
}

module reinforced_hollow_box() {
    // Hollow box with internal divider ribs for strength
    rib_thickness = 2;  // Thickness of each divider
    num_ribs = 3;       // Number of internal dividers
    rib_spacing = length / (num_ribs + 1);

    union() {
        hollow_box();

        // Add internal divider ribs spanning the tunnel
        for (i = [1:num_ribs]) {
            translate([i * rib_spacing - rib_thickness/2, wall_thickness, wall_thickness])
                cube([
                    rib_thickness,
                    width - 2*wall_thickness,
                    height - 2*wall_thickness
                ]);
        }
    }
}

// Render the box
// Options: solid_box(), hollow_box(), reinforced_hollow_box()
if (hollow) {
    hollow_box();  // No dividers, rounded inside and outside
    // reinforced_hollow_box();  // Uncomment for dividers
} else {
    solid_box();
}

// Preview info (shown in console)
echo(str("Box dimensions: ", length, "mm x ", width, "mm x ", height, "mm"));
echo(str("              : ", length/10, "cm x ", width/10, "cm x ", height/10, "cm"));
