# Formal Verification

> **Chapter Overview:** This chapter covers formal verification techniques for proving design correctness mathematically, including Binary Decision Diagrams (BDDs), Boolean satisfiability (SAT) solvers, model checking for temporal properties, and equivalence checking (CEC/SEC) for verifying functional equivalence across design transformations.

**Prerequisites:** [[02-Hardware-Description-Languages]], [[04-Logic-Synthesis]]  
**Related Topics:** [[05-Logic-Optimization]], [[08-Static-Timing-Analysis]]

---

## 1. Formal Verification vs Simulation

### 1.1 Simulation Limitations

**Coverage problem:**
- **Example:** 32×32-bit multiplier
  - Input combinations: 2⁶⁴ ≈ 1.8 × 10¹⁹
  - Simulation time: 1μs per test
  - Total time: ~584,000 years (exhaustive testing infeasible)

**Fundamental limitations:**
1. **Incomplete:** Cannot exhaustively test all inputs
2. **Test-vector dependent:** Coverage based on anticipated errors
3. **Bug presence, not absence:** Shows bugs exist, cannot prove absence
4. **Designer bias:** Bugs occur where designers didn't pay attention—same blind spots in test vectors

### 1.2 Formal Verification Approach

**Mathematical reasoning:**
- **Mechanism:** Proofs using logical inference (no test vectors)
- **Completeness:** Implicitly covers all inputs (if proof holds, function correct for any input)
- **Example:** Prove (x-4)² = x²-8x+16
  - Expand: (x-4)² = x² - 8x + 16 ✓
  - No specific x values needed; holds for all x

**Trade-offs:**

| Aspect | Simulation | Formal Verification |
|--------|-----------|---------------------|
| **Completeness** | Incomplete (test vectors) | Complete (mathematical proof) |
| **Resources** | Low (fast, scalable) | High (memory, computation) |
| **Bug finding** | Fast for typical cases | Slower but exhaustive |
| **Proof** | Cannot prove correctness | Can prove or find counter-example |
| **Application** | Design validation, debugging | Critical path verification, equivalence |

**1990s Breakthrough techniques:**
1. **Binary Decision Diagrams (BDDs):** Compact, canonical Boolean representation
2. **SAT solvers:** Efficient satisfiability problem solvers

---

## 2. Binary Decision Diagrams (BDDs)

### 2.1 Boolean Representation Properties

**Desired attributes:**

| Property | Definition | Examples |
|----------|------------|----------|
| **Compactness** | Size grows slowly with #variables | Truth table: 2ⁿ (exponential); Logic formula: polynomial (varies) |
| **Canonicity** | Equivalent functions → identical representation | Truth table: canonical; Logic formula: not canonical |

**Ideal:** Both compact AND canonical (BDDs achieve this for many practical functions)

### 2.2 Shannon Expansion

**Fundamental decomposition:**
$$f(x_1, x_2, ..., x_n) = x_1 \cdot f_{x_1=1} + x_1' \cdot f_{x_1=0}$$

**Cofactors:**
- **Positive cofactor ($f_1$ or $f_{x=1}$):** f with variable x assigned 1
- **Negative cofactor ($f_0$ or $f_{x=0}$):** f with variable x assigned 0

**Example:**
```
f = ab + acd + b'd + bc'

Expand on a:
f₀ (a=0) = b'd + bc'
f₁ (a=1) = b + cd + b'd + bc'

f = a'(b'd + bc') + a(b + cd + b'd + bc')
```

**Recursive application:** Expand on all variables → binary decision tree (2ⁿ leaves: 0 or 1)

### 2.3 Binary Decision Tree

**Structure:**
- **Root:** First variable expansion
- **Internal nodes:** Variable tests
- **Leaves:** Function values (0 or 1)
- **Paths:** Root-to-leaf = input combination

**Limitations:**
- **Not compact:** 2ⁿ leaves (exponential)
- **Not canonical:** Variable order not fixed (multiple trees for same function)

### 2.4 Ordered BDD (OBDD)

**Constraint:** Variable order same in all root-to-leaf paths (may skip variables).

**Structure:** Rooted Directed Acyclic Graph (DAG)
- **Terminal vertices:** Labels {0, 1}, outdegree = 0
- **Non-terminal vertices:** index (variable), low/high children
- **Ordering:** index(v) < index(low(v)), index(high(v))

**Example ordering:** x₁ → x₂ → x₃ (all paths follow this order; some may skip to leaf early)

**Still not canonical:** Different variable orders → different OBDDs

### 2.5 Reduced OBDD (ROBDD)

**Reduction rules:**
1. **Eliminate redundant nodes:** If low(v) = high(v) → remove v, redirect edges to child
2. **Merge isomorphic subgraphs:** If two nodes have identical low/high children → merge into one

**Bryant's Theorem (1986):** ROBDD is **canonical** for fixed variable order.
- Equivalent functions → identical ROBDD (same structure, same root)
- Different ROBDDs → functions not equivalent

**Canonicity application:**
- **Equivalence checking:** Build ROBDDs for f₁, f₂ → compare root pointers
  - Pointers equal → functions equivalent
  - Pointers different → functions not equivalent

### 2.6 ROBDD Compactness

**Variable order impact:**

| Function | Good Order | Poor Order |
|----------|-----------|------------|
| **Adder** | Polynomial (linear in bits) | Exponential |
| **Multiplier** | Exponential (any order) | Exponential |

**Finding optimal order:** NP-hard problem

**Practical approach:** Dynamic reordering heuristics
- BDD packages periodically reorder variables
- Heuristics: sifting, window permutation, genetic algorithms
- Trade-off: Reordering time vs BDD size reduction

**Compactness examples:**
- **Good:** Adders, XORs, parity functions (with good order)
- **Bad:** Multipliers (always exponential), some hash functions

### 2.7 ROBDD Applications

**1. Equivalence checking:**
```
Build ROBDD₁ for f₁
Build ROBDD₂ for f₂
if (root₁ == root₂)
    return EQUIVALENT
else
    return NOT_EQUIVALENT
```

**2. Satisfiability:**
```
Build ROBDD for f
if (exists path from root to 1-terminal)
    return SAT (+ satisfying assignment via path)
else
    return UNSAT
```

**3. Tautology:**
```
Build ROBDD for f
if (ROBDD == single 1-terminal vertex)
    return TAUTOLOGY (f always 1)
else
    return NOT_TAUTOLOGY
```

---

## 3. Boolean Satisfiability (SAT) Solvers

### 3.1 SAT Problem Definition

**Question:** Given Boolean function f(x₁,...,xₙ), ∃ assignment making f=1?

**Outcomes:**
- **SAT:** ∃ assignment → f=1 (satisfiable; return satisfying assignment)
- **UNSAT:** ∄ assignment → f=1 (unsatisfiable)

**Examples:**
```
SAT: f = x₁x₂ + x₁x₃ + x₂'x₃
     Satisfying: x₁=1, x₂=1 (any x₃) → f=1

UNSAT: g = (x₁+x₂)(x₁'+x₂')(x₁'+x₂)(x₁+x₃)(x₁+x₃')
       All 8 assignments → g=0
```

### 3.2 CNF (Conjunctive Normal Form)

**Structure:** AND of clauses; clause = OR of literals

**Formula:** $f = (x_1 + x_2)(x_1' + x_3)(x_2' + x_3')$
- 3 clauses ANDed
- Each clause: disjunction (OR) of literals

**Why CNF for SAT?**
- $f=0$ if any clause=0
- SAT solver exploits this for conflict detection
- Efficient data structures (watched literals)

**Circuit→CNF transformation:** Linear-time Tseitin transformation
- Combinational circuit → CNF input for SAT solver
- Introduces auxiliary variables for intermediate gates

### 3.3 k-SAT Complexity

| Problem | Max Literals/Clause | Complexity |
|---------|-------------------|------------|
| **2-SAT** | 2 | Polynomial-time solvable |
| **3-SAT** | 3 | NP-complete |
| **k-SAT (k≥3)** | k | NP-complete |

**Implication:** No known polynomial worst-case algorithm for 3-SAT; heuristics work well for practical problems.

### 3.4 DPLL Algorithm

**DPLL = Davis-Putnam-Logemann-Loveland (systematic SAT solving)**

**Four operations:**

#### 1. DECIDE
**Action:** Heuristically assign value to unassigned variable
- **Heuristics:** VSIDS (Variable State Independent Decaying Sum), activity-based, random

#### 2. DEDUCE (Boolean Constraint Propagation/BCP)
**Action:** Iteratively propagate implications from unit clauses

**Unit clause:** All literals=0 except 1 → forced assignment (implication)

**Example:**
```
Clauses: (x₁+x₂)(x₁'+x₃)(x₂'+x₃)
Assign: x₁=1
→ Clause 2 becomes (x₃) — unit clause → x₃=1 (forced)
→ Clause 3 becomes (x₂') — unit clause → x₂=0 (forced)
→ Clause 1: (1+0)=1 — satisfied
Result: SAT with x₁=1, x₂=0, x₃=1
```

#### 3. DIAGNOSE
**Action:** Detect conflicts; identify backtrack variable

**Conflict:** All literals in clause=0

**Example:**
```
Clause: (x₂'+x₃')
Assignments: x₂=1, x₃=1
→ x₂'=0, x₃'=0 → Clause=0 → CONFLICT
```

#### 4. BACKTRACK
**Action:** Toggle earlier decision if conflict; return UNSAT if no backtracking possible

**Modern enhancement:** Conflict-Driven Clause Learning (CDCL)
- Analyze conflict → learn new clause (reason for conflict)
- Add learned clause → prune future search space

**DPLL loop:**
```
while (true) {
    if (all variables assigned)
        return SAT
    DECIDE (assign variable)
    while (true) {
        DEDUCE (BCP until no more unit clauses)
        if (no conflict)
            break
        DIAGNOSE (conflict)
        if (cannot backtrack)
            return UNSAT
        BACKTRACK (toggle decision)
    }
}
```

### 3.5 Modern SAT Solver Techniques

**Optimizations:**
1. **CDCL (Conflict-Driven Clause Learning):** Learn clauses from conflicts → prune search
2. **Watched literals:** Efficient unit clause detection (2 literals per clause; update only when watched becomes false)
3. **Random restarts:** Escape local minima; restart with different variable order
4. **Preprocessing:** Simplify formula (subsumption, variable elimination)
5. **Multi-core parallelism:** Parallel search (portfolio approach: different heuristics)

**Tools:** MiniSat, Z3, Glucose, CryptoMiniSat, Lingeling, CaDiCaL

---

## 4. Model Checking

### 4.1 Model Checking Framework

**Inputs:**
1. **Design:** Modeled as Finite State Machine (FSM)
2. **Properties:** Temporal logic specifications (SystemVerilog Assertions—SVA)

**Output:**
- **Proof:** Property holds for all reachable states
- **Counter-example:** Input sequence violating property

**Challenge:** State explosion (n flip-flops → 2ⁿ states)

### 4.2 Temporal Logic and SVA

**Temporal logic:** Logic + time-related operators

**Operators:**
- **Whenever:** Condition triggers
- **Eventually:** Condition will hold in future
- **Always:** Condition holds at all times
- **Never:** Condition never holds

**SystemVerilog Assertions (SVA):**

**Keywords:**
- `assert`: Property to verify
- `assume`: Axiom/constraint (restrict input space)
- `restrict`: Input constraints (formal verification only)

**Examples:**
```systemverilog
// Request followed by ack within 1-5 cycles
assert property (@(posedge clk) (req |-> ##[1:5] ack));

// Mutex: signals a and b never both high
assert property (@(posedge clk) !(a && b));

// Eventually reset deasserts
assume property (eventually !rst);
```

### 4.3 Characteristics Functions

**Definition:** Boolean function representing set of states

**Notation:** $\text{CF}_S(x) = 1$ iff $x \in S$

**Example:**
```
FSM: 5 states {s0, s1, s2, s3, s4}
Encoding: 3 bits (x₂, x₁, x₀)
  s0=000, s1=001, s2=010, s3=011, s4=100

Subset A = {s0, s2, s4}
CF_A = x₂'x₁'x₀' + x₂'x₁x₀' + x₂x₁'x₀'
```

**BDD representation:** Compact (polynomial for many state sets despite exponential #states)

### 4.4 Transition Relation

**Definition:** $T(x, i, x') = 1$ iff transition from state x with input i to next state x'

**Example (2-state FSM):**
```
States: sA=0, sB=1
Inputs: A=0, B=1

Transitions:
  sA --[A]--> sA:  T(0, 0, 0) = 1
  sA --[B]--> sB:  T(0, 1, 1) = 1
  sB --[A]--> sB:  T(1, 0, 1) = 1
  sB --[B]--> sA:  T(1, 1, 0) = 1
```

**BDD representation:** Compact transition relation enables efficient image/preimage computation

### 4.5 Image and Preimage

**Image (forward reachability):**
$$\text{Image}(S, T) = S' = \{x' \ | \ \exists x \in S, \exists i : T(x, i, x') = 1\}$$
- Set of states reachable in 1 step from S

**Preimage (backward reachability):**
$$\text{Preimage}(S', T) = S = \{x \ | \ \exists i : T(x, i, x') = 1, x' \in S'\}$$
- Set of states from which S' reachable in 1 step

**Efficient computation:** BDD-based symbolic set operations (no explicit state enumeration)

### 4.6 Reachability Analysis

**Goal:** Compute all states reachable from initial state S₀

**Algorithm:**
```
S_reach = {S₀}
S_new = S₀
while (S_new ≠ ∅) {
    S_k = Image(S_new, T)
    S_new = S_k \ S_reach
    S_reach = S_reach ∪ S_new
}
return S_reach
```

**Fixed point:** Terminates when no new states discovered (FSM finite → guaranteed termination)

### 4.7 BDD-Based Model Checking

**Property verification:**
1. **Property P:** Boolean function of state bits
2. **State set S_P:** States where P holds → $\text{CF}_{S_P} = P$
3. **Compute backward reachability:** $S_{\text{reach}}' = \text{Preimage}^*(S_P, T)$
   - All states from which S_P reachable
4. **Check:** If $S_0 \in S_{\text{reach}}'$ → property holds; else → property fails

**Limitation:** BDD blow-up (exponential size for some functions/variable orders)

### 4.8 Bounded Model Checking (BMC)

**SAT-based approach:** Find counter-example of length n (n clock cycles from initial state)

**Formulation:** Construct Boolean function Φₙ (CNF)
$$\Phi_n = \text{initial\_state} \land \text{transitions}(0 \to 1 \to ... \to n) \land \neg \text{property}$$

**Verification:**
- Φₙ satisfiable ⇔ counter-example of length n exists
- Satisfying assignment → counter-example trace

**Iteration:** n=1, 2, 3,... until counter-example found or SAT solver times out

**Advantages:**
- Avoids BDD memory blow-up
- Linear growth in variables (vs exponential in BDD)
- Excellent for bug hunting (quickly find violations)

**Limitations:**
- **Incomplete:** Only verifies up to n cycles; cannot prove property holds for all n
- SAT complexity grows (may become unsolvable for large n)

**Comparison:**

| Aspect | BDD Model Checking | BMC (SAT-based) |
|--------|-------------------|-----------------|
| **Completeness** | Complete (proves or finds counter-example) | Incomplete (up to n cycles) |
| **Memory** | Can blow up (exponential BDD) | Linear in n |
| **Speed** | Slow for deep bugs | Fast for shallow bugs |
| **Application** | Proof of correctness | Bug hunting |

---

## 5. Equivalence Checking

### 5.1 Applications and Motivation

**Verify functional equivalence across transformations:**

| Transformation | From → To | Why Verify |
|----------------|-----------|------------|
| **Code changes** | RTL v1 → RTL v2 | Refactoring, dead code removal |
| **Synthesis** | RTL → Netlist | Logic optimization, technology mapping |
| **Optimization** | Netlist v1 → Netlist v2 | Timing fixes, buffer insertion |
| **Physical design** | Pre-CTS → Post-CTS | Clock tree synthesis |
| **ECO** | Final → Final+ECO | Engineering change orders |

### 5.2 Sequential vs Combinational Equivalence

**Sequential Equivalence Checking (SEC):**
- **Approach:** Model both designs as FSMs → verify identical output sequences for all input sequences
- **Challenge:** State explosion (symbolic state traversal computationally expensive)
- **Usage:** Rarely used in practice (most transformations preserve flip-flop correspondence)

**Combinational Equivalence Checking (CEC):**
- **Assumption:** One-to-one correspondence between memory elements (flip-flops) and ports
- **Validity:** Holds for most design transformations (incremental flow preserves ports/flip-flops)
- **Simplification:** Equivalence checking reduces to verifying pairs of combinational logic cones

**Why CEC assumption valid:**
- Synthesis: Preserves flip-flops (each RTL register → netlist flip-flop)
- Optimization: Logic between flip-flops optimized; flip-flops unchanged
- Physical design: Buffers added; flip-flops/ports preserved

### 5.3 CEC Framework

**Four steps:**

#### 1. Register/Port Matching
**Goal:** Establish correspondence between flip-flops and I/O ports in both models

**Heuristic: Name-based matching**
- Most common approach (port/flip-flop names preserved across transformations)
- **Example:** RTL signal `q` → synthesis creates flip-flop instance `q_reg` (add suffix `_reg`)

**Fallback:** Structural/functional analysis if name-based fails

**Manual override:** User specifies correspondence for unmatched flip-flops
- Regular expressions
- Direct mapping files

#### 2. Miter Construction
**Goal:** Create combinational circuits (miters) for each comparison point

**Comparison points:**
- D pins of matched flip-flops
- Output ports

**Miter construction steps:**
1. Identify comparison point (D pin or output port)
2. Traverse fan-in cone (stop at input ports or Q pins of flip-flops)
3. Create independent variables for inputs/flip-flops
4. Add XOR gate at outputs of two cones

**Miter definition:**
$$z = \text{CL}_1(x_1,...,x_n) \oplus \text{CL}_2(x_1,...,x_n)$$

**Interpretation:**
- z=0 for all inputs → CL₁ ≡ CL₂ (equivalent)
- z=1 for some input → CL₁ ≢ CL₂ (not equivalent; input is counter-example)

**Example:**
```
Model 1: z = AB (AND gate)
Model 2: z = A + B (OR gate)

Miter: z_miter = (AB) ⊕ (A+B)

Counter-examples:
  A=0, B=1 → 0 ⊕ 1 = 1 (not equivalent)
  A=1, B=0 → 0 ⊕ 1 = 1 (not equivalent)
```

#### 3. Miter Verification
**BDD-based:**
```
Build ROBDD for miter
if (ROBDD == single 0-terminal)
    return EQUIVALENT
else
    return NOT_EQUIVALENT
```

**SAT-based:**
```
Formulate miter as CNF
Invoke SAT solver
if (UNSAT)
    return EQUIVALENT
else
    return NOT_EQUIVALENT (satisfying assignment = counter-example)
```

#### 4. Result Analysis
**All miters equivalent:** Designs functionally equivalent

**Any miter fails:** Debug counter-example
- Check if counter-example is reachable state
- If unreachable → false failure (waive)
- If reachable → real bug (fix design)

### 5.4 False Failures

**Cause:** CEC treats flip-flop outputs as independent variables (any value allowed) → may include unreachable states

**Example:**
```
4 flip-flops in 1-hot FSM
Reachable states: 4 (0001, 0010, 0100, 1000)
CEC considers: 16 states (all 2⁴ combinations)

Miter may fail for state 0101 (unreachable)
→ False failure (state never occurs in actual circuit)
```

**Resolution:**
1. Analyze counter-example
2. Check if state reachable (simulate from initial state)
3. If unreachable → waive violation
4. If reachable → real bug

**Safety:** CEC never misses real failures
- Conservative approach (may report false positives, never false negatives)

---

## Key Takeaways

1. **Formal verification:** Mathematical proofs (no test vectors); covers all inputs implicitly; higher cost than simulation
2. **BDDs (1990s breakthrough):** Compact, canonical Boolean representation for many practical functions
3. **Shannon expansion:** Recursively split function into cofactors (x=0, x=1) → binary decision tree
4. **OBDD:** Fixed variable order (not canonical); ROBDD: Reduce redundancies (canonical for fixed order)
5. **ROBDD compactness:** Polynomial for many functions (adders), exponential for some (multipliers); variable order critical (optimal: NP-hard; use dynamic reordering)
6. **SAT problem:** ∃ assignment making f=1? (SAT if yes, UNSAT if no); CNF representation standard
7. **k-SAT complexity:** 2-SAT polynomial; 3-SAT NP-complete (modern solvers handle practical problems despite NP-completeness)
8. **DPLL algorithm:** Decide variable → deduce implications (BCP) → detect conflicts → backtrack; modern: CDCL (learn clauses from conflicts)
9. **Model checking:** Verify temporal properties on FSM; SVA (SystemVerilog Assertions) for specification
10. **Characteristics functions:** Boolean function representing state sets; compact BDD representation
11. **Image/preimage:** Symbolic set operations (1-step forward/backward state traversal); efficient in BDD
12. **Reachability:** Iterate image until fixed point (all states reachable from S₀)
13. **BDD model checking:** Complete but may face BDD blow-up (try variable reordering, add constraints)
14. **BMC (Bounded Model Checking):** SAT-based; find counter-example within n cycles (incomplete but avoids BDD blow-up; excellent for bug hunting)
15. **Equivalence checking:** Verify functional equivalence across transformations (RTL→RTL, RTL→netlist, netlist→netlist)
16. **SEC vs CEC:** Sequential (expensive, FSM-based) vs combinational (assumes 1-to-1 flip-flop correspondence)
17. **CEC framework:** (1) Register/port matching (name-based heuristic), (2) Miter construction (XOR logic cones), (3) Miter verification (BDD/SAT), (4) Result analysis
18. **False failures:** CEC tests unreachable states → manual analysis required (waive if unreachable); conservative (never misses real failures)

---

## Tools and Commands

| Tool | Category | Purpose |
|------|----------|---------|
| **CUDD, BuDDy, Sylvan** | BDD packages | ROBDD construction, manipulation |
| **MiniSat, Z3, Glucose** | SAT solvers | CNF satisfiability checking |
| **JasperGold, VC Formal** | Model checkers | Temporal property verification |
| **Conformal, Formality** | Equivalence checkers | CEC/SEC for design transformations |
| **NuSMV, ABC** | Academic tools | Research, open-source formal verification |

---

## Common Pitfalls

1. **Confusing OBDD with ROBDD:** OBDD not canonical; ROBDD canonical (for fixed order)
2. **Assuming all functions compact in ROBDD:** Multipliers always exponential regardless of variable order
3. **Ignoring variable order impact:** Poor order → memory blow-up (use dynamic reordering)
4. **Confusing SAT (satisfiable) with valid (tautology):** SAT: ∃ assignment → f=1; Valid: ∀ assignments → f=1
5. **Forgetting BCP in SAT:** Boolean Constraint Propagation essential for efficiency
6. **Over-relying on BMC for proof:** Incomplete (only up to n cycles); use for bug hunting, not proofs
7. **Assuming CEC always correct:** False failures possible for unreachable states (analyze counter-examples)
8. **Ignoring naming conventions:** Inconsistent names → name-based matching fails (requires structural analysis)
9. **Confusing image (forward: S→S') with preimage (backward: S'→S)**
10. **Forgetting to match flip-flops after sequential optimization:** Correspondence broken → CEC fails or requires manual matching

---

## Further Reading

- [[05-Logic-Optimization]]: Boolean function minimization (two-level, multi-level)
- [[04-Logic-Synthesis]]: RTL translation (precedes equivalence checking)
- [[08-Static-Timing-Analysis]]: Timing verification (complements functional verification)
- [[02-Hardware-Description-Languages]]: Verilog, SVA syntax
- [[13-Design-for-Test]]: Testability (complements formal verification)
