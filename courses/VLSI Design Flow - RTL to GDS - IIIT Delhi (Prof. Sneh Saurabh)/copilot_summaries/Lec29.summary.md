# Lec29 — Static Timing Analysis Part II: Timing Graph and Delay Calculation

## Overview
Covers timing graph structure (vertices=pins/ports, edges=timing arcs), delay calculation (stage-wise: driver model+interconnect model+receiver model), arrival time propagation (forward traversal, min/max bounds), required time propagation (backward traversal), slack computation (setup/hold), and efficiency (single-pass traversal).

## Core concepts
**Timing paths:**
- **Data paths:** Start at timing start points (input ports, FF clock pins) → combinational logic → end at timing end points (FF D pins, output ports)
- **Clock paths:** Start at clock source (specified in SDC) → buffers/inverters/clock gating → end at FF clock pins

**Timing start points:** Input ports, FF clock pins (Q pins)
**Timing end points (comparison points):** FF D pins, output ports
**Clock start point:** Clock source (specified in SDC create_clock)
**Clock end points:** FF clock pins (CP pins)

**Timing graph:**
- **Graph G=(V, E):** Vertices V=pins/ports; Edges E=timing arcs
- **Vertex types:** Source (no incoming edges: input ports, FF Q pins); Sink (no outgoing edges: output ports, FF D pins); Internal (both incoming/outgoing)
- **Edge types:**
  - **Cell arc:** Timing arc within same cell (e.g., A→Y in NAND gate; from .lib file)
  - **Net arc:** Timing arc between cells (via net: e.g., I1.Y → I2.A)
- **Annotations:** Each edge: delay D_ij (rise/fall, min/max), output slew; Each vertex: arrival time, required time, slack, slew

**Stage (for delay calculation):**
- **Components:** Driving cell + interconnect + driven pins (input pins modeled as capacitors)
- **Example:** Inverter I1 (driver) → net n → pins I2.A, I3.A (receivers, modeled as CL1, CL2)
- **Delay computation:** Requires driver model (.lib: NLDM/CCS), interconnect model (SPEF: RC parasitics), receiver model (input capacitance), input waveform (slew)

**Delay calculator:**
- **Inputs:** Driver model (.lib), interconnect model (SPEF), receiver model (input C), input slew
- **Outputs:** Delay (D_ij), output slew (for next stage)
- **Models:**
  - **Driver:** NLDM (2D tables: input slew, load → delay/slew) or CCS/ECS (current source models)
  - **Interconnect:** Lumped C, Elmore delay, AWE (Asymptotic Waveform Evaluation)
  - **Receiver:** Lumped capacitance (from .lib pin capacitance)
- **Topological order:** Compute stages sequentially (forward fan-out; need input slew before computing stage delay)

**Arrival time (A_j):**
- **Definition:** Time at which signal settles at vertex j
- **Single incoming edge:** A_j = A_i + D_ij
- **Multiple incoming edges (n edges from v_i to v_j):**
  - **Min bound:** A_j_min = min(A_i_min + D_ij_min) ∀i
  - **Max bound:** A_j_max = max(A_i_max + D_ij_max) ∀i
- **Initialization:** Input ports: A=0 (or specified in SDC)
- **Propagation:** Forward traversal (topological order: compute vertex only after all input vertices known)
- **One-pass:** Each vertex visited once → O(V+E) complexity
- **Storage:** 4 arrival times per vertex (rise_min, rise_max, fall_min, fall_max) + slew (rise/fall)

**Required time (R_j):**
- **Definition (setup):** Latest time signal can arrive without setup violation
- **Definition (hold):** Earliest time signal must arrive to avoid hold violation
- **Single outgoing edge:** R_i = R_j - D_ij
- **Multiple outgoing edges (n edges from v_i to v_j):**
  - **Setup (late):** R_i_setup = min(R_j_setup - D_ij) ∀j (most restrictive constraint)
  - **Hold (early):** R_i_hold = max(R_j_hold - D_ij) ∀j (least restrictive constraint)
- **Initialization:** Output ports/FF D pins: R from SDC or inferred from clock period
- **Propagation:** Backward traversal (topological order: compute vertex only after all output vertices known)
- **One-pass:** Each vertex visited once → O(V+E) complexity

**Slack:**
- **Setup slack:** Slack_setup = R_setup - A_max (positive → pass; negative → violation)
  - Time by which A_max can increase without violation
- **Hold slack:** Slack_hold = A_min - R_hold (positive → pass; negative → violation)
  - Time by which A_min can decrease without violation
- **Negative slack:** Timing violation (setup or hold)

## Methods/flows
1. **Build timing graph:** Create vertices (pins/ports) → create edges (cell arcs from .lib, net arcs from netlist)
2. **Delay calculation:** Decompose into stages → compute delay/slew per stage (driver+interconnect+receiver models, input slew) → annotate edges
3. **Arrival time:** Forward traversal (start from input ports, A=0) → compute A_j = max(A_i + D_ij) for all i → store bounds (min/max, rise/fall)
4. **Required time:** Backward traversal (start from output ports/FF D pins, R from SDC) → compute R_i = min(R_j - D_ij) for all j → store bounds (setup/hold)
5. **Slack:** For each vertex: Slack_setup = R_setup - A_max; Slack_hold = A_min - R_hold → report violations (slack < 0)

## Constraints/assumptions
- Delays depend on input slew → slew must be propagated alongside arrival time (see Lec30)
- Rise/fall delays different → separate timing arcs (4 arrival times per vertex)
- Delay calculator uses library models (not SPICE) → 100-1000x faster, small accuracy loss
- Topological order required (cannot compute vertex before predecessors/successors)
- Pessimistic bounds (max for setup, min for hold) ensure safety

## Examples
- **Timing graph:** Combinational circuit (IN1, IN2, IN3 → I2, I3, I4, I5, I6 → OUT1, OUT2)
  - **Vertices:** IN1, IN2, IN3, I2.A, I2.B, I2.Y, I3.A, I3.Z, I4.X, I4.Y, I4.Z, I5.A, I5.Y, I6.A, I6.Z, OUT1, OUT2
  - **Cell arcs:** I2.A→I2.Y, I2.B→I2.Y (NAND), I3.A→I3.Z (inverter), I4.X→I4.Z, I4.Y→I4.Z (AND)
  - **Net arcs:** IN1→I2.A, I2.Y→I4.X, I3.Z→I2.B, I3.Z→I4.Y
- **Arrival time:** IN1: A=0 → I2.A: A=0+1=1 → I2.Y: A=1+1=2 → I4.X: A=2+1=3 → I4.Z: A=max(3+1, 3+1)=4 → OUT1: A=4+1=5
- **Required time:** OUT1: R=12 → I4.Z: R=12-1=11 → I4.X: R=11-1=10, I4.Y: R=11-1=10 → I2.Y: R=10-1=9
- **Slack:** I4.Z: Slack = R - A = 11 - 4 = 7 (positive → pass)

## Tools/commands
- **STA tools:** Synopsys PrimeTime, Cadence Tempus, Siemens Questa STA
- **Delay calculators:** Built into STA tools (NLDM, CCS, ECS models)
- **Parasitics:** SPEF file (extracted from layout via Calibre xRC, StarRC)
- **Library:** .lib file (cell delays, input capacitance)

## Common pitfalls
- Forgetting to propagate slew (delay depends on input slew; cannot compute without it)
- Assuming single arrival time per vertex (need min/max, rise/fall → 4 values)
- Violating topological order (compute vertex before inputs known → incorrect arrival time)
- Confusing setup required time (min of successors) with hold required time (max of successors)
- Ignoring net arcs (only considering cell arcs → incomplete timing graph)

## Key takeaways
- Timing graph G=(V,E): Vertices=pins/ports; Edges=timing arcs (cell arcs+net arcs)
- Data paths: Input ports/FF Q pins → combinational logic → FF D pins/output ports
- Clock paths: Clock source → buffers/inverters → FF clock pins
- Stage: Driver cell + interconnect + driven pins → compute delay/slew (need driver/interconnect/receiver models + input slew)
- Delay calculator: Uses .lib (NLDM/CCS), SPEF (RC parasitics), input slew → outputs delay, output slew (for next stage)
- Arrival time: Time signal settles at vertex; forward traversal (A_j = max(A_i + D_ij)); bounds (min/max, rise/fall)
- Required time: Latest (setup) / earliest (hold) time signal can arrive; backward traversal (R_i = min(R_j - D_ij) for setup)
- Slack: Setup = R - A_max (positive → pass); Hold = A_min - R (positive → pass); negative → violation
- Efficiency: Single-pass traversal (O(V+E)); each vertex visited once
- Storage: 4 arrival times (rise_min, rise_max, fall_min, fall_max) + slew per vertex

**Cross-links:** See Lec28: setup/hold requirements; Lec30: slew propagation (GBA/PBA), OCV/MMMC; Lec26: .lib file (NLDM, cell delays); Lec31: SDC constraints

---

*This summary condenses Lec29 from ~18,000 tokens, removing repeated timing graph construction examples, redundant arrival/required time computation walkthroughs, and verbose stage-wise delay calculation diagrams.*
