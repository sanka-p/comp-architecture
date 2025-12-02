# Gate Sizing and Logical Effort (ISPD26)

This note focuses on post-placement gate sizing for setup timing with ideal clocks, using logical effort intuition and .lib LUTs.

## Essentials

- Variants: drive strength (X1/X2/...), threshold voltage (SVT/LVT/HVT). All variants preserve logic function.
- Inputs: .lib delay/slew/power tables; .def placement; .v netlist; .sdc constraints.
- Output: same function instance at same or nearby legal site, with variant swapped.

## Logical Effort (LE) quick primer

- Path effort H = G · B · F, where G is path logical effort, B is branching effort, F is electrical effort (C_out/C_in).
- Optimal stage effort f ≈ e; number of stages n ≈ ln(H)/ln(f). Use for intuition to avoid too few/too many strong stages.
- Sizing policy: distribute effort evenly; increase drive on stages with highest sensitivity.

## Sensitivity-based sizing

- Define sensitivity S = −Δdelay / Δpower for a candidate upsize (or VT swap). Choose highest S on critical arcs.
- Practical:
  - Evaluate Δdelay via .lib LUT (new slew, new load); approximate interconnect load from post-placement RC.
  - Evaluate Δpower = Δ(dynamic + leakage); remember ISPD scores dynamic and leakage separately.

## VT selection

- LVT: faster, higher leakage. HVT: slower, lower leakage. SVT: balanced.
- Policy: use LVT sparingly on the most critical arcs; prefer SVT/HVT where slack allows to reduce leakage.

## Legality & displacement

- Swapped cell must fit site width/height/orientation; respect blockages/PDN.
- Displacement penalty applies to non-repeater logic movement. Keep original instance nearest legal site.

## Worked micro-example

- Given critical arc A→B with slack −80ps, driver X1, load 30fF, input slew 50ps.
  - Try X2: LUT shows −45ps delay, +0.2mW dynamic, +1µW leakage.
  - Try VT swap SVT→LVT: −30ps delay, +0mW dynamic, +5µW leakage.
  - Choose X2 if Δdelay/Δpower better given weights w_tns, w_dpower, w_lpower.

## Checklist

- Ensure function-equivalence across variants.
- Update .v and .def consistently; add to .changelist as size_cell <x,y>.
- Re-run timing to confirm TNS improvement without ERC regressions.

## Example sensitivity table (illustrative)

| Variant change | Δdelay (ps) | Δdynamic (mW) | Δleakage (µW) | S = −Δdelay/Δpower (ps/mW) |
|---|---:|---:|---:|---:|
| X1→X2 | 45 | 0.20 | 1 | 225 |
| SVT→LVT | 30 | 0.00 | 5 | ∞ (use leakage weight to moderate) |
| X2→X4 | 20 | 0.35 | 3 | 57 |

Interpretation: prioritize changes with highest effective gain after weighting dynamic/leakage per contest w_dpower and w_lpower.
