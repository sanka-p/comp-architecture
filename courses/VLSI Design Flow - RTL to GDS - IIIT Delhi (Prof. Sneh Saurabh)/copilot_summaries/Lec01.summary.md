# Lec01 — Basic Concepts of Integrated Circuit: I

## Overview
- Historical context of ICs and why “copying” enables low cost mass production.
- Structure of ICs: layered devices and interconnects; motivation for multiple metal layers.
- Photolithography: how mask patterns are transferred to wafers to replicate designs.
- Terminology: ingot, wafer, die, chip; yield and packaging.
- Design vs fabrication: roles, foundries, PDKs, and industry business models.

## Core concepts
- Copying principle: mass manufacturing uses masks and photolithography to reproduce identical patterns across many dies.
- Integration evolution: SSI → LSI → VLSI; transistor scaling improves speed, energy efficiency, and cost per transistor.
- IC structure:
  - Bottom: devices (transistors, diodes) formed using diffusion/implants.
  - Above: multiple metal layers for interconnect; vias connect metal layers.
  - Layered routing enables non‑shorting connections in limited area.
- Photolithography pipeline:
  - Mask (transparent plate with opaque chromium patterns) defines geometry.
  - Coat photoresist → expose through mask → develop → etch deposited film → strip resist.
- Manufacturing units:
  - Silicon ingot → sliced wafers (typically 300 mm) → many dies per wafer → test → package → chip.
  - Yield = percentage of defect‑free dies; critical for profitability.
- Design vs fabrication:
  - Design chooses circuit parameters; ends with layout/masks.
  - Fabrication replicates physical chips; runs in foundries (expensive, cleanrooms, equipment).
- Ecosystem:
  - Fabless (design only): e.g., Qualcomm, NVIDIA.
  - Merchant foundries (fab only): e.g., TSMC, UMC, GlobalFoundries.
  - IDMs (both): e.g., Intel, Samsung.
- PDK (Process Design Kit): models, design rules, and constraints provided by foundry to designers to ensure manufacturable, high‑yield layouts.

## Methods/flows
- Mask creation from layout; photolithography repeated per wafer/layer to manufacture many dies.
- Packaging after wafer test produces marketable chips.
- Design adheres to foundry rules (PDK) to achieve target yield.

## Constraints/assumptions
- Routing in one plane may be infeasible; multi‑layer metals are required to avoid shorts.
- Foundries must run near full utilization due to enormous capex and limited shelf life.
- Yield depends on process control; adherence to design rules improves it.

## Examples
- CMOS inverter realized with layered devices and metals.
- Routing puzzle showing need for multiple layers to avoid shorts.

## Tools/commands
- Not applicable here; focus is on manufacturing processes and artifacts (mask, photoresist, etchant).

## Common pitfalls
- Confusing wafer, die, chip, ingot.
- Ignoring foundry design rules → poor yield.
- Assuming single‑layer routing suffices in dense designs.

## Key takeaways
- Photolithography and masks enable cheap copying of complex ICs at scale.
- ICs are layered: devices below, many metal layers above, connected by vias.
- Transistor scaling drives PPA improvements and lower cost per transistor, but design complexity rises.
- Yield is central to economics; design rules and PDKs align design with fabrication capabilities.
- Industry models: fabless, foundry, IDM; collaboration via PDK ensures consistency.
- Packaging turns tested dies into chips.
- Multi‑layer routing is essential to realize dense, non‑shorting interconnects.
- Design chooses parameters; fabrication replicates—distinct roles that must exchange data.

[Figure: IC layered cross‑section (summary)]
- Shows devices at substrate, stacked metals M1/M2… with vias.
- Highlights vertical layering to enable crossing connections without shorts.

Cross‑links: See Lec02: IC types and design styles; See Lec03: Design flow overview; See Lec28: STA basics; See Lec40: Physical design intro.
