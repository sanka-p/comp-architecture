# Lec03 — Overview of VLSI Design Flow: I

## Overview
- Three milestones: Idea → RTL → GDS → Chip.
- Abstraction: fewer details early enable faster exploration; details add accuracy later.
- Pre‑RTL methodologies: system‑level design, hardware‑software partitioning.

## Core concepts
- Divide‑and‑conquer design flow:
  - Idea to RTL (system level): specify functionality, partition HW/SW.
  - RTL to GDS: logical + physical design to create layout.
  - GDS to Chip: masks, fabrication, test, package.
- Abstraction vs optimization/turnaround:
  - High abstraction → broad exploration, fast iteration, coarse QoR estimates.
  - Low abstraction → accurate QoR, fewer options, slower iteration.
- RTL structure:
  - Data path (ALUs, regs, muxes) for computation.
  - Control path (FSM) generates control signals, sequences operations.
- HW/SW partitioning goal: exploit HW speed/efficiency and SW flexibility/low risk.

## Methods/flows
- Partitioning example flow:
  - Start with all functions in SW; set performance target P.
  - Profile to find bottlenecks; iteratively move top N functions to HW.
  - Re‑evaluate performance; stop when P met or no improvement.
- Verification approaches when HW isn’t built:
  - Co‑simulation with timing models.
  - Quick proto on FPGA or rough HLS‑based implementation to estimate performance.

## Constraints/assumptions
- Communication overhead and data dependencies can erase expected HW speedups.
- Performance estimates of non‑existent HW require proxies (FPGA/HLS) and are approximate.
- Integration requires bus/NoC and memory considerations.

## Examples
- Video compression: offload DCT (hot spot) to HW; keep frame handling in SW.
- Logic vs layout abstraction example showing turnaround vs accuracy trade‑off.

## Tools/commands
- Profilers (software), co‑simulation frameworks, HLS tools for quick HW estimates.

## Common pitfalls
- Ignoring HW/SW communication latency → overestimated gains.
- Moving too many functions to HW increases cost/complexity without meeting targets.
- Weak verification between HW and SW components.

## Key takeaways
- Structure the flow into Idea→RTL→GDS→Chip; manage abstraction intentionally.
- Use profiling to drive HW/SW partitioning; offload true bottlenecks.
- Verify early with co‑simulation or FPGA protos to de‑risk assumptions.
- Control/data paths define RTL; concurrency and sequencing must be modeled.

[Figure: Flow overview (summary)]
- Pipeline from Idea→RTL→GDS→Chip; abstraction decreases left→right.

Cross‑links: See Lec04: RTL creation paths; See Lec32: Verification overview; See Lec28: STA basics; See Lec40: Physical design intro.
