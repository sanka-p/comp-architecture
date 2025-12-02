# Lec07 — Overview of VLSI Design Flow: IV (Physical Design)

## Overview
- Physical design converts netlist → layout (GDS).
- Major tasks: chip planning, placement, CTS, routing, ECO, tapeout.
- Inputs: netlist, library (.lib), LEF (physical abstractions), constraints (SDC), floorplan.

## Core concepts
- Physical design objectives: place cells, route interconnects, meet timing/power/area, ensure manufacturability.
- LEF (Library Exchange Format): abstract physical views (bounding box, pin locations, metal layers); enables placement/routing.
- Chip planning (floorplanning):
  - Partition design into blocks; place macros/IOs; define standard-cell rows.
  - Power planning: PDN (power delivery network) to minimize voltage drop.
  - Congestion awareness; shape optimization for rectilinear macros.
- Placement: assign locations to millions of standard cells; optimize wirelength, timing, congestion.
- Clock Tree Synthesis (CTS):
  - Route clock first (resources available); minimize skew (symmetric topology).
  - Clock power can be 40% of total; use clock gating to reduce.
- Routing (global + detailed):
  - Global: plan paths through global bins (like Delhi→Lucknow→Calcutta).
  - Detailed: actual wire layout on metal layers using vias; honors global plan.
- ECO (Engineering Change Order): controlled incremental fixes post-routing.
- Optimization passes: buffer insertion, resizing, placement tweaks between steps.

## Methods/flows
- Chip plan → placement → CTS → global route → detail route → ECO → GDS.
- Incremental refinements; avoid large disruptions to converge.
- Iterations possible (route failure → rework placement); goal: minimize loops.

## Constraints/assumptions
- Routing is NP-hard; decompose into global + detailed.
- Wirelength estimates before routing; actual wires may differ → timing/congestion issues.
- Design closure requires iteration; predictive analysis helps.

## Examples
- Multi-million gate design with 10+ metal layers; macros in corners; IO pads at periphery; PDN grid.

## Tools/commands
- Cadence Innovus, Synopsys IC Compiler II; GDS streamout.

## Common pitfalls
- Poor floorplan → unsolvable congestion.
- Underestimating wirelength in placement → timing violations.
- Ignoring CTS skew → functional failures.
- Large optimization changes → divergence instead of closure.

## Key takeaways
- Physical design adds placement and routing to netlist.
- Chip planning sets stage; bad decisions cascade downstream.
- CTS is critical; clock skew must be minimal.
- Routing decomposed (global + detailed) to manage complexity.
- Iterate judiciously; incremental changes ensure convergence.
- Tapeout: final GDS handoff to foundry; design phase complete.

[Figure: Physical design flow (summary)]
- Shows chip plan → place → CTS → global route → detail route → ECO → GDS.

Cross‑links: See Lec06: Logic synthesis; See Lec28: STA; See Lec08: Verification; See Lec40: Placement detail; See Lec42: Routing detail; See Lec43: CTS detail.
