## OpenROAD Practical: Routing

Perform global and detailed routing, fix antenna, and write outputs.

```tcl
# Prerequisites: after CTS
read_lef tech.lef stdcell.lef
read_def cts.def

# Global routing (build guides)
global_route

# Detailed routing
route -verbose

# Antenna repair (if PDK provides diodes)
repair_antennas -lib_cell ANTENNA_DIODE_X1 -ratio 1.0

# Check DRC violations (requires rules support)
report_drc

# Save routed DEF and SPEF (if available)
write_def routed.def
write_sdf timing.sdf
write_spef routed.spef
```

Notes:
- `repair_antennas` requires diode cells defined in your library.
- SPEF extraction depends on tech RC data availability.
# Routing

> **Chapter Overview:** Routing connects the placed cells per the netlist under design rules, timing, and signal integrity constraints. This chapter covers global vs detailed routing, grid/track models, capacity/overflow/congestion, and post-routing optimizations including timing, SI, antenna, via redundancy, and CMP fills.

**Prerequisites:** [[16-Placement]], [[17-Clock-Tree-Synthesis]]  
**Related Topics:** [[19-Physical-Verification-and-Signoff]], [[21-EDA-Tools-and-Tutorials]]

---

## 1. Workflow (Lec52)

- Global routing (plan guides on a coarse grid)
- Detailed routing (exact wires on tracks)
- Post-routing optimization (timing/power/SI/antenna/EM)

---

## 2. Global Routing

- Divide area into global bins; build a grid graph with preferred directions and vias.
- Capacity vs use → overflow; congestion = use/capacity.
- Aim for overflow=0; detours acceptable for routability.

---

## 3. Detailed Routing

- Tracks with routing pitch (line-on-via typical); over-the-cell routing in upper layers.
- Honor connectivity and DRCs while meeting timing/SI.

---

## 4. Post-Routing Optimizations

- Timing: extract SPEF → STA; upsize, buffer, reroute, wire widen.
- Power: downsize non-critical, remove buffers, prefer HVT.
- SI: increase spacing, upsize victim, downsize aggressor.
- Antenna: layer jumps, jumpers, diodes.
- Via redundancy: on-track/off-track extra vias for reliability.
- CMP fills: dummy metal in sparse regions → re-extract, re-run STA.

---

## 5. Tutorial Highlights (Lec54)

- Pin access layers, congestion iterations, route guides.
- Multi-threaded detailed routing; filler cells for continuous wells.
- Parasitic extraction and SPEF write; final reports (slacks, TNS, skew, power).

---

## 6. Key Takeaways

1. Routing is the hardest PD step; plan globally to help detailed routing succeed.
2. Capacity/overflow model drives congestion-aware planning.
3. Accurate timing requires post-route extraction and signoff STA.

---

## Tools

- Global: Innovus `globalRoute`, ICC2 `route_auto -global`, OpenROAD `global_route`
- Detailed: Innovus `routeDesign`, ICC2 `route_auto`, OpenROAD `detailed_route`
- Extraction: StarRC, Calibre xRC, `write_spef`

---

## Common Pitfalls

- Large bins hiding congestion until detailed routing
- Aggressive pitch causing via DRCs; conservative pitch wasting tracks
- Skipping SPEF-based STA after routing

---

## Further Reading

- [[19-Physical-Verification-and-Signoff]]: DRC/LVS, extraction, STA signoff
- [[16-Placement]]: Routability-aware placement
- [[17-Clock-Tree-Synthesis]]: Clock routing constraints
