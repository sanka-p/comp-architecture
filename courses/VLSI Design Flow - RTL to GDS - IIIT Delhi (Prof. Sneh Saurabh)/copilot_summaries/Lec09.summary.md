# Lec09 — Overview of VLSI Design Flow: VI (Fabrication)

## Overview
- Layout → masks → wafer fabrication → test → package → final chip.
- Mask creation, resolution enhancement techniques (OPC, multi-patterning), wafer fab, packaging.

## Core concepts
- Mask fabrication:
  - Data prep: fracture complex polygons → rectangles/trapezoids; add RET (Resolution Enhancement Techniques).
  - Mask writing: laser/e-beam expose photoresist on glass/quartz blank → develop → etch chromium → strip resist.
  - QA: inspect, repair defects with laser; add pellicle (protective cover).
- Resolution enhancement (RET):
  - Optical Proximity Correction (OPC): add serifs, hammerheads, mouse bites to mask to compensate diffraction; final feature on wafer matches intent.
  - Double/multi-patterning: decompose closely spaced features into separate masks/exposures ("color assignment"); each exposure has lower density → higher resolution.
- Wafer fabrication:
  - Hundreds of process steps (photolithography, oxidation, diffusion, ion implantation, etching).
  - Front-end-of-line (FEOL): devices (transistors, diodes).
  - Back-end-of-line (BEOL): interconnects (multiple metal layers).
- Testing: wafer probe → slice dies → discard defective → proceed good dies to packaging.
- Packaging:
  - Encapsulate die in protective case; provide pins; enable heat dissipation; prevent mechanical/corrosion damage.
  - Types: Dual In-Line Package (DIP), Ball Grid Array (BGA), others.
  - Impact on signal delay, thermal management.
- Final test, burn-in, binning:
  - Final test: ensure packaging didn't introduce errors.
  - Burn-in: high voltage/temp to catch latent defects (infant mortality).
  - Binning: classify chips by performance; assign price tiers.

## Methods/flows
- Layout → fracture/RET → mask write → inspect/repair → pellicle → mask ready.
- Wafer fab (layer-by-layer photolithography) → test → slice → package → final test → burn-in → binning → ship.

## Constraints/assumptions
- Feature size < wavelength (193 nm) → diffraction/distortion; RET compensates.
- Closely spaced features need multi-patterning → extra masks, complexity, cost.
- Packaging must balance electrical, thermal, mechanical requirements.

## Examples
- OPC: add hammerheads to L-shape mask to correct corner rounding/line-end pullback.
- Double-patterning: split layout into red/blue masks; lower density per mask → better resolution.

## Tools/commands
- Mask prep: fracturing tools, OPC engines.
- Mask write: laser/e-beam writers.
- Inspection: automated optical/e-beam.

## Common pitfalls
- Skipping OPC → distorted features on wafer.
- Inadequate thermal design → chip overheating.
- Poor packaging pin design → signal integrity issues.

## Key takeaways
- Mask must compensate for optical effects (OPC) and density (multi-patterning).
- Wafer fab is sequential, hundreds of steps, layer-by-layer.
- Packaging is critical for signal integrity, thermal management, protection.
- Final test/burn-in/binning ensure quality and optimal pricing.
- Chip = tested, packaged die ready for market.

[Figure: Mask + RET (summary)]
- Shows layout → OPC mask (with serifs) → wafer feature (corrected shape).
- Double-patterning: layout → red mask, blue mask → combined exposure.

Cross‑links: See Lec01: Photolithography basics; See Lec08: Testing; See Lec40: Physical design (floorplan/packaging considerations); See Lec44: Yield modeling.
