# Lec20 — Logic Optimization Part III: Sequential Logic Optimization (FSM)

## Overview
Covers sequential logic optimization via Finite State Machines (FSMs): FSM models (Moore vs Mealy), state diagrams, implementation (flip-flops + combinational logic), state minimization (reduce flip-flops via equivalent state merging), and state encoding (choose binary representations to optimize combinational logic).

## Core concepts
**Finite State Machine (FSM):**
- **Components:** Finite non-empty sets of states, inputs, outputs; initial state; state transition function (current state + input → next state); output function
- **Moore machine:** Output = f(current state only)
- **Mealy machine:** Output = f(current state, current input)
- **Representation:** State diagram (directed graph; vertices=states, edges=transitions labeled with input/output)

**FSM implementation:**
- **Structure:** Flip-flops (store current state Q) + combinational logic CL (compute next state D and outputs)
- **State encoding:** Assign binary codes to states (e.g., s0=00, s1=01, s2=11)
  - Minimum bits: ⌈log₂(num_states)⌉ (e.g., 3 states → 2 bits)
- **Optimization targets:** (1) Flip-flops (state minimization), (2) Combinational logic CL (state encoding)

**State minimization:**
- **Goal:** Reduce number of states → reduce flip-flop count (area savings)
- **Equivalent states:** Two states s1, s2 are equivalent if:
  1. Identical outputs for same inputs
  2. Corresponding next states are same or equivalent
- **Approach:** Find equivalent states → merge (keep one, remove others, update transitions)
- **Algorithms:** Polynomial-time algorithms exist (e.g., Hopcroft's algorithm, partition refinement)

**State encoding:**
- **Goal:** Choose binary codes for states to minimize combinational logic CL (next state function, output function)
- **Encoding length:** Minimum ⌈log₂(num_states)⌉ bits; can use longer (e.g., one-hot: 1 bit per state)
- **One-hot encoding:** Reserve 1 bit per state (e.g., s0=001, s1=010, s2=100)
  - Advantage: Simpler state identification (check 1 bit vs multiple bits); fewer logic levels (faster)
  - Disadvantage: More flip-flops (area overhead)
- **Trade-offs:** Encoding affects CL complexity (area, timing); longer encodings may simplify CL despite more flip-flops

**State encoding optimization:**
- **Challenge:** Exponential possibilities (e.g., 50 states, 50 bits → vast search space)
- **Approach:** Maximize common cube/sub-expression sharing in CL
  - Define "gain" metric (quantifies sharing potential)
  - Heuristic algorithms maximize gain (approximate solution)
- **Sequential before combinational:** FSM optimization precedes combinational logic optimization (encoding chosen before CL implemented)

## Methods/flows
1. **State minimization:** Identify equivalent states (check output parity, next-state equivalence) → merge equivalent states → update transitions
2. **State encoding:** Choose encoding length (minimum or one-hot) → assign binary codes → evaluate CL complexity (gain metric) → iterate to maximize sharing
3. **Implementation:** Flip-flops store state bits (Q) → CL computes next state (D=f(Q, inputs)) and outputs → clock edge updates state (Q←D)

## Constraints/assumptions
- State minimization: Polynomial-time algorithms exist; always beneficial (reduces flip-flops without functionality loss)
- State encoding: No universally optimal encoding; heuristics approximate best (tool-dependent defaults)
- Moore vs Mealy: Moore outputs stable (depend only on state); Mealy outputs faster (react to inputs immediately) but may glitch
- One-hot encoding: Good for high-speed designs (fewer levels); bad for area-constrained designs (more flip-flops)

## Examples
- **Fan regulator FSM (Moore):**
  - States: s0, s1, s2, s3 (4 settings)
  - Inputs: rotate_clockwise, rotate_anticlockwise
  - Outputs: speed0, speed1, speed2, speed3 (one per state)
  - Transitions: CW: s0→s1→s2→s3→s0; ACW: s0→s3→s2→s1→s0
  - Encoding: Minimal (2 bits): s0=00, s1=01, s2=11, s3=10; One-hot (4 bits): s0=0001, s1=0010, s2=0100, s3=1000

- **Equivalent states:**
  - States sA, sC: Both produce same outputs (A→1, B→0); both transition to same/equivalent next states (A→sC, B→sB for both) → merge sA and sC

- **State encoding impact:**
  - 3 states (s0, s1, s2): Minimal (2 bits): s0=00, s1=01, s2=11 → CL may require complex logic
  - One-hot (3 bits): s0=001, s1=010, s2=100 → CL simpler (identify state via 1 bit) but 3 flip-flops vs 2

## Tools/commands
- **FSM synthesis tools:** Synopsys Design Compiler, Cadence Genus (integrated FSM optimization)
- **State minimization:** Hopcroft's algorithm, partition refinement
- **State encoding:** NOVA, JEDI (research tools); heuristics in commercial tools

## Common pitfalls
- Forgetting to check next-state equivalence (states with same outputs but different next states ≠ equivalent)
- Assuming minimal encoding always best (one-hot may reduce CL area/delay despite more flip-flops)
- Over-minimization: Merging non-equivalent states → functional errors (always verify equivalence formally)
- Ignoring timing: One-hot faster (fewer levels) but minimal encoding uses fewer flip-flops (balance speed vs area)

## Key takeaways
- FSM = states + inputs/outputs + transitions + initial state; Moore (output=f(state)) vs Mealy (output=f(state, input))
- Implementation: Flip-flops (state storage) + combinational logic CL (next state, output functions)
- State minimization: Find equivalent states → merge → reduce flip-flop count (polynomial-time algorithms)
- State encoding: Assign binary codes to states; minimum ⌈log₂(num_states)⌉ bits or longer (one-hot)
  - Minimal encoding: Fewer flip-flops, complex CL
  - One-hot encoding: More flip-flops, simpler/faster CL
- Encoding optimization: Maximize common cube sharing in CL (heuristic gain metrics; NP-hard problem)
- Sequential optimization precedes combinational (encoding chosen before CL synthesis)

**Cross-links:** See Lec17-19: combinational logic optimization (two-level, multi-level); Lec15: RTL synthesis (always blocks → flip-flops/combinational logic); Lec21: formal verification (equivalence checking post-optimization)

---

*This summary condenses Lec20 from ~10,000 tokens, removing redundant FSM diagram explanations, repetitive state equivalence checks, and verbose encoding trade-off discussions.*
