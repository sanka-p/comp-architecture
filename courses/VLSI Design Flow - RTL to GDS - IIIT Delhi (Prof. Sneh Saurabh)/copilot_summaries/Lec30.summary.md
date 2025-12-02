# Lec30 — Static Timing Analysis Part III: Slew Propagation and Variations

## Overview
Covers slew propagation methods (GBA: graph-based analysis with pessimism; PBA: path-based analysis with accuracy), variation modeling (MMMC: multimode multi-corner analysis for global variations; OCV: on-chip variation derating for local variations), and trade-offs (accuracy vs computational cost).

## Core concepts
**Slew propagation challenge:**
- **Problem:** Delay depends on input slew (from .lib NLDM/CCS tables) → must propagate slew alongside arrival time
- **Multiple paths:** Different timing arcs produce different output slews at same vertex (e.g., NAND A→Z: slew=10ps; B→Z: slew=15ps; C→Z: slew=8ps)
- **Storage explosion:** If store all slews → exponential growth (3 arcs → 3 slews; next stage with 3 inputs → 3×3=9 slews; N stages → 3^N slews)
- **Solution:** Store only bounds (min/max slew) per vertex → linear storage

**Monotonicity property:**
- **Key insight:** Delay, output slew are monotonically non-decreasing functions of input slew (↑ input slew → ↑ output slew, ↑ delay)
- **Implication:** Storing min/max slew bounds sufficient to compute delay bounds (no need to track all intermediate slews)
- **Example:** Input slew: 10ps → delay=50ps, slew_out=5ps; Input slew: 20ps → delay=80ps, slew_out=8ps (↑ input → ↑ delay, ↑ slew_out)

**GBA (Graph-Based Analysis):**
- **Method:** At each vertex, store only S_min, S_max (independent of path)
  - **Slew bound:** S_j_min = min(OS_ij_min) ∀i; S_j_max = max(OS_ij_max) ∀i (OS_ij = output slew from edge i→j)
  - **Arrival time:** A_j_max = max(A_i_max + D_ij_max) ∀i (using D_ij_max corresponding to S_i_max)
- **Pessimism:** Arrival time and slew may come from different paths (e.g., A_max from path A→Y, S_max from path C→Y)
  - **Consequence:** Overly pessimistic bounds (e.g., computed A_max=250ps, actual worst-case=200ps)
- **Efficiency:** Linear storage (2 slews per vertex: min/max); single-pass traversal
- **Usage:** Default mode in STA tools (fast, safe, but may report false violations)

**PBA (Path-Based Analysis):**
- **Method:** Propagate arrival time and slew through same path (compute per-path bounds)
  - **Example:** Path A→Y→X: A=180ps, S=10ps; Path C→Y→X: A=200ps, S=20ps → worst-case A=200ps (tighter than GBA's 250ps)
- **Accuracy:** Removes GBA pessimism (arrival time, slew consistent along path)
- **Cost:** Exponential paths (cannot analyze all paths) → selective PBA (analyze only failing paths from GBA)
- **Usage:** Invoked for critical paths flagged by GBA (remove false violations; reduce over-design)

**Variations:**
- **PVT:** Process, Voltage, Temperature fluctuations → delays/slews vary from nominal
- **Global variations:** All devices affected similarly (e.g., slow process corner → all gates slower)
- **Local variations:** Random device-to-device differences (e.g., gate G1: +10% delay, G2: -5% delay)

**MMMC (Multimode Multi-Corner Analysis):**
- **Purpose:** Account for global variations (PVT corners)
- **Scenarios:** Combinations of:
  1. **PVT corners:** Different .lib files (slow, fast, typical process; VDD min/max; T= -40°C/125°C)
  2. **Modes:** Different SDC files (functional, test, sleep, turbo modes → different clock frequencies, control signals)
  3. **RC corners:** Different SPEF files (C_min, C_max, RC_min, RC_max)
- **Example:** 3 PVT corners × 4 modes × 4 RC corners = 48 scenarios
- **Mechanism:** Analyze all scenarios simultaneously (dominated scenarios pruned; parallel processing)
  - **Dominated scenario:** If scenario A always worse than scenario B → skip A (B's safety implies A's safety)
- **Efficiency:** Avoids 48 separate STA runs (prune dominated scenarios; parallel execution)

**OCV (On-Chip Variation) derating:**
- **Purpose:** Account for local variations (random device-to-device differences)
- **Method:** Apply derating factors to delays
  - **Effective delay:** D_eff = D_nominal × derate_factor
  - **Path-specific:** Data path derate ≠ clock path derate; gate delay derate ≠ interconnect delay derate
  - **Late/early:** Late paths (data, clock launch) use derate > 1 (pessimistic); Early paths (clock capture for setup, data for hold) use derate < 1
- **Example:** Late derate=1.1, early derate=0.9
  - **Setup analysis:** Data path: D×1.1 (late); Clock capture: D×0.9 (early) → tighter constraint
  - **Hold analysis:** Data path: D×0.9 (early); Clock capture: D×1.1 (late) → tighter constraint
- **Trade-off:** Over-derating → area/power overhead (over-design); under-derating → timing failures (low yield)

**Derate application (setup vs hold):**
- **Setup (late analysis):**
  - **Late paths:** Data path, clock launch path → derate = 1.1 (increase delay → more pessimistic)
  - **Early paths:** Clock capture path → derate = 0.9 (decrease delay → more pessimistic)
- **Hold (early analysis):**
  - **Early paths:** Data path, clock launch path → derate = 0.9 (decrease delay → more pessimistic)
  - **Late paths:** Clock capture path → derate = 1.1 (increase delay → more pessimistic)
- **Rationale:** Pessimism ensures safety (if worst-case passes, all cases pass)

## Methods/flows
1. **GBA slew propagation:** Store S_min, S_max at each vertex → propagate via S_j_max = max(OS_ij_max) ∀i → use for next stage delay calculation
2. **PBA slew propagation:** For failing path P from GBA → re-compute arrival time, slew along P (consistent path) → tighter bound → check if violation real or false
3. **MMMC analysis:** Define scenarios (PVT corners × modes × RC corners) → analyze simultaneously → prune dominated scenarios → report worst-case violations across all scenarios
4. **OCV derating:** Specify derate factors (late/early, data/clock, gate/interconnect) → apply D_eff = D_nominal × derate → re-compute arrival/required times

## Constraints/assumptions
- Monotonicity: Delay/slew non-decreasing with input slew (valid for CMOS; breaks for some exotic circuits)
- GBA pessimism: Safe (never misses violations) but may report false violations
- PBA cost: Exponential paths → selective use (only for failing paths from GBA)
- MMMC: Assumes global variations (all devices shift together); local variations need OCV
- OCV: Assumes statistical delay variation (normal distribution); requires silicon data for accurate derate factors

## Examples
- **Slew propagation (3-input NAND):** A→Z: slew=10ps, B→Z: slew=15ps, C→Z: slew=8ps → GBA stores S_max=15ps (from B) → next stage uses 15ps (pessimistic if signal actually from A)
- **GBA vs PBA:** Path A→Y→X: A=180ps (slew=10ps); Path C→Y→X: A=200ps (slew=30ps); GBA: A_max=250ps (uses worst arrival + worst slew from different paths); PBA: A_max=200ps (consistent path)
- **MMMC:** Scenario 1: slow .lib, func.sdc, C_max.spef → worst setup slack; Scenario 2: fast .lib, turbo.sdc, C_min.spef → worst hold slack
- **OCV:** Nominal delay=100ps; Late derate=1.1 → D_eff=110ps (setup data path); Early derate=0.9 → D_eff=90ps (setup clock capture path)

## Tools/commands
- **STA tools:** Synopsys PrimeTime (MMMC, OCV, GBA/PBA), Cadence Tempus, Siemens Questa STA
- **MMMC setup:** Define scenarios (set_scenario; set_operating_conditions; read_sdc; read_spef)
- **OCV commands:** `set_timing_derate -late 1.1 -data` (data path late derate), `set_timing_derate -early 0.9 -clock` (clock early derate)
- **PBA:** `update_timing -full` (GBA), `update_timing -full -path_based` (PBA for critical paths)

## Common pitfalls
- Confusing GBA (fast, pessimistic) with PBA (slow, accurate; use only for failing paths)
- Applying same derate to all paths (should differ for data/clock, gate/interconnect, late/early)
- Over-derating (excessive area/power overhead) or under-derating (timing failures post-silicon)
- Running 48 separate STA for MMMC (use simultaneous analysis to prune dominated scenarios)
- Assuming PBA removes all pessimism (still has approximations; exact analysis infeasible)

## Key takeaways
- Slew propagation: Delay depends on input slew → must propagate slew alongside arrival time
- Monotonicity: ↑ input slew → ↑ delay, ↑ output slew (CMOS property) → storing min/max bounds sufficient
- GBA (Graph-Based Analysis): Store S_min, S_max per vertex (path-independent) → fast, pessimistic (arrival time, slew from different paths)
- PBA (Path-Based Analysis): Propagate arrival time, slew along same path → accurate, expensive → use selectively for failing GBA paths
- GBA vs PBA: GBA default (safe, fast); PBA for critical paths (remove false violations)
- Variations: Global (MMMC: PVT corners) + local (OCV: derating factors)
- MMMC: 3 PVT corners × 4 modes × 4 RC corners = 48 scenarios → analyze simultaneously (prune dominated; parallel execution)
- OCV derating: D_eff = D_nominal × derate; late/early, data/clock, gate/interconnect have different factors
- Setup analysis: Data path late (derate>1), clock capture early (derate<1)
- Hold analysis: Data path early (derate<1), clock capture late (derate>1)
- Trade-off: Accuracy (PBA, MMMC, OCV) vs computational cost (GBA faster)

**Cross-links:** See Lec28: setup/hold requirements; Lec29: timing graph, arrival/required time; Lec26: .lib (NLDM, PVT corners); Lec31: SDC constraints (modes); Lec07: physical design (SPEF extraction)

---

*This summary condenses Lec30 from ~16,000 tokens, removing repeated slew propagation numerical examples, redundant MMMC scenario enumeration tables, and verbose OCV derating walkthroughs.*
