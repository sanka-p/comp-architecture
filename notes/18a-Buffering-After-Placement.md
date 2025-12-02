# Buffering After Placement (ISPD26)

Post-detailed placement repeater insertion to fix ERC (slew/cap/fanout) and improve TNS, respecting legality and congestion.

## Goals

- Improve setup TNS with minimal dynamic/leakage increase.
- Eliminate ERC violations.
- Keep placement legal under PDN/blockages and minimize displacement.

## Theory

- Elmore delay and slew reset: buffers partition RC ladders; reset slew, reduce upstream C_eff.
- Fanout splitting: partition sinks (clustering) and drive each cluster with a repeater.
- Net decomposition: build Steiner-like trees pragmatically (FLUTE for guidance; use HPWL heuristics for speed).

## Heuristics

- Net ordering: prioritize by slack (critical first), HPWL, sink count, ERC severity.
- Candidate sites: scan nearest legal sites (row-based), avoiding blockages/PDN and high-overflow tiles.
- Cost function: w_tns*ΔTNS − w_dpower*Δdyn − w_lpower*Δleak − penalties(overflow, displacement).

## Pin/driver specifics

- Driver pin lists in changelist must match updated DEF/Verilog.
- Preserve net names; inserted repeaters get unique names per OpenROAD convention.

## Micro workflow

1) Identify violating nets (slew/cap/fanout) and critical nets.
2) Propose buffer count/locations (spacing from Elmore, legal site search window).
3) Update net topology: insert repeater instances, reconnect loads.
4) Legalize: ensure on-site placement, orientation, blockage compliance.
5) Re-run timing and ERC; iterate with capped passes.

## Checklist

- insert_repeater <x,y> entries with driver pin and load pins.
- DEF segments updated; .v net connections consistent; unique instance/net names.
- Global routing overflow stays under thresholds.

## Worked example: buffer count and spacing

- Given a net with length L = 1000µm on M3 (R=0.08Ω/µm, C=0.2fF/µm), driver resistance Rdrv=500Ω.
	- Distributed RC: Rwire ≈ 80Ω, Cwire ≈ 200fF. Elmore delay (no buffer) ~ Rdrv*(Cwire+Cl) + Rwire*(Cwire/2 + Cl).
	- Target stage effort f≈e; choose n buffers to partition wire into n+1 segments with similar RC.
	- Try n=2: segments ~333µm each: per segment R≈26.6Ω, C≈66.6fF, buffers reset slew. Verify output slews < max_slew and TNS improves.

## Congestion-aware placement heuristic

- Build a coarse grid over the core; mark tiles with overflow > threshold as forbidden.
- When selecting buffer sites, prioritize nearest legal sites not in forbidden tiles; add penalty for tiles near macros/PDN blockages.
- Determinism & runtime: use fixed seeds for clustering/order; cap iterations and net count per pass; early-stop when ΔTNS plateau.
