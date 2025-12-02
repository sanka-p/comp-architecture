# Lec39 — Basic Concepts of DFT (Design for Test)

## Overview
Introduces DFT (design modifications for testability), structural testing (test components, not I/O behavior), fault models (stuck-at faults), test vectors, and controllability/observability challenges in sequential circuits.

## Core concepts
**DFT (Design for Test):**
- **Purpose:** Make testing cost-effective, efficient (reduce test time, improve fault coverage)
- **Design tasks:** Insert test structures, modify circuit for better controllability/observability, generate test patterns
- **Testing flow:** Fabricate die → apply test patterns (ATE: Automatic Test Equipment) → compare actual vs expected responses → pass/fail

**Structural testing:**
- **Paradigm:** Test components (AND, OR, FF) individually (not I/O behavior)
- **Example:** Circuit with 16 inputs, 5 NAND gates
  - **Functional testing:** 2¹⁶ = 65,536 patterns (exhaustive I/O combinations)
  - **Structural testing:** 5 gates × 16 patterns/gate = 80 patterns (test each NAND with 2⁴=16 combinations)
- **Assumptions:** (1) Can observe internal node outputs; (2) Can control (write) internal node inputs; (3) Integration OK (no broken wires)
- **Challenge:** Internal nodes not accessible (only I/O ports accessible to ATE) → DFT techniques ensure assumptions hold

**Fault models:**
- **Purpose:** Abstract defects (physical: short-circuit, open-circuit) → logical faults (stuck-at)
- **Stuck-at fault model:** Signal permanently stuck at 0 (SA0) or 1 (SA1)
  - **Example:** AND gate input B shorted to ground → B SA0; shorted to V_DD → B SA1
- **Single stuck-at fault (SSF):** Only 1 fault active at a time
  - **Justification:** SSF test patterns cover 99% of multiple stuck-at faults (for complex circuits with multiple outputs)
  - **Benefit:** Reduces test pattern complexity (linear in #nets, not exponential)

**Fault sites:**
- **Fan-out-free net:** 1 fault site (output pin = input pin; e.g., inverter→inverter)
- **Net with fan-out N:** N+1 fault sites (1 at driver output + N at driven inputs)
  - **Example:** NAND output drives 3 gates → 4 fault sites (1 at NAND.Z, 3 at input pins of driven gates)
- **Total faults:** 2 × #fault_sites (each site has SA0, SA1)

**Test vectors:**
- **Definition:** Input pattern producing different responses for faulty vs fault-free circuit
- **Example:** 4-input NAND gate (5 pins: 4 inputs + 1 output; 10 faults: 2 per pin)
  - **Test for A SA0:** Pattern {1,1,1,1} → fault-free: Z=0; faulty (A=0): Z=1 (detects fault)
  - **Test for Z SA0:** Any pattern except {1,1,1,1} → fault-free: Z=1; faulty: Z=0
  - **Complete test set:** {1,1,1,1}, {0,1,1,1}, {1,0,1,1}, {1,1,0,1}, {1,1,1,0} (5 patterns for 10 faults)
- **General n-input NAND:** n+1 test patterns (vs 2ⁿ for exhaustive functional testing)

**Controllability:**
- **Definition:** Ability to apply desired value (0/1) at internal signal from primary inputs
- **Example:** NAND gate near input port → high controllability (easy to set inputs); NAND deep in logic → low controllability (intervening logic may block patterns)
- **Sequential circuits:** Worse (may need exponential cycles to reach target state; e.g., counter from 0000→1111: 2⁴=16 cycles)

**Observability:**
- **Definition:** Ability to observe internal signal value at primary outputs
- **Example:** Gate output near output port → high observability; deep in logic → low observability (fault effect may not propagate to output)
- **Sequential circuits:** Worse (may need state traversal to propagate fault effect to output)

**Sequential circuit challenges:**
- **Controllability:** Reaching target state (e.g., FF outputs = 1111) may need exponential cycles (state traversal in FSM)
- **Observability:** Fault effect propagation to output may need exponential cycles (reverse state traversal)
- **ATPG (Automatic Test Pattern Generation):** Sequential ATPG exponentially harder than combinational ATPG

## Methods/flows
1. **Structural testing:** For each component (gate), derive test patterns (e.g., n+1 for n-input NAND) → apply to circuit → observe outputs → compare with expected
2. **Fault site enumeration:** Count fan-out-free nets (1 site each) + fan-out nets (N+1 sites for N fan-out) → total faults = 2 × #sites
3. **Test vector derivation:** For each fault, find input pattern where fault-free ≠ faulty output
4. **Controllability/observability analysis:** Trace paths from inputs→internal node (controllability), internal node→outputs (observability) → identify hard-to-test nodes → insert DFT structures

## Constraints/assumptions
- **SSF assumption:** Only 1 fault at a time (realistic: random defects → multiple faults possible; but SSF tests cover 99% of multi-fault cases)
- **Structural testing assumptions:** (1) Internal nodes observable; (2) Internal nodes controllable; (3) Integration OK → DFT techniques ensure these
- **Sequential ATPG:** Exponential complexity (state traversal) → impractical without DFT (scan design)

## Examples
**Fault sites (fan-out example):**
- Net N2 drives 3 gates (G2, G3, G4) → 4 fault sites: (1) G1.Z, (2) G2.A, (3) G3.A, (4) G4.A
- Each site: 2 faults (SA0, SA1) → 8 faults for net N2

**Test vectors (4-input NAND):**
- 5 pins (A, B, C, D, Z) → 10 faults (A SA0/1, B SA0/1, C SA0/1, D SA0/1, Z SA0/1)
- Test set: {1111, 0111, 1011, 1101, 1110} (5 patterns detect all 10 faults)
- **A SA0:** {1111} → fault-free: Z=0; faulty: Z=1 (detected)
- **Z SA0:** {0111} → fault-free: Z=1; faulty: Z=0 (detected)

**Controllability challenge (sequential):**
- Counter (4 FFs): Initial state 0000, target state 1111 → 16 clock cycles (state traversal)
- With scan: Load 1111 directly via scan chain → 4 clock cycles (linear in #FFs)

## Tools/commands
- **ATPG:** Synopsys TetraMAX, Cadence Modus, Siemens Tessent (generate test patterns)
- **Fault simulation:** Determine fault coverage (% faults detected by test set)
- **DFT insertion:** Synthesis tools (insert scan chains, BIST structures)

## Common pitfalls
- Assuming internal nodes accessible (ATE can only access I/O ports; need DFT for internal access)
- Confusing defect (physical: short/open) with fault (logical: stuck-at)
- Using exhaustive functional testing (2ⁿ patterns; exponential → infeasible for large n)
- Ignoring controllability/observability (deep logic → hard to test; need DFT)
- SSF assumption invalid (believing SSF tests won't catch multiple faults; but 99% coverage empirically observed)

## Key takeaways
- DFT: Design modifications to improve testability (controllability, observability, fault coverage)
- Structural testing: Test components (gates), not I/O behavior → reduces test patterns (linear vs exponential)
- Fault model: Stuck-at (SA0, SA1); abstracts physical defects → enables algorithmic test pattern generation
- Single stuck-at fault (SSF): 1 fault at a time (simplifies ATPG; SSF tests cover 99% of multi-fault cases)
- Fault sites: Fan-out-free net=1 site; net with fan-out N = N+1 sites; total faults = 2×#sites
- Test vector: Input pattern where fault-free ≠ faulty output
- n-input NAND: n+1 test patterns (vs 2ⁿ exhaustive functional)
- Controllability: Ability to apply 0/1 at internal node from inputs (hard for deep logic, sequential circuits)
- Observability: Ability to observe internal node at outputs (hard for deep logic, sequential circuits)
- Sequential circuits: Exponential controllability/observability (state traversal) → DFT (scan design) transforms to combinational testing
- Structural testing assumptions: (1) Internal nodes observable; (2) Controllable; (3) Integration OK → DFT ensures these hold

**Cross-links:** See Lec40: Scan design (solves controllability/observability via scan chains); Lec06: VLSI flow (testing phase); Lec41: ATPG (automatic test pattern generation algorithms)

---

*This summary condenses Lec39 from ~12,000 tokens, removing repeated fault enumeration examples, redundant controllability/observability definitions, and verbose sequential circuit FSM traversal walkthroughs.*
