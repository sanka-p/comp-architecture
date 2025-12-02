# Lec04 — Overview of VLSI Design Flow: II

## Overview
- Translating high‑level functional descriptions to RTL.
- Two major approaches: IP assembly (SoC methodology) and Behavior/High‑Level Synthesis (HLS).
- Integration challenges: metadata, configuration, interconnect (NoC), verification.

## Core concepts
- Implementation gap: High‑level (C/C++/SystemC/MATLAB) lacks timing; RTL adds cycle‑accurate sequencing.
- RTL anatomy: data path computes; control path (FSM) orchestrates; supports serial and parallel operations.
- SoC/IP reuse:
  - IPs are pre‑designed subsystems (CPU, memory, peripherals, verification IP).
  - Integration productivity via reuse; cost down; features up.
  - Packaging information (structure, interfaces, registers, configs) is critical.
- Metadata and generators:
  - Use IP‑XACT/SystemRDL/XML/spreadsheets to describe IPs, buses, ports, registers.
  - Generators emit SoC‑level RTL, verification env, and low‑level drivers from metadata.
- Interconnect evolution: ad‑hoc buses → structured Network‑on‑Chip (NoC) for scalability.
- HLS framework:
  - Inputs: untimed algorithm + constraints (resources, frequency, latency, power) + resource library.
  - Output: RTL meeting constraints; cost metrics include area, latency, max frequency, power, throughput.
- Timing concepts:
  - Synchronous paths from launch FF (Q) to capture FF (D) must meet Tp > dmax; fmax < 1/dmax.

## Methods/flows
- Behavior synthesis examples for Y = a + b + c:
  - RTL‑1: two adders, latency 1, dmax ≈ 2 adder delays.
  - RTL‑2: pipeline (insert FF), latency 2, dmax ≈ 1 adder, higher fmax.
  - RTL‑3: single shared adder with muxing, latency 2, lower area, dmax ≈ adder + mux.
- Tool chooses implementation per constraints (min area, min latency, max fmax).

## Constraints/assumptions
- Physical design unknown at HLS time → risk of congestion around shared resources.
- Machine‑generated RTL often less readable; small behavior edits can cause large RTL diffs.
- Need formal/rigorous checks to ensure algorithm ↔ RTL functional equivalence.

## Examples
- SoC assembly with CPU, accelerators, memories, peripherals via NoC.
- Metadata‑driven generation of RTL and verification environment.

## Tools/commands
- IP‑XACT/SystemRDL; vendor IP generators; HLS tools; STA for timing validation.

## Common pitfalls
- Inconsistent IP configurations (e.g., bus widths) causing integration errors.
- Underestimating verification space across modes/configs.
- Over‑sharing resources in HLS → routing/timing issues later.

## Key takeaways
- Bridging the implementation gap: reuse IPs or use HLS to produce cycle‑accurate RTL.
- Metadata + generators make SoC integration faster and less error‑prone.
- Choose HLS implementations via clear constraints; understand latency/throughput/area/fmax trade‑offs.
- Plan for verification early; machine‑generated RTL needs robust alignment checks.

[Figure: HLS trade‑offs (summary)]
- Compares area/latency/fmax across pipeline vs shared resources.

Cross‑links: See Lec03: Flow overview; See Lec28: STA basics; See Lec40: Physical design; See Lec32: Verification; See Lec41: Power.
