## OpenROAD Practical: Chip Planning & Floorplanning

Use the following TCL in OpenROAD to set up die/core, IOs, tapcells, and power grid.

```tcl
# Libraries and design
read_lef tech.lef stdcell.lef io.lef
read_verilog design.v
link_design top

# Floorplan: die/core size and utilization
initialize_floorplan -die_area "0 0 3000 3000" -core_area "200 200 2800 2800" -site core -utilization 0.6

# IO pin placement (example)
place_pins -hor_layers {metal2} -ver_layers {metal3} -random -exclude -corner_keepout 20

# Add well taps and endcaps
tapcell -distance 14 -tapcell_master TAPCELL_X1 -endcap_master ENDCAP_X1

# Power Distribution Network (PDN)
define_pdn_grid -name core_grid -voltage_domains {core}
add_pdn_stripe -grid core_grid -layer metal5 -width 2.0 -pitch 40 -offset 10
add_pdn_stripe -grid core_grid -layer metal6 -width 2.0 -pitch 40 -offset 10 -followpins
add_pdn_connect -grid core_grid -layers {metal5 metal6}
pdngen

# Save floorplan
write_def floorplan.def
```

Notes:
- Replace LEF/Verilog file names and masters with your PDK/library.
- Adjust utilization, site, and PDN parameters per technology.
# Chip Planning and Floorplanning

> **Chapter Overview:** Plan the chip before placement: partition hierarchically, budget timing, choose die size/utilization, place IOs and macros, and set up rows. Good planning makes downstream stages easier.

**Prerequisites:** [[14-Physical-Design-Basics]]  
**Related Topics:** [[16-Placement]], [[17-Clock-Tree-Synthesis]]

---

## 1. Hierarchical Design (Lec47)

- Partition: functional groups + min-cut to reduce inter-block nets
- Budget: push timing (SDC) and physical/DFT constraints into blocks
- Implement blocks; assemble with abstract models (ETM/ILM focusing on interface paths)

---

## 2. Floorplanning Basics (Lec47)

### 2.1 Die Size and Utilization

- Core area from cell + macro + halo; target 60–80% utilization (leave 20–40% for routing)
- Smaller die improves yield and cost; package constraints also matter

### 2.2 IO Cells and Power Pads

- IO types: input, output, bidirectional; functions: drive, level shift, ESD
- Place IOs with heuristics: group jointly-driven inputs, spread power-hungry IOs, keep sensitive signals away from noisy IOs
- Separate IO vs core supplies; size power pads per current draw

### 2.3 Rows and Macros

- Define standard cell rows; macro placement and halos covered next

---

## 3. Practical Tips

- Avoid over/under-partitioning; re-budgeting is expensive
- Reserve top-level timing budget for inter-block routing
- Keep utilization < 100% to avoid congestion

---

## 4. Key Takeaways

1. Hierarchical flow reduces complexity and improves QoR.
2. Smart IO and die planning prevents routing and SI headaches.
3. Abstract timing models simplify top-level closure.

---

## Tools

- Partitioning: hMetis, Innovus/ICC2 hierarchical flows
- Floorplan: Innovus `floorPlan`, ICC2 `initialize_floorplan`, OpenROAD

---

## Common Pitfalls

- Ignoring DFT constraints during budgeting
- Random IO placement causing hotspots and crosstalk
- 100% utilization—no room for routing

---

## Further Reading

- [[16-Placement]]: Standard cell placement
- [[17-Clock-Tree-Synthesis]]: Skew/latency targets, buffering
