# Design for Test (DFT)

> **Chapter Overview:** DFT adds structures and modes to make testing efficient and high-coverage. This chapter introduces structural testing and fault models, scan design to transform sequential→combinational testing, ATPG to generate compact test sets, and BIST for self-test.

**Prerequisites:** [[04-Logic-Synthesis]], [[06-Formal-Verification]]  
**Related Topics:** [[21-EDA-Tools-and-Tutorials]]

---

## 1. DFT Basics (Lec39)

- Structural testing: test gates/FFs vs functional I/O behavior → drastic pattern reduction
- Fault model: stuck-at (SA0/SA1); SSF assumption (1 fault at a time) covers ~99% multiple faults
- Fault sites: fan-out-free net=1 site; net with fan-out N → N+1 sites (driver + each sink) → total faults = 2×sites
- Controllability/observability: ability to set/read internal nodes; hard in sequential circuits (state traversal)

---

## 2. Scan Design (Lec40)

### 2.1 Scan Cells and Ports

- Replace FFs with scan cells (MUX + FF): pins D, SI, SE, CLK, Q
- Add ports: TM (test mode), SE (scan enable), SI (scan in), SO (scan out)

### 2.2 Scan Chains and Modes

- Chain FFs: SI→FF1→FF2→...→FFn→SO; SE=1 → shift register (scan mode)
- Modes: normal (TM=0, SE=0), shift (TM=1, SE=1), capture (TM=1, SE=0)

### 2.3 Testing Mechanism

1. Shift pattern (N cycles for N FFs)
2. Apply primary inputs
3. Capture (1 cycle)
4. Shift out response (N cycles); pipeline next pattern while unloading

### 2.4 Practical Considerations

- Multiple chains reduce shift time
- Hold checks on FF.Q→next FF.SI (short paths, clock skew)
- Area/timing overhead: +10–20% area, −5–10% frequency; ensure functional equivalence in normal mode

---

## 3. ATPG (Lec42)

### 3.1 Goal and Method

- Generate minimal test set; combinational ATPG on scan designs (FF.Q=PPI, FF.D=PPO)
- Path sensitization: (1) fault sensitization (opposite value), (2) fault propagation (side inputs non-controlling), (3) line justification (set inputs to realize side-inputs)

### 3.2 Challenges

- Reconvergent fanout → conflicts → backtracking; set practical limits
- Redundant faults: untestable → optimize logic (remove/constant-tie)

---

## 4. BIST (Lec43)

### 4.1 Architecture

- TPG (LFSR), input selector MUX, CUT, TRA (SISR), controller FSM
- Pseudo-random patterns + deterministic ROM for hard faults
- Signature analysis (n-bit signature; aliasing probability ≈ 2⁻ⁿ)

### 4.2 Trade-offs

- Advantages: Lower ATE dependency, field/at-speed testing
- Costs: Area overhead (5–15%), aliasing risk, controller complexity

---

## 5. Key Takeaways

1. DFT transforms testing to be controllable/observable and scalable.
2. Scan design enables combinational ATPG; test logic between scan cells.
3. ATPG path sensitization produces compact test sets; redundant faults can guide optimization.
4. BIST adds self-test (LFSR-based patterns, signature compaction) with manageable aliasing.

---

## Tools

- Scan synthesis: DFT Compiler, Genus
- ATPG: TetraMAX, Modus, Tessent
- Simulation: VCS, ModelSim (scan chain sanity)
- Timing: PrimeTime/Tempus (scan hold checks)

---

## Common Pitfalls

- Asynchronous resets asserted during scan shift
- Gated clocks blocking scan propagation
- Single long scan chain (excessive shift time)
- Ignoring scan hold violations post-CTS

---

## Further Reading

- [[21-EDA-Tools-and-Tutorials]]: Practical scripts and reports
- [[06-Formal-Verification]]: Equivalence checking after scan insertion
