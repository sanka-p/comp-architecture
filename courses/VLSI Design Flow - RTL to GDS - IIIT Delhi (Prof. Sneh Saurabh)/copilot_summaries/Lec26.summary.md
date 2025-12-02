# Lec26 — Technology Library

## Overview
Introduces technology libraries (.lib, Liberty format) and physical libraries (LEF), library creation vs usage, characterization process (SPICE simulation, PDK, abstract model extraction), NLDM delay/slew models, setup/hold time modeling, and motivations (cost distribution, abstraction level, reusability).

## Core concepts
**Technology library (.lib, Liberty format):**
- Contains cell functionality, timing (delays, slews), power, area, constraints (setup/hold)
- ASCII, human-readable format
- Initially for synthesis; evolved to support timing/power analysis, physical design, test

**Physical library (LEF, Library Exchange Format):**
- Contains abstract layout info (pin locations, cell dimensions), technology data (layers, resistance/capacitance per square)
- Used in physical design (covered in later lectures)

**Library creation vs usage:**
- **Creating:** Design cells at transistor level (NAND, AND, flip-flops), optimize layout (PPA), extract info → .lib
- **Using:** Instantiate cells from library (focus on connectivity, not cell internals)
- **Benefits:** Cost distributed over multiple designs (1 library → 100 chips); reduces design time/errors; raises abstraction (transistor→cell level)

**Library characterization:**
- Done by foundry or design house
- **Steps:** (1) Design cell optimally (layout, SPICE verify); (2) SPICE simulate (various stimuli, operating conditions, PDK); (3) Extract parameters (delay, slew, capacitance); (4) Build abstract model → write .lib

**PVT (Process, Voltage, Temperature):**
- Corners defined in library header (e.g., slow/fast/typical process, VDD min/typ/max, T= -40°C/25°C/125°C)
- Different libraries for different PVT corners (worst-case, best-case, typical)

**Timing arcs:**
- **Delay arc:** From start pin (related_pin) to end pin; models propagation delay
- **Constraint arc:** Setup/hold checks at D pin relative to clock pin

**Slew (transition time):**
- Quantifies signal steepness (0→1 or 1→0 transition)
- **Definition:** Time from LTP (lower threshold %, e.g., 10%) to UTP (upper threshold %, e.g., 90%)
  - **Rise slew:** Time for signal to rise from LTP to UTP (e.g., 10%→90%)
  - **Fall slew:** Time for signal to fall from UTP to LTP (e.g., 90%→10%)
- Thresholds: 10-90, 20-80, 30-70 (specified in library header)
- Alternate names: Transition time, rise time, fall time

**Delay (propagation delay):**
- Time elapsed from input crossing threshold to output crossing threshold
- **Rise delay:** Output rising (measured at output rise threshold, e.g., 50%)
- **Fall delay:** Output falling (measured at output fall threshold, e.g., 50%)
- **Thresholds:** IRTP (input rise threshold %), IFTP (input fall threshold %), ORTP (output rise threshold %), OFTP (output fall threshold %)
  - Example: IRTP=50%, ORTP=50% → delay = time(output@50%) - time(input@50%)

**NLDM (Non-Linear Delay Model):**
- Delay, output slew = f(input slew, output load capacitance)
- **2D lookup tables:** Discrete points (e.g., input slew: 10, 20, 30 ps; load: 1.2, 5.0, 15.0, 37.5 fF) → 3×4=12 entries
- **Interpolation:** Linear interpolation for intermediate values
- **Separate tables:** Rise delay, fall delay, rise slew, fall slew
- **Limitation:** Accuracy loss at advanced nodes (assumes purely capacitive load, linear slew) → use CCS/ECS

**CCS/ECS (Current Source Models):**
- More accurate than NLDM at advanced process nodes (account for resistive loads, non-linear effects, Miller coupling)
- **CCS:** Composite Current Source Model
- **ECS:** Effective Current Source Model

**Setup time (T_setup):**
- Minimum time data must be stable **before** clock edge (forbidden window before clock)
- Modeled as 2D table: f(data slew, clock slew)
- Example: constrained_pin (data), related_pin (clock) → rise_constraint table

**Hold time (T_hold):**
- Minimum time data must be stable **after** clock edge (forbidden window after clock)
- Modeled as 2D table: f(data slew, clock slew)
- Example: constrained_pin (data), related_pin (clock) → fall_constraint table (if data falling)

**Library variety and uniformity:**
- **Variety:** Multiple drive strengths (1x, 2x, 4x AND gates); different flavors (low power, high performance, high density, low/high VT)
- **Uniformity:** Fixed cell height (width varies); eases physical design (standard rows)

## Methods/flows
1. **Library characterization:** Design cell → SPICE simulate (PDK, stimuli, operating conditions) → extract delay/slew/capacitance → build NLDM/CCS tables → write .lib
2. **Delay/slew modeling:** For each cell arc, simulate at discrete (input slew, load capacitance) points → populate 2D tables → interpolate for intermediate values
3. **Setup/hold modeling:** For flip-flops, simulate at discrete (data slew, clock slew) points → populate constraint tables

## Constraints/assumptions
- NLDM assumes purely capacitive loads (RC effects, Miller coupling ignored) → inaccurate at advanced nodes
- Interpolation assumes smooth delay/slew functions (valid for most CMOS gates)
- Library models sacrifice SPICE accuracy for speed (100-1000x faster than SPICE)
- Robustness: Models should work across all instantiations (different environments)

## Examples
- **Timing arc:** `pin(Z) { timing() { related_pin: "A"; cell_rise(delay_table_3x4) { index_1: "10, 20, 30"; index_2: "1.2, 5.0, 15.0, 37.5"; values(...); } } }`
- **Setup time:** Flip-flop D pin: `rise_constraint(setup_table) { constrained_pin: "D"; related_pin: "CLK"; index_1: "10, 20, 30"; index_2: "5, 10, 15, 20"; values(...); }`
- **NLDM table:** 3 input slews × 4 loads = 12 delay values (e.g., slew=10ps, load=1.2fF → delay=0.05ns)

## Tools/commands
- **Characterization tools:** Liberate (Cadence), SiliconSmart (Synopsys), Variety (ANSYS)
- **SPICE simulators:** HSPICE, Spectre, Ngspice (use PDK models)
- **Format:** Liberty (.lib); extension formats: .db (compiled binary for faster tool access)

## Common pitfalls
- Confusing slew (transition steepness) with delay (propagation time)
- Using wrong thresholds (read library header for LTP/UTP, IRTP/ORTP definitions)
- Assuming NLDM accurate at 7nm/5nm (use CCS/ECS instead)
- Forgetting setup/hold depend on both data and clock slew (not just one)
- Over-constraining with too many library flavors (synthesis runtime increases)

## Key takeaways
- Technology library: Cell functionality, timing (NLDM/CCS), power, area, setup/hold (Liberty format, .lib)
- Physical library: Abstract layout, technology params (LEF format, .lef)
- Library creation: Transistor-level design → SPICE → extract → abstract model → .lib
- Library usage: Instantiate cells (focus on connectivity, not internals); cost/effort reduction
- Timing arc: Delay arc (input→output propagation); constraint arc (setup/hold checks)
- Slew: Transition steepness (LTP→UTP time, e.g., 10%→90%); rise slew, fall slew
- Delay: Propagation time (input threshold → output threshold); rise delay (output rising), fall delay (output falling)
- NLDM: 2D tables (input slew, output load) → delay/slew; interpolation for intermediate values; inaccurate at advanced nodes
- CCS/ECS: Current source models (more accurate at advanced nodes; account for RC, non-linear effects)
- Setup/hold: 2D tables (data slew, clock slew) → constraint values; separate tables for rise/fall constraints
- PVT corners: Process, Voltage, Temperature variations → different libraries (slow, fast, typical)
- Library variety: Multiple drive strengths, flavors (low power, high perf, low/high VT)
- Library uniformity: Fixed cell height (eases physical design)

**Cross-links:** See Lec28-30: STA (uses library models for delay/slack computation); Lec06: synthesis (technology mapping to .lib cells); Lec07: physical design (uses LEF); Lec15-16: RTL synthesis (maps to generic gates, then .lib cells)

---

*This summary condenses Lec26 from ~12,000 tokens, removing repeated NLDM table examples, verbose slew threshold definitions, and redundant library characterization walkthroughs.*
