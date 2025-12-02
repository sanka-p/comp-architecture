# Lec34 — Technology Mapping

## Overview
Converts optimized netlist (generic logic gates) → netlist (technology library cells). Covers inputs (libraries, unmapped netlist, constraints), objectives (minimize area/delay/power), functional equivalence requirement, mapping solutions (multiple PPA trade-offs), and approaches (structural vs Boolean matching).

## Core concepts
**Technology mapping inputs:**
1. **Technology libraries:** Standard cells (AND, OR, NAND, inverter, FF, latch); multiple sizes (1x, 2x, 4x for same function); multiple flavors (low VT: fast, high power; high VT: slow, low power)
2. **Unmapped netlist:** Generic logic gates (functionality defined, but no transistor implementation → area/delay/power unknown)
3. **Constraints:** SDC file (clock frequency, I/O delays) → guides mapping decisions (critical paths use fast cells; non-critical use small cells)
4. **Objectives:** Minimize area (area-constrained delay) OR minimize delay (delay-constrained area) OR minimize power (based on synthesis effort level)

**Functional equivalence:**
- **Requirement:** Unmapped netlist ≡ mapped netlist (same I/O behavior for all input sequences)
- **Verification:** Formal equivalence checking (CEC) or simulation

**Mapping solutions:**
- **Multiple valid mappings:** Same function, different PPA (area/delay/power trade-offs)
- **Example:** Y = (A·B + C)' (NAND-NAND vs NAND-AND vs NAND_LP-NAND_LP)
  - **Solution 1:** NAND1 (A·B→) + NAND1 (·C'→) + INV + INV → Area=10, Delay=20, Power=50
  - **Solution 2:** NAND1 (A·B→) + AND1 (·C'→) + INV → Area=13, Delay=17, Power=55
  - **Solution 3:** NAND1_LP + NAND1_LP + INV + INV → Area=12, Delay=32, Power=22
- **Trade-offs:** Solution 1 (min area), Solution 2 (min delay), Solution 3 (min power)

**Library variety:**
- **Same function, different sizes:** Inverter (1x, 2x, 4x) → larger = faster (lower delay), higher area/power
- **Same function, different VT:** AND_LVT (low VT: fast, high power), AND_HVT (high VT: slow, low power)

**Mapping approaches:**
1. **Structural mapping:**
   - **Method:** Represent unmapped netlist + library cells in base functions (e.g., NAND + inverter)
   - **Matching:** Structurally compare netlist portions with library cells → find min-cost cover
   - **Limitation:** Same Boolean function can have many structural representations (e.g., 4-input AND = tree of 2-input ANDs) → misses some matches
2. **Boolean mapping:**
   - **Method:** Functional equivalence check (e.g., BDD comparison) for netlist portions vs library cells
   - **Advantage:** Canonical representation (BDDs) → catches all matches (regardless of structure)
   - **Preferred:** Modern synthesis tools (more accurate than structural)

## Methods/flows
1. **Load inputs:** Libraries (.lib files), unmapped netlist (generic gates), constraints (SDC)
2. **Partition netlist:** Divide into small portions (cones of logic)
3. **Match portions:** For each portion, find library cells with equivalent functionality (structural or Boolean matching)
4. **Select mapping:** Among valid matches, choose cell based on objective (min area, min delay, min power)
5. **Generate mapped netlist:** Replace generic gates with selected library cells
6. **Verify:** Check functional equivalence (unmapped ≡ mapped)

## Constraints/assumptions
- **Functional equivalence mandatory:** Mapping must preserve I/O behavior
- **PPA trade-offs:** Minimizing one metric (delay) often increases another (area, power)
- **Library completeness:** Richer library (more cells, sizes, VT options) → more mapping choices → better PPA
- **Objective from effort:** High timing effort → minimize delay; low area effort → minimize area
- **No change in functionality:** Mapping does NOT alter Boolean function (only cell implementation)

## Examples
**Unmapped netlist:** Y = (A·B + C)' (generic AND + NOR gates; area/delay/power unknown)
**Library cells:** INV1 (area=1, delay=4, power=5), NAND1 (area=4, delay=8, power=20), NAND1_LP (area=5, delay=12, power=6), AND1 (area=8, delay=9, power=30)

**Solution 1 (NAND-NAND-INV):** ((A·B)' · C')' = (A·B + C)' (De Morgan's law)
- **Cells:** NAND1 (A·B→) + NAND1 (·C'→) + INV + INV
- **PPA:** Area=10 (min), Delay=20, Power=50

**Solution 2 (NAND-AND-INV):** ((A·B)' · C')' = (A·B + C)' (De Morgan's law)
- **Cells:** NAND1 (A·B→) + AND1 (·C'→) + INV
- **PPA:** Area=13, Delay=17 (min), Power=55

**Solution 3 (NAND_LP-NAND_LP-INV):** Same logic, low-power cells
- **Cells:** NAND1_LP + NAND1_LP + INV + INV
- **PPA:** Area=12, Delay=32, Power=22 (min)

**Trade-off summary:**
| Solution | Area | Delay | Power | Optimized for |
|----------|------|-------|-------|---------------|
| 1 (NAND-NAND) | 10 (min) | 20 | 50 | Area |
| 2 (NAND-AND) | 13 | 17 (min) | 55 | Delay |
| 3 (NAND_LP-NAND_LP) | 12 | 32 | 22 (min) | Power |

## Tools/commands
- **Synthesis tools:** Synopsys Design Compiler, Cadence Genus, Yosys (open-source)
- **Mapping commands (Yosys):** `techmap` (map to generic cells), `abc -liberty <lib>` (map to technology library)
- **Verification:** Synopsys Formality, Cadence Conformal (CEC for functional equivalence)

## Common pitfalls
- Assuming single "best" mapping (PPA trade-offs → objective-dependent)
- Ignoring library variety (using only 1x cells → suboptimal timing; only 4x → excessive area)
- Not verifying functional equivalence (mapping errors → functional failures)
- Over-constraining (all paths critical → uses only large cells → area explosion)
- Structural matching only (misses valid mappings due to structural variation)

## Key takeaways
- Technology mapping: Generic logic gates → technology library cells (standard cells: AND, OR, FF, etc.)
- Inputs: (1) Technology libraries (cells of different sizes, VT); (2) Unmapped netlist (generic gates); (3) Constraints (SDC); (4) Objectives (min area/delay/power)
- Functional equivalence: Mapped netlist ≡ unmapped netlist (mandatory; verified via CEC)
- Multiple solutions: Same function, different PPA (e.g., NAND-NAND: min area; NAND-AND: min delay; NAND_LP: min power)
- PPA trade-offs: Min delay → large cells (high area/power); Min area → small cells (high delay); Min power → high VT cells (high delay)
- Library variety: Multiple sizes (1x, 2x, 4x) for same function → more mapping choices → better PPA
- Structural mapping: Match netlist structure with library cells (base functions: NAND+INV) → fast, may miss matches
- Boolean mapping: Match Boolean functions (BDD comparison) → catches all matches (preferred in modern tools)
- Objective-driven: High timing effort → minimize delay (use large cells on critical paths); Low area effort → minimize area (use small cells)
- Generic gates → library cells: Generic gates have no PPA attributes; library cells have area/delay/power from .lib

**Cross-links:** See Lec06: Synthesis overview (RTL→generic gates→library cells); Lec13: Logic optimization (before mapping); Lec26: Technology library (.lib: cell area/delay/power); Lec35: Timing-driven optimization (after mapping); Lec32-33: Constraints (guide mapping decisions)

---

*This summary condenses Lec34 from ~7,500 tokens, removing repeated PPA table displays, redundant functional equivalence derivations (De Morgan's law), and verbose mapping solution walkthroughs.*
