# Lec43 — Built-in Self Test (BIST)

## Overview
Covers BIST architecture (alternative to ATE-based testing): pseudo-random test pattern generation (LFSR), signature analysis (compaction via LFSR/SISR), advantages (field testing, at-speed), and disadvantages (area overhead, aliasing).

## Core concepts
**BIST vs ATE-based testing:**
- **ATE disadvantages:** High cost (expensive equipment), large data volume (test vectors + responses), production-only (no field testing), speed limitations (probe inductance/capacitance)
- **BIST advantages:** Reduces ATE dependence, enables field testing (in-situ), at-speed testing (no probe parasitics), lower test cost
- **BIST cost:** Area overhead (test pattern generator, response analyzer, controller), potential performance loss (critical path), additional pins (BIST control, pass/fail)

**BIST architecture:**
1. **Test Pattern Generator (TPG):** Pseudo-random pattern generator (LFSR) + optional ROM (target specific faults)
2. **Input Selector (MUX):** Selects input from TPG (BIST mode) or primary inputs/scan (normal mode); controlled by BIST controller
3. **Circuit Under Test (CUT):** Main functional circuit (being tested)
4. **Test Response Analyzer (TRA):** Compacts responses → signature (via LFSR/SISR); compares with golden signature (ROM)
5. **BIST Controller:** FSM controlling TPG, input selector, TRA; orchestrates test sequence (generate → apply → capture → compare)

**Pseudo-random pattern generation (LFSR):**
- **LFSR (Linear Feedback Shift Register):** Shift register + XOR feedback → generates pseudo-random sequences
- **Repeatability:** Given seed, LFSR produces same sequence (deterministic)
- **Efficiency:** Minimal area (n FFs + XOR gates); long sequences (2ⁿ-1 states; avoid 0...0 forbidden state)
- **Types:** Standard LFSR (external XOR), modular LFSR (internal XOR; used in response analyzer)

**Standard LFSR:**
- **Structure:** n FFs (a₀, a₁, ..., aₙ₋₁) in series; feedback: aₙ₋₁⁽ᵏ⁺¹⁾ = XOR of selected outputs (h₀·a₀⁽ᵏ⁾, h₁·a₁⁽ᵏ⁾, ..., hₙ₋₁·aₙ₋₁⁽ᵏ⁾)
- **Example (3 FFs):** a₀⁽ᵏ⁺¹⁾=a₁⁽ᵏ⁾, a₁⁽ᵏ⁺¹⁾=a₂⁽ᵏ⁾, a₂⁽ᵏ⁺¹⁾=a₀⁽ᵏ⁾ XOR a₁⁽ᵏ⁾
- **State diagram (seed=100):** 100 → 010 → 101 → 110 → 111 → 011 → 001 → 100 (7 states; 2³-1; 000 forbidden)
- **Maximal-length LFSR:** Proper feedback (h values) → 2ⁿ-1 states before repetition

**Signature analysis (compaction):**
- **Problem:** Storing all responses (e.g., 10⁶ patterns × 100 outputs = 100M bits = 12.5MB) impractical
- **Solution:** Signature = compact representation (e.g., count 1s; but high aliasing)
- **SISR (Single Input Signature Register):** Modular LFSR with CUT output as XOR input
  - **Compaction:** n-bit signature for arbitrary-length response sequence
  - **Golden signature:** Pre-computed for fault-free circuit (stored in TRA ROM)
  - **Test signature:** Computed from CUT outputs during testing; compared with golden signature
- **Aliasing:** Golden signature = test signature for faulty circuit (lossy compaction; false pass)
  - **Probability:** Depends on signature length (n-bit: ~2⁻ⁿ aliasing probability; n=32: ~2⁻³²≈10⁻¹⁰)
  - **Mitigation:** Longer LFSR (larger n), multiple signatures (different seeds)

**Random pattern fault coverage:**
- **Observation:** 85-90% stuck-at faults covered by ~100s of random patterns (logarithmic rise to 100%)
- **Hard-to-detect faults:** Require specific patterns (e.g., 5-input OR stuck-at-1: all inputs=0; probability=2⁻⁵=1/32)
- **Augmentation:** Small ROM with deterministic patterns (ATPG-generated) targeting hard-to-detect faults

## Methods/flows
**BIST testing flow:**
1. **BIST controller:** Initialize LFSR (TPG) with seed; set input selector to TPG mode
2. **Generate:** TPG (LFSR) generates pseudo-random pattern → input selector → CUT
3. **Capture:** CUT produces output → TRA (SISR)
4. **Compact:** TRA (modular LFSR) updates signature (XOR CUT output into feedback)
5. **Repeat:** Steps 2-4 for N clock cycles (N patterns; e.g., N=1000)
6. **Compare:** TRA signature vs golden signature (ROM) → pass/fail result output
7. **Normal mode:** Input selector switches to primary inputs; CUT operates functionally

**LFSR state traversal (3-FF example, seed=100):**
- Clock 0: {a₂, a₁, a₀} = {1,0,0}
- Clock 1: a₀=a₁=0, a₁=a₂=1, a₂=a₀ XOR a₁=0 XOR 0=0 → {0,1,0}
- Clock 2: {1,0,1}, Clock 3: {1,1,0}, Clock 4: {1,1,1}, Clock 5: {0,1,1}, Clock 6: {0,0,1}
- Clock 7: {1,0,0} (repeats; cycle length=7; maximal-length LFSR)

**Signature computation (SISR):**
- Modular LFSR + CUT output (XOR input) → after N cycles: n-bit signature
- **Example (n=32, N=10⁶):** 32-bit signature represents 10⁶-bit response sequence (lossy compaction)

## Constraints/assumptions
- **BIST controller:** FSM design critical (most difficult part; designer responsibility; tools assist)
- **Aliasing:** False pass (faulty circuit signature = golden signature); probability~2⁻ⁿ (n=signature length)
- **Area overhead:** LFSR (TPG, TRA), controller, ROM, MUX → +5-15% area (technology-dependent)
- **Forbidden state (000...0):** LFSR stuck; must initialize with non-zero seed

## Examples
**LFSR (3 FFs, seed=100):**
- State diagram: 100 → 010 → 101 → 110 → 111 → 011 → 001 → 100 (7 states; maximal-length)
- Test patterns: {100, 010, 101, 110, 111, 011, 001} (7 pseudo-random patterns before repeat)

**Signature (ones counting, 4 patterns):**
- Fault-free: {0,0,1,0} → 1 one
- Faulty (permutation): {1,0,0,0} → 1 one (aliasing: signatures match despite different responses)

**SISR (modular LFSR, n=8):**
- 10⁶ patterns, 100 outputs → 100M bits → compressed to 8-bit signature
- Aliasing probability: ~2⁻⁸=1/256 (n=32: ~2⁻³²≈10⁻¹⁰)

## Tools/commands
- **BIST insertion:** Synopsys DFT Compiler, Cadence Modus (insert LFSR, controller, TRA)
- **LFSR design:** Polynomial selection (maximal-length sequences; e.g., x⁸+x⁶+x⁵+x+1 for 8-bit LFSR)
- **Fault simulation:** Determine random pattern fault coverage (target 85-90% with LFSR; augment with ROM for 95%+)

## Common pitfalls
- Initializing LFSR with all-zeros (forbidden state; stuck)
- Over-reliance on random patterns (hard-to-detect faults need deterministic patterns; augment with ROM)
- Short LFSR (low fault coverage; need sufficient length, e.g., n≥20 for long sequences)
- Ignoring aliasing (false pass; mitigate with longer signatures, multiple seeds)
- Not designing BIST controller properly (FSM controls entire flow; errors → test fails)
- Area overhead too high (BIST infrastructure > benefits; optimize LFSR size, controller complexity)

## Key takeaways
- BIST: Self-testing infrastructure (TPG, TRA, controller) embedded in IC (vs external ATE)
- Advantages: Field testing, at-speed (no probe parasitics), lower cost (no ATE dependency)
- Disadvantages: Area overhead (+5-15%), aliasing (false pass; ~2⁻ⁿ), design complexity (controller)
- LFSR (pseudo-random generator): n FFs + XOR feedback → 2ⁿ-1 states (avoid 000...0); deterministic (seed→sequence)
- Standard LFSR (TPG): External XOR; generates test patterns
- Modular LFSR/SISR (TRA): Internal XOR + CUT output → compacts response to n-bit signature
- Signature: Compact representation (n bits for arbitrary-length response); golden vs test signature → pass/fail
- Aliasing: Faulty circuit signature = golden signature (lossy compaction); probability~2⁻ⁿ (n=32: ~10⁻¹⁰)
- Random pattern coverage: 85-90% faults with ~100s patterns (logarithmic); augment with ROM (deterministic ATPG patterns) for 95%+
- BIST controller: FSM orchestrating test (generate → apply → capture → compare); designer responsibility (most difficult part)
- Field testing: BIST enables in-situ testing (post-integration); ATE cannot (production-only)

**Cross-links:** See Lec42: ATPG (deterministic patterns for ROM; complement random patterns); Lec40: Scan design (CUT = scan-inserted circuit; BIST patterns → scan chain); Lec39: DFT basics (structural testing, stuck-at faults)

---

*This summary condenses Lec43 from ~11,000 tokens, removing repeated LFSR state diagrams, redundant signature compaction examples, and verbose BIST architecture descriptions.*
