# Lec49 — Placement

## Overview
Covers standard cell placement: goal (routability, minimize wire length), stages (global placement, legalization, detailed placement), wire length estimation (half-perimeter), analytical placement (point objects, math solvers), timing-driven placement, scan cell reordering, and spare cell placement.

## Core concepts
**Placement objective:**
- **Goal:** Ensure routability (routing is hardest physical design task; placement → decide cell locations making routing feasible)
- **Primary metric:** Minimize total wire length (Σ wire lengths of all nets)
  - **Intuition:** Short wires → cells close → easier routing, better timing, ↓congestion
- **Secondary metrics:** Timing (critical paths), congestion (avoid routing hotspots)

**Placement stages:**
1. **Global placement:** Spread cells evenly over core area (ignore overlaps, cell dimensions)
   - **Why spread:** Routing resources distributed uniformly → even cell distribution → better resource utilization
   - **Output:** Cells positioned (may overlap; not in legal rows)
2. **Legalization:** Remove overlaps, snap cells to legal sites (row positions)
   - **Legal site:** On allocated standard cell rows (from floorplanning)
   - **Incremental changes:** Minimal perturbation (shift cells slightly; don't radically alter global placement solution)
3. **Detailed placement:** Improve QR (wire length, timing, routability) via incremental changes
   - **Methods:** Swap adjacent cells, redistribute free space, move cells to unused locations
   - **Incremental:** Small adjustments (large changes → degrade solution)

**Wire length estimation (half-perimeter/semi-perimeter):**
- **Method:** Bounding box enclosing all net pins → perimeter/2
- **Formula:** HPWL = (x_max - x_min) + (y_max - y_min)
- **Advantages:** Fast to compute (only min/max coordinates), fairly accurate (especially 2-3 pin nets)
- **Usage:** Placement tools call repeatedly (estimate wire length for candidate cell positions)

**Analytical placement:**
- **Approach:** Cells as point objects (ignore dimensions; use center or corner coordinates: x_i, y_i)
- **Cost function:** Total wire length ≈ Σ (x_i - x_j)² + (y_i - y_j)² (Euclidean distance squared; differentiable)
- **Solver:** Mathematical optimization (quadratic programming, conjugate gradient) → find {x_i, y_i} minimizing cost
- **Constraints:** (1) Fixed entities (macros, IOs; constrain connected cells), (2) Cell density (penalize high-density regions; avoid trivial solution: all cells at one point)
- **Modifications:** Add density cost term (spreads cells), fixed entity constraints (cells pulled toward connected IOs/macros)
- **Outcome:** Overlaps allowed (global placement); legalization follows

**Timing-driven placement:**
- **Mechanism:** Internal timer (STA) → identify critical paths (negative slack) → adjust placement to improve timing
- **Objective:** Worst Negative Slack (WNS; most negative slack path) or Total Negative Slack (TNS; Σ negative slacks)
- **Method:** Weight critical nets higher in cost function (e.g., critical net: weight=10× normal) → solver places critical cells closer → ↓interconnect delay → ↑timing
- **Incremental timing:** Evaluate timing impact of small placement changes (fast; avoids full STA for every perturbation)

**Scan cell reordering (post-placement optimization):**
- **Problem:** Scan chain order (DFT stage) arbitrary (no placement info) → long wires between consecutive scan cells
- **Solution:** Reorder scan chain (consecutive cells = nearby cells) → ↓wire length, ↓routing resources
- **Example:** Initial chain: SI → FF1 → FF2 (far) → FF3 → ... → SO (long wires)
  - Reordered: SI → FF1 → FF3 (nearby) → FF5 → FF2 → FF4 → FF6 → SO (short wires)
- **Note:** Test patterns change (chain order different); regenerate ATPG patterns post-reordering

**Spare cell placement:**
- **Purpose:** Allow post-fab bug fixes with reduced respin cost (only top metal layers; device layers unchanged)
- **Mechanism:** Insert unconnected spare cells during design → if bug found post-fab → rewire spare cells → fix functionality
- **Cost savings:** Device layers (bottom ~10-15 layers) unchanged → only top metal layers (interconnects) respun → cheaper than full mask set respin
- **Placement:** (1) Near anticipated problem areas (complex modules), (2) Random (if unpredictable; distributed over layout)
- **Caution:** Spare cells unconnected → tools may optimize out → mark as "don't touch" (prevent removal)

## Methods/flows
**Placement flow:**
1. **Global placement:** Analytical method (cells as points, minimize wire length + density cost) → cells spread over core (overlaps OK)
2. **Legalization:** Remove overlaps (shift cells apart), snap to legal sites (rows) → minimal perturbation
3. **Detailed placement:** Swap adjacent cells, redistribute free space, move to unused locations → improve wire length, timing, routability

**Analytical placement:**
1. Formulate cost: φ = Σ [(x_i - x_j)² + (y_i - y_j)²] + λ·density_cost (λ: weight; density_cost penalizes high-density regions)
2. Add constraints: Fixed entities (macros at (x_fixed, y_fixed)), cell density limits
3. Solve: Quadratic programming → {x_i, y_i} for all cells (overlaps allowed)
4. Legalize: Snap to legal rows, remove overlaps

**Half-perimeter wire length:**
- Net with pins at (x₁,y₁), (x₂,y₂), (x₃,y₃), (x₄,y₄)
- Bounding box: x_min=min(x₁,x₂,x₃,x₄), x_max=max(...), y_min=min(y₁,...), y_max=max(...)
- HPWL = (x_max - x_min) + (y_max - y_min)

**Timing-driven placement:**
1. Run STA → identify critical paths (WNS, TNS)
2. Weight critical nets (e.g., critical net: w=10; normal: w=1)
3. Cost: φ = Σ w_ij · [(x_i - x_j)² + (y_i - y_j)²] → critical cells placed closer
4. Re-run STA → verify timing improvement; iterate if needed

**Scan cell reordering:**
1. Post-placement: Know cell locations (x_i, y_i for all scan cells)
2. Reorder chain: Consecutive cells = nearby cells (e.g., sort by x-coordinate or use TSP-like heuristic)
3. Update netlist: Reconnect scan chain (SI → FF_nearest → FF_next_nearest → ... → SO)
4. Regenerate test patterns (ATPG; chain order changed)

## Constraints/assumptions
- **Placement is NP-complete:** Heuristics (analytical, simulated annealing, etc.) used; may not be optimal
- **Global placement overlaps:** Cells may overlap (dimensions ignored); legalization resolves
- **Incremental changes:** Legalization, detailed placement perturb minimally (large changes → degrade solution)
- **Spare cells:** Pre-placed (anticipatory; may go unused); tools must not optimize out

## Examples
**Half-perimeter wire length:**
- Net n: pins at p1(1,5), p2(9,5), p3(9,11), p4(3,7)
- Bounding box: x_min=1, x_max=9, y_min=5, y_max=11
- HPWL = (9-1) + (11-5) = 8 + 6 = 14

**Analytical placement (simplified):**
- 2 cells: C1 connected to IO at (0,0), C2 connected to C1 and IO at (10,0)
- Cost: φ = (x₁-0)² + (y₁-0)² + (x₁-x₂)² + (y₁-y₂)² + (x₂-10)² + (y₂-0)²
- Minimize φ (calculus: ∂φ/∂x₁=0, ∂φ/∂y₁=0, ...) → solution: C1 at (~3.3, 0), C2 at (~6.7, 0)

**Timing-driven placement:**
- Critical path: A → B → C (slack=-2ns); normal path: D → E (slack=+5ns)
- Weight critical net (A-B, B-C): w=10; normal (D-E): w=1
- Cost: φ = 10·[(x_A-x_B)² + ...] + 10·[(x_B-x_C)² + ...] + 1·[(x_D-x_E)² + ...]
- Solver places A, B, C close (minimize weighted cost) → ↓wire length → ↑timing

**Scan cell reordering:**
- Initial: SI → FF1(0,0) → FF2(10,0) → FF3(0,5) → ... (wire: SI→FF1: 0, FF1→FF2: 10, FF2→FF3: √(10²+5²)≈11; total≈21)
- Reordered: SI → FF1(0,0) → FF3(0,5) → FF2(10,0) → ... (wire: 0+5+√125≈16; saved ~5 units)

**Spare cells:**
- Design: Insert 10× 2-input NAND spare cells (random placement)
- Post-fab bug: Need inverter at location (5,5) → use nearby spare NAND (at 5,6; tie one input high → inverter)
- Respin: Only rewire top 2 metal layers (M7, M8) → device layers (M1-M6) unchanged → cost↓

## Tools/commands
- **Placement:** Innovus `place_design`, ICC2 `place_opt`, OpenRoad `global_placement` + `detailed_placement`
- **Analytical placement:** RePlAce (OpenRoad's global placer; quadratic, nonlinear optimization)
- **Timing-driven:** Innovus `-timing_driven`, ICC2 `place_opt -optimize_dft`
- **Scan reordering:** Innovus `reorder_scan`, ICC2 `set_scan_configuration -chain_reorder`

## Common pitfalls
- Not legalizing (overlaps remain → routing fails, DRC violations)
- Large changes in detailed placement (degrades global placement solution → worse wire length/timing)
- Ignoring timing (minimize wire length only → critical paths may worsen)
- Not reordering scan chains (long scan wires → routing congestion, test time↑)
- Optimizing out spare cells (mark "don't touch"; else tools remove unconnected cells)
- Over-packing (high utilization → no free space for detailed placement swaps → poor QR)

## Key takeaways
- Placement goal: Routability (routing is hardest task; good placement → feasible routing)
- Primary metric: Minimize total wire length (short wires → easier routing, better timing)
- Stages: Global (spread cells, ignore overlaps) → legalization (remove overlaps, snap to rows) → detailed (incremental improvements)
- Half-perimeter wire length (HPWL): Bounding box perimeter/2; fast, accurate for small nets
- Analytical placement: Cells as point objects, minimize wire length (quadratic cost) + density constraints → math solver → overlaps allowed
- Timing-driven: Weight critical nets higher (e.g., 10×) → solver places critical cells closer → ↓interconnect delay → improve timing
- Scan cell reordering: Post-placement; reorder chain (consecutive = nearby) → ↓wire length, ↓routing resources (test patterns change; regenerate ATPG)
- Spare cells: Unconnected cells (anticipatory; post-fab bug fixes) → rewire top metal layers only → reduced respin cost (device layers unchanged)
- Placement is NP-complete: Heuristics (analytical, simulated annealing, etc.); may not be optimal
- Global placement overlaps OK: Legalization resolves (incremental; minimal perturbation)
- Detailed placement incremental: Swap adjacent, redistribute free space → improve QR (large changes → degrade)

**Cross-links:** See Lec47-48: Chip planning (floorplan, macro placement, standard cell rows); Lec28-30: STA (timing analysis; timing-driven placement uses internal timer); Lec40: Scan design (scan chains; reordered post-placement); Lec50-51: CTS, routing (next physical design stages)

---

*This summary condenses Lec49 from ~11,000 tokens, removing verbose analytical placement derivations, redundant wire length estimation examples, and repeated scan reordering walkthroughs.*
