# Lec38 — Power Optimization

## Overview
Covers power reduction strategies based on P = C_L·V²_DD·α·f_clk + V_DD·I_leak equation: dynamic voltage/frequency scaling (DVFS), power gating, clock gating, and resizing. Explains circuit modifications (switching cells, retention cells, isolation cells, integrated clock gates) and trade-offs.

## Core concepts
**Power reduction strategies:**
- **Target parameters:** V_DD (quadratic impact), f_clk, α (activity), C_L, I_leak
- **Supply voltage:** Most effective (V²_DD → quadratic reduction); but increases delay (↓V_DD → ↑delay → must ↓f_clk)
- **Clock frequency:** Lower f_clk → lower P_dyn (linear); but increases task completion time
- **Activity:** Reduce toggling (clock gating, operand isolation) → lower α
- **Load capacitance:** Smaller cells → lower C_L (but higher delay)
- **Leakage:** Reduce I_leak (power gating, high-VT cells)

**1. Dynamic Voltage Frequency Scaling (DVFS):**
- **Strategy:** Vary V_DD and f_clk based on workload (high performance → high V_DD/f_clk; low workload → low V_DD/f_clk)
- **Example:** Processor@1.2V, 1.2GHz (task completes in 10ms) → reduce to 0.6V, 600MHz (task completes in 20ms)
  - Power savings: P_sw ∝ V²_DD·f_clk → (0.6/1.2)² × (600/1200) = 1/8 (8× reduction)
  - Energy savings: E = P×time → (1/8)×(20/10) = 1/4 (4× reduction; less than power due to longer time)
- **Trade-off:** Lower V_DD → slower (↑delay) → must ↓f_clk; energy savings < power savings (longer execution time)
- **Application:** Microprocessors (workload varies; full speed only for short bursts; idle/light tasks → low V_DD/f_clk)
- **Implementation:** Feedback loop (workload monitor → voltage/frequency controller → adjust V_DD/f_clk)

**2. Power gating:**
- **Strategy:** Disconnect V_DD for idle blocks (V_DD=0 → P_dyn=0, P_leak=0)
- **Circuit modifications:**
  - **Switching cell (header/footer):** High-VT PMOS/NMOS switch between V_DD and gated block (sleep=0: ON, V_DD_SW=V_DD; sleep=1: OFF, V_DD_SW floating)
  - **Retention cell:** Dual-supply FF (V_DD: always-on; V_DD_SW: switchable); safe signal → latch state to L1 (always-on) before sleep; restore signal → write L1→FF after wake-up
  - **Isolation cell:** Tie gated block outputs to known value (0 or 1) during sleep (prevent X propagation → short-circuit current in fan-out gates)
- **Example:** AND gate: `isolate = (sleep_bar & signal)` → sleep=1 → isolate=0 (outputs forced to 0)
- **Cost:** Area (switching, retention, isolation cells), design complexity (state retention, wake-up sequence)
- **Benefit:** Complete power shut-off (P_dyn + P_leak = 0 during sleep)

**3. Clock gating:**
- **Strategy:** Disable clock to FFs when data not updating (↓activity in clock network + FFs)
- **Motivation:** Clock network: high capacitance (global routing) → high P_sw; FF internal: master-slave latches toggle every cycle → high P_sw
- **Implementation:** `GCLK = enable & clock` (simple AND gate)
  - **Problem:** Glitches (enable transitions during clock=1 → narrow pulse → timing violations, hold failures)
  - **Solution:** Integrated Clock Gate (ICG) = latch + AND gate
    - Latch enabled when clock=0 (negative-edge sensitive) → enable sampled when clock=0 → stable during clock=1 → no glitches
- **ICG circuit:** `LQ = latch(enable, !clock); GCLK = LQ & clock`
  - enable transitions allowed only when clock=0 → LQ stable when clock=1 → GCLK glitch-free
- **Cost:** ICG area, power (latch dissipates power); extraction (synthesis tool finds enable conditions)
- **Benefit:** 20-40% dynamic power savings (clock network + FF internals)

**4. Resizing:**
- **Strategy:** Use smaller cells in non-critical paths (↓C_input → ↓C_L → ↓P_sw for driver)
- **Trade-off:** Smaller cells → lower area/power, higher delay (acceptable if slack permits)
- **Application:** After timing-driven optimization (non-critical paths have positive slack → can tolerate delay increase)
- **Benefit:** Area + power savings without timing violations

## Methods/flows
1. **DVFS:** Workload monitor → adjust V_DD/f_clk → apply; repeat based on demand
2. **Power gating:** Insert switching cells (header/footer) → replace critical FFs with retention cells → add isolation cells at outputs → control via sleep signal
3. **Clock gating:** Synthesis tool identifies enable conditions (data not updating) → insert ICG → connect enable, clock → GCLK drives FFs
4. **Resizing:** STA identifies non-critical paths (high slack) → downsize cells → reduce C_L → verify timing still met

## Constraints/assumptions
- **DVFS:** V_DD↓ requires f_clk↓ (delay increases); feedback loop needed to track workload
- **Power gating:** State retention critical (incorrect wake-up → functional errors); isolation prevents X propagation
- **Clock gating:** ICG prevents glitches (simple AND gate causes glitches → timing violations)
- **Resizing:** Only for non-critical paths (critical paths need large cells for timing)

## Examples
**DVFS calculation:**
- Baseline: V_DD=1.2V, f_clk=1.2GHz, task time=10ms, P_sw ∝ V²·f = 1.44×1.2 = 1.728 (normalized)
- Reduced: V_DD=0.6V, f_clk=600MHz, task time=20ms, P_sw ∝ 0.36×0.6 = 0.216 (8× reduction)
- Energy: E_baseline = 1.728×10ms = 17.28 (normalized); E_reduced = 0.216×20ms = 4.32 (4× reduction)

**Power gating (switching cell):**
- Sleep=0 (normal): PMOS ON → V_DD_SW = V_DD (1.2V) → block active
- Sleep=1 (power-down): PMOS OFF → V_DD_SW floating → P_dyn=0, P_leak≈0

**Clock gating (ICG):**
- enable=0 (data not updating): LQ=0 (sampled when clock=0) → GCLK=0 (clock disabled)
- enable=1 (data updating): LQ=1 (sampled when clock=0) → GCLK=clock (clock enabled)
- Glitch prevention: enable transitions only when clock=0 → LQ stable when clock=1 → no narrow pulses

**Resizing:**
- Path slack=500ps, cell delay=50ps → downsize (delay→100ps) → slack=450ps (still positive)
- C_input: 10fF→5fF → driver C_L↓ → P_sw↓ (driver dissipates less power)

## Tools/commands
- **Power analysis:** Synopsys PrimeTime PX, Cadence Voltus (identify power-hungry blocks)
- **Power gating:** Synopsys Power Compiler (insert switching/retention/isolation cells)
- **Clock gating:** Synthesis tools (Design Compiler, Genus) automatically insert ICG (enable condition extraction)
- **DVFS:** SoC-level (firmware/hardware; e.g., ARM big.LITTLE, Intel SpeedStep)

## Common pitfalls
- DVFS without f_clk reduction (V_DD↓ + same f_clk → timing violations; delay increases)
- Power gating without retention (state lost → functional errors after wake-up)
- Power gating without isolation (gated outputs=X → fan-out gates draw short-circuit current → power spike)
- Clock gating with simple AND gate (glitches → timing violations, hold failures; must use ICG)
- Resizing critical paths (timing violations; only resize non-critical with slack)
- Over-aggressive clock gating (enable condition too complex → ICG overhead > savings)

## Key takeaways
- Power reduction strategies: ↓V_DD (most effective; quadratic), ↓f_clk, ↓α (activity), ↓C_L, ↓I_leak
- DVFS: Vary V_DD/f_clk based on workload (8× power, 4× energy savings; but 2× slower)
- Power gating: Disconnect V_DD for idle blocks (P=0); needs switching cells (header/footer), retention cells (save/restore state), isolation cells (prevent X propagation)
- Clock gating: Disable clock when data not updating (20-40% P_dyn savings); ICG prevents glitches (latch + AND gate)
- Resizing: Smaller cells in non-critical paths (↓C_L → ↓P_sw for driver; acceptable if slack permits)
- Switching cell: High-VT PMOS/NMOS (low leakage); sleep=0: ON (V_DD_SW=V_DD); sleep=1: OFF (V_DD_SW floating)
- Retention cell: Dual-supply FF (V_DD always-on, V_DD_SW switchable); safe→latch state; restore→write back
- Isolation cell: Force outputs to 0/1 during sleep (prevent short-circuit in fan-out; simple AND gate with sleep_bar)
- ICG: Latch (negative-edge) + AND gate → glitch-free (enable sampled when clock=0 → stable when clock=1)
- Trade-offs: DVFS (power vs performance), power gating (power vs area/complexity), clock gating (power vs ICG overhead), resizing (power vs timing)

**Cross-links:** See Lec37: Power analysis (P = C_L·V²_DD·α·f_clk + V_DD·I_leak); Lec35: Timing-driven optimization (resizing for timing; similar strategy for power); Lec26: Technology library (high-VT cells for leakage reduction); Lec32-33: Constraints (clock gating affects timing constraints)

---

*This summary condenses Lec38 from ~10,000 tokens, removing repeated power equation derivations, redundant DVFS calculation examples, and verbose power gating circuit diagrams.*
