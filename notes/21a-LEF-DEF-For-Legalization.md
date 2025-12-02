# LEF/DEF for Legalization (ISPD26)

Key LEF/DEF concepts required to produce legal post-placement updates under PDN and blockages.

## LEF essentials

- Tech LEF: layers (width, pitch, spacing tables), vias (enclosure), units.
- Cell LEF: site, size (width/height), pins (shapes, access), obstruction geometry.
- Macro LEF: macro dimensions and pins; fixed in contest.

## DEF essentials

- Components: instances, placement (x,y), orientation, status (FIXED/PLACED).
- Pins: I/O fixed; nets must preserve names.
- Blockages: placement/routing blockages regions.
- Special nets: PDN; must not be perturbed.

## Legal placement

- On-site grid alignment; correct orientation; no overlap; respect blockages and PDN-induced pin blockage.
- Displacement metric: average Manhattan displacement vs. baseline for movable cells.

## Coordinates and units

- Understand database units (DBU) vs micron; convert consistently across LEF/DEF.
- Site rows origin and step define legal x,y candidates.

## Changelist consistency

- size_cell <x,y>: swapped variant must exist in .lib/.lef; same function.
- insert_repeater <x,y>: instance must exist in library; DEF shows instance at x,y; netlist reconnects driver/load pins; names follow OpenROAD unique naming.

## Common pitfalls

- Off-grid placements; wrong orientation; overlapping components.
- Net/instance rename mismatches across .v and .def.
- Ignoring PDN blockages causing pin access failures post-route.

## Legal site finder (pseudocode)

```
function find_nearest_legal_site(x0, y0, rows, blockages, pdn_mask):
	candidates = generate_sites_in_window(x0, y0, radius)
	legal = []
	for (x,y,orient,row) in candidates:
		if on_site_grid(x,y,row) and not overlaps_blockage(x,y,blockages) and not pdn_mask[x,y]:
			legal.append((manhattan_dist(x0,y0,x,y), x,y,orient))
	return min_by_distance(legal)
```

Use DBU coordinates and row origin/step. Apply orientation constraints (N/FS/...) from LEF site symmetry.
