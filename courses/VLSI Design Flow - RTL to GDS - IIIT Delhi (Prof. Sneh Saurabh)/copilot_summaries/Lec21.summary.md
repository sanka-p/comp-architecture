# Lec21 — Formal Verification Part I: Introduction and Binary Decision Diagrams (BDDs)

## Overview
Introduces formal verification vs simulation (exhaustive vs test-vector based), core techniques enabling scalability (BDDs, SAT solvers), BDD representation (Shannon expansion, OBDD, ROBDD), canonicity and compactness properties, and applications (equivalence checking, satisfiability testing, tautology checking).

## Core concepts
**Simulation limitations:**
- Cannot exhaustively verify (e.g., 32×32 multiplier: 2⁶⁴ combinations ≈ 500,000 years @ 1μs/test)
- Test vectors based on anticipated errors (bugs occur where designers didn't pay attention)
- Cannot prove correctness (only show presence of bugs, not absence)

**Formal verification:**
- **Mechanism:** Mathematical reasoning/proofs (no test vectors)
- **Completeness:** Implicitly covers all inputs (if proof holds, function correct for any input)
- **Example:** Prove (x-4)² = x²-8x+16 via algebraic expansion (no specific x values needed)
- **Cost:** Higher computational resources than simulation

**Breakthrough techniques (1990s):**
1. **Binary Decision Diagrams (BDDs):** Compact, canonical Boolean representation
2. **SAT solvers:** Efficient satisfiability problem solvers

**Boolean representation attributes:**
- **Compactness:** Size growth rate with # variables (truth table: exponential 2ⁿ; logic formula: polynomial for flexible forms)
- **Canonicity:** Equivalent functions have identical representations (truth table: canonical; logic formula: not canonical)
- **Ideal:** Both compact and canonical (BDDs achieve this for many practical functions)

**Shannon expansion:**
- Split Boolean function into cofactors: `f = x·f_x=1 + x'·f_x=0`
- **Positive cofactor (f₁):** f with variable assigned 1
- **Negative cofactor (f₀):** f with variable assigned 0
- Example: `y=ab+acd+b'd+bc'` → expand on `a`: `y=a'(b'd+bc') + a(b+cd+b'd+bc')`

**Binary Decision Tree:**
- Recursive Shannon expansion on all variables → 2ⁿ leaf nodes (0 or 1)
- Not compact (exponential leaves) or canonical (variable order not fixed)

**Ordered BDD (OBDD):**
- **Constraint:** Variable order same in all root-to-leaf paths (may skip variables)
- **Structure:** Rooted DAG; terminal vertices (labels 0/1, outdegree=0); non-terminal vertices (index, low/high children)
- **Ordering:** index(v) < index(low(v)), index(high(v)) (indices increase along paths)
- Example: 3 variables (x₁, x₂, x₃) → paths always x₁→x₂→x₃ (some may skip to leaf)

**Reduced OBDD (ROBDD):**
- Remove redundancies: (1) No vertex v with low(v)=high(v); (2) No pair (u, v) with isomorphic subgraphs
- **Canonicity:** Bryant proved ROBDD canonical (equivalent functions → identical ROBDD)
- **Compactness:** Polynomial growth for many practical functions (adders: linear if good variable order; multipliers: always exponential)
- **Variable order impact:** Good order → compact; poor order → exponential (finding optimal order: NP-hard; tools use heuristics)

**Applications:**
- **Equivalence checking:** Compare ROBDD pointers (identical → functions equivalent)
- **Satisfiability:** Path from root to 1-terminal exists?
- **Tautology:** ROBDD = single 1-terminal vertex (function always 1)

## Methods/flows
1. **Shannon expansion:** f(x₁,...,xₙ) → f₀ (x₁=0), f₁ (x₁=1); recursively expand until leaf values (0/1)
2. **OBDD construction:** Binary decision tree + enforce variable ordering (same order all paths)
3. **ROBDD construction:** OBDD → remove vertices with identical children → merge isomorphic subgraphs
4. **Equivalence check:** Build ROBDDs for f₁, f₂ → compare root pointers (equal → equivalent)

## Constraints/assumptions
- ROBDD canonical only for fixed variable order
- Compactness depends on variable order (good order: polynomial; poor order: exponential)
- Some functions (multipliers) always exponential regardless of variable order
- Finding optimal variable order: NP-hard (tools use dynamic reordering heuristics)

## Examples
- **Shannon expansion:** `y=ab+acd+b'd+bc'` on `a` → `y₀=b'd+bc'`, `y₁=b+cd+b'd+bc'` → `y=a'y₀+a'y₁`
- **Binary decision tree:** 3 vars → 8 leaves (2³); expand x₁ → 2 subtrees; expand x₂ in each → 4 subtrees; expand x₃ → 8 leaves
- **OBDD:** Enforce x₁→x₂→x₃ order in all paths (some paths may skip variables, e.g., x₁→leaf)
- **ROBDD reduction:** Remove vertex with both edges to 0; merge two x₃ vertices with identical 0/1 children
- **Equivalence:** f₁=`x₁x₂+x₂x₃`, f₂=`x₂(x₁+x₃)` → build ROBDDs → same structure → equivalent

## Tools/commands
- **BDD packages:** CUDD (Colorado University Decision Diagram), BuDDy, Sylvan (multi-core)
- **Applications:** Formal verification tools (model checkers, equivalence checkers)

## Common pitfalls
- Confusing OBDD (ordered) with ROBDD (reduced+ordered; ROBDD canonical, OBDD not)
- Assuming all functions compact in ROBDD (multipliers always exponential)
- Ignoring variable order impact (poor order → memory blow-up)
- Manually fixing variable order (use dynamic reordering in BDD packages)

## Key takeaways
- Formal verification: Mathematical proofs (no test vectors), covers all inputs implicitly
- Simulation: Fast, low resources, but incomplete (cannot prove correctness)
- BDDs (1990s breakthrough): Compact, canonical Boolean representation for many practical functions
- Shannon expansion: Recursively split function into cofactors (x=0, x=1)
- OBDD: Fixed variable order (not canonical); ROBDD: Reduce redundancies (canonical)
- ROBDD compactness: Polynomial for many functions (adders), exponential for some (multipliers)
- Variable order: Critical (good order → compact; poor order → exponential; finding optimal: NP-hard)
- Applications: Equivalence checking (compare pointers), satisfiability, tautology

**Cross-links:** See Lec23: SAT solvers; Lec24: model checking (BDD-based state traversal); Lec25: equivalence checking (CEC); Lec17-19: Boolean function representations (SOP, BLN)

---

*This summary condenses Lec21 from ~15,000 tokens, removing repeated OBDD construction examples, redundant isomorphism checks, and verbose Shannon expansion walkthroughs.*
