# Scooter Under Bed Stand Box

## Project Overview
OpenSCAD designs for 3D-printable stands/brackets to support a scooter under a bed, lifting it slightly off the ground.

## Files

| File | Description |
|------|-------------|
| `scooter_stand_box.scad` | Original hollow tunnel box design with rounded edges |
| `scooter_stand_L_bracket.scad` | L-shaped bracket with triangular gusset reinforcements |

## Current Dimensions
- Length: 200mm (20cm)
- Width: 95mm (9.5cm)
- Height: 95mm (9.5cm)

## Design Notes
- Outer edges use fillets (rounded), configurable via `fillet_radius`
- Inner corners also have configurable `inner_fillet_radius`
- Open ends are flat/blunt (no curves on the small faces)
- L-bracket includes triangular gussets for strength

---

## TODO

- [x] Upload project to GitHub
- [ ] Test print and verify dimensions
- [ ] Adjust reinforcements if needed after testing

## Repository
https://github.com/kwad-pylot/scooter-under-bed-stand

---

## Session Notes
- Wall thickness: 3-10mm depending on design
- Gusset size: 25mm (adjustable)
- Number of gussets: 5 along the 200mm length
