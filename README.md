# Scooter Under Bed Stand Box

3D-printable stands and brackets designed in OpenSCAD to support a scooter under a bed, lifting it slightly off the ground.

## Designs

### 1. Hollow Box (`scooter_stand_box.scad`)
Simple tunnel-style box with:
- Rounded outer edges (configurable fillet radius)
- Rounded inner corners
- Open ends (flat/blunt cut)

### 2. L-Bracket (`scooter_stand_L_bracket.scad`)
L-shaped bracket with:
- Configurable wall thickness
- Rounded edges on all surfaces including ends
- Triangular gusset reinforcements for strength

## Default Dimensions
- Length: 200mm (20cm)
- Width: 95mm (9.5cm)
- Height: 95mm (9.5cm)

## Parameters
All designs include configurable parameters at the top of each file:
- `length`, `width`, `height` - Overall dimensions
- `wall_thickness` - Thickness of walls
- `fillet_radius` - Outer edge rounding
- `inner_fillet_radius` - Inner corner rounding

## Usage
1. Open the `.scad` file in [OpenSCAD](https://openscad.org/)
2. Adjust parameters at the top of the file
3. Press F5 to preview, F6 to render
4. Export as STL for 3D printing

## License
MIT License - Feel free to use and modify.
