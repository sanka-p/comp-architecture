# Lec53 — Post-layout Verification and Signoff

## Overview
Covers post-layout verification workflow: layout extraction (circuit extraction: devices/nets; parasitic extraction: R/C/L), physical verification (DRC, ERC, LVS), signoff checks (STA, SI, power integrity, EM), and ECO (engineering change order: functional/timing fixes).

## Core concepts
**Layout extraction (motivation):**
- **Problem:** Layout = polygons (shapes on layers); tools (STA, SI, DRC, LVS) cannot work directly on polygons (too complex)
- **Solution:** Extract useful information from layout → give to verification tools (simplified computation)

**Circuit extraction:**
- **Goal:** Extract devices (transistors) + interconnections (nets) from layout
- **Inputs:** (1) Merged GDS (design layout + library GDS merged), (2) Extraction rules (LVS/ERC rule deck; from foundry)
- **Rule deck:** Instructions for extracting devices (e.g., poly ∩ diffusion → transistor); technology-specific (22nm ≠ 7nm)
- **Outputs:** (1) Layout netlist (SPICE format; devices + connectivity extracted from layout), (2) ERC report (invalid connections flagged)

**Parasitic extraction:**
- **Goal:** Extract unwanted R, C, L from layout (unintentional; created automatically)
- **Resistance:** Per net (segment into sections; compute R per segment: sheet resistance × L/W; combine for total R)
- **Capacitance:** All components (fringe, lateral, overlap; most difficult; decomposed into pre-characterization + pattern matching)
  - **Pre-characterization (once per technology):** Enumerate millions of sample geometries/structures (metal stack combinations) → compute C using field solvers (numerical; accurate) → store in LUT/empirical formulas
  - **Pattern matching (per design):** Partition layout into windows → match with pre-characterized patterns → lookup C from LUT/formulas (use actual layout geometry)
- **Output:** SPEF (Standard Parasitic Exchange Format; R, C, L values)

**Physical verification:**
1. **DRC (Design Rule Check):** Ensure layout meets manufacturing constraints (from foundry; technology-specific)
   - **Rules:** Min width (e.g., poly ≥ w), min spacing (e.g., poly-poly ≥ s), etc.
   - **Goal:** Good yield, reliability (rules ↑complex as feature size↓)
2. **ERC (Electrical Rule Check):** Check problematic electrical connections (shorts, opens, floating gates/nets)
3. **LVS (Layout vs Schematic):** Verify layout matches original netlist (functionality preserved)
   - **Inputs:** (1) Extracted netlist (layout netlist from circuit extraction), (2) Source netlist (logical netlist + device info)
   - **Comparison:** If match → pass; if mismatch → violations (fix layout/netlist; iterate)

**Signoff checks (before tape-out):**
- **Goal:** Ensure layout delivers intended functionality + meets QR (quality requirements)
- **Checks:** (1) STA (post-layout; accurate parasitics), (2) Physical verification (DRC, ERC, LVS), (3) SI (signal integrity; coupling C from layout), (4) Power integrity (IR drop, EM: electromigration), (5) Custom checks (design-house/designer-defined)
- **Tools:** Separate signoff tools (higher accuracy than implementation tools; e.g., PrimeTime vs Innovus timer)
- **Iterations:** Violations → loop back (ECO if localized; else chip planning/placement/CTS/routing)

**ECO (Engineering Change Order):**
- **Purpose:** Introduce controlled, incremental changes late in design flow (bugs discovered late, functionality change requests)
- **Risk:** Late changes dangerous (introduce new errors); ECO tools minimize risk (enable targeted changes, verify correctness: formal, STA)
- **Types:**
  - **Functional ECO:** Logic change (replace AND with NAND, etc.); requires logic re-synthesis or spare cells
  - **Timing ECO:** Fix setup/hold violations, SI, DRCs (upsize, downsize, buffer, reroute); direct layout changes
- **Benefits:** Save time/effort/cost (vs re-implementing design from scratch); minimize risk (tools verify correctness)

**Tape-out:**
- **Definition:** Send GDS (layout) to foundry for fabrication (project completion; celebration for designers)

## Methods/flows
**Layout extraction:**
1. Merge GDS: Design layout + library GDS (standard cells, macros) → merged GDS
2. Circuit extraction: Merged GDS + LVS/ERC rule deck → layout netlist (SPICE) + ERC report
3. Parasitic extraction: Layout + extraction rules → SPEF (R, C, L)

**Physical verification:**
1. DRC: Layout + DRC rules (foundry) → DRC report (violations: fix → iterate until clean)
2. ERC: Circuit extraction → ERC report (shorts, opens, floating; fix → iterate)
3. LVS: Compare extracted netlist (layout) vs source netlist (logic + devices) → match (pass) or violations (fix → iterate)

**Signoff:**
1. Extract design info (circuit, parasitics) from layout
2. Run checks: STA, DRC, ERC, LVS, SI, power integrity, EM, custom
3. Violations? → ECO (if localized) or loop back (chip planning/placement/CTS/routing)
4. All checks pass → tape-out (send GDS to foundry)

**ECO:**
1. Identify change needed (bug, functionality change, violation)
2. Functional ECO: Re-synthesize or use spare cells (rewire)
3. Timing ECO: Upsize, downsize, buffer, reroute (direct layout changes)
4. Verify correctness: Formal, STA (tools ensure no new errors)

## Constraints/assumptions
- **Merged GDS:** Required (design + library; abstract view + actual layout)
- **Rule deck:** Technology-specific (foundry-provided; 22nm ≠ 7nm)
- **Pre-characterization:** Once per technology (expensive; amortized over many designs)
- **Signoff tools:** Separate from implementation tools (higher accuracy; slower)
- **ECO:** Localized changes only (deep-rooted issues → re-implement from early stages)

## Examples
**Circuit extraction:**
- **Input:** Merged GDS (inverter layout + library GDS), LVS rule deck (poly ∩ diffusion → transistor)
- **Output:** Layout netlist (SPICE: pMOS, nMOS, connections), ERC report (no floating gates)

**DRC violations:**
- Rule: Min poly width ≥ w
  - Violation: Poly width < w → flag in DRC report → fix (widen poly to ≥ w)
- Rule: Min poly-poly spacing ≥ s
  - Violation: Spacing < s → flag → fix (increase spacing to ≥ s)

**LVS:**
- **Source netlist:** Logic (AND, inverter) + devices (pMOS, nMOS per AND/inverter)
- **Extracted netlist:** Layout (pMOS, nMOS connections from polygons)
- **Comparison:** Match → pass; mismatch (extra/missing transistor, wrong connection) → violations → fix

**Parasitic extraction (pre-characterization):**
- **Sample structure:** M1 (bottom), M2 (top, offset), dielectric (SiO₂)
- **Field solver:** Mesh structure → numerical computation → C = 10fF (store in LUT)

**Parasitic extraction (pattern matching):**
- **Layout window:** M1 + M2 configuration → match pre-characterized pattern → lookup C = 10fF (use actual geometry: W, spacing)

**ECO (functional):**
- Bug: AND gate should be NAND
- Fix: Replace AND with NAND (re-synthesize) or use spare NAND cell (rewire in layout)

**ECO (timing):**
- Violation: Setup violation on path A→B
- Fix: Upsize gate A (↓delay), insert buffer (restore slew), wire widen (↓RC delay)

## Tools/commands
- **Circuit extraction:** Calibre LVS, Assura, PVS (inputs: merged GDS + LVS rule deck → layout netlist, ERC report)
- **Parasitic extraction:** StarRC, Calibre xRC, Quantus QRC (inputs: layout + rules → SPEF)
- **DRC:** Calibre DRC, ICV, PVS (inputs: layout + DRC rules → DRC report)
- **LVS:** Calibre LVS, Assura, PVS (inputs: extracted netlist vs source netlist → LVS report)
- **Signoff STA:** PrimeTime (Synopsys), Tempus (Cadence)
- **ECO:** Conformal ECO (Cadence), Formality ECO (Synopsys)

## Common pitfalls
- Not merging GDS (design + library; abstract view insufficient for extraction)
- Using wrong rule deck (technology mismatch; 22nm rules on 7nm design → incorrect extraction)
- Skipping parasitic extraction (post-layout STA inaccurate; timing violations missed)
- Using implementation tools for signoff (lower accuracy → violations missed; use signoff tools)
- Not iterating DRC/LVS (violations remain → foundry rejects layout)
- Late functional ECO without spare cells (requires re-synthesis; expensive; use spare cells if available)
- ECO without verification (introduce new bugs; use tools: formal, STA)
- Tape-out with violations (foundry rejects or chip fails; ensure all checks pass)

## Key takeaways
- Layout extraction: Circuit (devices, nets) + parasitics (R, C, L) → enable verification tools (simplified from polygons)
- Circuit extraction: Merged GDS + LVS/ERC rule deck → layout netlist (SPICE) + ERC report
- Parasitic extraction: Pre-characterization (once per technology; field solvers → LUT) + pattern matching (per design; match layout windows)
- Physical verification: DRC (design rules: min width, spacing), ERC (shorts, opens, floating), LVS (layout vs netlist: functionality match)
- Signoff checks: STA (accurate parasitics), DRC/ERC/LVS, SI (coupling C), power integrity (IR drop, EM), custom checks
- Signoff tools: Separate from implementation (higher accuracy; slower)
- Signoff iterations: Violations → ECO (localized) or loop back (chip planning/placement/CTS/routing)
- ECO: Controlled, incremental changes (late bugs, functionality changes); tools minimize risk (verify correctness: formal, STA)
- ECO types: Functional (logic change; re-synthesize or spare cells), timing (fix violations; upsize, downsize, buffer, reroute)
- Tape-out: Send GDS to foundry (all checks pass; project completion; celebration)
- Pre-characterization expensive: Once per technology; amortized over many designs
- Pattern matching fast: Per design; matches layout windows with pre-characterized patterns

**Cross-links:** See Lec28-30: STA (timing analysis; signoff uses accurate parasitics); Lec40: DFT (spare cells for functional ECO); Lec52: Routing (parasitics accurate post-routing; extraction); Lec44-45: Interconnects (R, C, L; parasitic extraction targets)

---

*This summary condenses Lec53 from ~11,000 tokens, removing verbose LVS framework descriptions, redundant DRC examples, and repeated parasitic extraction walkthroughs.*
