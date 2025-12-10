## OpenROAD Practical: Placement

This TCL snippet runs global and detailed placement with legalization and optional timing-driven parameters.

```tcl
# Prerequisites
read_lef tech.lef stdcell.lef
read_def floorplan.def

# Set target density (utilization)
set_place_density 0.6

# Global placement
global_placement -skip_io -routability_driven

# Legalization (ensure rows/sites alignment)
place_detail

# Optional: improve timing by buffering/move critical cells
optimize_mets -hold -setup

# Check placement metrics
report_placement

# Save placed DEF
write_def placed.def
```

Notes:
- Use `-routability_driven` to reduce congestion; tune density for timing/congestion tradeoffs.

## 2. Placement

**Placement** determines the location of standard cells in the design within the rows defined during chip planning.

### Placement Characteristics

- **Highly automated** (unlike macro placement which allows manual intervention)
- Handles millions of standard cells
- Manual tweaking possible only for specific violations

### Placement Objectives

#### 2.1 Wirelength Minimization
- **Most important objective**
- Place connected cells close together
- Challenge: wires not yet routed, must rely on estimates
- Independent cells can be placed farther apart

#### 2.2 Timing Optimization
- Minimize delays on critical paths
- Techniques:
  - Place critical path cells close together
  - Reduce wire delay
  - Minimize capacitance to be driven by gates

#### 2.3 Congestion Avoidance
- Poor placement can create overcrowded regions
- Leads to timing and routability problems later


# Placement

> **Chapter Overview:** Placement positions standard cells to make routing feasible and timing achievable. This chapter covers objectives, stages (global, legalization, detailed), HPWL estimation, analytical placement, timing-driven methods, scan chain reordering, and spare cells.

**Prerequisites:** [[15-Chip-Planning-and-Floorplanning]]  
**Related Topics:** [[17-Clock-Tree-Synthesis]], [[18-Routing]]

---

## 1. Objectives

- Routability first (routing is hardest); minimize wire length (primary proxy)
- Secondary: timing (critical nets), congestion, test routing

---

## 2. Stages (Lec49)

1. Global placement (overlaps OK; spread cells, optimize cost)
2. Legalization (snap to rows/sites; remove overlaps; minimal perturbation)
3. Detailed placement (small swaps/moves to refine wire length/timing)

---

## 3. Wire Length Estimation (HPWL)

- HPWL = (x_max − x_min) + (y_max − y_min) for each net’s bounding box; fast and effective

---

## 4. Analytical Placement

- Treat cells as points; minimize quadratic wire length + density penalty
- Solve with math optimizers; then legalize to rows

---

## 5. Timing-Driven Placement

- Weight critical nets (WNS/TNS) higher; bring critical cells closer
- Incremental timing to evaluate small moves

---

## 6. Scan Chain Reordering

- Reorder scan chains based on placement to reduce wire length and congestion
- Regenerate ATPG patterns for new chain order

---

## 7. Spare Cells

- Pre-place spare gates to enable top-metal ECO fixes post-fab; mark "don’t touch"

---

## 8. Key Takeaways

1. Good placement enables routing and timing; wire length minimization is a strong proxy.
2. Use timing-driven weights for critical nets; keep detailed changes incremental.
3. Reorder scan chains post-placement; keep spare cells for ECOs.

---

## Tools

- Innovus `place_design`, ICC2 `place_opt`, OpenROAD `global_placement` + `detailed_placement`
- RePlAce (OpenROAD) for analytical global placement

---

## Common Pitfalls

- Skipping legalization; allowing overlaps into routing
- Large disruptive detailed moves degrading solution
- Not reordering scans; excessive scan wiring and test time

---

## Further Reading

- [[17-Clock-Tree-Synthesis]]: CTS after placement
- [[18-Routing]]: Post-CTS routing and SI fixes
