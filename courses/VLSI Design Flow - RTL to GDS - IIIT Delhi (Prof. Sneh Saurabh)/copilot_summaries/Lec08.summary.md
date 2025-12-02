# Lec08 — Overview of VLSI Design Flow: V (Verification and Testing)

## Overview
- Verification: ensure design works per spec (during design).
- Testing: detect manufacturing defects (post-fabrication).
- Both are essential; verification catches design bugs; testing catches fabrication faults.

## Core concepts
- Verification methods:
  - Simulation: apply test vectors to RTL/netlist/transistor; compare outputs to spec; fast, versatile, incomplete (cannot cover all inputs).
  - Model checking (formal): prove properties mathematically; complete but computationally hard; best for critical properties (e.g., mutual exclusion, eventual grant).
  - Combinational Equivalence Checking (CEC): verify RTL ≡ netlist ≡ post-place/route using formal methods; run after each transformation.
- Static Timing Analysis (STA): verify synchronous timing; check setup/hold; pessimistic (safe); run throughout flow.
- Physical verification:
  - DRC (Design Rule Check): foundry rules for manufacturability.
  - ERC (Electrical Rule Check): connectivity (no shorts/opens).
  - LVS (Layout vs Schematic): ensure layout matches original function.
- Rule checking: RTL/constraint/netlist checkers flag synthesis/simulation/DFT issues; more restrictive than language allows.
- Manufacturing test:
  - Defects (physical imperfections) → faults (models like stuck-at).
  - Spot defects (random, area-dependent) are primary concern; distortions/inconsequential flaws ignored.
  - ATE (Automatic Test Equipment): apply test patterns, compare actual vs expected response.
  - Fault coverage: % faults detected; target >99%.
  - Yield: fraction of defect-free dies; depends on area, defect density, clustering.
  - Defect level (DL): faulty chips escaping to customer; measured in ppm; <500 ppm for commercial.
  - Burn-in: high voltage/temperature to catch latent defects (infant mortality).
  - Binning: classify chips by performance; assign price tiers.

## Methods/flows
- Verify after each major transformation (RTL→netlist→layout); use CEC to chain equivalence.
- Test flow: wafer test (probe) → slice dies → package → final test → burn-in → binning → ship.

## Constraints/assumptions
- Simulation cannot be exhaustive; choose corner cases wisely.
- Formal methods may not scale to entire design; apply to critical blocks/properties.
- Yield model (Poisson-based): Y = (1 + Ad/α)^(−α); depends on area A, defect density d, clustering α.

## Examples
- Traffic controller property: "not more than one light green."
- Yield example: 90% yield, 50% fault coverage → DL = 5/95 million ≈ 52,600 ppm.

## Tools/commands
- Simulators: ModelSim, VCS, Xcelium.
- Formal: Cadence JasperGold, Synopsys VC Formal.
- STA: Synopsys PrimeTime, Cadence Tempus.
- DRC/LVS: Mentor Calibre, Synopsys IC Validator.
- ATE: Teradyne, Advantest.

## Common pitfalls
- Assuming simulation = complete verification; miss corner cases.
- Skipping CEC after tool changes → undetected functional bugs.
- Low fault coverage → high defect level → customer complaints.
- Ignoring DRC/LVS → yield loss/fab rejection.

## Key takeaways
- Verification is iterative throughout design; catch bugs early to reduce fix cost.
- Simulation is fast but incomplete; formal methods are complete but expensive.
- CEC ensures functional equivalence across transformations.
- STA is mandatory for timing closure; pessimistic but safe.
- Testing targets manufacturing defects; DFT features added during design.
- Yield depends on area, defect density, clustering; fault coverage drives defect level.
- Final test, burn-in, and binning ensure quality chips reach customers.

[Figure: Verification vs testing (summary)]
- Verification: design-time, spec correctness. Testing: post-fab, defect detection.

Cross‑links: See Lec06: Logic synthesis; See Lec07: Physical design; See Lec28: STA detail; See Lec31: DFT basics; See Lec32: Verification flows; See Lec33: Formal methods.
