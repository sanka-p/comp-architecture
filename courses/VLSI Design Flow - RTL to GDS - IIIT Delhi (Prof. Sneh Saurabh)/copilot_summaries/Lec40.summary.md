# Lec40 — Scan Design Flow

## Overview
Covers scan design methodology (transforms sequential→combinational testing): design modifications (scan cell insertion, scan chain formation), testing modes (normal, shift, capture), mechanism (shift pattern→capture response→shift out), and DFT tasks (scan synthesis, reordering, stitching, verification).

## Core concepts
**Scan design modifications:**
1. **Add ports:** TM (test mode), SE (scan enable), SI (scan input), SO (scan output)
2. **Replace FFs with scan cells:** Merged D scan cell = 2:1 MUX + D-FF
   - **Pins:** D (data), SI (scan input), SE (scan enable), CLK, Q
   - **Functionality:** SE=0 → Q ← D (normal FF); SE=1 → Q ← SI (shift register)
3. **Form scan chain:** Connect scan cells in series (SI port → FF1.SI, FF1.Q → FF2.SI, ..., FFn.Q → SO port)
   - **Result:** Shift register (SI→SO) when SE=1 (shift mode)

**Operating modes:**
- **Normal mode (TM=0):** Circuit performs functional operation (SE=0 → scan cells act as normal FFs)
- **Shift mode (TM=1, SE=1):** Scan cells form shift register (shift test pattern from SI→FFs, shift response FFs→SO)
- **Capture mode (TM=1, SE=0):** Scan cells capture combinational output at D pin (1 clock cycle)

**Scan cell (merged D scan cell):**
- **Structure:** MUX(D, SI, SE) → D-FF → Q
- **SE=0:** MUX selects D → normal D-FF behavior (functional mode)
- **SE=1:** MUX selects SI → shift register behavior (shift mode; Q ← SI on clock edge)
- **Library:** Scan cells pre-designed in technology library (various sizes, flavors like normal FFs)

**Scan chain formation:**
- **Original:** FF1.D ← logic, FF1.Q → logic (functional connections preserved)
- **Scan chain:** SI port → FF1.SI, FF1.Q → FF2.SI, FF2.Q → FF3.SI, FF3.Q → SO port
- **Pseudo primary inputs (PPI):** FF.Q pins (controllable via scan chain; treat as inputs for combinational ATPG)
- **Pseudo primary outputs (PPO):** FF.D pins (observable via scan chain; treat as outputs for combinational ATPG)
- **Transformation:** Sequential testing → combinational testing (test logic between scan cells)

**Testing mechanism:**
1. **Shift mode (SE=1):** Shift test pattern from SI port → scan chain (N cycles for N FFs; load target values at FF.Q pins)
2. **Apply primary inputs:** Set values at input ports (A, B, C, ...) for combinational logic
3. **Capture mode (SE=0, 1 cycle):** Scan cells capture combinational outputs at D pins (fault effect stored in FFs)
4. **Shift mode (SE=1):** Shift captured response from scan chain → SO port (N cycles; observe FF.D values)
5. **Repeat:** While shifting out response, shift in next test pattern → pipelined (shift-capture-shift-capture...)

**Controllability/observability improvement:**
- **Controllability:** Any value (0/1) at FF.Q in N cycles (linear; vs exponential state traversal in sequential circuit)
- **Observability:** Any FF.D value readable at SO in N cycles (linear; vs exponential reverse state traversal)
- **ATPG:** Sequential ATPG → combinational ATPG (treat FF.Q as PPI, FF.D as PPO)

**Scan design tasks:**
1. **Prepare design:** Ensure RTL testable (no asynchronous resets during shift, no gated clocks on scan FFs)
2. **Scan synthesis (scan insertion):**
   - **Configuration:** #scan chains, scan cell types, exclusions (critical path FFs)
   - **Replace:** D-FFs → scan cells
   - **Form chains:** Connect scan cells in series (SI→FF1→FF2→...→FFn→SO)
3. **Scan reordering/stitching (physical design):** Minimize scan chain wire length (reorder FFs in chain based on placement)
4. **Test pattern generation (ATPG):** Generate test vectors for combinational logic (treat FF.Q as PPI, FF.D as PPO)
5. **Verification:**
   - **Timing:** Check hold violations (FF.Q→next FF.SI: short path, high clock skew → hold violation risk)
   - **Scan chain sanity:** Simulate scan shift (verify SI→SO path functional)
   - **Functional equivalence:** CEC (combinational equivalence check) for normal mode (scan insertion must not alter functionality)

## Methods/flows
**Scan chain example (3 FFs):**
- **Original:** FF1, FF2, FF3 (functional connections: D pins ← logic, Q pins → logic)
- **Modified:** 
  - SI port → FF1.SI
  - FF1.Q → FF2.SI (+ original fan-out to logic)
  - FF2.Q → FF3.SI (+ original fan-out)
  - FF3.Q → SO port (+ original fan-out)
  - SE port → all FF.SE pins
- **Shift mode (SE=1):** SI → FF1 → FF2 → FF3 → SO (3 cycles to load/unload)
- **Capture mode (SE=0, 1 cycle):** FF.D ← combinational outputs

**Testing example (AND gate between FFs):**
- **Target:** Test AND gate (inputs from FF.Q, FF.Q; output to FF.D)
- **Pattern:** Load {1, 1} at FF outputs (shift mode: 2 cycles)
- **Apply:** Set input port C=1 (if AND input comes from port)
- **Capture (SE=0):** AND output (fault-free: 1; SA0 fault: 0) → captured at FF.D
- **Shift out (SE=1):** Read FF.Q value at SO (2 cycles) → compare with expected

## Constraints/assumptions
- **Scan chain length N:** Shift time = N cycles (load + unload); multiple chains reduce time (N/M cycles for M chains)
- **Functional equivalence:** Normal mode (SE=0) must behave identically to pre-scan design
- **Hold violations:** Scan chain (FF.Q→next FF.SI) may have short paths → check after CTS (clock tree synthesis)
- **Area overhead:** ~10-20% (scan cells larger than D-FFs; routing for SE, SI, SO)
- **Timing degradation:** MUX in data path (D→MUX→FF) → delay increase (~5-10% freq. reduction)

## Examples
**Scan chain (N=3 FFs):**
- **Shift in pattern {1, 0, 1}:** SI=1 (cycle 1) → FF1.Q=1; SI=0 (cycle 2) → FF2.Q=0, FF1.Q shifts; SI=1 (cycle 3) → FF3.Q=1, chain loaded
- **Capture (1 cycle):** Combinational outputs → FF.D pins (fault effect stored)
- **Shift out response:** SO reads FF3.Q (cycle 1), FF2.Q (cycle 2), FF1.Q (cycle 3)

**Fault detection:**
- AND gate SA0 at output → pattern {1,1} applied → fault-free: Z=1; faulty: Z=0
- Capture mode: FF.D ← 0 (faulty) instead of 1 (fault-free)
- Shift out: SO=0 (faulty) vs expected=1 → fault detected

## Tools/commands
- **Scan synthesis:** Synopsys DFT Compiler, Cadence Genus (insert scan cells, form chains)
- **ATPG:** Synopsys TetraMAX, Cadence Modus, Siemens Tessent (generate test patterns for combinational logic)
- **Scan chain verification:** Simulation (VCS, ModelSim) to check SI→SO functionality
- **Timing verification:** PrimeTime, Tempus (check hold violations on scan chains after CTS)

## Common pitfalls
- Asynchronous resets active during shift (breaks scan chain; reset must be de-asserted during TM=1)
- Gated clocks on scan FFs (clock may not propagate during shift; exclude gated FFs or disable clock gating during scan)
- Not checking hold violations (scan chain short paths + clock skew → hold violations after CTS)
- Single long scan chain (shift time = N cycles for N FFs; use multiple chains to reduce time)
- Functional mode broken (scan cell MUX adds delay; if not accounted, timing violations in normal mode)

## Key takeaways
- Scan design: Insert scan cells (MUX+FF), form scan chains (shift register) → transform sequential→combinational testing
- Scan cell: SE=0 (normal FF; D→Q); SE=1 (shift register; SI→Q)
- Operating modes: Normal (TM=0, SE=0), shift (TM=1, SE=1), capture (TM=1, SE=0)
- Scan chain: SI → FF1.SI, FF1.Q → FF2.SI, ..., FFn.Q → SO (shift register when SE=1)
- Pseudo primary I/O: FF.Q = PPI (controllable in N cycles); FF.D = PPO (observable in N cycles)
- Testing mechanism: Shift pattern (N cycles) → capture (1 cycle) → shift response (N cycles) → repeat
- Controllability/observability: Linear in #FFs (vs exponential for sequential circuits)
- ATPG: Sequential → combinational (treat FF.Q as inputs, FF.D as outputs)
- Scan synthesis tasks: Configuration → replace FFs → form chains
- Physical design: Scan reordering/stitching (minimize chain wire length)
- Verification: Timing (hold check), scan chain sanity (simulation), functional equivalence (CEC)
- Costs: Area (+10-20%), timing (-5-10% freq), design effort
- Benefits: Testability (99%+ fault coverage), combinational ATPG (vs exponential sequential ATPG)

**Cross-links:** See Lec39: DFT basics (structural testing, fault models, controllability/observability); Lec41: ATPG (test pattern generation for scan-inserted design); Lec26: Technology library (scan cells); Lec06: VLSI flow (DFT phase)

---

*This summary condenses Lec40 from ~11,000 tokens, removing repeated scan chain formation diagrams, redundant shift-capture-shift examples, and verbose scan cell functionality explanations.*
