# Lec23 — Formal Verification Part II: Boolean Satisfiability (SAT) Solvers

## Overview
Introduces Boolean satisfiability problem (SAT/UNSAT), CNF representation (clauses, literals), k-SAT complexity (2-SAT: polynomial; 3-SAT: NP-complete), DPLL algorithm (decide, deduce/BCP, diagnose, backtrack), and applications in VLSI formal verification alongside BDD techniques.

## Core concepts
**Satisfiability problem:**
- **Question:** Given Boolean function f(x₁,...,xₙ), ∃ assignment making f=1?
- **SAT instance:** ∃ assignment → f=1 (function satisfiable)
- **UNSAT instance:** ∄ assignment → f=1 (function unsatisfiable)
- Example SAT: `f=x₁x₂+x₁x₃+x₂'x₃` (e.g., x₁=1, x₂=1 → f=1)
- Example UNSAT: `g=(x₁+x₂)(x₁'+x₂')(x₁'+x₂)(x₁+x₃)(x₁+x₃')` (all 8 assignments → g=0)

**CNF (Conjunctive Normal Form):**
- **Structure:** AND of clauses; clause = OR of literals
- **Formula:** f = (x₁+x₂)(x₁'+x₃)(x₂'+x₃') — 3 clauses ANDed
- **Why CNF:** f=0 if any clause=0 (SAT solver exploits this for conflict detection)
- **Circuit→CNF:** Linear-time transformation (combinational circuit → CNF input for SAT solver)

**k-SAT problem:**
- **Definition:** Max k literals per clause
- **2-SAT:** Polynomial-time solvable (easy)
- **3-SAT:** NP-complete (hard; no known polynomial worst-case algorithm)
- **k≥3:** NP-complete
- Example: `(x₁+x₂)(x₁'+x₃')` → 2-SAT; `(x₁+x₂+x₃)(x₁'+x₂')` → 3-SAT

**SAT solver mechanics:**
- Brute force: 2ⁿ assignments (infeasible for n>50)
- **Systematic search:** Heuristically assign variables → deduce implications → backtrack on conflicts → prune search space

**DPLL algorithm (Davis-Putnam-Logemann-Loveland):**
- **DECIDE:** Heuristically assign value to unassigned variable
- **DEDUCE (Boolean Constraint Propagation/BCP):** Iteratively propagate implications from unit clauses
  - **Unit clause:** All literals=0 except 1 → forced assignment (implication)
  - Example: `x₁=1` in `(x₁+x₂)(x₁'+x₃)` → clause 1 satisfied; clause 2 becomes unit (x₃ forced to 1)
- **DIAGNOSE:** Detect conflicts (all literals in clause=0); identify backtrack variable
- **BACKTRACK:** Toggle earlier decision if conflict; return UNSAT if no backtracking possible
- **Loop:** Repeat until all variables assigned (SAT) or conflict with no backtrack (UNSAT)

**Implications and conflicts:**
- **Implication:** Unit clause forces variable assignment (e.g., `(x₁'+x₃)` with x₁=1 → x₃=1)
- **Conflict:** All literals in clause=0 (e.g., `(x₂'+x₃')` with x₂=1, x₃=1 → conflict)
- **Example:** `(x₁+x₂)(x₁'+x₃)(x₂'+x₃)` — assign x₁=1 → x₃=1 (implication) → x₂=0 (implication) → SAT

## Methods/flows
1. **SAT solving:** Represent f in CNF → apply DPLL (decide → deduce/BCP → diagnose conflicts → backtrack) → return SAT (+ satisfying assignment) or UNSAT
2. **Boolean Constraint Propagation (BCP):** Assign variable → identify unit clauses → force assignments → repeat until no more unit clauses or conflict
3. **Backtracking:** Conflict detected → diagnose which decision caused conflict → toggle variable → retry

## Constraints/assumptions
- SAT solver input: CNF representation (combinational circuits transformed to CNF in linear time)
- 3-SAT NP-complete: No polynomial worst-case algorithm (heuristics work well for practical VLSI problems)
- Modern SAT solvers exploit: Preprocessing, efficient data structures (watched literals), conflict-driven learning, random restarts, multi-core parallelism

## Examples
- **SAT instance:** `f=x₁x₂+x₁x₃+x₂'x₃` → 4 satisfying assignments (e.g., x₁=1, x₂=1, x₃=0)
- **UNSAT instance:** `g=(x₁+x₂)(x₁'+x₂')(x₁'+x₂)(x₁+x₃)(x₁+x₃')` → truth table: all rows → g=0
- **CNF example:** `(x₁+x₂)(x₁'+x₃)(x₂'+x₃')` — 3 clauses; 2-SAT (max 2 literals/clause)
- **Implication chain:** Assign x₁=1 in `(x₁+x₂)(x₁'+x₃)(x₂'+x₃)` → clause 2 unit (x₃=1) → clause 3 unit (x₂=0) → SAT
- **Conflict:** Assign x₁=1 in `(x₁+x₂)(x₁'+x₃)(x₁'+x₂')` → x₃=1 implied → clause 3: x₁'=0, x₂'=? (conflict if x₂=1)

## Tools/commands
- **Modern SAT solvers:** MiniSat, Z3, Glucose, CryptoMiniSat, Lingeling
- **Applications:** Formal verification (model checking, equivalence checking), test generation, logic synthesis

## Common pitfalls
- Confusing SAT (satisfiable) with valid (tautology; always true)
- Assuming 2-SAT hard (it's polynomial-time solvable; 3-SAT is NP-complete)
- Forgetting BCP (Boolean Constraint Propagation essential for efficiency)
- Over-relying on brute force (2ⁿ infeasible; SAT solver prunes search space via implications/backtracking)

## Key takeaways
- SAT problem: ∃ variable assignment making f=1? (SAT if yes, UNSAT if no)
- CNF representation: AND of clauses (OR of literals); SAT solver input format
- k-SAT complexity: 2-SAT polynomial; 3-SAT NP-complete (hard)
- DPLL algorithm: Decide variable → deduce implications (BCP) → detect conflicts → backtrack
- BCP (Boolean Constraint Propagation): Unit clauses force assignments; chain implications until conflict or no more units
- Conflict: All literals in clause=0 → backtrack (toggle earlier decision)
- Modern SAT solvers: Efficient heuristics (conflict-driven learning, watched literals, random restarts) solve practical VLSI problems despite NP-completeness
- Applications: Formal verification (model checking, CEC), test generation, logic synthesis

**Cross-links:** See Lec21: BDDs (alternative formal verification technique); Lec24: model checking (bounded model checking uses SAT); Lec25: equivalence checking (SAT-based CEC); Lec08: verification overview

---

*This summary condenses Lec23 from ~10,000 tokens, removing redundant SAT/UNSAT examples, repeated DPLL pseudocode explanations, and verbose implication chain walkthroughs.*
