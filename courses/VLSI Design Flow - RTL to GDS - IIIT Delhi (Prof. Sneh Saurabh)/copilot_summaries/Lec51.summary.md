# Lec51 — Clock Tree Synthesis (CTS)

## Overview
Covers CTS objectives (minimize skew, reduce power), terminologies (source, sink, insertion delay, skew), clock distribution networks (global/local, symmetric trees: H-tree/X-tree, non-tree: cross-links/mesh), and useful skew (controlled skew to improve performance).

## Core concepts
**CTS motivation:**
- **Logic synthesis assumption:** Ideal clock (zero skew; same waveform everywhere; instantaneous propagation)
- **Physical design reality:** Non-ideal (delays in clock path → skew; different arrival times at flip-flops)
- **CTS goal:** Mimic ideal clock (minimize skew; cannot achieve zero skew due to PVT variations)

**Clock buffers/inverters (why needed):**
- **Delay reduction:** Long wire (R=2rL, C=2cL) → delay=4rcL²; insert buffer at mid-point → 2×rcL² (half delay)
- **Signal quality:** Long wire → slew degradation (2ps→100ps); buffers restore sharpness (pull up to VDD; restore transitions)
- **Drive capability:** Buffers enhance drive strength (large loads; sharp transitions)

**Terminologies:**
- **Source:** Starting point of clock signal (clock generator; from SDC: `create_clock`, `create_generated_clock`)
- **Sink:** Final receiving endpoints (clock pins of flip-flops; leaves of clock tree)
- **Insertion delay (latency):** Time from source to sink (propagation through clock tree; estimated during synthesis; actual post-CTS)
- **Clock skew (δ_S1,S2):** Difference in arrival time between two sinks S1, S2 → δ = t_S1 - t_S2
  - **Example:** t_a=30ps, t_b=40ps → δ_ab = 30-40 = -10ps; δ_ba = 40-30 = +10ps (sign matters)
- **Global skew:** Max skew between any pair of sinks → max|δ_S1,S2| for all S1, S2
  - **Example:** t_a=30ps, t_b=40ps, t_c=30ps, t_d=26ps → δ_global = 40-26 = 14ps (b has max, d has min)

**Clock distribution hierarchy:**
- **Global clock distribution network:** Distributes clock across entire chip (large area, large buffers, high power; manual planning, manual intervention)
- **Local clock distribution network:** Delivers clock to individual flip-flops (small area, smaller buffers; automated by CTS tools)
- **Global endpoints → Local starts:** Global network endpoints connect to local network starts

**Symmetric tree architectures (global network):**
- **H-tree:** Clock source → center of chip → symmetric H structure → endpoints (same wire length from source to all endpoints)
- **X-tree:** Clock source → center → symmetric X structure → endpoints (same distance; balanced delays)
- **Ideal:** All paths same length → zero skew (with matched buffers/inverters)
- **Reality:** PVT variations (process: wire thickness varies; voltage/temperature fluctuations) → skew still observed (delays vary)

**Non-tree architectures (reduce PVT impact):**
- **Cross-links:** Add cross-links between symmetric tree nodes → shared paths → correlated delays → ↓PVT impact
- **Mesh architecture:** 2D grid with redundant wires/devices; drive from multiple points → many paths from source to any point → highly correlated delays → very small skew
  - **Advantages:** (1) Very low skew (many shared paths), (2) Robust (one link breaks → alternate paths), (3) ↓PVT impact
  - **Disadvantages:** (1) High capacitance (more wires) → ↑power, (2) Short-circuit power (drivers with skewed inputs → pMOS/nMOS both ON briefly → short-circuit current)

**Useful skew:**
- **Concept:** Introduce controlled skew to improve performance (not minimize skew → zero)
- **When useful:** Significant slack difference on two sides of flip-flop (one path critical, other has excess margin)
- **Mechanism:** Delay clock to non-critical flip-flop → allocate more time to critical path → ↑max frequency
- **Example:** Path A: FF1→D1(200ps)→FF2; Path B: FF2→D2(300ps)→FF3; zero skew → T_clk≥300ps (f_max=3.33GHz)
  - **Add delay (50ps) to FF2 clock:** Path A: 100+200 < T+50 → T≥250ps; Path B: 50+300 < T+100 → T≥250ps → T_clk=250ps (f_max=4GHz; 20% improvement)
- **Caution:** (1) Optimum delay exists (too much → other path becomes critical), (2) Setup improves, hold may worsen (late clock → capture FF → hold risk)
- **Side benefit:** ↓IR drop (staggered flip-flop triggering → spread current draw over time → ↓simultaneous switching)

**Post-CTS:**
- **Realistic timing:** Clock network built → actual delays (no longer ideal/estimated)
- **SDC update:** `set_propagated_clock [all_clocks]` (use actual delays; remove network latency estimates; source latency remains)
- **New violations:** (1) Additional skew (realistic clock), (2) Data path changes (logic displaced for clock buffers → ↑delay)
- **Optimization:** Resize, buffering, incremental placement → fix violations
- **Frozen clock network:** After CTS + optimization → clock network frozen (no changes unless ECO: engineering change order)

## Methods/flows
**CTS flow:**
1. Insert clock buffers/inverters (reduce delay, restore signal quality, enhance drive)
2. Route clock distribution network (global: symmetric tree/mesh → local: to flip-flops)
3. Minimize skew (balanced paths; matched buffers) + reduce power (↓capacitance, ↓buffers)
4. Fix timing violations (new violations post-CTS; data path perturbed)
5. Update SDC: `set_propagated_clock [all_clocks]` (use actual clock delays)
6. Freeze clock network (no changes post-CTS; only ECO allowed)

**Useful skew insertion:**
1. Identify critical/non-critical paths (STA: WNS, TNS)
2. Calculate optimum delay (balance slack on both sides of FF)
3. Insert delay buffers/extra wires on non-critical clock paths
4. Verify setup (improves), hold (may worsen; check), timing closure

## Constraints/assumptions
- **Ideal clock (synthesis):** Zero skew, zero delay (unrealistic; estimate via latency/uncertainty)
- **PVT variations:** Skew inevitable (symmetric trees: same length ≠ same delay)
- **Useful skew:** Requires slack analysis (significant slack difference on FF sides)
- **Power:** Clock network: 25-70% of active power (high activity; transitions every cycle)

## Examples
**Buffer insertion (delay reduction):**
- **Before:** Wire (2L): R=2rL, C=2cL → delay=RC=4rcL²
- **After:** Wire (L) + buffer + wire (L): delay ≈ rcL² + B + rcL² = 2rcL² + B (if B<<rcL², delay halves)

**Clock skew:**
- Sinks: a (30ps), b (40ps), c (30ps), d (26ps)
- δ_ab = 30-40 = -10ps; δ_ba = 40-30 = +10ps
- δ_global = max|δ| = |40-26| = 14ps

**Useful skew:**
- **Zero skew (ideal):** FF1 (50ps) → D1 (200ps) → FF2 (50ps) → D2 (300ps) → FF3 (50ps)
  - Path A (FF1→FF2): 50+200 < T+50 → T≥200ps
  - Path B (FF2→FF3): 50+300 < T+50 → T≥300ps → T_min=300ps → f_max=3.33GHz
- **Useful skew (add 50ps delay to FF2):** FF1 (50ps), FF2 (100ps), FF3 (50ps)
  - Path A: 100+200 < T+50 → T≥250ps
  - Path B: 50+300 < T+100 → T≥250ps → T_min=250ps → f_max=4GHz (20% ↑)

**Symmetric tree (H-tree):**
- Source → center → 4 branches (H shape) → each branch same length → zero skew (ideal; PVT → small skew actual)

**Mesh:**
- 2D grid; drive from multiple points → point A: many paths from source (shared with point B) → delays correlated → ↓skew, ↓PVT impact

## Tools/commands
- **CTS:** Innovus `clock_design`, ICC2 `clock_opt`, OpenRoad `clock_tree_synthesis`
- **Useful skew:** Innovus `-useful_skew`, ICC2 `set_clock_tree_options -target_skew`
- **Post-CTS SDC:** `set_propagated_clock [all_clocks]` (use actual delays; remove network latency)

## Common pitfalls
- Assuming zero skew possible (PVT variations → skew inevitable; minimize, not eliminate)
- Not inserting buffers (long wires → high delay, poor signal quality)
- Over-inserting buffers (↑power, ↑area; insert only where needed: long wires, high loads)
- Ignoring PVT (symmetric tree: same length ≠ same delay; need non-tree: cross-links, mesh)
- Useful skew without optimization (arbitrary delay → other path critical; calculate optimum)
- Not checking hold post-useful-skew (setup improves, hold may worsen; verify both)
- Not updating SDC post-CTS (`set_propagated_clock`; else tools use estimates → inaccurate timing)
- Modifying clock network post-CTS (frozen; only ECO allowed; else risk violations)

## Key takeaways
- CTS goal: Mimic ideal clock (minimize skew; reduce power; fix timing violations)
- Ideal clock (synthesis): Zero skew, zero delay (unrealistic); CTS builds realistic clock network
- Buffers/inverters: (1) Reduce delay (long wire: split → half delay), (2) Restore signal quality (sharp transitions), (3) Enhance drive
- Insertion delay (latency): Time from source to sink (estimated during synthesis; actual post-CTS)
- Clock skew: Difference in arrival time between sinks (δ_S1,S2 = t_S1 - t_S2; global skew = max|δ|)
- Global network: Distributes clock across chip (large buffers, high power; manual planning)
- Local network: Delivers to flip-flops (smaller buffers; automated by CTS)
- Symmetric trees: H-tree, X-tree (same wire length → zero skew ideal; PVT → small skew actual)
- Non-tree: Cross-links (shared paths → correlated delays → ↓PVT), mesh (many paths → very low skew, robust; high power)
- Mesh advantages: Very low skew, robust (alternate paths), ↓PVT impact
- Mesh disadvantages: High capacitance (↑power), short-circuit power (skewed driver inputs)
- Useful skew: Controlled skew to improve performance (delay non-critical FF clock → allocate time to critical path → ↑f_max)
- Useful skew caution: Optimum delay (balance slack), hold may worsen (verify), IR drop benefit (staggered switching)
- Post-CTS: Update SDC (`set_propagated_clock`; use actual delays), new violations (skew, data path perturbed), optimize, freeze clock network

**Cross-links:** See Lec28-30: STA (timing analysis; setup/hold constraints; useful skew uses slack); Lec47-48: Chip planning (power planning; IR drop; useful skew reduces IR drop); Lec52: Routing (clock routing frozen post-CTS)

---

*This summary condenses Lec51 from ~11,000 tokens, removing verbose derivations, redundant skew examples, and repeated buffer insertion explanations.*
