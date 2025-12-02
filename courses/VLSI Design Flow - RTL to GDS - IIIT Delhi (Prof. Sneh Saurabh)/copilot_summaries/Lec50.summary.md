# Lec50 — Tutorial: Chip Planning and Placement (OpenRoad)

## Overview
Hands-on tutorial demonstrating OpenRoad workflow for chip planning (floorplan, power planning) and placement using GCD example (Nangate45): initialize floorplan (site, die/core area, DEF), IO placement, tap cells, PDN, global placement, detailed placement.

## Core concepts
**OpenRoad inputs:**
- **Netlist:** gcd.v (synthesized Verilog)
- **Constraints:** gcd_nangate45.sdc
- **Libraries:** Nangate45_typ.lib (timing), Nangate45_tech.lef (technology), Nangate45_stdcell.lef (cell abstracts)

**Floorplanning workflow (flow_floorplan.tcl):**
1. **Initialize floorplan:** Define site (unit tile: min width/height for cell placement), die area (LX,LY,UX,UY coordinates), core area
2. **IO placement:** Random (initial) → optimized (post-global placement; based on connectivity)
3. **Macro placement:** Check for macros → place (halo, channel); GCD has no macros
4. **Tap cells:** Insert well taps (prevent latchup, guard against damage near borders); placed at core boundary
5. **Write DEF:** Design Exchange Format (physical design info)

**Power planning (flow_pdn.tcl):**
- **PDN config (pdn_cfg):** Define global connections (VDD, VSS), voltage domains, power grids (standard cells, macros)
- **PDN generation:** `pdngen` builds power grid (mesh: rails + straps + vias)
- **Verification:** View power/ground nets (no signal/clock nets yet; PDN built before routing)

**Placement workflow:**
- **Global placement (flow_globalplacement.tcl):**
  - **Congestion estimate:** Set global routing layer adjustment (avoid congestion during placement)
  - **Routing layers:** Define layers for signal/clock
  - **Macro extension:** G-cells/routing means added to macro blockage boundaries
  - **Global placement:** Routability-driven; set density (target placement density), padding (left/right of cells)
  - **IO placement:** Optimized (based on connectivity; replaces random placement)
  - **Repair design:** Fix max slew/capacitance/fanout violations (insert buffers, resize gates); use layer_rc file (R, C per layer for delay calculation)
  - **Repair tie fanout:** Insert tie cells (pins tied to logic 0/1 → tie to VDD/VSS)
  - **Output:** Cells placed (overlaps OK; not legalized yet; not in rows)
- **Detailed placement (flow_detailedplacement.tcl):**
  - **Placement padding:** Add padding (left/right; leave routing space)
  - **Detailed placement:** Legalize (remove overlaps, snap to rows), optimize (swap cells, redistribute)
  - **Timing reports:** Setup/hold slacks, TNS (total negative slack)
  - **Output:** Cells in legal rows, no overlaps; power/ground nets visible

## Methods/flows
**Running OpenRoad:**
```bash
openroad -gui -log gcd.log gcd_nangate45_copy.tcl
```
- `-gui`: Launch GUI
- `-log gcd.log`: Create log file
- `gcd_nangate45_copy.tcl`: Script (sources flow_floorplan.tcl → flow_pdn.tcl → flow_globalplacement.tcl → flow_detailedplacement.tcl)

**Viewing layout:**
- **Core area:** Pink region (die area minus IO cells)
- **Standard cell rows:** Grid (zoom in → see site: unit tile)
- **IO pins:** Random (floorplan) → optimized (after global placement)
- **Tap cells:** Filter instances → physically → well taps (at core boundary)
- **Power nets:** View nets → power nets (VDD mesh), ground nets (GND mesh)
- **Placement:** Global: red blocks (overlaps, not in rows); Detailed: cells in rows, no overlaps

## Constraints/assumptions
- **GCD design:** No macros (macro placement skipped; tools check, skip if none)
- **Nangate45:** 45nm library (educational; not for production)
- **Toy example:** Small design (easy visualization; real designs: millions of cells)
- **Site:** Fixed (library-defined; min width/height for cells)

## Examples
**Die/core area (coordinates: LX,LY,UX,UY):**
- Die: (0, 0, 100μm, 100μm) → die area = 100×100 = 10,000μm²
- Core: (10, 10, 90, 90) → core area = 80×80 = 6,400μm² (64% of die; 36% for IO cells)

**Site:**
- Unit tile: e.g., 0.19μm (width) × 1.4μm (height) → cells placed in multiples

**Tap cells:**
- Placed at core boundary (prevent latchup; connect substrate/wells to VDD/GND)

**Power grid:**
- Mesh: rails (horizontal) + straps (vertical) + vias (connections) → VDD/GND separate meshes

**Global placement:**
- Target density: e.g., 0.7 (70% utilization; 30% for routing)
- Output: Cells spread (overlaps OK; not in rows)

**Detailed placement:**
- Output: Cells in legal rows, no overlaps

## Tools/commands
- **OpenRoad:** `openroad -gui script.tcl` (GUI mode)
- **Floorplan:** `initialize_floorplan` (die/core area), `place_pins` (IO placement)
- **PDN:** `pdngen` (build power grid; from pdn_cfg)
- **Placement:** `global_placement` (spread cells), `detailed_placement` (legalize)
- **Repair:** `repair_design` (fix slew/cap/fanout), `repair_tie_fanout` (insert tie cells)
- **Viewing:** GUI → nets (power/ground), instances (tap cells, standard cells)

## Common pitfalls
- Not sourcing helper files (helpers.tcl, flow_helpers.tcl; defines procedures)
- Incorrect die/core coordinates (LX,LY,UX,UY; ensure UX>LX, UY>LY)
- Forgetting tap cells (latchup risk; insert at boundary)
- Not building PDN before placement (power grid needed for cells)
- Expecting final routing after placement (only PDN built; signal/clock routing after CTS)
- Not repairing design post-global-placement (violations → timing fails later)

## Key takeaways
- OpenRoad inputs: Netlist (.v), constraints (.sdc), libraries (.lib, .lef)
- Floorplan: Initialize (site, die/core area) → IO placement (random→optimized) → tap cells (core boundary) → write DEF
- Site: Unit tile (min width/height); cells placed in multiples (library-defined)
- Power planning: PDN config (global connections, voltage domains, grids) → pdngen (mesh: rails+straps+vias) → VDD/GND separate
- Global placement: Congestion estimate → set layers (signal, clock) → routability-driven → spread cells (overlaps OK) → repair design (fix violations: insert buffers, resize)
- Detailed placement: Padding (routing space) → legalize (remove overlaps, snap to rows) → optimize (swap, redistribute) → timing reports
- Tap cells: Well taps (prevent latchup; at core boundary)
- Repair design: Fix max slew/cap/fanout (layer_rc: R, C per layer → insert buffers, resize gates)
- IO placement: Random (floorplan) → optimized (post-global-placement; connectivity-based)
- Viewing: GUI → nets (power/ground), instances (tap cells, filters)
- Next steps: CTS (clock tree synthesis), routing (signal nets)

**Cross-links:** See Lec47-48: Chip planning (concepts: floorplan, power planning); Lec49: Placement (concepts: global, legalization, detailed); Lec46: OpenRoad installation; Lec54: CTS/routing tutorial (next steps)

---

*This summary condenses tutorial Lec50 from ~3,500 tokens, removing verbose GUI navigation, redundant command echoes, and step-by-step visualization descriptions.*
