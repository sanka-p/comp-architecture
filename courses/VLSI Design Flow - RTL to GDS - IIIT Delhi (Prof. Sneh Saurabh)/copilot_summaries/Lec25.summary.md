# Lec25 — Formal Verification Part IV: Equivalence Checking

## Overview
Covers equivalence checking (verify two design representations functionally identical), sequential vs combinational equivalence checking (SEC vs CEC), CEC framework (register/port matching, miter construction, BDD/SAT verification), name-based matching heuristics, and false failures (unreachable states).

## Core concepts
**Equivalence checking applications:**
- **RTL v1 → RTL v2:** Manual code changes (dead code removal, refactoring) → verify equivalence
- **RTL → Netlist:** Post-synthesis verification (logic optimization, technology mapping) → ensure functional equivalence
- **Netlist v1 → Netlist v2:** Post-optimization (timing fixes, buffer insertion, CTS) → verify no functional changes
- **Physical design:** Post-placement/routing → verify ECOs didn't disrupt functionality

**Sequential Equivalence Checking (SEC):**
- **Approach:** Model both designs as FSMs → verify identical output sequences for all input sequences (starting from initial states)
- **Challenge:** State explosion (requires symbolic state traversal; computationally expensive)
- **Usage:** Rarely used in practice (prefer CEC if applicable)

**Combinational Equivalence Checking (CEC):**
- **Assumption:** One-to-one correspondence between memory elements (flip-flops) and ports in both models
- **Validity:** Assumption holds for most design transformations (ports, flip-flops rarely change; incremental design flow)
- **Simplification:** Equivalence checking reduces to verifying pairs of combinational logic cones (between flip-flops, ports)

**CEC framework:**
1. **Register/port matching:** Establish correspondence between flip-flops and I/O ports (heuristic: name-based matching)
2. **Miter construction:** Create combinational circuits (miters) for each comparison point (D pins of flip-flops, output ports)
3. **Miter verification:** Use BDD or SAT solver to check if miter output=0 for all inputs
4. **Result:** All miters equivalent → designs equivalent; any miter fails → counter-example (input pattern causing discrepancy)

**Register/port matching:**
- **Name-based matching:** Most common heuristic (port/flip-flop names preserved across transformations)
  - Example: RTL signal `q` → synthesis creates flip-flop instance `q_reg` (add suffix `_reg`)
- **Fallback:** Structural/functional analysis if name-based fails
- **Manual override:** User specifies correspondence for unmatched flip-flops (via regular expressions, direct mapping)

**Miter:**
- **Definition:** Combinational circuit comparing two logic cones; outputs 1 if cones differ, 0 if equivalent
- **Construction:** (1) Identify comparison points (D pins of matched flip-flops, output ports); (2) Traverse fan-in cone (stop at input ports or Q pins of flip-flops); (3) Create independent variables for inputs/flip-flops; (4) Add XOR gate at outputs of two cones
  - **Miter output:** z = CL1(x₁,...,xₙ) ⊕ CL2(x₁,...,xₙ)
  - If z=0 for all inputs → CL1 ≡ CL2 (equivalent)
  - If z=1 for some input → CL1 ≢ CL2 (not equivalent; input is counter-example)

**Miter verification:**
- **BDD-based:** Build ROBDD for miter; if ROBDD = single 0-terminal → equivalent; else → not equivalent
- **SAT-based:** Formulate miter as CNF; invoke SAT solver → UNSAT: equivalent; SAT: not equivalent (satisfying assignment = counter-example)

**False failures:**
- **Cause:** CEC treats flip-flop outputs as independent variables (any value allowed) → may include unreachable states
  - Example: 4 flip-flops in 1-hot FSM → only 4 reachable states (0001, 0010, 0100, 1000); CEC considers all 2⁴=16 states
- **Impact:** Miter may fail for unreachable state (e.g., 0101) → false failure (state never occurs in actual circuit)
- **Resolution:** Analyze counter-example; if unreachable state → waive violation (designs still equivalent)
- **Safety:** CEC never misses real failures (conservative; may report false positives, never false negatives)

## Methods/flows
1. **CEC workflow:** Input two models → register/port matching (name-based heuristic) → construct miters (for each flip-flop D pin, output port) → verify miters (BDD/SAT) → all pass: equivalent; any fail: debug counter-example
2. **Miter construction:** Identify comparison point → traverse fan-in cone (stop at ports/flip-flops) → create independent variables → XOR outputs → verify z=0 for all inputs
3. **Name-based matching:** Extract instance names (e.g., `q_reg` from RTL signal `q`); match by name across models

## Constraints/assumptions
- CEC assumes 1-to-1 correspondence (flip-flops, ports) → valid for most incremental transformations
- Sequential optimization may break correspondence → require SEC or manual matching
- Name-based matching relies on consistent naming conventions (synthesis tools typically preserve names)
- False failures possible (unreachable states treated as reachable) → require manual analysis

## Examples
- **Miter (simple):** Model 1: z=AB (AND); Model 2: z=A+B (OR) → miter: z_miter=(AB) ⊕ (A+B)
  - Counter-examples: A=0, B=1 → z_miter=0⊕1=1 (not equivalent); A=1, B=0 → z_miter=0⊕1=1
- **Name-based matching:** RTL: `always @(posedge clk) q <= d;` → synthesis: instance `q_reg` (suffix `_reg` added)
- **False failure:** 4 flip-flops (1-hot FSM, 4 reachable states); CEC tests all 16 states → fails for 0101 (unreachable) → waive (false failure)
- **Register correspondence:** Model 1: {reg1, reg2, reg3, reg4}; Model 2: {reg1, reg2, reg3, reg4} → match by name; unmatched → structural analysis or manual override

## Tools/commands
- **CEC tools:** Cadence Conformal, Synopsys Formality, Siemens Questa Formal (commercial); ABC, Yosys (open-source)
- **Miter verification:** BDD packages (CUDD), SAT solvers (MiniSat, Z3)
- **Matching overrides:** Regular expressions, manual correspondence files (tool-specific syntax)

## Common pitfalls
- Assuming CEC always correct (false failures possible for unreachable states; analyze counter-examples)
- Forgetting to match flip-flops after sequential optimization (correspondence broken → CEC fails or requires manual matching)
- Ignoring naming conventions (inconsistent names → name-based matching fails; requires structural analysis)
- Over-relying on CEC for designs with major sequential changes (use SEC if flip-flop correspondence unclear)

## Key takeaways
- Equivalence checking: Verify two design representations functionally identical (RTL↔RTL, RTL↔netlist, netlist↔netlist)
- SEC (Sequential EC): FSM-based, expensive (state explosion); rarely used
- CEC (Combinational EC): Assumes 1-to-1 flip-flop/port correspondence → simplify to combinational logic cone comparisons
- CEC framework: (1) Register/port matching; (2) Miter construction (XOR outputs of logic cones); (3) Miter verification (BDD/SAT)
- Name-based matching: Heuristic relying on preserved names (e.g., `q` → `q_reg`); fallback: structural/functional analysis
- Miter: z = CL1 ⊕ CL2; z=0 for all inputs → equivalent; z=1 for some input → counter-example
- BDD verification: ROBDD=0-terminal → equivalent; SAT verification: UNSAT → equivalent
- False failures: CEC treats flip-flops as independent (may test unreachable states) → manual analysis required (waive if unreachable)
- Safety: CEC conservative (never misses failures; may report false positives)

**Cross-links:** See Lec21: BDDs (ROBDD verification); Lec23: SAT solvers (CNF, UNSAT); Lec24: model checking (property verification); Lec06: synthesis overview; Lec15-16: RTL synthesis

---

*This summary condenses Lec25 from ~12,000 tokens, removing repeated miter construction walkthroughs, redundant CEC framework diagrams, and verbose false failure case analyses.*
