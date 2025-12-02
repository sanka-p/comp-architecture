# Lec42 — Automatic Test Pattern Generation (ATPG)

## Overview
Covers combinational ATPG (for scan-inserted designs): path sensitization method (fault sensitization, fault propagation, line justification), redundant faults (untestable faults usable for optimization), and ATPG challenges (reconvergent fanout, backtracking limits).

## Core concepts
**ATPG objective:**
- Generate minimal test pattern set detecting all (detectable) faults
- **Small test set:** Reduces test time, ATE cost (fewer patterns to apply)
- **Target:** Combinational circuits (scan design transforms sequential→combinational ATPG)

**Path sensitization method (3 steps):**
1. **Fault sensitization:** Set fault site to opposite of fault value (stuck-at-1 → apply 0; stuck-at-0 → apply 1)
2. **Fault propagation:** Set side inputs to non-controlling values (output decided by on-input; fault effect propagates to output)
3. **Line justification:** Find input port values that produce required side input values (work backwards from fault site to inputs)

**Terminologies:**
- **Path:** Sequence of pins in topological order (e.g., G3.Y → G4.X2 → G4.Y → G5.X → G5.Y → G7.X1 → G7.Y → Z)
- **On-input pins:** Input pins lying on path (for path P1: G4.X2, G5.X, G7.X1)
- **Side-input pins:** Input pins NOT on path, of gates on path (for P1: G4.X1 (side input of G4), G7.X2, G7.X3 (side inputs of G7))

**Controlling/non-controlling values:**
- **Controlling value:** Input value forcing output to known value (AND: 0; OR: 1; NAND: 0; NOR: 1; XOR: none)
- **Non-controlling value:** Input value where output depends on other inputs (AND: 1; OR: 0; NAND: 1; NOR: 0; XOR: 0, 1)

**Redundant faults:**
- **Definition:** Faults untestable by any input pattern (circuit behavior identical with/without fault)
- **Detection:** ATPG encounters conflicts during line justification (no consistent input values) → no test pattern exists
- **Use:** Optimize hardware (tie fault site to fault value → simplify logic; e.g., remove redundant gate)

**ATPG challenges:**
- **Reconvergent fanout:** Fan-out signals reconverge at later gates → multiple implications from single decision → conflicts → backtracking
- **Backtracking limit:** Tools set limit (e.g., 1000) to avoid infinite backtracking for redundant faults (too low: miss detectable faults; too high: waste time on redundant faults)

## Methods/flows
**Path sensitization example (stuck-at-1 at G4.X1):**
1. **Fault sensitization:** G4.X1 SA1 → set G4.X1=0 (opposite of fault)
   - G4 is NAND; output G4.Y=0 requires all inputs=1 → set A=1, B=1 (from input ports)
2. **Fault propagation:** Path G4.X1 → G4.Y → Z; side input: G4.X2
   - Set G4.X2=1 (non-controlling for NAND) → fault effect propagates to Z
3. **Line justification:** G4.X2=1 requires inverter input=0; inverter input=0 requires OR gate output=0
   - OR output=0 requires all inputs=0 → set C=0, D=0
4. **Test pattern:** {A=1, B=1, C=0, D=0}
5. **Verification:** Fault-free: Z=1; Faulty (G4.X1=1): Z=0 → fault detected

**Conflict resolution (stuck-at-0 at G2.Y):**
- Fault sensitization: G2.Y SA0 → set G2.Y=1 → B=1, C=0
- Fault propagation (path to Y): Side input G5.X1=1 (non-controlling for AND) → line justification: G2.X2=0 → B=0
- **Conflict:** B=1 (sensitization) vs B=0 (justification) → backtrack → try alternate path (to Z)
- Fault propagation (path to Z): Side input G6.X2=0 → G4 output=0 → C=0, D=0
- **Consistent:** C=0 matches sensitization → test pattern: {B=1, C=0, D=0} (A: don't care)

**Redundant fault example (stuck-at-1 at G3.X1):**
- Fault sensitization: G3.X1 SA1 → set G3.X1=0 → B=0
- Fault propagation: Side inputs G3.X2=1 (C=1), G4.X1=0 (NAND input=0)
- Line justification: G4.X1=0 requires G2 output=0 (NAND); G2 output=0 requires both inputs=1 → G2.X2=1 → B=1
- **Conflict:** B=0 (sensitization) vs B=1 (justification) → no alternate path → no test pattern exists → redundant fault
- **Optimization:** Assume G3.X1=1 always → G3 (AND) output=C → remove G3 gate, connect C directly to G4.X2

## Constraints/assumptions
- **Combinational ATPG:** Scan design prerequisite (FF.Q=PPI, FF.D=PPO; sequential ATPG exponential)
- **Single stuck-at fault (SSF):** ATPG assumes 1 fault at a time (simplifies problem; SSF tests cover 99% multi-fault)
- **Backtracking limit:** Practical (avoid infinite loops for redundant faults); may miss some detectable faults if too low

## Examples
**NAND gate (4 inputs A, B, C, D; output Z):**
- 5 pins → 10 faults (2 per pin: SA0, SA1)
- Test set: {1111, 0111, 1011, 1101, 1110} (5 patterns for 10 faults)
  - {1111}: Detects Z SA0 (fault-free: Z=0; faulty: Z=0... wait, this detects A/B/C/D SA0: fault-free Z=0; if A SA0, inputs become {0,1,1,1} → Z=1 → detected)
  - **Correction:** {1111} detects A/B/C/D SA0 (fault-free: Z=0; faulty (any input SA0): Z=1); {0111, 1011, 1101, 1110} detect A/B/C/D SA1 (fault-free: Z=1; faulty: Z=0)
- **General n-input NAND:** n+1 test patterns (vs 2ⁿ exhaustive)

**Redundant fault (G3.X1 SA1):**
- Functional equivalence: Circuit with fault ≡ circuit without fault (for all 2³=8 input combinations)
- Optimization: Remove G3 (AND gate) → connect C directly to G4.X2 → 1 fewer gate (area savings)

## Tools/commands
- **ATPG:** Synopsys TetraMAX, Cadence Modus, Siemens Tessent (combinational ATPG for scan-inserted designs)
- **Fault simulation:** Determine fault coverage (% faults detected by test set)
- **Algorithms:** D algorithm (Roth, 1966), PODEM (Goel, 1981), FAN (Fujiwara, 1983)

## Common pitfalls
- Confusing on-input (pins on path) with side-input (other input pins of gates on path)
- Not setting side inputs to non-controlling values (fault effect won't propagate)
- Ignoring conflicts during line justification (must backtrack and try alternate paths)
- Assuming all faults detectable (redundant faults exist; untestable by any pattern)
- Setting backtracking limit too low (misses detectable faults) or too high (wastes time on redundant faults)
- Applying combinational ATPG to sequential circuits without scan (exponential; impractical)

## Key takeaways
- ATPG goal: Minimal test set detecting all detectable faults (reduces test time, ATE cost)
- Path sensitization: (1) Fault sensitization (opposite value at fault site), (2) Fault propagation (side inputs=non-controlling), (3) Line justification (input values producing side inputs)
- On-input: Input pins on path; side-input: Other input pins of gates on path
- Controlling value: Forces output (AND: 0; OR: 1); non-controlling: Output depends on others (AND: 1; OR: 0)
- Redundant fault: Untestable (conflicts in justification) → optimize hardware (tie to fault value → simplify logic)
- Reconvergent fanout: Multiple implications → conflicts → backtracking → increases ATPG complexity
- Backtracking limit: Avoid infinite loops (redundant faults); practical trade-off (too low: miss faults; too high: waste time)
- Scan design enables combinational ATPG: FF.Q=PPI, FF.D=PPO → test combinational logic between FFs
- n-input NAND: n+1 test patterns (vs 2ⁿ exhaustive) → drastic reduction
- ATPG algorithms: D (1966), PODEM (1981), FAN (1983) → 50+ years of advancement

**Cross-links:** See Lec40: Scan design (transforms sequential→combinational ATPG; FF.Q=PPI, FF.D=PPO); Lec39: DFT basics (stuck-at faults, test vectors, controllability/observability); Lec43: BIST (alternative to ATE-based testing)

---

*This summary condenses Lec42 from ~11,000 tokens, removing repeated path sensitization examples, redundant conflict resolution walkthroughs, and verbose terminology definitions.*
