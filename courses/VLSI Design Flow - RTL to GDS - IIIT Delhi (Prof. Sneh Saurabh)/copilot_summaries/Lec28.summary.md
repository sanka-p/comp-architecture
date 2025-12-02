# Lec28 — Static Timing Analysis Part I: Setup and Hold Requirements

## Overview
Introduces STA purpose (ensure circuit in valid states, meet frequency/setup/hold), synchronous circuit behavior (valid states), zero clocking (setup violation: data arrives too late), double clocking (hold violation: data arrives too early), setup/hold constraint derivation for realistic flip-flops.

## Core concepts
**STA objectives:**
1. **Valid states:** Ensure circuit in expected state at each clock cycle (avoid zero/double clocking)
2. **Frequency:** Verify design can run at specified clock frequency (from SDC file)
3. **Setup/hold:** Ensure setup/hold time met for all flip-flops

**STA vs simulation:**
- **STA:** No test vectors; pessimistic view (worst-case delays); checks timing only (not functionality); static analysis
- **Simulation:** Requires test vectors; checks functionality; dynamic analysis; incomplete coverage

**Synchronous circuit valid states:**
- **Example:** 2 flip-flops (FF1, FF2), combinational logic (delays D1, D2, D3), clock buffers (C1, C2)
- **Initial state:** Q1=p, Q2=q → state={p, q}
- **Input sequence:** {a, b, c, d} at port IN
- **Valid states (ideal case):** {pq} → {ap} → {ba} → {cb} → {dc} (data advances 1 stage per cycle)

**Zero clocking (setup violation):**
- **Cause:** Data path delay > T_period (data arrives too late; misses capture clock edge)
- **Example:** D2 delay > T_period → data captured 1 cycle late
- **Invalid states:** {pq} → {aq} → {bp} → {ca} (data skips cycles; wrong states)
- **Consequence:** Circuit fails to sample data correctly (synchronicity lost)

**Double clocking (hold violation):**
- **Cause:** Clock path delay (e.g., C2) >> data path delay → data arrives before clock (captured in same cycle)
- **Example:** C2 delay = δ >> D3 delay → data from FF1 captured by FF2 in same cycle
- **Invalid states:** {pp} → {aa} → {bb} (same data latched by both FF1, FF2)
- **Consequence:** Data propagates too fast (violates pipelining)

**Setup requirement (avoid zero clocking):**
- **Constraint:** T_arrival ≤ T_required_setup
- **Derivation:**
  - **T_arrival:** T_launch + T_clk→q (launch FF) + T_data (combinational delay)
  - **T_required_setup:** T_period + T_capture - T_setup (capture FF)
- **Rearranged:** T_period ≥ δ_LC (clock skew) + T_clk→q (launch) + T_data + T_setup (capture)
- **Clock skew (δ_LC):** T_launch - T_capture (difference in clock arrival times at launch/capture FFs)
- **Pessimistic analysis:** T_data = max (longest path), δ_LC = max, T_clk→q = max, T_setup = max
- **Violation if:** Decrease T_period (increase frequency), increase T_data, increase T_launch, decrease T_capture

**Hold requirement (avoid double clocking):**
- **Constraint:** T_arrival ≥ T_required_hold
- **Derivation:**
  - **T_arrival:** T_launch + T_clk→q (launch) + T_data
  - **T_required_hold:** T_capture + T_hold (capture FF)
- **Rearranged:** δ_LC + T_clk→q + T_data ≥ T_hold
- **Pessimistic analysis:** T_data = min (shortest path), δ_LC = min, T_clk→q = min, T_hold = max
- **Violation if:** Decrease T_data, decrease T_launch, increase T_capture
- **Note:** Independent of T_period (clock frequency does not affect hold)

**Ideal case (ideal flip-flops, zero skew):**
- **Setup:** T_period ≥ T_data_max (no zero clocking if delay < clock period)
- **Hold:** T_data_min ≥ 0 (no double clocking if any delay exists)
- **Implication:** Setup prevents zero clocking; hold prevents double clocking (in ideal case)

## Methods/flows
1. **Setup analysis (late analysis):** Compute T_arrival (latest data arrival) → compare with T_required_setup → slack = T_required - T_arrival (positive → pass; negative → violation)
2. **Hold analysis (early analysis):** Compute T_arrival (earliest data arrival) → compare with T_required_hold → slack = T_arrival - T_required (positive → pass; negative → violation)
3. **Pairwise checking:** Analyze each launch-capture FF pair separately (ignore global circuit; focus on adjacent FFs)

## Constraints/assumptions
- STA checks timing for worst-case (pessimistic view; no test vectors needed)
- Assumes synchronous design (all flip-flops clocked by same/related clocks)
- Setup/hold checked at capture FF (not launch FF)
- Clock skew δ_LC depends on clock tree structure (known only after CTS in physical design)
- Flip-flop parameters (T_clk→q, T_setup, T_hold) from .lib file (PVT-dependent)

## Examples
- **Setup violation:** T_period=1ns, δ_LC=0.1ns, T_clk→q=0.2ns, T_data=0.8ns, T_setup=0.2ns → 1ns ≥ 0.1+0.2+0.8+0.2=1.3ns (FAIL; need T_period≥1.3ns or reduce T_data)
- **Hold violation:** δ_LC=0.1ns, T_clk→q=0.1ns, T_data=0.05ns, T_hold=0.3ns → 0.1+0.1+0.05=0.25ns ≥ 0.3ns (FAIL; need T_data≥0.15ns or increase skew)
- **Ideal case:** Setup: T_period ≥ T_data (no FF overhead); Hold: T_data ≥ 0 (trivial if combinational logic exists)

## Tools/commands
- **STA tools:** Synopsys PrimeTime, Cadence Tempus, Siemens Questa STA
- **Constraints:** SDC file (clock period, input/output delays, timing exceptions)
- **Library:** .lib file (T_clk→q, T_setup, T_hold, cell delays)

## Common pitfalls
- Confusing setup (data arrives too late) with hold (data arrives too early)
- Assuming hold depends on clock period (it doesn't; only on skew, data delay, T_hold)
- Forgetting clock skew δ_LC (can be positive or negative; affects both setup and hold)
- Optimizing for setup during synthesis (hold violations appear only after CTS; defer hold fixes to physical design)
- Using launch FF's setup/hold instead of capture FF's (timing checked at capture side)

## Key takeaways
- STA: Ensures timing safety (valid states, frequency, setup/hold) without test vectors (pessimistic worst-case analysis)
- Synchronous circuit: Valid states advance 1 stage per cycle (e.g., {pq}→{ap}→{ba})
- Zero clocking (setup violation): Data delay > T_period → data captured 1 cycle late (invalid states)
- Double clocking (hold violation): Clock delay >> data delay → data captured same cycle (invalid states)
- Setup constraint: T_period ≥ δ_LC + T_clk→q + T_data_max + T_setup (avoid zero clocking)
- Hold constraint: δ_LC + T_clk→q + T_data_min ≥ T_hold (avoid double clocking; independent of T_period)
- Clock skew δ_LC: T_launch - T_capture (can be ±; affects both setup and hold)
- Pessimistic analysis: Setup uses max delays; hold uses min delays
- Pairwise checking: Analyze each launch-capture FF pair separately (not global)
- Ideal case: Setup → T_period ≥ T_data; Hold → T_data ≥ 0
- Hold violations: Common in shift registers (FF→FF, no logic); fix after CTS (not during synthesis)

**Cross-links:** See Lec29: timing graph, arrival/required time, slack computation; Lec30: slew propagation, OCV/MMMC; Lec26: .lib file (T_clk→q, T_setup, T_hold); Lec06: synthesis overview

---

*This summary condenses Lec28 from ~15,000 tokens, removing repeated zero/double clocking circuit diagrams, redundant setup/hold derivation walkthroughs, and verbose state transition tables.*
