# Lec35 — Timing-Driven Optimization

## Overview
Post-technology-mapping optimizations targeting critical paths. Covers flow (STA → identify targets → apply transformations → incremental STA → area recovery), and transformations (resizing, restructuring/rewiring, fan-out optimization, retiming) with PPA trade-offs.

## Core concepts
**Timing-driven optimization flow:**
1. **STA (Static Timing Analysis):** Analyze mapped netlist (library cells) → identify critical paths, slack violations
2. **Check timing target:** If slack ≥ target (e.g., >0ps or >100ps for synthesis margin) → DONE; else continue
3. **Identify targets:** Find critical paths, negative slack paths, or paths close to violation
4. **Apply transformations:** Resizing, restructuring, fan-out optimization, retiming (iteratively)
5. **Incremental STA:** Re-analyze only affected logic cone (not entire design → fast)
6. **Iterate:** Repeat until timing target met OR no further improvement possible
7. **Area recovery:** After timing OK, reduce area in non-critical paths (convert large cells → small cells where slack permits)

**Why after technology mapping:**
- **Library cells have PPA:** Can compute delay, area, power (not possible with generic gates)
- **Timing analysis feasible:** Delays known from .lib → identify critical paths
- **Targeted optimization:** Focus on critical paths (not global optimization)

**Slack target > 0:**
- **Reason:** Interconnect delays unknown before physical design (wires not laid out) → leave margin (e.g., 100ps slack) for wire delay
- **After place & route:** Interconnect delays known → slack target can be 0ps

## Transformations
**1. Resizing:**
- **Operation:** Replace cell with same function, different size (e.g., inverter 1x → 2x)
- **Larger size (upsize):**
  - **Benefit:** Lower delay (larger transistors → higher drive current → faster charging), lower output slew
  - **Cost:** Higher area, higher power, higher input capacitance (affects driver delay)
- **Smaller size (downsize):**
  - **Benefit:** Lower area, lower power, lower input capacitance
  - **Cost:** Higher delay, higher output slew
- **Effects:**
  - **Fan-out (downstream):** Upsize → lower delay, lower slew (faster downstream gates)
  - **Fan-in (upstream):** Upsize → higher input cap → driver sees higher load → driver delay increases, driver slew increases
- **Trade-off:** Upsize improves fan-out delay, degrades fan-in delay → optimal size balances both
- **Tool strategy:** Iterative sizing (upsize critical cells; downsize non-critical after area recovery)

**2. Restructuring (rewiring):**
- **Operation:** Move late-arriving signals closer to output (reduce depth)
- **Simple case (symmetric gates):** 4-input AND = AND(AND(A, B), AND(C, D)) → move critical signal (highest arrival time) to last stage
  - **Example:** Arrival times: A=40, B=70, C=20, D=30 → B most critical
    - **Original:** 3 levels, max arrival=220ps (70 + 50 + 50 + 50)
    - **Rewired:** Move B to last level → max arrival=180ps (30 + 50 + 50 + 50)
- **General case (asymmetric gates):** Shannon expansion w.r.t. critical variable
  - **Function:** Y = F(x0, x1, ..., xn); xn most critical
  - **Expansion:** Y = xn' · F0 + xn · F1 (F0 = F(xn=0), F1 = F(xn=1); cofactors)
  - **Implementation:** MUX (select=xn; inputs=F0, F1) → xn moved closer to output
  - **Cost:** Area increase (two cofactors F0, F1 may need more gates than original F); added MUX delay
- **Example:** Y = A·B + C; B most critical (arrival=100ps)
  - **Shannon expansion w.r.t. B:** F_B=0 = C, F_B=1 = A + C
  - **Implementation:** MUX(B, C, A+C) → B to select line (1 level from output)
  - **Improvement:** Max arrival: 145ps → 130ps

**3. Fan-out optimization (buffering):**
- **Problem:** High fan-out net → high load → large driver delay, large output slew
- **Solution:** Insert buffers to partition fan-out (reduce load per driver)
- **Strategy:**
  - **Critical path buffering:** Isolate critical sink (add buffer for non-critical sinks) → critical path sees lower load
  - **Fan-out balancing:** Split N sinks into groups (buffer each group) → recursive (buffer tree)
- **Example:** Gate G driving 100 pins (p1...p100); p1 most critical
  - **Buffering:** G → p1 (direct); G → buffer B1 → p2...p100 → lower load on G → faster p1
  - **Cost:** Buffer area, buffer power; p2...p100 delay increases (buffer in path)
- **Violation fixes:** Max transition (output slew), max capacitance (output load) violations → add buffers to reduce slew/cap

**4. Retiming:**
- **Operation:** Move flip-flops to balance logic delays (shift computation across FF boundaries)
- **Example:** FF1 → 500ps logic → FF3 → 400ps logic → FF4
  - **Critical path:** 500ps (limits frequency)
  - **Retiming:** Move AND gate from left side of FF3 to right side (replicate FF3 for AND inputs)
  - **Result:** FF1 → 500ps logic → FF3a, FF3b → AND (50ps) → FF4 (balanced: 500ps, 450ps)
  - **Improvement:** Max delay: 550ps → 500ps (f_max: 1.82GHz → 2GHz)
- **Cost:** Extra flip-flops (FF3a, FF3b vs FF3 → +1 FF); higher area/power
- **Functional equivalence:** Preserved (data shifts by 1 cycle, but I/O behavior same)

**Area recovery:**
- **When:** After timing target met (slack positive on all paths)
- **How:** Downsize cells on non-critical paths (slack permits delay increase) → reduce area/power
- **Trade-off:** Delay increases, but stays within slack budget (timing still OK)

## Methods/flows
1. **Run STA:** Analyze mapped netlist → identify critical paths, slack
2. **If slack < target:** Identify critical cells/paths
3. **Apply transformations:**
   - **Resizing:** Upsize critical cells (reduce delay); downsize non-critical (reduce area)
   - **Restructuring:** Shannon expansion for critical variable → move to output
   - **Fan-out optimization:** Buffer high-fan-out nets (critical path isolation or fan-out balancing)
   - **Retiming:** Shift FFs to balance logic delays across stages
4. **Incremental STA:** Re-analyze affected logic cone (not entire design)
5. **Iterate:** Repeat steps 2-4 until timing target met or no improvement
6. **Area recovery:** Downsize cells on non-critical paths (slack permits delay increase)

## Constraints/assumptions
- **After technology mapping:** Library cells have delays (STA feasible)
- **Interconnect delays unknown:** Before physical design → slack target > 0ps (margin for wire delays)
- **Iterative optimization:** Each transformation affects small region → incremental STA (not full STA)
- **Trade-offs:** Delay vs area/power (upsize: faster but larger; downsize: slower but smaller)
- **Functional equivalence:** Transformations preserve I/O behavior (retiming shifts cycles, but functionality same)

## Examples
**Resizing:** Inverter 1x (delay=100ps, area=10) → 2x (delay=60ps, area=20) on critical path → delay -40ps, area +10
**Restructuring:** Y = A·B + C; B critical (arrival=100ps)
- **Original:** 3 gates (AND, OR, NOT) → max arrival=145ps
- **Shannon w.r.t. B:** MUX(B, C, A+C) → max arrival=130ps (-15ps)
**Fan-out:** G → 100 pins → G → buffer B1 → 99 pins; G → p1 (critical) → p1 delay improves
**Retiming:** FF1 → 500ps → FF3 → 400ps → FF4 (max=500ps) → FF1 → 500ps → FF3a/b → 50ps AND → FF4 (max=500ps; balanced)

## Tools/commands
- **Synthesis tools:** Synopsys Design Compiler (`compile_ultra -timing_driven`), Cadence Genus (`syn_opt -effort high`)
- **STA:** PrimeTime, Tempus (identify critical paths)
- **Incremental STA:** Analyze only affected logic cone (fast; avoids full design STA)
- **Area recovery:** `compile_ultra -incremental -area_effort high` (after timing met)

## Common pitfalls
- Upsizing all cells (excessive area/power; driver delays increase)
- Restructuring non-critical paths (area increase without timing benefit)
- Over-buffering (area/power explosion; diminishing returns)
- Retiming without replication (functional errors; e.g., single FF cannot feed two independent paths)
- Skipping area recovery (timing met, but excessive area/power)
- Ignoring fan-in effects (upsize improves fan-out, but degrades driver → net delay may not improve)

## Key takeaways
- Timing-driven optimization: After technology mapping (library cells → delays known) → target critical paths
- Flow: STA → identify critical paths → apply transformations → incremental STA → area recovery
- Slack target > 0: Before physical design (interconnect delays unknown) → margin for wire delays
- Resizing: Same function, different size (upsize: faster, larger; downsize: slower, smaller); balances fan-in vs fan-out effects
- Restructuring (rewiring): Move late-arriving signals closer to output (Shannon expansion → MUX); cost: area increase
- Fan-out optimization (buffering): Insert buffers to reduce load (critical path isolation or fan-out balancing); cost: buffer area/power
- Retiming: Move FFs to balance logic delays (shift computation across FF boundaries); cost: extra FFs, functional equivalence preserved
- Area recovery: After timing OK, downsize non-critical cells (slack permits delay increase) → reduce area/power
- Incremental STA: Re-analyze only affected logic cone (not entire design) → fast iteration
- Trade-offs: Delay vs area/power (no free lunch; optimize for objective)

**Cross-links:** See Lec34: Technology mapping (precedes timing optimization); Lec28-30: STA (identifies critical paths); Lec26: .lib (cell delays, sizes); Lec32-33: Constraints (timing targets); Lec36: Power analysis/optimization (next topic)

---

*This summary condenses Lec35 from ~9,500 tokens, removing repeated resizing examples, redundant Shannon expansion derivations, and verbose retiming circuit diagrams.*
