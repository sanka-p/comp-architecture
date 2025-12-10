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



---

## 3. Layout Extraction (Lec53)

### 3.1 Motivation for Layout Extraction

**Problem:** Layout consists of various shapes/polygons on different layers. Verification tools cannot efficiently work directly with polygons.

**Solution:** Extract useful information from layout for verification tools:
- Static timing analysis tools
- Signal integrity tools
- Power analysis tools
- Physical verification tools

**Benefits:**
- Simplified representation for tools
- Faster computation
- Easier analysis
- Standard formats for tool interoperability

### 3.2 Two Major Extraction Tasks

1. **Circuit Extraction:** Extract devices (transistors) and interconnections (nets)
2. **Parasitic Extraction:** Extract unwanted R, C, L parasitics

---

## 4. Circuit Extraction (Lec53)

### 4.1 Circuit Extraction Framework

**Inputs:**

1. **Merged GDS**
   - Physical design tools create layout with abstract cell views (LEF format)
   - LEF contains: bounding box, pin locations (not internal layout details)
   - Actual cell layouts (inverter, AND gate internals) in separate GDS files from PDK
   - Must merge design GDS with standard cell GDS from library
   - Result: Complete layout ready for fabrication

2. **LVS/ERC Rule Deck**
   - Set of instructions in format tool can understand
   - Encodes device recognition rules
   - Example rule: "poly ∩ diffusion → transistor at intersection"
   - Technology-specific (different for 22nm, 7nm, etc.)
   - Provided by foundry
   - Contains extraction rules for various device types

**Process:**
- Tool reads merged GDS and rule deck
- Applies extraction rules to identify devices
- Traces connectivity between devices
- Generates netlist representation

**Outputs:**

1. **Layout Netlist (SPICE format)**
   - Describes extracted circuit topology
   - Lists all transistors and their connections
   - Example: Inverter chain
     ```
     * Inverter I1: PMOS + NMOS
     * Output of I1 → Input of I2
     * Includes power/ground connections
     ```
   - Used for LVS (Layout vs. Schematic) checking

2. **ERC Report**
   - Electrical Rule Check violations
   - Identifies connectivity issues
   - Reports invalid connections
   - Generated during circuit extraction using ERC rules from rule deck

### 4.2 Example: Inverter Extraction

**Layout:** Two inverters connected in series

**Extraction identifies:**
- Inverter 1 (I1): 1 PMOS + 1 NMOS
- Inverter 2 (I2): 1 PMOS + 1 NMOS
- VDD connection to both PMOS sources
- GND connection to both NMOS sources
- Output of I1 connected to gates of I2

**Generated SPICE netlist:**
```spice
* Extracted netlist
M1 out1 in vdd vdd pmos ...
M2 out1 in gnd gnd nmos ...
M3 out2 out1 vdd vdd pmos ...
M4 out2 out1 gnd gnd nmos ...
```

---

## 5. Parasitic Extraction (Lec53)

### 5.1 What are Parasitics?

**Definition:** Unwanted resistance, capacitance, and inductance created automatically in the layout (not intentionally designed).

**Sources:**
- Wire resistance
- Coupling capacitance between adjacent wires
- Self-capacitance to substrate
- Inductance in long wires

### 5.2 Resistance Extraction

**Process:**
- Extract resistance for each net on layout
- Segment nets into sections
- Compute resistance per segment

**Calculation:**
- Based on sheet resistance (Rs)
- Wire length (L)
- Wire width (W)
- Formula: R = Rs × (L/W)

**Output:**
- Resistance network for each net
- Multiple segments per net
- Reported in SPEF format

### 5.3 Capacitance Extraction

**Types of capacitance:**

1. **Parallel-plate capacitance:** Wire to substrate below
2. **Fringe capacitance:** Sidewalls of wire
3. **Lateral capacitance:** Same-layer neighboring wires
4. **Overlap capacitance:** Cross-layer wires

**Extraction method:**
- Pre-characterization of capacitance patterns
- Pattern matching in layout
- Look-up tables for different configurations
- Combine contributions from all sources

### 5.4 Output Format: SPEF

**Standard Parasitic Exchange Format:**
- Industry standard format
- Contains R, C, L values for all nets
- Used by timing analysis tools
- Includes coupling capacitances
- Net-by-net parasitic information

---

## 6. Physical Verification (Lec53)

Ensure the layout does not have manufacturing and connectivity issues and the yield remains high

### 6.1 Design Rule Checking (DRC)

**Purpose:** Verify layout meets manufacturing constraints

**Rules checked:**
- **Minimum width:** Wires/features must be wide enough
- **Minimum spacing:** Adequate spacing between features
- **Minimum area:** Features must have sufficient area
- **Via enclosure:** Vias properly enclosed by metal
- **Antenna rules:** Prevent plasma-induced gate damage
- **Density rules:** Metal density requirements for CMP
- **Well rules:** N-well, P-well spacing and overlap

**Process:**
- Run DRC tool on final layout
- Tool checks every rule in rule deck
- Reports violations with locations
- Designer must fix all violations
- Re-run DRC until clean

### 6.2 Electrical Rule Checking (ERC)

**Purpose:** Identify electrical connectivity issues

**Checks performed:**
- **Shorts:** Unintended connections between nets
- **Opens:** Incomplete connections
- **Floating nodes:** Disconnected circuit elements
- **Multiple drivers:** Nets driven by multiple sources
- **Missing connections:** Required connections not made

**Timing:** Often performed during circuit extraction

### 6.3 Layout vs. Schematic (LVS)

**Purpose:** Verify layout netlist matches source/schematic netlist

**Process:**
1. Extract layout netlist from layout (circuit extraction)
2. Compare with source netlist (from synthesis)
3. Check device-by-device correspondence
4. Verify connectivity matches
5. Report mismatches

**What is compared:**
- Number and types of devices (transistors, resistors, etc.)
- Device connectivity
- Net names (with equivalence mapping)
- Device parameters (sizes, types)

**Result:**
- **Pass:** Layout correctly implements schematic
- **Fail:** Mismatches found—must fix and re-run

**Common LVS errors:**
- Missing devices
- Extra devices
- Swapped connections
- Shorted nets
- Open nets

---

## 7. Signoff Checks

### 7.1 Signoff Static Timing Analysis (STA)

**Purpose:** Verify timing with accurate post-layout parasitics

**Requirements:**
- Use extracted SPEF parasitics
- Multi-corner/multi-mode analysis
- Accurate delay models
- All timing constraints checked

**Signoff vs. Implementation STA:**
- **Signoff tools:** Higher accuracy, more thorough (PrimeTime, Tempus)
- **Implementation tools:** Faster, less accurate (used during P&R)
- Must use signoff tools for final verification

**Checks:**
- Setup timing (max delay)
- Hold timing (min delay)
- Clock skew and jitter
- Multi-cycle paths
- False paths
- All operating modes and corners

### 7.2 Signal Integrity (SI)

**Crosstalk analysis:**
- Coupling capacitance effects
- Dynamic delay variation
- Glitch analysis on victim nets
- Same-direction vs. opposite-direction transitions

**Noise analysis:**
- Peak noise amplitude
- Noise width
- Impact on logic levels
- Critical on clock/reset/control signals

### 7.3 Power Integrity (PI)

**IR Drop analysis:**
- Static IR drop (average current)
- Dynamic IR drop (switching current)
- Voltage drop limits
- Power grid adequacy

**Checks:**
- VDD drop within specifications
- Ground bounce acceptable
- Adequate decoupling capacitance

### 7.4 Electromigration (EM)

**Analysis:**
- Current density in wires
- RMS and average current
- Wire lifetime estimation
- Compliance with EM limits

**Action:**
- Widen wires if violations
- Add parallel wires
- Reduce current through wire

### 7.5 Why Separate Signoff Tools?

**Accuracy requirements:**
- Implementation tools optimize for speed
- Signoff tools optimize for accuracy
- Different algorithms and models
- More thorough corner coverage

**Industry practice:**
- Never rely on implementation timers alone
- Always run dedicated signoff analysis
- Signoff tools are foundry-qualified

---

## 8. ECO (Engineering Change Order)

### 8.1 What is ECO?

**Definition:** Controlled, incremental changes to design after major implementation complete

**Purpose:**
- Fix verification failures
- Address late-stage bugs
- Improve timing/power/area
- Implement specification changes

**Philosophy:**
- Minimize changes (small "blast radius")
- Avoid re-running entire flow
- Maintain design stability
- Reduce turnaround time

### 8.2 Types of ECO

#### Functional ECO

**Purpose:** Fix functional bugs or implement logic changes

**Methods:**
1. **Re-synthesis:**
   - Modify RTL
   - Re-synthesize affected portion
   - Patch into existing netlist
   
2. **Spare cells:**
   - Pre-placed unused cells in design
   - Utilize for small fixes
   - Faster than re-synthesis

3. **Manual logic changes:**
   - Add/remove gates
   - Change gate types
   - Modify connections

**Verification:**
- Formal verification (equivalence checking)
- Simulation with updated testbench
- Ensure no new bugs introduced

#### Timing ECO

**Purpose:** Fix setup/hold violations after signoff STA

**Techniques:**
1. **Cell upsizing:** Increase drive strength to reduce delay
2. **Cell downsizing:** Reduce size to fix hold or reduce power
3. **Buffer insertion:** Break long wires, reduce delay
4. **Buffer relocation:** Move buffers for better timing
5. **Wire widening:** Reduce resistance, improve delay
6. **Rerouting:** Change wire paths to reduce length/coupling
7. **Clock tree adjustments:** Fix skew issues

**Verification:**
- Re-run STA with updated design
- Verify violations fixed
- Ensure no new violations created
- Check hold timing after setup fixes

### 8.3 ECO Flow

**Process:**
1. **Identify violations:** From signoff analysis reports
2. **Root cause analysis:** Understand why violations occur
3. **Plan fixes:** Determine minimal changes needed
4. **Implement ECO:** Make changes to netlist/layout
5. **Re-extract:** Update parasitics if layout changed
6. **Verify:** Run formal, STA, DRC/LVS as needed
7. **Iterate:** Repeat until all violations fixed

### 8.4 ECO Best Practices

**Minimize blast radius:**
- Make smallest possible changes
- Localize impact to specific region
- Avoid cascading changes

**Verification is critical:**
- Always verify ECO with formal tools
- Re-run affected analyses
- Don't assume fix is correct

**Track changes:**
- Document all ECO changes
- Maintain change history
- Enable debugging if issues arise

**Consider alternatives:**
- Sometimes better to re-run flow
- Too many ECOs indicate flow problems
- Balance ECO effort vs. clean re-implementation

---

## 9. Post-Layout Verification and Signoff Flow (Lec53)

### 9.1 Complete Flow

**After detailed routing:**

1. **Merge GDS**
   - Combine design layout with standard cell layouts
   - Create complete manufacturable layout

2. **Circuit Extraction**
   - Input: Merged GDS + LVS/ERC rule deck
   - Output: Layout netlist (SPICE) + ERC report
   - Identifies devices and connectivity

3. **Parasitic Extraction**
   - Input: Merged GDS
   - Output: SPEF (parasitics for all nets)
   - Extracts R, C, L values

4. **Physical Verification**
   - **DRC:** Check all design rules
   - **LVS:** Compare layout netlist vs. source netlist
   - **ERC:** Check electrical connectivity
   - Fix all violations, re-verify

5. **Signoff Analysis**
   - **STA:** Timing with accurate SPEF parasitics
   - **SI:** Signal integrity and crosstalk
   - **IR:** Power integrity and voltage drop
   - **EM:** Electromigration analysis
   - Use dedicated signoff tools

6. **ECO (if needed)**
   - Fix timing violations
   - Fix functional bugs
   - Improve power/area if needed
   - Minimize changes

7. **Re-verify after ECO**
   - Re-extract if layout changed
   - Re-run affected analyses
   - Formal verification for functional changes

8. **Signoff complete**
   - All DRC/LVS/ERC clean
   - All timing/SI/IR/EM constraints met
   - Formal verification passed

9. **Tape-out**
   - Send final GDS to foundry
   - Include design documentation
   - Fabrication begins

### 9.2 Iteration and Convergence

**Common pattern:**
- First signoff run: violations found
- ECO to fix violations
- Re-verify: may create new violations
- Iterate until all clean

**Convergence challenges:**
- Setup fixes can cause hold violations
- Timing fixes can increase power
- Layout changes affect parasitics
- Require multiple ECO iterations

**Design closure:**
- Achieved when all checks pass
- No remaining violations
- Design meets all specifications
- Ready for manufacturing

---

## 10. Key Takeaways

### From Verification Overview (Lec08)
1. **Verify throughout flow:** Catch errors early when fixes are cheaper
2. **Simulation advantages:** Fast, versatile, works at multiple abstraction levels
3. **Simulation limitations:** Incomplete coverage, cannot prove correctness
4. **Formal methods:** Provide mathematical proofs, complete coverage
5. **Complementary approaches:** Use both simulation and formal methods
6. **Property-based verification:** Define critical properties for model checking

### From Extraction and Signoff (Lec53)
7. **Extraction is essential:** Translates polygons to analyzable formats (SPICE, SPEF)
8. **Merged GDS:** Combine design with standard cell layouts before extraction
9. **Rule decks:** Technology-specific, provided by foundry
10. **DRC/LVS mandatory:** Cannot tape-out without clean DRC/LVS
11. **Signoff tools required:** Implementation timers insufficient for final verification
12. **Parasitics critical:** Post-layout timing significantly different from pre-layout
13. **ECO for fixes:** Targeted changes minimize impact and turnaround time
14. **Verification after ECO:** Always re-verify after making changes
15. **Design closure:** Iterative process requiring multiple verification rounds

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
