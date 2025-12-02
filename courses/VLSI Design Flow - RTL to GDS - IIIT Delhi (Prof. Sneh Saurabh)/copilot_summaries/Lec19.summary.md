# Lec19 — Logic Optimization Part II: Multi-Level Logic Optimization

## Overview
Covers multi-level logic optimization: factored form representation, Boolean logic networks (BLNs), transformations (eliminate, simplify, substitute, extract), algebraic model (efficient division, common sub-expression extraction), Boolean model (controllability/observability don't cares), and area-timing trade-offs.

## Core concepts
**Multi-level logic:**
- **Definition:** >2 logic levels (e.g., AND-OR-AND-OR); arises naturally from RTL (procedural blocks, sequential statements)
- **Advantages:** Smaller area than two-level (SOP/POS); area-timing trade-offs (add levels → reduce area, increase delay)
- **Disadvantages:** Slower than two-level (more gate delays)

**Factored form:**
- Recursive definition: Literal | SOP of factored forms | POS of factored forms
- Example: `(a+b)(c+d)+ce` (3 levels) vs `ac+ad+bc+bd+ce` (2 levels, SOP)
- **Area metric:** Literal count (correlates with CMOS area)
- **Timing metric:** Logic depth (levels from input to output)
- Trade-off: Factored form reduces literals but increases depth

**Boolean Logic Network (BLN):**
- **Structure:** Directed acyclic graph (DAG); vertices = local functions (single-output Boolean functions); edges = dependencies
- **Node annotation:** LHS = node name (e.g., `p`); RHS = local SOP expression (e.g., `a+b`)
- **Flexibility:** Local functions can be arbitrarily complex (unlike logic circuits with fixed gate types)
- **Constraint:** Local functions in minimal SOP (no implicant contained by another); enables easy area/delay estimation
  - Area: Sum of literal counts across all nodes
  - Delay: Longest path (level count) from input to output

**Transformations (BLN operators):**
- **Eliminate:** Remove node; replace occurrences in fan-out with local function
  - Example: Eliminate `p=bc` → replace `p` in `q=p+d` with `bc` → `q=bc+d`
  - Benefit: Enable subsequent simplifications (not immediate area reduction)
- **Simplify:** Optimize local SOP using two-level minimizer (ESPRESSO)
  - Example: `q=abc+ab'c` → `q=ac` (2 literals vs 4)
- **Substitute:** Replace local SOP by creating dependency on another node
  - Example: `p=a+b`, `q=(a+b)c+d` → `q=pc+d` (5 literals → 3 literals)
  - Requires: Division algorithm (check if `p` divides `q`)
- **Extract:** Find common sub-expression in multiple nodes; create new node
  - Example: `q=ab+ac+d`, `r=ab+ac+bd+cd+e` → `p=a(b+c)` → `q=p+d`, `r=p+bd+cd+e` (14 literals → 10)
  - Requires: Find divisors, match divisors across nodes

**Algebraic model:**
- **Approach:** Treat Boolean functions as polynomials; ignore Boolean properties (a+a'=1, aa'=0)
- **Key idea:** Treat variable and complement as separate variables (a ≠ a')
- **Benefits:**
  - Efficient division algorithms (polynomial algebra faster than Boolean algebra)
  - Efficient common sub-expression extraction (prune search space using algebraic properties)
- **Limitation:** Cannot fully optimize (misses Boolean identities like a+a'=1)
- **Usage:** Apply algebraic optimizations first (fast), then Boolean optimizations (capture missed opportunities)

**Boolean model (don't care optimization):**
- **Controllability Don't Cares (CDC):** Input combinations that never occur at a node
  - Example: `p=ab`, node `q` depends on `p` and `b` → `p=1, b=0` can never occur (if b=0, p=0)
  - Derive from Satisfiability Don't Cares (SDC): `p ⊕ ab = 0` → `pa' + pb' + p'ab = 0` → CDC: `pb'`
- **Observability Don't Cares (ODC):** Input combinations where node output not observed at network output
  - Example: `q=pc`, network output `x=q+c'` → if `c=0`, `x=1` (independent of `q`) → CDC: `c=0` for node `q`'s input `p`
- **Application:** Use CDC/ODC as don't cares in two-level minimization of local functions → reduce literals

**Heuristic strategy:**
- Start with initial BLN (e.g., from RTL synthesis)
- Iteratively apply transformations (eliminate, simplify, substitute, extract) until no improvement
- Final result depends on operator order (experimentally derived defaults in tools)

## Methods/flows
1. **Factored form optimization:** SOP → factor (group common terms) → reduce literal count
2. **BLN transformation:** Build initial BLN → eliminate → simplify (ESPRESSO on local SOPs) → substitute (find divisions) → extract (find common divisors) → repeat until convergence
3. **Algebraic optimizations:** Treat as polynomials → division/extraction (fast) → obtain near-optimal BLN
4. **Boolean optimizations:** Compute CDC (from SDC), ODC (from fan-out) → simplify local functions with don't cares → final refinement

## Constraints/assumptions
- Local functions in minimal SOP form (no implicant containment)
- Algebraic model faster but misses Boolean optimizations (apply Boolean model afterward)
- Don't care discovery: CDC from SDC (local constraints), ODC from fan-out analysis (traversal-based)
- Transformation order impacts final QoR (tool-dependent defaults; no universally optimal order)

## Examples
- **Factored form:** `ac+ad+bc+bd+ce` (10 literals, 2 levels) → `(a+b)(c+d)+ce` (6 literals, 3 levels)
- **Eliminate:** `p=bc`, `q=p+d`, `r=pc'+d` → eliminate `p` → `q=bc+d`, `r=bcc'+d` (8 literals unchanged; enables simplify)
- **Simplify:** `q=abc+ab'c` → `q=ac` (4→2 literals); `r=bcc'+d` → `r=d` (Boolean: `cc'=0`)
- **Substitute:** `p=a+b`, `q=ac+bc+d` → `q=pc+d` (7→3 literals; division: `p` divides `q`)
- **Extract:** `q=ab+ac+d`, `r=ab+ac+bd+cd+e` → `p=b+c`, `q=ap+d`, `r=ap+d(b+c)+e` (14→10 literals)
- **CDC:** `p=ab`, `q=pb+bc` → `pb'` never occurs (if b=0, p=0) → treat `pb'` as DC → `q=p+bc` (4→3 literals)
- **ODC:** `p=ab+bc+ac`, `q=pc`, `x=q+c'` → if c=0, x=1 (p irrelevant) → treat c=0 as DC for `p` → `p=a+b` (6→2 literals)

## Tools/commands
- **ESPRESSO:** Two-level minimizer (used in simplify operator)
- **SIS (Sequential Interactive Synthesis):** Research tool for multi-level optimization
- **ABC (A System for Sequential Synthesis):** Modern multi-level optimizer (used in Yosys, commercial tools)

## Common pitfalls
- Assuming algebraic model finds optimal solution (misses Boolean identities; apply Boolean optimizations afterward)
- Over-factoring: Excessive levels increase delay without proportional area savings (balance area-timing)
- Ignoring don't cares: CDC/ODC discovery enables significant literal reduction (requires traversal algorithms)
- Operator order: Different sequences yield different results (no single best order; tools use empirical defaults)

## Key takeaways
- Multi-level logic: Smaller area than two-level, slower timing (trade-off via factorization depth)
- Factored form: Recursive SOP/POS; area = literal count, timing = logic depth
- Boolean Logic Network: DAG with local SOP functions; transformations (eliminate, simplify, substitute, extract) iteratively optimize
- Algebraic model: Fast division/extraction (treat variables/complements as separate); misses Boolean optimizations
- Boolean model: CDC (input combinations never occur), ODC (output never observed) → use as don't cares in two-level minimization
- Heuristic: Apply algebraic ops first (fast), then Boolean ops (capture missed opportunities); iterate until convergence
- Area-timing trade-off: Factorization reduces literals but adds levels (balance via transformation choices)

**Cross-links:** See Lec17: two-level minimization (ESPRESSO), prime implicants, set covering; Lec16: CSE (common sub-expression elimination in RTL); Lec20: sequential optimization (FSM, state minimization)

---

*This summary condenses Lec19 from ~16,000 tokens, removing repeated BLN graph redrawing examples, redundant explanations of eliminate/substitute/extract, and verbose SDC derivations.*
