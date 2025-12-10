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

> **Chapter Overview:** After routing, the layout must be extracted and verified before tape-out. This chapter covers verification throughout the design flow, functional verification methods (simulation and formal methods), circuit/parasitic extraction, DRC/ERC/LVS, signoff timing and integrity checks, and ECO flows for late fixes.

**Prerequisites:** [[18-Routing]], [[06-Formal-Verification]]  
**Related Topics:** [[21-EDA-Tools-and-Tutorials]]

---

## Overview: Verification in VLSI Design Flow (Lec08)

**Verification** ensures the design works as per specified functionality throughout the design transformation process (idea → RTL → netlist → layout → GDS).

### Why Verification is Critical

- **Error sources:** Human error, miscommunication between teams, tool misuse, tool bugs
- **Multiple verification points:** Required whenever design undergoes non-trivial changes
- **Early bug detection:** Catching errors early reduces fix cost and effort
- **Increasing effort:** Verification effort grows with design complexity and features
- **Current state:** Verification consumes significant portion of design cycle

### Verification Methodology

- **Verify early, verify often:** Check design after each major transformation
- **Incremental approach:** Catch and fix problems immediately
- **Reduced cost:** Early fixes require less time and effort than late-stage corrections

---

## 1. Functional Verification Methods (Lec08)

### 1.1 Simulation-Based Verification

**Definition:** Technique for ensuring functional correctness using test vectors (sequences of 0s/1s with timing information).

#### Simulation Framework

```
Test Vectors → RTL Model → Simulator → Output Response
                ↓
Test Vectors → Specification (C/C++/MATLAB) → Expected Response
                ↓
            Compare Responses → Pass/Fail
```

**Process:**
1. Apply test vectors to RTL model through simulator
2. Compute expected output from specification model
3. Compare actual vs. expected responses
4. Pass if responses match; fail otherwise

#### Advantages

- **Fast:** Similar speed to running executables
- **Versatile:** Works at multiple abstraction levels
  - RTL level
  - Gate-level netlist
  - Transistor level
- **Simple:** Similar to running and testing computer programs

#### Limitations

- **Incomplete coverage:** Cannot apply all possible test vectors
- **Exponential inputs:** Number of test vectors exponential in number of inputs
- **State space explosion:** Sequential elements (flip-flops) create massive state space
- **Non-exhaustive:** Test only anticipated corner cases and vulnerable regions
- **Selected coverage:** Focus on:
  - Corner cases
  - Areas prone to bugs
  - Computation-intensive code sections
  - Brittle/vulnerable areas

### 1.2 Model Checking (Formal Methods)

**Definition:** Functional verification using formal mathematical methods to establish proof of properties.

#### Key Differences from Simulation

| Aspect | Simulation | Model Checking |
|--------|-----------|----------------|
| Method | Test vectors | Mathematical proof |
| Coverage | Selected inputs | All possible inputs |
| Proof | Shows bugs exist | Proves correctness or finds counter-example |
| Completeness | Incomplete | Complete (when proof succeeds) |

#### Formal Method Characteristics

- **Mathematical reasoning:** Establishes formal proofs using logical inference
- **No test vectors needed:** Implicit coverage of all input combinations
- **Property-based:** Proves specific properties hold for all cases
- **Resource intensive:** Requires more computation and memory than simulation

#### When to Use Each Method

**Simulation:**
- Initial design validation
- Quick bug finding
- Large designs where formal methods don't scale
- General functional testing

**Model Checking:**
- Critical properties that must be proven
- Safety-critical designs
- Properties that are hard to verify with simulation
- Equivalence checking between design transformations

---

## 2. Extraction (Lec53)

### 2.1 Circuit Extraction

- Inputs: merged GDS + LVS/ERC rule deck
- Output: layout netlist (SPICE) and ERC report
- Rule deck encodes device recognition (poly ∩ diffusion → transistor), technology-specific

### 2.2 Parasitic Extraction

- Extract R/C/L from layout; output SPEF
- Resistance: sheet R × L/W per segment
- Capacitance: fringe/lateral/overlap via pre-characterization + pattern matching

---

## 3. Physical Verification (Lec53)

- DRC: min width/spacing/area, via enclosure, antenna rules
- ERC: electrical issues (shorts, opens, floating)
- LVS: layout netlist vs source netlist must match

---

## 4. Signoff Checks

- STA with accurate parasitics (PrimeTime/Tempus)
- Signal integrity (coupling, noise), power integrity (IR drop), electromigration (EM)
- Separate signoff tools (higher accuracy than implementation timers)

---

## 5. ECO (Engineering Change Order)

- Functional ECO: logic change via re-synthesis or spare cells
- Timing ECO: upsize/downsize, buffer, reroute, wire widen
- Verify with formal and STA; minimize blast radius

---

## 6. Flow Summary

1. Merge GDS → circuit extraction (SPICE) + ERC
2. Parasitic extraction → SPEF
3. DRC/ERC/LVS → fix violations
4. Signoff STA/SI/IR/EM → fix via ECO
5. All clean → tape-out (send GDS to foundry)

---

## 7. Key Takeaways

1. Verification must be performed throughout design flow to catch errors early.
2. Simulation is fast and versatile but incomplete; formal methods provide mathematical proofs.
3. Extraction translates polygons into devices/nets and parasitics for accurate verification.
4. DRC/LVS are mandatory; ERC catches electrical issues early.
5. Signoff STA uses SPEF; SI/IR/EM checks ensure robust operation.
6. ECO enables late, targeted fixes with verification safeguards.

---

## Tools

- Simulation: ModelSim, VCS, Xcelium
- Formal Verification: JasperGold, VC Formal
- Extraction/Verification: Calibre (DRC/LVS/xRC), StarRC, Quantus QRC
- Signoff STA: PrimeTime, Tempus
- ECO: Conformal ECO, Formality ECO

---

## Common Pitfalls

- Skipping verification after design changes
- Relying solely on simulation without formal verification for critical paths
- Using implementation timers for signoff
- Skipping re-extraction after layout edits (parasitics change)
- ECO without formal/STA verification

---

## Further Reading

- [[06-Formal-Verification]]: Detailed formal methods (BDD, SAT, model checking)
- [[18-Routing]]: Parasitics accurate post-route
- [[21-EDA-Tools-and-Tutorials]]: Commands and report workflows
