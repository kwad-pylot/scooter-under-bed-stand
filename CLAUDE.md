# Scooter Under Bed Stand Box

## Project Overview
OpenSCAD designs for 3D-printable stands/brackets to support a scooter under a bed, lifting it slightly off the ground.

## Files

| File | Description |
|------|-------------|
| `scooter_stand_box.scad` | Original hollow tunnel box design with rounded edges |
| `scooter_stand_L_bracket.scad` | L-shaped bracket with triangular gusset reinforcements |
| `scooter_stand_T_bracket.scad` | T-shaped bracket with independent left/right bases and gussets |

## T-Bracket Parameters

### Main Dimensions
| Parameter | Default | Description |
|-----------|---------|-------------|
| `length` | 200mm | Length of the bracket (extrusion direction) |
| `base_width_right` | 80mm | Width of base extending to the RIGHT of vertical wall |
| `base_width_left` | 40mm | Width of base extending to the LEFT of vertical wall |
| `height` | 105mm | Height of the vertical wall |
| `wall_thickness` | 10mm | Thickness of the walls |

### Fillet Control
| Parameter | Default | Description |
|-----------|---------|-------------|
| `add_fillets` | false | Enable/disable all rounded corners and edges |
| `fillet_radius` | 3mm | Outer fillet radius |
| `inner_fillet_radius` | 3mm | Inner corner fillet radius |

### Gusset Reinforcement
| Parameter | Default | Description |
|-----------|---------|-------------|
| `add_gussets_left` | true | Enable LEFT side gussets |
| `add_gussets_right` | true | Enable RIGHT side gussets |
| `gusset_size` | 80mm | Maximum size of triangular gusset |
| `gusset_thickness` | 5mm | Thickness of each gusset |
| `gusset_margin` | 5mm | Gap between gusset edge and base/wall edge |
| `gusset_rib_width` | 20mm | Width of diagonal rib (weight-reducing cutout) |
| `num_gussets` | 3 | Number of gussets along the length |

## Design Notes
- T-bracket has independent left/right base width controls
- Gussets feature weight-reducing triangular cutouts leaving a diagonal rib
- Gussets automatically scale with wall height and base width
- Both left and right gussets can be toggled independently
- Fillets can be enabled for rounded edges (adjusts gusset positioning automatically)

---

## TODO

- [x] Upload project to GitHub
- [x] Add T-bracket design with adjustable bases
- [x] Add weight-reducing gusset cutouts
- [x] Add independent left/right gusset toggles
- [ ] Test print and verify dimensions
- [ ] Adjust reinforcements if needed after testing

## Repository
https://github.com/kwad-pylot/scooter-under-bed-stand
