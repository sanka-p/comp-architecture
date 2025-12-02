# Logic Optimization

> **Chapter Overview:** This chapter covers comprehensive logic optimization techniques including two-level minimization (Quine-McCluskey, heuristics), multi-level optimization (factored forms, Boolean networks), sequential optimization (FSM state minimization, encoding), and practical resource sharing using synthesis tools.

**Prerequisites:** [[04-Logic-Synthesis]], [[02-Hardware-Description-Languages]]  
**Related Topics:** [[10-Technology-Mapping]], [[11-Timing-Driven-Optimization]]

---

## 1. Logic Optimization Overview

### 1.1 Optimization Levels

**Two-level logic:**
- **Structure:** SOP (AND-OR) or POS (OR-AND)
- **Depth:** Exactly 2 logic levels
- **Characteristics:** Optimal timing (2 gate delays), large area (many literals)
- **Use case:** Timing-critical paths, PLAs

**Multi-level logic:**
- **Structure:** >2 logic levels (AND-OR-AND-OR...)
- **Depth:** Variable (3-10+ levels typical)
- **Characteristics:** Smaller area than two-level, worse timing
- **Use case:** Most modern designs (RTL synthesis produces multi-level naturally)

**Sequential logic:**
- **Structure:** Flip-flops + combinational logic
- **Optimization targets:** (1) State count (flip-flops), (2) Combinational logic (next-state/output functions)
- **Use case:** FSMs, sequential controllers

### 1.2 Optimization Goals

| Goal | Metric | Optimization Strategy |
|------|--------|----------------------|
| **Minimize area** | Literal count (2-level), gate count (multi-level) | Eliminate redundancy, share resources |
| **Minimize delay** | Logic depth (levels), critical path delay | Reduce levels, balance paths |
| **Minimize power** | Switching activity, leakage | Reduce transitions, gate count |

> **Trade-off reality:** Optimizing one metric often worsens others. Area-delay is the primary trade-off (factorization reduces area but increases delay).

---

## 2. Two-Level Logic Minimization

### 2.1 Boolean Terminology

**Basic concepts:**

| Term | Definition | Example |
|------|------------|---------|
| **Variable** | Boolean input | x ∈ {0, 1} |
| **Literal** | Variable or complement | x, x' |
| **Cube** | Product of literals | x₁x₂x₃, x₁x₂' |
| **Minterm** | Cube with all n variables | x₁x₂'x₃ (n=3) |
| **Maxterm** | Sum of all n variables | x₁+x₂'+x₃ |

**Function representations:**

1. **Truth table:** 2ⁿ rows (all input combinations) + output column
2. **Minterm form (SOP canonical):** Sum of minterms where f=1
   ```
   f(x₁,x₂,x₃) = Σm(0,3,7) = x₁'x₂'x₃' + x₁'x₂x₃ + x₁x₂x₃
   ```
3. **Hypercube:** n-dimensional cube; corners = n-bit vectors
   - Mark corners: 1 (onset), 0 (offset), X (don't care)
   - Visualize adjacency, grouping opportunities

### 2.2 Incompletely Specified Functions

**Sets:**
- **Onset:** Input combinations where f=1 (required)
- **Offset:** Input combinations where f=0 (required)
- **DC (don't care):** Input combinations where f=X (assign 0 or 1 for optimization)

**Don't care sources:**
1. **Never occur:** Invalid inputs (e.g., BCD: 1010-1111)
2. **Never observed:** Outputs not used in certain modes (e.g., sleep state)

**Optimization benefit:** Assign DC → 1 or 0 to enable larger cubes → fewer literals.

### 2.3 Implicants and Covers

**Definitions:**

| Term | Definition | Property |
|------|------------|----------|
| **Implicant** | Cube covering only onset or DC (not offset) | May overlap with other implicants |
| **Prime implicant** | Implicant not covered by any other implicant | Maximal cube |
| **Essential prime** | Prime covering ≥1 minterm that no other prime covers | Must be in minimum cover |
| **Cover** | Set of implicants covering all onset minterms | Function representation |
| **Minimum cover** | Cover with minimum size (fewest cubes/literals) | Correlates with minimum area |

**Example (3-variable function):**
```
f(x₁,x₂,x₃) = 1 at minterms {000, 011, 111}

Implicants:
- x₁'x₂'x₃' (covers 000)
- x₂x₃ (covers 011, 111)
- x₁x₃ (covers 011, 111)

Prime implicants:
- x₁'x₂' (covers 000, 001 [DC assumed])
- x₂x₃ (covers 011, 111)

Essential prime:
- x₁'x₂' (only prime covering 000)

Minimum cover: {x₁'x₂', x₂x₃} (size 2, literal count 4)
```

### 2.4 Exact Minimization (Quine's Method)

**Quine's Theorem:** There exists a minimum cover consisting only of prime implicants.

**Approach:**
1. **Find all prime implicants** (enumerate via merging adjacent minterms)
2. **Build prime implicant table**
   - Rows: Onset minterms
   - Columns: Prime implicants
   - Entry: 1 if prime covers minterm
3. **Identify essential primes** (columns covering unique minterms)
4. **Solve set covering problem** for remaining minterms
   - Select minimum set of columns (primes) covering all rows (minterms)
   - **NP-complete** problem

**Reduction techniques:**
- Select essential primes (always in cover)
- Remove covered minterms
- Remove dominated columns (prime A covers subset of prime B → remove A)
- Solve residual set covering

**Limitation:** Exponential complexity for large functions (>20 variables infeasible)

### 2.5 Heuristic Minimization (ESPRESSO)

**Goal:** Find **minimal** cover (local minimum) vs **minimum** cover (global minimum).

**Minimal cover property:** No implicant covered by another implicant (irredundant).

**ESPRESSO operators:**

#### 1. Expand
- **Action:** Expand non-prime implicant → prime implicant
- **Benefit:** Enable subsequent coverage by fewer cubes
- **Example:** Cube x₁x₂x₃ → expand to x₁x₂ (covers more minterms)

#### 2. Reduce
- **Action:** Replace implicant with reduced implicant (cover fewer minterms)
- **Constraint:** Function still covered by other cubes
- **Benefit:** Remove redundancy

#### 3. Reshape
- **Action:** Expand one implicant, reduce another
- **Benefit:** Same cover size but different structure (enables future optimizations)

#### 4. Irredundant
- **Action:** Remove redundant implicants
- **Constraint:** Cover remains valid (all minterms still covered)

**ESPRESSO algorithm:**
```
1. Start with initial cover (e.g., minterm form)
2. Repeat until no improvement:
   a. Expand (non-primes → primes)
   b. Reduce (remove redundancy)
   c. Reshape (restructure for future opts)
   d. Irredundant (remove redundant cubes)
3. Return minimal cover
```

**Performance:**
- Fast for large functions (>20 variables)
- Near-optimal (typically 1-2% larger than minimum)
- Industry standard for two-level minimization

**Example:**
```
Initial: 5 minterms (5 cubes, 15 literals)
↓ Expand
4 cubes (12 literals)
↓ Reduce  
4 cubes (12 literals)
↓ Reshape
4 cubes (12 literals)
↓ Expand
3 cubes (9 literals) ← Minimal cover
```

---

## 3. Multi-Level Logic Optimization

### 3.1 Factored Forms

**Definition:** Recursive structure
- **Base:** Literal
- **Recursive:** SOP of factored forms | POS of factored forms

**Example:**
```
SOP (2-level): ac + ad + bc + bd + ce
Factored (3-level): (a+b)(c+d) + ce

Literal count: 10 (SOP) vs 6 (factored)
Logic depth: 2 (SOP) vs 3 (factored)
```

**Area-delay trade-off:**
- **Factorization reduces literals** (area) but **increases depth** (delay)
- Balance via factorization depth control

### 3.2 Boolean Logic Networks (BLNs)

**Structure:** Directed Acyclic Graph (DAG)
- **Vertices:** Local functions (single-output Boolean functions)
- **Edges:** Dependencies (fan-in/fan-out)

**Node annotation:**
```
p = a + b       // Node p, local function: SOP
q = pc + d      // Node q depends on p
```

**Constraints:**
- Local functions in **minimal SOP** (no implicant containment)
- Enables easy estimation:
  - **Area:** Sum of literal counts across all nodes
  - **Delay:** Longest path (level count) from inputs to outputs

**Example BLN:**
```
Inputs: a, b, c, d
p = a + b
q = pc + d
r = qc' + p
Output: r

Levels: a,b,c,d (0) → p (1) → q (2) → r (3)
Delay: 3 levels
Area: (2+2) + (3+2) + (4+2) = 15 literals
```

### 3.3 BLN Transformations

#### 1. Eliminate
**Action:** Remove node; replace occurrences in fan-out with local function

**Example:**
```
Before: p = bc
        q = p + d
After:  q = bc + d

Effect: Enable subsequent simplifications (not immediate area reduction)
```

#### 2. Simplify
**Action:** Optimize local SOP using two-level minimizer (ESPRESSO)

**Example:**
```
Before: q = abc + ab'c
After:  q = ac

Literal reduction: 4 → 2
```

#### 3. Substitute
**Action:** Replace local SOP by creating dependency on another node

**Requirement:** Division algorithm (check if node p divides node q)

**Example:**
```
Before: p = a + b
        q = ac + bc + d
After:  q = pc + d

Division: q = (a+b)c + d = pc + d
Literal reduction: 7 → 3
```

#### 4. Extract
**Action:** Find common sub-expression in multiple nodes; create new node

**Example:**
```
Before: q = ab + ac + d
        r = ab + ac + bd + cd + e

After:  p = ab + ac
        q = p + d
        r = p + bd + cd + e

Literal reduction: 14 → 10 (save 4 literals)
```

### 3.4 Algebraic vs Boolean Models

**Algebraic model:**
- **Approach:** Treat Boolean functions as polynomials
- **Simplification:** Ignore Boolean identities (a+a'=1, aa'=0)
- **Advantage:** Fast division/extraction algorithms
- **Limitation:** Misses Boolean optimizations

**Boolean model:**
- **Approach:** Exploit Boolean identities
- **Tools:** Controllability/Observability Don't Cares (CDC/ODC)
- **Advantage:** Captures opportunities missed by algebraic model
- **Limitation:** Slower (requires SAT solving, traversal)

**Strategy:** Apply algebraic optimizations first (fast), then Boolean optimizations (capture missed opportunities).

### 3.5 Don't Care Optimization

#### Controllability Don't Cares (CDC)
**Definition:** Input combinations that never occur at a node.

**Example:**
```
p = ab
q depends on p and b

CDC: If b=0, then p=0 (cannot have p=1, b=0)
Derive from SDC (Satisfiability Don't Cares):
  p ⊕ ab = 0 → pa' + pb' + p'ab = 0
  CDC: pb' (p=1, b=0 never occurs)

Simplification:
Before: q = pb + b'c
After:  q = p + b'c (using CDC: pb' = DC)
```

#### Observability Don't Cares (ODC)
**Definition:** Input combinations where node output not observed at network output.

**Example:**
```
p = ab + bc + ac
q = pc
x = q + c'

ODC for p: If c=0, then x=1 (independent of q, hence p)
Treat c=0 as DC for node p

Simplification:
Before: p = ab + bc + ac (6 literals)
After:  p = a + b (2 literals, using ODC c=0)
```

**Discovery:** ODC requires fan-out traversal (identify when node output doesn't affect network output).

---

## 4. Sequential Logic Optimization (FSMs)

### 4.1 FSM Fundamentals

**Finite State Machine components:**
1. **States:** Finite non-empty set (S = {s₀, s₁, ...})
2. **Inputs:** Finite alphabet (I = {i₀, i₁, ...})
3. **Outputs:** Finite alphabet (O = {o₀, o₁, ...})
4. **Initial state:** s₀ ∈ S
5. **Transition function:** δ: S × I → S (next state)
6. **Output function:**
   - **Moore:** λ: S → O (output depends only on state)
   - **Mealy:** λ: S × I → O (output depends on state and input)

**State diagram:**
- **Vertices:** States
- **Edges:** Transitions (labeled with input/output)

**Example (Moore machine):**
```
States: s0, s1, s2
Inputs: {0, 1}
Outputs: {A, B, C}

s0 (output A) --1--> s1 (output B)
s0 (output A) --0--> s0
s1 (output B) --1--> s2 (output C)
s1 (output B) --0--> s0
s2 (output C) --0,1--> s2
```

### 4.2 FSM Implementation

**Structure:**
```
Flip-flops (store state Q) + Combinational Logic CL
CL computes:
  - Next state D = f(Q, Inputs)
  - Outputs = g(Q) [Moore] or g(Q, Inputs) [Mealy]
Clock edge: Q ← D
```

**State encoding:**
- Assign binary codes to states
- **Minimum bits:** ⌈log₂(num_states)⌉
- **Example:** 3 states → 2 bits (s0=00, s1=01, s2=11)

**Optimization targets:**
1. **Flip-flops:** State minimization (reduce state count)
2. **Combinational logic CL:** State encoding (choose binary codes to minimize CL complexity)

### 4.3 State Minimization

**Goal:** Reduce number of states → reduce flip-flop count.

**Equivalent states:** Two states s1, s2 are equivalent if:
1. **Identical outputs** for same inputs
2. **Corresponding next states** are same or equivalent

**Example:**
```
States sA, sC:
- Both produce output (A=1, B=0)
- Both transition to same next states: 
  Input 0: sA→sC, sC→sC (both go to sC)
  Input 1: sA→sB, sC→sB (both go to sB)
→ sA and sC are equivalent → Merge
```

**Algorithm (partition refinement):**
1. Start with partitions based on output
2. Refine partitions based on next-state equivalence
3. Iterate until stable (no further refinement)
4. Merge states within same partition

**Complexity:** Polynomial time (Hopcroft's algorithm: O(ns log n), n=states, s=symbols)

**Benefit:** Always beneficial (reduces flip-flops without functionality loss)

### 4.4 State Encoding

**Goal:** Choose binary codes for states to minimize combinational logic CL.

**Encoding strategies:**

#### 1. Minimal Encoding
- **Bits:** ⌈log₂(num_states)⌉ (minimum possible)
- **Example (4 states):** 2 bits
  - s0=00, s1=01, s2=11, s3=10
- **Advantage:** Fewest flip-flops
- **Disadvantage:** May require complex CL

#### 2. One-Hot Encoding
- **Bits:** num_states (1 bit per state)
- **Example (4 states):** 4 bits
  - s0=0001, s1=0010, s2=0100, s3=1000
- **Advantage:** Simpler CL (identify state via 1 bit), fewer logic levels (faster)
- **Disadvantage:** More flip-flops (area overhead)

**Trade-off:**
```
Minimal encoding: Fewer FF, complex CL, slower
One-hot encoding: More FF, simple CL, faster
```

**When to use:**
- **High-speed designs:** One-hot (fewer CL levels → higher fmax)
- **Area-constrained designs:** Minimal (fewer flip-flops)
- **Moderate designs:** Gray code, custom encodings

### 4.5 Encoding Optimization

**Challenge:** Exponential possibilities (e.g., 50 states, 50 bits → vast search space)

**Heuristic approach:**
1. Define **gain metric** (quantifies common cube/sub-expression sharing in CL)
2. Maximize gain via greedy algorithms
3. Iterate until convergence

**Tools:** NOVA, JEDI (research); heuristics in commercial tools (Design Compiler, Genus)

---

## 5. Resource Sharing (Practical Optimization)

### 5.1 Concept and Motivation

**Definition:** Combine multiple operators into fewer instances (reduce area).

**Mechanism:** Time-multiplex expensive resources (multipliers, dividers) using muxes.

**Example:**
```verilog
if (select == 0)
    Z = A * B;
else
    Z = X * Y;
```

**Before optimization:** 2 multipliers + 1 output mux

**After resource sharing:** 1 multiplier + 2 input muxes
```
operand1 = select ? X : A
operand2 = select ? Y : B
Z = operand1 * operand2
```

### 5.2 Trade-offs

**Area savings:**
- Multiplier (8-bit): ~100-200 gates
- Mux (8-bit 2:1): ~8-16 gates
- **Net savings:** ~180 gates per shared multiplier

**Delay increase:**
- Critical path: mux_delay + multiplier_delay (vs multiplier_delay alone)
- **Impact:** May violate timing constraints

**When beneficial:**
1. **Operator expensive:** Multiplier/divider area >> mux area
2. **Mutually exclusive:** Operations cannot execute simultaneously
3. **Timing slack:** Delay increase acceptable

**When detrimental:**
1. **Small operators:** Adder area ≈ mux area (savings minimal)
2. **Timing-critical:** No slack for mux overhead
3. **High throughput:** Need parallel execution

### 5.3 Yosys Resource Sharing

**Command:** `share -aggressive`

**Mechanism:** SAT solver identifies sharable cells (mutually exclusive conditions)

**Workflow:**
```tcl
read_verilog top.v
proc                        # Convert always blocks
clean
opt                         # General optimization
share -aggressive           # SAT-based resource sharing
show                        # Verify (1 multiplier vs 2)
techmap
dfflibmap -liberty <lib>
abc -liberty <lib>
stat                        # Report area
write_verilog -noattr netlist_opt.v
```

**Example results:**
```
Unoptimized: 2 multipliers → Area = 13,944
Optimized:   1 multiplier + muxes → Area = 7,546 (~46% reduction)
```

**Caution:** SAT solver may timeout on large designs (conservative; may miss opportunities).

---

## Key Takeaways

1. **Two-level optimization:** Exact (Quine's method, NP-complete, <20 vars) vs heuristic (ESPRESSO, fast, near-optimal)
2. **Implicants:** Prime (maximal cubes), essential (must be in cover), minimum cover (fewest cubes/literals)
3. **ESPRESSO:** Expand/reduce/reshape/irredundant operators; industry standard for two-level
4. **Multi-level:** Factored forms (reduce literals, increase depth); BLN transformations (eliminate, simplify, substitute, extract)
5. **Algebraic model:** Fast division/extraction (treat as polynomials); misses Boolean optimizations
6. **Boolean model:** CDC (input combos never occur), ODC (output not observed); use as don't cares in minimization
7. **Strategy:** Algebraic optimizations first (fast) → Boolean optimizations (capture missed opportunities)
8. **FSM optimization:** (1) State minimization (reduce flip-flops; polynomial time), (2) State encoding (minimize CL; heuristic)
9. **Encoding trade-off:** Minimal (fewer FF, complex CL) vs one-hot (more FF, simple/fast CL)
10. **Resource sharing:** Time-multiplex expensive operators (multipliers); trade area (savings) for delay (mux overhead)
11. **Yosys `share -aggressive`:** SAT-based shareability detection; ~46% area reduction (example)
12. **Area-delay fundamental:** Factorization/sharing reduce area but increase delay; balance via constraints

---

## Tools and Commands

| Tool | Command | Purpose |
|------|---------|---------|
| **ESPRESSO** | `espresso <input>` | Two-level heuristic minimizer |
| **SIS** | (Research tool) | Multi-level optimization framework |
| **ABC** | `read; strash; balance; rewrite` | Modern multi-level optimizer |
| **Yosys** | `opt; share -aggressive` | Resource sharing optimization |
| **Commercial** | Design Compiler, Genus | Integrated optimization suites |

---

## Common Pitfalls

1. **Confusing prime with essential:** Essential primes always in cover; non-essential primes optional
2. **Assuming heuristic finds minimum:** ESPRESSO finds minimal (local optimum), not minimum (global optimum)
3. **Applying exact minimization to >20 vars:** Exponential runtime; use heuristic
4. **Over-factorization:** Excessive levels increase delay without proportional area savings
5. **Ignoring don't cares:** CDC/ODC enable significant literal reduction (must discover via traversal)
6. **Wrong FSM encoding:** One-hot for area-constrained design (wastes flip-flops) or minimal for high-speed (complex CL)
7. **Resource sharing without timing check:** Mux overhead may violate timing constraints
8. **Sharing small operators:** Adder sharing saves minimal area (mux overhead comparable)
9. **Forgetting `share -aggressive`:** Default `share` less aggressive (misses opportunities)
10. **Operator order dependence:** Different transformation sequences yield different results (use tool defaults)

---

## Further Reading

- [[04-Logic-Synthesis]]: RTL translation, parsing, elaboration (precedes optimization)
- [[10-Technology-Mapping]]: Map optimized logic to standard cells
- [[11-Timing-Driven-Optimization]]: Gate sizing, buffering, retiming (post-mapping optimization)
- [[06-Formal-Verification]]: Equivalence checking (verify optimizations preserve functionality)
- [[07-Technology-Libraries]]: Library characterization (area/delay models used in optimization)
- [[08-Static-Timing-Analysis]]: Timing analysis (evaluate delay after optimization)
