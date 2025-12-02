# Lec24 — Formal Verification Part III: Model Checking

## Overview
Covers model checking framework (verify properties on FSM models), SystemVerilog Assertions (SVA) for temporal logic specifications, BDD-based symbolic state traversal (image/preimage computation, reachability analysis, characteristics functions), and SAT-based bounded model checking (BMC) for bug hunting.

## Core concepts
**Model checking framework:**
- **Inputs:** (1) Design (RTL/netlist) modeled as FSM; (2) Properties (temporal logic specifications)
- **Output:** Proof (property holds) or counter-example (property violated)
- **Challenge:** State explosion (n flip-flops → 2ⁿ states; must verify property across all reachable states)

**Temporal logic and SVA:**
- **Temporal logic:** Logic + time-related operators (whenever, eventually, always, never)
- **SystemVerilog Assertions (SVA):** Embedded in RTL; checked during simulation and formal verification
  - Keywords: `assert` (property), `assume` (axiom/constraint), `restrict` (input constraints)
- Example properties: "Whenever correct password entered, door opens eventually"; "Traffic light always has one of red/yellow/green on"

**Characteristics function:**
- **Definition:** Boolean function representing set of states; f(x)=1 iff x ∈ S
- **Example:** FSM with 5 states (s0-s4), 3 state bits (x₂, x₁, x₀); subset A={s0, s2, s4} → CF_A = x₂'x₁'x₀' + x₂'x₁x₀' + x₂x₁'x₀'
- **BDD representation:** Compact (polynomial for many sets despite exponential # states)

**Transition relation:**
- **Definition:** T(x, i, x')=1 iff transition from state x with input i to next state x'
- **Example:** 2-state FSM (sA=0, sB=1), 2 inputs (A=0, B=1) → T(0,0,0)=1 (sA →[A] sA), T(0,1,1)=1 (sA →[B] sB)
- **BDD representation:** Compact transition relation enables efficient image/preimage computation

**Image and preimage:**
- **Image(S, T):** Set of states reachable in 1 step from S
  - S' = Image(S, T) (next states from current states S)
- **Preimage(S', T):** Set of states from which S' reachable in 1 step
  - S = Preimage(S', T) (previous states leading to S')
- **Efficient computation:** BDD-based (symbolic set operations; no explicit state enumeration)

**Reachability analysis:**
- **Goal:** Compute all states reachable from initial state S₀
- **Algorithm:** S_reach={S₀}; S_new=S₀; while S_new≠∅: S_k=Image(S_new, T); S_new=S_k \ S_reach; S_reach=S_reach ∪ S_new
- **Fixed point:** Terminates when no new states discovered (FSM finite → guaranteed termination)

**BDD-based model checking:**
- **Property P:** Boolean function of state bits; set S_P of states where P holds → CF_SP = P
- **Approach:** Compute S_reach' = Preimage*(S_P, T) (all states from which S_P reachable)
  - If S₀ ∈ S_reach' → property holds
  - If S₀ ∉ S_reach' → property fails
- **Limitation:** BDD blow-up (exponential size for some functions/variable orders)

**Bounded Model Checking (BMC):**
- **Approach:** SAT-based; find counter-example of length n (n clock cycles from initial state)
- **Formulation:** Construct Boolean function Φₙ (CNF) = initial_state ∧ transitions(0→1→...→n) ∧ ¬property
  - Φₙ satisfiable ⇔ counter-example of length n exists
- **Iteration:** n=1, 2, 3,... until counter-example found or SAT solver cannot handle complexity
- **Advantages:** Avoids BDD memory blow-up; linear growth in variables (vs exponential in BDD)
- **Limitations:** Incomplete (only verifies up to n cycles; cannot prove property holds for all n)
- **Application:** Bug hunting (quickly find violations without exhaustive proof)

## Methods/flows
1. **BDD model checking:** FSM → build transition relation T (BDD) → compute reachable states (image iteration) → compute preimage*(property P) → check if initial state included
2. **Reachability:** S_reach={S₀}; iterate Image(S_new) until fixed point (no new states)
3. **BMC:** Unfold FSM n cycles → construct Φₙ (initial ∧ transitions ∧ ¬property) → invoke SAT solver → if SAT: counter-example found; if UNSAT: no violation up to n cycles

## Constraints/assumptions
- BDD model checking: BDD size can explode (exponential for some functions; try different variable orders or simplify problem via constraints/assumptions)
- BMC: Incomplete (only up to n cycles); SAT complexity grows (may become unsolvable for large n)
- Property specification: Require temporal logic (SVA) for time-related constraints
- FSM modeling: Design represented as FSM with known initial state

## Examples
- **Characteristics function:** 5 states {s0, s1, s2, s3, s4}, 3 bits; subset {s0, s2, s4} → CF = x₂'x₁'x₀' + x₂'x₁x₀' + x₂x₁'x₀'
- **Transition relation:** FSM (sA→[A]sA, sA→[B]sB, sB→[A]sB, sB→[B]sA) → T(0,0,0)=1, T(0,1,1)=1, T(1,0,1)=1, T(1,1,0)=1
- **Reachability:** S₀={s0} → Image(S₀)={s0, s1} → Image({s1})={s2} → S_reach={s0, s1, s2}
- **Property check:** P holds at states {s2, s3}; Preimage*({s2, s3})={s0, s1, s2, s3}; if S₀=s0 → property holds
- **BMC:** Property: "door locked if password wrong"; n=5 cycles → Φ₅ satisfiable → counter-example: wrong password at cycle 3, door opened at cycle 5

## Tools/commands
- **BDD packages:** CUDD, BuDDy (used in BDD-based model checkers)
- **SAT solvers:** MiniSat, Z3 (used in BMC)
- **Model checkers:** Cadence JasperGold, Synopsys VC Formal, OneSpin (commercial); NuSMV, ABC (academic/open-source)
- **SVA syntax:** `assert property (@(posedge clk) (req |-> ##[1:5] ack));` (req → ack within 1-5 cycles)

## Common pitfalls
- Confusing image (forward: S→S') with preimage (backward: S'→S)
- Assuming BDD always compact (multipliers, poor variable order → exponential)
- Over-relying on BMC for proof (incomplete; only verifies up to n cycles)
- Ignoring constraints/assumptions in SVA (help reduce search space; improve BDD/SAT efficiency)
- Forgetting fixed-point check in reachability (infinite loop if not detected)

## Key takeaways
- Model checking: Verify temporal properties on FSM (formal, covers all inputs)
- SVA (SystemVerilog Assertions): Temporal logic embedded in RTL (checked during simulation + formal verification)
- Characteristics function: Boolean function representing set of states (compact BDD representation)
- Transition relation: Boolean function T(x, i, x') (1 if transition exists); enables image/preimage computation
- Image/preimage: Symbolic set operations (1-step forward/backward state traversal; efficient in BDD)
- Reachability: Iterate image until fixed point (all states reachable from S₀)
- BDD model checking: Compute Preimage*(property) → check if S₀ included (complete but may face BDD blow-up)
- BMC (Bounded Model Checking): SAT-based; find counter-example within n cycles (incomplete but avoids BDD blow-up; good for bug hunting)
- BDD limitation: Memory blow-up (try variable reordering, add constraints/assumptions)
- BMC limitation: Incomplete (only up to n cycles; SAT complexity grows exponentially)

**Cross-links:** See Lec21: BDDs (ROBDD, variable order); Lec23: SAT solvers (DPLL, CNF); Lec25: equivalence checking (CEC); Lec20: FSM (state minimization, encoding)

---

*This summary condenses Lec24 from ~14,000 tokens, removing repeated image/preimage examples, redundant reachability pseudocode walkthroughs, and verbose BMC Φₙ construction details.*
