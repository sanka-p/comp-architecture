## OpenROAD Practical: Physical Verification & Timing Signoff

Run timing with Liberty, SDC, and SPEF; export reports. DRC/LVS are typically done in external tools, but routing DRC can be checked if supported.

```tcl
# Load design and libraries
read_lef tech.lef stdcell.lef
read_def routed.def
read_liberty fast.lib slow.lib
read_sdc constraints.sdc

# Load parasitics (if extracted)
read_spef routed.spef

# Update timing and report
set_propagated_clock [all_clocks]
report_checks -path_delay min_max -fields {slew cap input_pins nets} -digits 3 > timing_report.txt
report_power > power_report.txt

# Optional: write SDF for back-annotation
write_sdf timing_postroute.sdf

# Basic DRC report (depends on rule deck availability)
report_drc > drc_report.txt

# Save final outputs
write_def signoff.def
```

Notes:
- Use appropriate corners (fast/slow libs) and multi-corner/multi-mode as needed.
- For full DRC/LVS, use foundry-qualified tools (e.g., Calibre/ICV) with corresponding rule decks.
# Physical Verification and Signoff

> **Chapter Overview:** After routing, the layout must be extracted and verified before tape-out. This chapter covers circuit/parasitic extraction, DRC/ERC/LVS, signoff timing and integrity checks, and ECO flows for late fixes.

**Prerequisites:** [[18-Routing]]  
**Related Topics:** [[21-EDA-Tools-and-Tutorials]]

---

## 1. Extraction (Lec53)

### 1.1 Circuit Extraction

- Inputs: merged GDS + LVS/ERC rule deck
- Output: layout netlist (SPICE) and ERC report
- Rule deck encodes device recognition (poly ∩ diffusion → transistor), technology-specific

### 1.2 Parasitic Extraction

- Extract R/C/L from layout; output SPEF
- Resistance: sheet R × L/W per segment
- Capacitance: fringe/lateral/overlap via pre-characterization + pattern matching

---

## 2. Physical Verification (Lec53)

- DRC: min width/spacing/area, via enclosure, antenna rules
- ERC: electrical issues (shorts, opens, floating)
- LVS: layout netlist vs source netlist must match

---

## 3. Signoff Checks

- STA with accurate parasitics (PrimeTime/Tempus)
- Signal integrity (coupling, noise), power integrity (IR drop), electromigration (EM)
- Separate signoff tools (higher accuracy than implementation timers)

---

## 4. ECO (Engineering Change Order)

- Functional ECO: logic change via re-synthesis or spare cells
- Timing ECO: upsize/downsize, buffer, reroute, wire widen
- Verify with formal and STA; minimize blast radius

---

## 5. Flow Summary

1. Merge GDS → circuit extraction (SPICE) + ERC
2. Parasitic extraction → SPEF
3. DRC/ERC/LVS → fix violations
4. Signoff STA/SI/IR/EM → fix via ECO
5. All clean → tape-out (send GDS to foundry)

---

## 6. Key Takeaways

1. Extraction translates polygons into devices/nets and parasitics for accurate verification.
2. DRC/LVS are mandatory; ERC catches electrical issues early.
3. Signoff STA uses SPEF; SI/IR/EM checks ensure robust operation.
4. ECO enables late, targeted fixes with verification safeguards.

---

## Tools

- Extraction/Verification: Calibre (DRC/LVS/xRC), StarRC, Quantus QRC
- Signoff STA: PrimeTime, Tempus
- ECO: Conformal ECO, Formality ECO

---

## Common Pitfalls

- Using implementation timers for signoff
- Skipping re-extraction after layout edits (parasitics change)
- ECO without formal/STA verification

---

## Further Reading

- [[18-Routing]]: Parasitics accurate post-route
- [[21-EDA-Tools-and-Tutorials]]: Commands and report workflows
