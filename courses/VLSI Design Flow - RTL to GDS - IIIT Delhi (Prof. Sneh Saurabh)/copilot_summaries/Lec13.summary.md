# Lec13 — Functional Verification using Simulation

## Overview
Explains simulation-based functional verification: testbench framework (stimulus generator, DUV, response monitor), coverage models (code coverage: line/branch/state/toggle; functional coverage), Verilog simulation mechanics (events, timing wheel, stratified event queue), and race conditions.

## Core concepts
**Simulation framework:**
- **DUV (Design Under Verification):** RTL model to verify
- **Testbench:** Environment interacting with simulator; contains:
  - **Stimulus generator:** Applies inputs to DUV (generate or read from file)
  - **Response monitor:** Checks DUV outputs against expected behavior (self-check or dump to file)
- **Simulator:** Computes DUV response mathematically given stimuli

**Testbench structure (Verilog):**
1. Instantiate DUV in testbench module
2. Generate test signals (initialize, create clocks)
3. Monitor outputs (VCD file for waveform viewing)
- **VCD (Value Change Dump):** File format for simulation results; load in waveform viewer to verify behavior

**Coverage models:**
- **Code coverage:** Measures RTL code execution during simulation (identifies unexecuted sections)
  - **Line coverage:** % of RTL statements executed
  - **Branch coverage:** If-else/case branches exercised (both true/false paths)
  - **State coverage:** FSM states visited, transitions traversed
  - **Toggle coverage:** Variables/bits toggled 0→1 and 1→0
  - Limitation: Only measures existing code; cannot detect missing features
- **Functional coverage:** Measures design features exercised (requires separate coverage model)
  - Designer creates feature list (coverage model); tool reports untested features
  - Advantage: Can detect missing implementation (code coverage cannot)
  - Effort: Requires manual coverage model creation

**Simulation mechanics (Verilog):**
- **Process:** Design object simulator can evaluate (gate primitives, initial/always blocks, continuous/procedural assignments)
- **Event:** Action requiring simulator response
  - **Update event:** Net/variable value change
  - **Evaluation event:** Process evaluated (triggered when input nets/variables change)
- **Simulation time:** Time value in simulated circuit (not wall-clock runtime); depends on testbench/design; any simulator should give same simulation time for same events
- **Event queue:** Internal queue ordered by simulation time (timing wheel data structure)

**Timing wheel:**
- Array of M slots indexed by `T % M` (T = simulation time, M = slot count, e.g., 100)
- Events at time T appended to linked list at slot `T % 100`
- Example: T=58 → slot 58, T=163 → slot 63
- Process events in increasing time order; reuse slots after processing

**Event processing:**
1. Apply stimulus → update events
2. Update events trigger evaluation events (for sensitive processes)
3. Evaluation events produce new update events
4. Cycle: update → evaluate → update → ... until simulation end

**Stratified Verilog event queue (within single timestep):**
Layers processed top-down:
1. **Active events:** Continuous assignments (`assign`), blocking assignments (`=`), RHS of non-blocking (`<=`), `$display`
   - No priority among active events (arbitrary order → source of non-determinism)
2. **Inactive events:** `#0` delay assignments (avoid in designs; use better modeling)
3. **NBA update:** LHS of non-blocking assignments (`<=`) updated
4. **Monitor events:** `$monitor`, `$strobe`
5. **Future events:** Move to next time slot
- Iteration: NBA updates can trigger new active events (re-enter active queue)

**Determinism vs non-determinism:**
- **Deterministic:** Statements in `begin...end` block execute in order
- **Non-deterministic:** Multiple always/initial blocks can execute in any order (models hardware concurrency)

**Race conditions:**
- Definition: Simulation results depend on event execution order when language permits multiple valid orders
- Example: Two initial blocks writing same variable → different results if order changes
- Guidelines to avoid:
  - Use blocking (`=`) for combinational, non-blocking (`<=`) for sequential
  - Never write variable in >1 always block
  - Follow coding style guides

## Methods/flows
1. **Create testbench:** Instantiate DUV, declare stimulus signals (reg), output monitors (wire)
2. **Initialize:** `initial` block: set clocks=0, reset=1, de-assert reset after delay, `$finish` at end
3. **Generate stimuli:** `always #50 clk = ~clk;` (clock toggle every 50 time units)
4. **Monitor outputs:** `$dumpfile("count.vcd"); $dumpvars; $monitor("%t clk=%b rst=%b count=%h", $time, clk, rst, count);`
5. **Run simulator:** Load design + testbench → simulate → generate VCD file
6. **View waveforms:** Load VCD in waveform viewer → verify correctness
7. **Measure coverage:** Code coverage (line/branch/state/toggle) + functional coverage (feature list)

## Constraints/assumptions
- Testbench quality: Comprehensive (diverse stimuli, no redundancy), measured by coverage (not just stimulus count)
- Simulation time ≠ simulator runtime (simulation time is design-dependent; runtime is tool/hardware-dependent)
- Stratified queue: Active events no priority (arbitrary order); sequential blocks execute in-order
- Race conditions: Results should not depend on arbitrary event ordering (follow coding guidelines)

## Examples
- **4-bit counter testbench:**
  ```verilog
  module Testbench;
    reg Clock, Reset; wire [3:0] Count;
    Mycounter I1(.CLK(Clock), .RST(Reset), .OUT(Count));
    initial begin Clock=0; Reset=1; #100 Reset=0; #2000 $finish; end
    always #50 Clock = ~Clock; // Period 100
    initial begin $dumpfile("count.vcd"); $dumpvars; $monitor(...); end
  endmodule
  ```
- **Event processing (circuit with 2-input NAND, NOR gates):**
  - T=0: A=0→1 (update) → Evaluate G1 (NAND) → X=1→0 (update) → Evaluate G2, G3 → Y=0→1 (update) → Evaluate G4 → Out=0→1
- **Stratified queue example:**
  ```verilog
  initial begin
    a = 1'b0;           // Active: a=0
    a <= 1'b1;          // Active: eval RHS (1'b1); NBA update: schedule a=1
    $display("%b", a);  // Active: displays 0 (a not yet updated)
  end                   // NBA update: a=1 (after display)
  ```
  Output: `0` (display runs before NBA update)

## Tools/commands
- **Verilog simulators:** Icarus Verilog (iverilog), Verilator, commercial tools (VCS, ModelSim, Xcelium)
- **Waveform viewers:** GTKWave (for VCD files)
- **Coverage tools:** Integrated in simulators (line/branch/toggle coverage reports)
- **System tasks:** `$dumpfile`, `$dumpvars`, `$monitor`, `$display`, `$time`, `$finish`

## Common pitfalls
- Redundant stimuli: Testing same feature multiple times wastes resources (use coverage to guide stimulus generation)
- Missing branches: Incomplete case statements → latches/unverified code (use coverage to detect)
- Race conditions: Writing same variable in multiple always blocks → order-dependent results (use blocking for comb, non-blocking for seq)
- `#0` delays: Avoid (inactive events layer rarely needed; use non-blocking instead)

## Key takeaways
- Simulation verifies RTL correctness by applying stimuli and checking outputs
- Testbench = stimulus generator + DUV + response monitor; VCD file captures waveforms
- Coverage: Code coverage (line/branch/state/toggle) identifies unexecuted code; functional coverage detects missing features (requires manual coverage model)
- Event processing: Update events trigger evaluation events → timing wheel orders events by simulation time
- Stratified queue (within timestep): Active → Inactive → NBA update → Monitor → Future; active events no priority (non-determinism models hardware concurrency)
- Race conditions: Results depend on arbitrary event order (avoid by using blocking for comb, non-blocking for seq; don't write variable in >1 block)
- Sequential blocks deterministic (`begin...end` executes in-order); multiple always/initial blocks non-deterministic (arbitrary order)

**Cross-links:** See Lec11-12: Verilog constructs (always blocks, assignments); Lec15: synthesis of RTL constructs; Lec28: STA (timing verification); Lec31-33: DFT, advanced verification

---

*This summary condenses Lec13 from ~16,000 tokens, removing tutorial-style walkthroughs ("Now let us understand..."), redundant explanations of timing wheel mechanics, and repeated warnings about race conditions.*
