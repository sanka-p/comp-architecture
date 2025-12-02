# Lec54 — Tutorial: Clock Tree Synthesis and Routing (OpenRoad)

## Overview
Hands-on tutorial demonstrating OpenRoad CTS and routing for GCD example (Nangate45): repair clock inverters, CTS (buffer insertion, sync clustering), clock net repair, hold timing repair, global routing (congestion, pin access), detailed routing (multi-threaded), parasitic extraction (SPEF), filler cells, final reports.

## Core concepts
**CTS workflow (flow_cts.tcl):**
1. **Repair clock inverters:** Clone clock tree inverters near register loads (CTS won't buffer inverted clocks)
2. **Clock tree synthesis:** Insert clock buffers (specified list), enable sync clustering (diameter parameter)
   - **Sync clustering:** Group nearby sinks (diameter: max distance) → build sub-trees → minimize skew within cluster
3. **Repair clock nets:** Insert buffers in long wires (pad → clock tree root; reduce delay)
4. **Detailed placement:** Place inserted clock buffers (legalize)
5. **Setup/hold timing repair:** Post-CTS (actual latencies) → estimate parasitics (placement-based; global routing too slow) → `repair_timing` (downsize or high-V_t cells for hold)
6. **Timing reports:** Worst slack (setup/hold), TNS (total negative slack)

**Routing workflow (flow_routing.tcl):**
1. **Global routing:**
   - **Pin access:** Define routing layers for accessing standard cell pins
   - **Route guide output:** File for detailed router
   - **Global routing:** Congestion iterations (e.g., 100; check overflow)
   - **Antenna check:** Flag antenna violations (plasma-induced gate damage; no violations in GCD)
2. **Filler cells:** Insert filler cells (fill gaps between standard cells; continuous n-well/p-well)
   - **Legality check:** Verify filler cell placement (no overlaps, legal rows)
3. **Detailed routing:**
   - **Multi-threaded:** `set_thread_count` (find # processors; parallel routing for speed)
   - **DRC output:** Generate DRC file (design rule violations)
   - **Antenna repair:** `repair_design` (if violations; layer jump, jumper, diode insertion; GCD has none)
4. **Parasitic extraction:**
   - **RC file:** Nangate45_rc (R, C per layer; from library)
   - **Extract parasitics:** Compute R, C, L from routed layout
   - **SPEF:** Standard Parasitic Exchange Format (output file; used by STA)
5. **Final reports:** Worst slack (setup/hold), TNS, power, clock skew, floating nets, design area

**Viewing/verification:**
- **Clock tree viewer:** Visualize clock tree (buffers, fly lines from clock pin → buffers → sequential cells)
- **Routing nets:** Signal nets (routes from pins to cells), clock nets (separate; built in CTS)
- **Filler cells:** Filter instances → filler cells (fill gaps; everywhere in layout)
- **Heat maps:** Placement density (blue=dense), power density (red=high power), routing congestion (red=congested)

## Methods/flows
**Running CTS + routing:**
```tcl
source flow_cts.tcl
source flow_routing.tcl
```

**CTS steps:**
1. `repair_clock_inverters` (clone near loads)
2. `clock_tree_synthesis -buf_list {BUF_X1 BUF_X2} -sink_clustering_enable -sink_clustering_max_diameter 50` (insert buffers, cluster sinks)
3. `repair_clock_nets` (buffer long pad→root wires)
4. `detailed_placement` (legalize clock buffers)
5. `estimate_parasitics -placement` (fast; global routing too slow)
6. `repair_timing` (fix setup/hold; downsize, high-V_t)
7. `report_worst_slack`, `report_tns` (timing reports)

**Global routing:**
```tcl
set_global_routing_layer_adjustment metal1-metal6 0.5
global_route -congestion_iterations 100
write_guides route.guide
```

**Detailed routing:**
```tcl
set_thread_count [exec nproc]  # Multi-threaded
detailed_route -output_drc gcd.drc -guide route.guide
```

**Parasitic extraction:**
```tcl
read_spef Nangate45_rc
extract_parasitics
write_spef gcd.spef
```

**Filler cells:**
```tcl
filler_placement FILL_CELL_1 FILL_CELL_2 ...
check_placement
```

**Final reports:**
```tcl
report_worst_slack -max  # Setup
report_worst_slack -min  # Hold
report_tns
report_power
report_clock_skew
report_floating_nets
report_design_area
```

## Constraints/assumptions
- **GCD:** No macros, no antenna violations (simple design)
- **Placement-based parasitics:** Fast estimate (global routing too slow for production; SPEF extraction after detailed routing more accurate)
- **Sync clustering:** Groups nearby sinks (diameter parameter); improves skew within cluster
- **Filler cells:** Required (continuous n-well/p-well; DRC compliance)

## Examples
**Clock tree viewer:**
- Clock pin → main buffer → 4 sub-buffers → sequential cells (repeated structure)

**Routing:**
- Signal nets: Routes from cell pins to other cells (visible in GUI: signal nets option)
- Clock nets: Separate from signals (built in CTS; routed before signal routing)
- Power/ground nets: Mesh grid (built in PDN; before placement)

**Filler cells:**
- Inserted everywhere (gaps between standard cells) → continuous n-well/p-well (DRC compliance)

**Heat maps:**
- Placement density: Dark blue (high density; tightly packed cells)
- Power density: Red (high power consumption; active regions)
- Routing congestion: Red (congested; many nets crossing; overflow risk)

**Timing reports (example):**
- Worst setup slack: -0.5ns (violation; needs fixing)
- Worst hold slack: +0.2ns (met; margin)
- TNS: -5ns (total negative slack; sum of all setup violations)

**Parasitic extraction:**
- Input: Routed layout, Nangate45_rc (R, C per layer)
- Output: gcd.spef (R, C, L per net; used by STA for accurate timing)

## Tools/commands
- **CTS:** `clock_tree_synthesis`, `repair_clock_nets`, `repair_clock_inverters`
- **Timing repair:** `estimate_parasitics -placement`, `repair_timing`
- **Global routing:** `global_route -congestion_iterations 100`
- **Detailed routing:** `detailed_route -output_drc file.drc -guide route.guide`
- **Parasitic extraction:** `extract_parasitics`, `write_spef file.spef`
- **Filler cells:** `filler_placement FILL_CELL_LIST`
- **Antenna:** `check_antennas`, `repair_design` (if violations)
- **Reports:** `report_worst_slack`, `report_tns`, `report_power`, `report_clock_skew`, `report_floating_nets`, `report_design_area`
- **Viewing:** GUI → Clock tree viewer, nets (signal, clock, power), instances (filler cells), heat maps (density, power, congestion)

## Common pitfalls
- Not repairing clock inverters (CTS may not buffer inverted clocks properly)
- Skipping clock net repair (long pad→root wires → high delay)
- Not estimating parasitics post-CTS (timing repair inaccurate; needs parasitics)
- Using global routing for parasitic estimation (too slow; use placement-based estimate; final SPEF after detailed routing)
- Not inserting filler cells (DRC violations; discontinuous n-well/p-well)
- Single-threaded detailed routing (slow; use multi-threaded: `set_thread_count [exec nproc]`)
- Not writing SPEF (final timing analysis needs accurate parasitics from routed layout)
- Ignoring antenna violations (check, repair if needed; GCD has none)

## Key takeaways
- CTS workflow: Repair clock inverters → insert buffers (sync clustering) → repair clock nets (long wires) → detailed placement → timing repair (hold; parasitics estimate) → reports
- Sync clustering: Group nearby sinks (diameter) → build sub-trees → minimize intra-cluster skew
- Hold timing repair: Post-CTS (actual latencies) → estimate parasitics (placement-based; fast) → `repair_timing` (downsize, high-V_t)
- Global routing: Pin access (layers) → congestion iterations (overflow check) → route guide (for detailed router) → antenna check
- Detailed routing: Multi-threaded (fast; `set_thread_count`) → DRC output (violations) → antenna repair (if needed)
- Filler cells: Fill gaps (continuous n-well/p-well; DRC compliance) → check legality (no overlaps, legal rows)
- Parasitic extraction: RC file (R, C per layer; library) → extract from routed layout → SPEF (accurate R, C, L; used by STA)
- Final reports: Worst slack (setup/hold), TNS, power, clock skew, floating nets, design area
- Clock tree viewer: Visualize buffers, fly lines (clock pin → buffers → sequential cells)
- Heat maps: Placement density (blue=dense), power density (red=high power), routing congestion (red=congested)
- Routing nets: Signal (routes after CTS/detailed routing), clock (built in CTS), power/ground (mesh; built in PDN)
- Placement-based parasitics: Fast estimate (global routing too slow); final SPEF after detailed routing (accurate)
- Antenna check/repair: Flag violations (plasma damage); repair (layer jump, jumper, diode); GCD has none

**Cross-links:** See Lec51: CTS (concepts: minimize skew, buffers, useful skew); Lec52: Routing (concepts: global, detailed, parasitics); Lec53: Post-layout verification (parasitic extraction: SPEF, STA); Lec50: Chip planning/placement tutorial (prior steps)

---

*This summary condenses tutorial Lec54 from ~3,500 tokens, removing verbose GUI navigation, redundant script echoes, and step-by-step visualization descriptions.*
