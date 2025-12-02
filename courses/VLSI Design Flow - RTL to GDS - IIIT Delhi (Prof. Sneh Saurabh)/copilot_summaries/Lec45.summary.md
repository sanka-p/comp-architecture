# Lec45 — Basic Concepts for Physical Design - II

## Overview
Covers signal integrity (crosstalk: dynamic delay variation, glitches/noise), antenna effect (plasma-induced gate damage, antenna ratio), and LEF files (technology LEF: layer/via properties, design rules; cell LEF: abstract cell layout for placement/routing).

## Core concepts
**Signal integrity (coupling capacitance effects):**
- **Coupling capacitance (C_c):** Between adjacent wires in close vicinity → voltage in one wire (aggressor) impacts voltage in another (victim)
- **Two manifestations:** (1) Dynamic delay variation (delay depends on aggressor activity), (2) Glitches/noise (functional errors)

**Dynamic delay variation:**
- **Base delay:** Delay computed assuming aggressors held constant (0 or 1) → charge C_g + C_c
- **Negative incremental delay:** Victim + aggressor transition in same direction (0→1, 0→1) → C_c not charged (V_AB=0 initially, 0 finally) → driver charges only C_g → delay↓ (less charge needed)
- **Positive incremental delay:** Victim + aggressor transition in opposite directions (0→1, 1→0) → C_c voltage change: 2V_DD (V_AB: -V_DD→+V_DD) → driver charges C_g + 2C_c → delay↑ (more charge needed)
- **STA impact:** Base delay (default; no SI) → adjusted delay (±incremental) for SI-aware STA → slack changes

**Glitches/noise (crosstalk):**
- **Mechanism:** Victim held constant, aggressor transitions → C_c charges/discharges → current through victim driver (PMOS/NMOS resistance) → temporary voltage dip/bump
- **Types:** (1) Rise glitch (victim=0, aggressor: 0→1 → victim bumps above 0), (2) Fall glitch (victim=1, aggressor: 1→0 → victim dips below V_DD), (3) Undershoot (victim<0), (4) Overshoot (victim>V_DD)
- **Magnitude factors:**
  - **Aggressor transition speed:** Fast transition → large di/dt → larger glitch
  - **Coupling capacitance (C_c):** Larger C_c → more charge transfer → larger glitch
  - **Victim ground capacitance (C_g):** Larger C_g → dampens glitch (charge shared)
  - **Victim driver strength:** Stronger driver (lower R) → smaller IR drop → smaller glitch
- **Functional impact:** Glitch above threshold + wide enough → wrong value latched by FF (especially critical on clock/reset/control signals)
- **Noise models:** Libraries contain noise propagation models → tools compute glitch propagation through logic → verify functional correctness

**Antenna effect (plasma-induced gate damage):**
- **Mechanism:** During BEOL fabrication (layer-by-layer), plasma etching/deposition → charge accumulates on metal wires → if wire connected directly to gate, charge discharges through thin gate oxide (2-3nm) → oxide damage
- **Damage:** High voltage across thin oxide → breakdown, defects → V_TH shift, functional failure
- **Antenna ratio:** A_conductor / A_oxide (conductor area / gate oxide area)
  - **High ratio:** Large conductor → more charge accumulated → greater damage risk
  - **Antenna rules:** Foundry specifies max allowed ratio (e.g., ratio<400); violations → DRC error
- **Mitigation (physical design):**
  - **Layer jumping:** Use upper metal layers (deposited later) → less charge accumulation (fewer process steps after deposition)
  - **Diode insertion:** Connect diode (anode→wire, cathode→V_DD/GND) → alternate discharge path (charge flows through diode, not gate)
  - **Wire splitting:** Break long wire into segments (vias to upper layer) → reduce conductor area per segment

**Library Exchange Format (LEF) files:**
- **Purpose:** Capture fabrication constraints, provide abstract cell info for physical design (placement, routing)
- **Technology LEF:** Foundry-specific (one per technology node)
  - **Layers:** Metal layers (M1, M2, ...), via layers (V1, V2, ...), properties (type, direction, min width, spacing, pitch)
  - **Sheet resistance (R_s):** Per layer (e.g., M1: R_s=0.1Ω/□)
  - **Capacitance:** Per unit area/length (e.g., C_pp=50aF/μm²)
  - **Design rules:** Min width, min spacing, min area, via enclosure, antenna rules (max ratio)
- **Cell LEF:** Cell-specific (one per library cell; e.g., NAND2, INV, DFF)
  - **Abstract layout:** Bounding box (cell size), pin locations (layer + coordinates), obstructions (blockages for routing/placement)
  - **Not full layout:** Detailed transistor layout NOT needed for P&R (abstract sufficient for placement, routing)
  - **Purpose:** Tools use for placement (bounding box, obstructions), routing (pin access, obstruction avoidance)

## Methods/flows
**Crosstalk analysis:**
1. Extract coupling capacitances (C_c) from layout → parasitic extraction (Quantus QRC, StarRC)
2. Identify aggressor-victim pairs (adjacent wires with high C_c)
3. Compute incremental delay: Same direction → negative; opposite → positive
4. SI-aware STA: Base delay ± incremental delay → adjusted slack

**Glitch analysis:**
1. Extract C_c, C_g, driver strength from layout/netlist
2. Identify critical nets (clock, reset, control signals)
3. Simulate aggressor transitions → compute glitch magnitude/width (SPICE, noise tools)
4. Propagate glitch through logic (noise models) → verify threshold violations → flag functional errors

**Antenna violation fix:**
1. Post-route DRC → identify antenna violations (A_conductor/A_oxide > max_ratio)
2. Mitigation: (a) Layer jump (via to upper metal), (b) Diode insertion (connect to V_DD/GND), (c) Wire split (break into segments)
3. Re-DRC → verify violations fixed

**LEF usage (P&R tools):**
1. Read technology LEF (layers, design rules, sheet resistance, capacitance)
2. Read cell LEF (bounding box, pin locations, obstructions)
3. Placement: Use bounding box (cell size), obstructions (avoid overlap)
4. Routing: Use pin locations (connect nets), design rules (min width, spacing), sheet resistance (parasitic R)

## Constraints/assumptions
- **Base delay assumption:** Aggressors held constant (default STA; SI-aware STA adjusts)
- **Glitch threshold:** Depends on logic family (e.g., CMOS: ~0.3V_DD for logic 1, ~0.7V_DD for logic 0)
- **Antenna rules:** Foundry-specific (max ratio varies; e.g., 100-1000 depending on process)
- **LEF abstraction:** Cell LEF omits transistor details (sufficient for P&R; not for analog design)

## Examples
**Dynamic delay variation (C_g=1fF, C_c=0.5fF):**
- **Base delay:** Charge C_g + C_c = 1.5fF
- **Same direction (0→1, 0→1):** Charge only C_g = 1fF → delay↓ (33% less charge)
- **Opposite direction (0→1, 1→0):** Charge C_g + 2C_c = 1+1=2fF → delay↑ (33% more charge)

**Glitch (victim=1, aggressor: 1→0):**
- C_c=0.5fF, aggressor transition: 100ps → C_c charges (V_AB: 0→V_DD) → current from victim driver (PMOS R=1kΩ) → IR drop → victim dips to 0.9V_DD (fall glitch)
- **Mitigation:** Increase C_g (add decap), stronger driver (lower R), reduce C_c (increase spacing)

**Antenna ratio:**
- Conductor: M1 (100μm long × 0.5μm wide = 50μm²), Gate oxide: 0.1μm² → Ratio = 50/0.1 = 500
- **Violation:** If max_ratio=400 → violation → fix: layer jump (via to M2; M2 deposited later, less charge accumulation)

**Technology LEF (M1 layer):**
```
LAYER M1
  TYPE ROUTING ;
  DIRECTION HORIZONTAL ;
  PITCH 0.5 ;  # μm
  WIDTH 0.2 ;  # min width
  SPACING 0.2 ;  # min spacing
  RESISTANCE RPERSQ 0.1 ;  # Ω/□
  CAPACITANCE CPERSQDIST 50 ;  # aF/μm²
  ANTENNARATIO 400 ;  # max ratio
END M1
```

**Cell LEF (INV):**
```
MACRO INV
  SIZE 1.0 BY 2.0 ;  # μm (bounding box)
  PIN A
    DIRECTION INPUT ;
    PORT
      LAYER M1 ;
      RECT 0.1 0.5 0.3 0.7 ;  # pin location (x1 y1 x2 y2)
    END
  END A
  PIN Y
    DIRECTION OUTPUT ;
    PORT
      LAYER M1 ;
      RECT 0.7 0.5 0.9 0.7 ;
    END
  END Y
  OBS  # obstructions (blockages for routing)
    LAYER M1 ;
    RECT 0.4 0.3 0.6 1.7 ;
  END
END INV
```

## Tools/commands
- **Parasitic extraction:** Cadence Quantus QRC, Synopsys StarRC (extract C_c, R from layout → SPEF file)
- **SI-aware STA:** PrimeTime SI, Tempus (compute incremental delays, adjusted slacks)
- **Noise analysis:** Cadence Voltus, Synopsys HSPICE (simulate glitches, propagate through logic)
- **DRC (antenna check):** Calibre, ICV (check antenna ratios → flag violations)
- **LEF readers:** P&R tools (Innovus, ICC2) read technology + cell LEF for placement, routing

## Common pitfalls
- Ignoring signal integrity (base delay only → inaccurate slack; may miss timing violations)
- Not checking glitches on clock/reset (functional failures; latched wrong values)
- Violating antenna rules (gate damage → yield loss, reliability issues)
- Using full layout for P&R (slow; cell LEF abstract sufficient)
- Not mitigating antenna violations (post-fab damage; diode insertion, layer jump necessary)
- Assuming C_c negligible (advanced nodes: close spacing → large C_c → significant SI impact)

## Key takeaways
- Signal integrity (SI): Coupling capacitance (C_c) → aggressor impacts victim (delay variation, glitches)
- Dynamic delay variation: Base delay (aggressors constant) ± incremental delay (same direction: negative; opposite: positive)
- Glitch/noise: Victim constant, aggressor transitions → C_c charges → current through victim driver → voltage dip/bump
- Glitch factors: Aggressor speed (fast→large), C_c (large→large), C_g (large→small), driver strength (strong→small)
- Functional impact: Glitch > threshold + wide → wrong FF value (critical on clock/reset/control)
- Antenna effect: Plasma charging metal → discharge through gate oxide (2-3nm) → damage
- Antenna ratio: A_conductor / A_oxide (high ratio → greater damage risk; foundry specifies max)
- Mitigation: Layer jump (upper metal, less charge), diode insertion (alternate discharge path), wire split (reduce area)
- LEF files: Technology LEF (layers, design rules, R_s, C, antenna rules), cell LEF (bounding box, pins, obstructions)
- Technology LEF: Foundry-specific (one per node); contains layer properties, design rules
- Cell LEF: Cell-specific (abstract layout; sufficient for P&R, not full transistor layout)
- P&R usage: Technology LEF (routing rules, parasitics), cell LEF (placement size, pin access)

**Cross-links:** See Lec44: Interconnect parasitics (C_c, R_s), fabrication (BEOL, dual damascene); Lec28-30: STA (delay calculation; SI-aware STA adjusts for coupling); Lec26: Technology library (.lib: noise models, timing)

---

*This summary condenses Lec45 from ~11,000 tokens, removing repeated coupling capacitance diagrams, redundant glitch calculation examples, and verbose LEF syntax descriptions.*
