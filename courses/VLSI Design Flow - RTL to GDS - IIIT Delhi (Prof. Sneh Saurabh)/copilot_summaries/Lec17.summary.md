# Lec17 — Logic Optimization Part I: Two-Level Logic Minimization

## Overview
Introduces logic optimization tasks (two-level vs multi-level), Boolean function representations (truth table, minterm, hypercube), terminology (implicant, prime, cover), exact minimization (Quine's theorem, prime implicant table, set covering), and heuristic minimization (expand, reduce, irredundant) for two-level logic (SOP/POS).

## Core concepts
**Logic optimization types:**
- **Two-level:** SOP (AND-OR) or POS (OR-AND); 2 logic levels max
- **Multi-level:** >2 logic levels (AND-OR-AND-OR...); more area-efficient, worse timing
- Goal: Transform generic logic netlist → optimized netlist (preserve functionality, improve area/timing)

**Boolean terminology:**
- **Variable:** x ∈ {0, 1}
- **Function:** y = f(x₁, x₂, ..., xₙ) → {0, 1}
- **Literal:** Variable or complement (x, x')
- **Cube:** Product of literals (x₁x₂x₃, x₁x₂')
- **Minterm:** Cube with all n variables (each appears once, e.g., x₁x₂'x₃ for n=3)
- **Maxterm:** Sum of all n variables (e.g., x₁+x₂'+x₃)

**Boolean representations:**
- **Truth table:** 2ⁿ rows (all input combinations) + output column
- **Minterm form:** Sum of minterms where f=1 (SOP canonical form)
- **Hypercube:** n-dimensional cube; corners = n-bit vectors (input combinations); mark corners with f=0/1/X (don't care)

**Incompletely specified functions:**
- **Onset:** Input combinations where f=1
- **Offset:** Input combinations where f=0
- **DC (don't care):** Input combinations where f=X (can assign 0 or 1 for optimization)
  - Never occur (e.g., BCD: 1010-1111 invalid)
  - Never observed (output block in sleep state)

**Implicant and cover:**
- **Implicant:** Cube covering only onset or DC (not offset)
- **Prime implicant:** Implicant not covered by any other implicant
- **Essential prime:** Prime covering ≥1 minterm that no other prime covers
- **Cover:** Set of implicants covering all minterms
- **Minimum cover:** Cover with minimum size (fewest cubes); correlates with area

**Exact minimization (Quine's theorem):**
- **Quine's theorem:** There exists a minimum cover consisting only of primes
- **Approach:** Find all prime implicants → build prime implicant table (rows=minterms, cols=primes; entry=1 if prime covers minterm) → set covering problem (select minimum columns covering all rows)
- **Set covering:** NP-complete; complexity grows exponentially with variables/minterms
- **Reduction techniques:** Identify essential primes (always in cover), remove covered minterms, solve for remainder

**Heuristic minimization:**
- Goal: Find minimal cover (local minimum) vs minimum cover (global minimum)
- Minimal: No implicant covered by another implicant (irredundant)
- **Operators:**
  - **Expand:** Expand non-prime → prime; remove covered implicants
  - **Reduce:** Replace implicant with reduced implicant (cover fewer minterms; function still covered)
  - **Reshape:** Expand one implicant, reduce another (cover size unchanged; enable future optimizations)
  - **Irredundant:** Remove redundant implicants (cover remains valid)
- Iterate operators until no improvement; faster than exact for >20 variables

## Methods/flows
1. **Exact minimization:** Represent function (truth table/hypercube) → identify all primes → build prime table → identify essential primes → solve set covering for remaining minterms
2. **Heuristic minimization:** Start with initial cover (e.g., minterm form) → apply expand → reduce → reshape → irredundant → repeat until no improvement

## Constraints/assumptions
- Two-level logic optimal for timing (2 gate delays) but large area (many literals)
- Exact minimization: Feasible for small functions (<20 variables); NP-complete for large
- Heuristic minimization: Near-optimal solutions acceptable (e.g., 988 vs 980 cubes); much faster
- Cover size (literal count) correlates with CMOS area

## Examples
- **Minterm:** f(x₁,x₂,x₃) = x₁'x₂'x₃' + x₁'x₂x₃ + x₁x₂x₃ → 3 minterms (000, 011, 111)
- **Hypercube:** 3-var cube; corners labeled 000-111; mark 1 at onset, 0 at offset, X at DC
- **Implicant:** x₂x₃ (covers 011, 111); x₁' (covers 000, 001, 010, 011); not implicant if intersects offset
- **Prime:** x₁'x₂' (covers 000, 001, 010); x₂x₃ (covers 011, 111); x₁x₃ (covers 101, 111)
- **Essential prime:** Only prime covering specific minterm (e.g., 000 covered only by x₁'x₂')
- **Cover:** {x₁'x₂', x₂x₃} (size 2) vs {x₁'x₂'x₃', x₁'x₂x₃, x₁x₂x₃} (size 3); minimum cover = size 2
- **Heuristic:** Start 5 minterms → expand (5→4 cubes) → reduce (4→4) → reshape (4→4) → expand (4→3); final cover size 3

## Tools/commands
- **ESPRESSO:** Heuristic two-level minimizer (widely used)
- **Exact minimizers:** Research tools (small problems only)

## Common pitfalls
- Confusing prime implicant with essential prime (essential primes always in minimum cover; other primes optional)
- Assuming heuristic finds minimum cover (finds minimal, not minimum; may be 1-2% larger)
- Applying exact minimization to >20 variables (exponential runtime; use heuristic)

## Key takeaways
- Two-level logic: Optimal timing (2 delays), large area (many literals)
- Minimum cover: Fewest cubes covering all minterms; correlates with area
- Quine's theorem: Minimum cover exists among prime covers (search only primes, not all covers)
- Exact minimization: Prime implicant table → set covering (NP-complete); feasible for small functions
- Heuristic minimization: Expand/reduce/reshape/irredundant operators; fast, near-optimal (acceptable for >20 variables)
- Incompletely specified functions: Don't cares enable better minimization (assign X→0 or 1 as needed)

**Cross-links:** See Lec18: multi-level logic optimization; Lec19: algebraic model, Boolean don't cares; Lec16: operator-level optimizations (CSE)

---

*This summary condenses Lec17 from ~18,000 tokens, removing repeated hypercube drawing explanations, redundant definitions, and step-by-step prime table construction walkthroughs.*
