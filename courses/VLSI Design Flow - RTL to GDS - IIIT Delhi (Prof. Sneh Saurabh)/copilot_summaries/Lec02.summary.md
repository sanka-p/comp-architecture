# Lec02 — Basic Concepts of Integrated Circuit: II

## Overview
- IC types by application scope: ASIC vs general‑purpose.
- Design styles: full‑custom, standard‑cell, gate‑array, FPGA.
- Economics: fixed vs variable costs; break‑even for FPGA vs ASIC.
- Figures of merit: PPA plus testability, reliability, schedule.

## Core concepts
- Types:
  - ASIC: specific function; low programmability; lower volume.
  - General‑purpose: CPUs, memories, FPGAs; high programmability; higher volume.
- Design styles and customization level:
  - Full‑custom: transistor/layout level; highest effort; best PPA.
  - Standard‑cell: use pre‑designed cells/macros; automate placement/routing; strong PPA.
  - Gate‑array: devices fixed; customize top metal; limited functionality density.
  - FPGA: hardware fixed; program interconnects/logic; lowest effort; easy bug fix.
- Economics:
  - Fixed costs: design effort, EDA tools, HW, masks (per layer).
  - Variable: wafers, chemicals, die area, yield.
  - Break‑even: small volume → FPGA cheaper; large volume → ASIC (std‑cell) cheaper.
- PPA trade‑offs: improving one metric may worsen others (e.g., speed vs area/power).
- Additional metrics: testability (DFT), reliability (aging margins), schedule (time‑to‑market).

## Methods/flows
- Choose design style based on volume, PPA targets, schedule, risk.
- Standard‑cell flow uses characterized libraries; masks for device + interconnect are design‑specific.
- Gate‑array flow customizes only upper metals; FPGA uses vendor tools and bitstreams.

## Constraints/assumptions
- High fixed cost and mask count for ASIC; plan for sufficient volume.
- FPGA area/yield typically worse due to unused fabric; faster iteration.
- Trade‑offs are unavoidable; seek acceptable, not mathematical optimum.

## Examples
- Standard‑cell rows with identical cell heights; macros for multipliers/memories.
- Cost vs units curve with break‑even between FPGA and ASIC.

## Tools/commands
- EDA tooling for ASIC (synthesis, P&R, STA); FPGA vendor tools (Xilinx/AMD, Intel/Altera).

## Common pitfalls
- Choosing ASIC when volume is too low → poor ROI.
- Ignoring testability/reliability → quality issues despite good PPA.
- Over‑optimizing one metric at the expense of others.

## Key takeaways
- Application scope and volume steer the choice: ASIC vs general‑purpose.
- Design styles span effort vs quality spectrum: full‑custom → FPGA.
- Costs split into fixed vs variable; area and yield dominate variable cost.
- PPA trades are inherent; quote and track PPA consistently.
- Include testability, reliability, schedule in success criteria.

[Figure: Design styles spectrum (summary)]
- Axis from customization/effort to automation; shows PPA vs effort trends.

Cross‑links: See Lec03: Flow overview; See Lec31: DFT basics; See Lec28: STA; See Lec41: Power optimization; See Lec40: Physical design.
