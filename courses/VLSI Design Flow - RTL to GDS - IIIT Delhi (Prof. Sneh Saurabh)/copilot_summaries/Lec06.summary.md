# Lec06 — Overview of VLSI Design Flow: III (Logic Synthesis)

## Overview
- RTL to GDS flow splits into logic synthesis (RTL → netlist) and physical design (netlist → layout).
- Logic synthesis transforms RTL (Verilog/VHDL) into gate-level netlist using standard cells from library.
- Major challenge: optimization (PPA) while maintaining functional equivalence.

## Core concepts
- Logic synthesis framework:
  - Inputs: RTL, library (.lib), constraints (SDC).
  - Output: netlist (gate-level interconnections; functionally equivalent to RTL).
- Netlist terminology:
  - Design: top-level entity (top module).
  - Ports: PI (primary inputs), PO (primary outputs).
  - Cells: library entities (AND, NOT, DFF); instances: cells placed in design with unique names.
  - Pins: interfaces of cells/instances; named as `instance/pin`.
  - Nets: wires connecting instances/ports; port-connected nets often share port name.
- Synthesis pipeline:
  - RTL synthesis: translate RTL constructs → generic gates (no transistor detail); parsing, elaboration, arithmetic optimizations.
  - Logic optimization: minimize area/gates at generic level; Boolean minimization (Karnaugh-like, scaled).
  - Technology mapping: map generic gates → standard cells; multiple drive strengths per function; huge solution space.
  - Technology-dependent optimization: refine PPA using accurate cell models.
- Generic vs standard cells:
  - Generic: well-defined Boolean function; no transistor-level details; cannot estimate delay/power accurately.
  - Standard: characterized cells in library; transistor-level known; enables PPA estimation.

## Methods/flows
- Translation: Verilog/VHDL → gates → optimize → map to library cells → optimize timing/power/area.
- Constraints guide optimization: relaxed timing → favor area; tight timing → favor speed.

## Constraints/assumptions
- Functional equivalence must hold between RTL and netlist.
- Library must provide cells for all needed functions; multiple drive strengths enable flexibility.
- Optimization is incomplete (no global optimum guarantee); seek acceptable solution.

## Examples
- RTL snippet (mux + DFF) → schematic (MUX, DFF) → Verilog netlist instantiating cells from library.

## Tools/commands
- Synthesis tools: Synopsys Design Compiler, Cadence Genus.
- Liberty (.lib) format for cell characterization; SDC for constraints.

## Common pitfalls
- Mismatched library/constraints → suboptimal mapping.
- Overlooking technology mapping complexity → poor PPA.
- Ignoring standard cell drive strength options → timing violations.

## Key takeaways
- Logic synthesis bridges RTL (behavior) and netlist (structure).
- Generic gates enable early optimization; standard cells enable accurate PPA.
- Technology mapping is the critical optimization step with large search space.
- Constraints drive synthesis trade-offs among area, timing, power.
- Netlist terminology (design, port, cell, instance, pin, net) is foundational for tool usage.

[Figure: Synthesis flow (summary)]
- Shows RTL → generic gates → logic opt → tech mapping → tech-dependent opt → netlist.

Cross‑links: See Lec07: Physical design; See Lec28: STA basics; See Lec08: Verification (CEC); See Lec22: Technology mapping detail; See Lec41: Power optimization.
