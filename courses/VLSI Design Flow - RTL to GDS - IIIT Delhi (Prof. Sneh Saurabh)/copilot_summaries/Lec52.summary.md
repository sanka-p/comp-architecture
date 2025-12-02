# Lec52 — Routing

## Overview
Covers routing workflow (global routing: plan via grid graph/GBins; detailed routing: exact layout via tracks), constraints (connectivity, design rules, timing, SI), routing models (global bins, grid graph, capacity/use/overflow/congestion), and post-routing optimizations (timing, power, SI, antenna, via redundancy, CMP fills).

## Core concepts
**Routing objective:**
- **Goal:** Make physical interconnections between components (macros, standard cells, IO cells) per netlist
- **Difficulty:** Hardest physical design task (billions of nets, limited routing resources, design rules, timing, SI)
- **Stages:** Global routing (plan: routing regions) → detailed routing (exact layout: wire segments) → post-routing optimization

**Global routing:**
- **Goal:** Provide complete instructions to detailed router (plan: where to route each net) → maximize detailed router success probability
- **Objectives:** (1) Maximize routability (detailed router completes routing), (2) Minimize total wire length, (3) Minimize critical path delay
- **Speed:** Very fast (orders of magnitude faster than detailed routing; used in synthesis, floorplan, placement for prototyping)

**Routing model (global routing):**
- **Global bins (GBs):** Divide routing area into rectangular grids (each layer); also called global tiles, routing tiles, global cells, buckets
- **Grid graph:** Vertices (GBs), edges (boundaries between adjacent GBs; preferred direction only; vertical edges=vias)
  - **Preferred direction:** M1→y, M2→x, M3→y (alternate); edges only along preferred direction (M1: y-edges, M2: x-edges)
  - **Vias:** Edges between vertically adjacent GBs (M1↔M2, M2↔M3)
- **Net routing:** Find optimal path in grid graph (from source GB to sink GB; minimize cost: wire length, congestion)

**Capacity, use, overflow, congestion:**
- **Use (demand):** Number of nets crossing an edge (e.g., use(e)=3 if 3 nets cross edge e)
- **Capacity (supply):** Routing resources available for edge (# tracks; depends on layer, design rules, routing blockages: power grid, clock nets)
- **Capacity constraint:** use(e) ≤ cap(e) (if violated → overflow)
- **Overflow:** OF(e) = max(0, use(e) - cap(e)) (e.g., use=5, cap=2 → OF=3; use≤cap → OF=0)
- **Congestion:** CG(e) = use(e) / cap(e) (e.g., use=4, cap=6 → CG=0.67; use=5, cap=6 → CG=0.83; ↑CG → worse)
- **Global routing goal:** Route all nets with OF=0 (may sacrifice timing for routability; take detours to avoid overflow)

**Global routing challenges:**
- **Run time vs accuracy tradeoff:** Fast (simplify problem) vs accurate (detailed router correlation)
- **Larger GBs:** ↓run time (fewer bins) but ↓accuracy (problem shifts to detailed router)
- **Smaller GBs:** ↑accuracy (fine-grained; model design rules) but ↑run time
- **Goal:** Anticipate detailed router problems (congestion, overflow) → flag early → designer fixes (adjust placement, resize macros)

**Detailed routing:**
- **Goal:** Determine exact layout of each net (wire segments: width, location) per netlist connectivity, design rules, timing, SI
- **Routing model:** Detailed routing grid (finer granularity than global routing); tracks (uniform spacing: routing pitch)
  - **Tracks:** Metal lines with uniform spacing (parallel to preferred direction); simplifies algorithm (automation)
  - **Routing pitch:** Spacing between tracks = min spacing allowed by technology (pack wires compactly)
- **Routing pitch choices:**
  - **Line-on-line:** Min spacing for two lines (too aggressive → via DRCs; via-line spacing > line-line)
  - **Via-on-via:** Min spacing for two vias (too conservative; wastes space where no vias)
  - **Line-on-via:** Min spacing for via-line (good tradeoff; allocates via space; skew/skip tracks for via-via)
- **Over-the-cell routing:** Upper metal layers available over cells (cell uses lower layers; upper layers for routing)

**Post-routing optimizations:**
- **Timing:** Extract parasitics (accurate; exact layout known) → STA → fix violations (upsize, buffering, reroute, wire widening)
- **Power:** Downsize non-critical gates, remove buffers, swap low-power cells (same footprint, high-V_t)
- **SI (signal integrity):** Increase wire spacing (reduce coupling C_c), upsize victim driver, downsize aggressor driver
- **Antenna effect:** Layer jump (route on upper layer; short M1 to gate), jumper (M1→M2→M1; break long M1), diode insertion
- **Via redundancy:** Insert redundant vias (on-track: extend one layer in non-preferred direction; off-track: both layers extend) → reliability (via defects: mask misalignment, thermal stress)
- **CMP fills (dummy metal fills):** Add dummy metal in sparse regions → uniform roughness → avoid irregular topography (CMP: softer regions polished more)
  - **Caution:** Changes coupling capacitance → re-extract parasitics, re-run STA (verify timing still closed)

## Methods/flows
**Global routing:**
1. Divide layout into global bins (GBs; rectangular grids per layer)
2. Create grid graph (vertices=GBs, edges=boundaries along preferred direction + vias)
3. Associate pins with GBs (locate source/sink GBs for each net)
4. Find optimal path (minimize wire length, avoid overflow: use≤cap) for each net in grid graph
5. Report congestion/overflow (OF>0 → flag; designer adjusts placement/macros)

**Detailed routing:**
1. Create detailed routing grid (tracks: uniform spacing = routing pitch)
2. Route each net (exact wire segments: width, location) per connectivity, design rules, timing
3. Use track abstraction (simplifies algorithm; automation)
4. Verify: No shorts, no opens, no DRCs

**Post-routing:**
1. Extract parasitics (R, C, L; exact layout) → SPEF (Standard Parasitic Exchange Format)
2. STA (accurate; actual parasitics) → identify violations
3. Fix timing: Upsize, buffer, reroute, wire widen
4. Fix power: Downsize non-critical, remove buffers, low-power cells
5. Fix SI: Increase spacing, resize drivers
6. Fix antenna: Layer jump, jumper, diode insertion
7. Via redundancy: Insert redundant vias (on-track/off-track)
8. CMP fills: Add dummy metal (sparse regions) → re-extract, re-run STA

## Constraints/assumptions
- **Global routing:** Approximate (plan; not exact layout); fast (prototyping, congestion estimate)
- **Detailed routing:** NP-complete (heuristics; may not be optimal); slow (exact layout; time-consuming)
- **Routing pitch:** Technology-dependent (min spacing; line-on-via typical)
- **CMP fills:** Change coupling C → must re-extract, re-run STA

## Examples
**Grid graph (3 layers: M1, M2, M3):**
- M1, M3: preferred direction = y → edges along y-direction only
- M2: preferred direction = x → edges along x-direction only
- Vias: edges between M1↔M2, M2↔M3 (vertically adjacent GBs)

**Routing path (net n: y_pin → x_pin):**
- y_pin in GB_1 (M1), x_pin in GB_9 (M2)
- Path: GB_1 (M1) → GB_2 (M1, y-edge) → via (M1→M2) → GB_5 (M2, x-edge) → GB_6 (M2) → ... → GB_9 (M2)

**Overflow:**
- Edge e: use=5, cap=2 → OF = 5-2 = 3 (overflow; detailed router may fail)
- Edge e': use=3, cap=6 → OF = 0 (legal; use ≤ cap)

**Congestion:**
- Edge e: use=4, cap=6 → CG = 4/6 = 0.67
- Edge e': use=5, cap=6 → CG = 5/6 = 0.83 (higher congestion; less routing resource left)

**Routing pitch (line-on-via):**
- Min via-line spacing = w' (> min line-line spacing w) → track spacing = w'
- Benefit: Via space allocated; no unused tracks (vs line-on-line: via→skip track); less waste (vs via-on-via)

**Via redundancy:**
- Single via: M1 ⊥ M2 (1 via) → failure risk (mask misalignment, thermal stress)
- On-track: M2 extended (non-preferred jog) → 2 vias on same M1 track (redundancy)
- Off-track: M1 extended (preferred), M2 extended (non-preferred jog) → 2 vias (redundancy)

**CMP fills:**
- Sparse region (little metal) → soft → more polishing → uneven topography
- Fix: Add dummy metal fills (not functional; uniform roughness) → caution: changes coupling C → re-extract, re-run STA

## Tools/commands
- **Global routing:** Innovus `globalRoute`, ICC2 `route_auto -global`, OpenRoad `global_route`
- **Detailed routing:** Innovus `routeDesign`, ICC2 `route_auto`, OpenRoad `detailed_route` (TritonRoute engine)
- **Parasitic extraction:** StarRC, Calibre xRC, OpenRoad `write_spef` (SPEF: Standard Parasitic Exchange Format)
- **Post-routing optimization:** Innovus `optDesign -postRoute`, ICC2 `route_opt`

## Common pitfalls
- Large GBs (fast but inaccurate; detailed router fails; problem not solved, just shifted)
- Ignoring capacity constraints (overflow → detailed router fails)
- Not fixing congestion early (flagged in global routing; fix placement/macros before detailed routing)
- Routing pitch too aggressive (line-on-line → via DRCs) or too conservative (via-on-via → wasted space)
- Not inserting redundant vias (via defects → reliability failures; single-point failures)
- CMP fills without re-extraction (coupling C changes → timing violations)
- Not re-running STA post-routing (parasitics accurate only after exact layout; earlier STA estimates)

## Key takeaways
- Routing: Hardest physical design task (billions of nets, limited resources, design rules, timing, SI)
- Global routing: Plan (grid graph: GBs + edges) → maximize detailed router success (minimize overflow, wire length, delay)
- Grid graph: Vertices=GBs, edges=boundaries (preferred direction) + vias (vertical adjacency)
- Capacity, use, overflow: use≤cap (legal); use>cap → overflow (OF=use-cap; detailed router may fail)
- Congestion: CG=use/cap (fraction of resources used; ↑CG → worse; spread routing evenly)
- Global routing goal: OF=0 for all nets (may take detours; sacrifice timing for routability)
- Detailed routing: Exact layout (wire segments: width, location); tracks (uniform spacing: routing pitch)
- Routing pitch: Line-on-via typical (via-line min spacing; tradeoff: allocates via space, less waste)
- Over-the-cell routing: Upper layers available (cell uses lower layers)
- Post-routing: Extract parasitics (accurate) → STA → fix timing (upsize, buffer, reroute, wire widen), power (downsize non-critical), SI (spacing, resize)
- Antenna: Layer jump, jumper, diode insertion (prevent plasma-induced gate damage)
- Via redundancy: On-track/off-track (insert 2+ vias; reliability; via defects: mask misalignment, thermal stress)
- CMP fills: Dummy metal (sparse regions; uniform roughness) → caution: changes coupling C → re-extract, re-run STA
- Routing is NP-complete: Heuristics (may not be optimal); global routing used in synthesis/floorplan/placement (fast prototyping)

**Cross-links:** See Lec47-48: Chip planning (power grid, clock mesh; routing blockages); Lec49: Placement (routability: primary goal); Lec51: CTS (clock routing frozen post-CTS); Lec53: Post-layout verification (parasitic extraction, STA, DRC, LVS)

---

*This summary condenses Lec52 from ~14,000 tokens, removing verbose grid graph examples, redundant overflow/congestion definitions, and repeated post-routing optimization walkthroughs.*
