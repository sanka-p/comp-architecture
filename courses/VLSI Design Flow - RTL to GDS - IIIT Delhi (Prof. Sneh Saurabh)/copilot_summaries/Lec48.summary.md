# Lec48 — Chip Planning - II

## Overview
Covers macro placement (fly lines, guidelines: contiguous regions, avoid narrow channels, halos, orientation/shape flexibility), standard cell row creation (abutment, alternating VDD/GND), and power planning (mesh grid, electromigration, IR drop, decaps).

## Core concepts
**Macro placement (large objects: blocks, RAM, ROM, analog):**
- **Differentiation:** Macros (tens/hundreds; manual intervention possible) vs standard cells (millions; automated)
- **Connectivity-based (fly lines):** Show net count between macros/IOs
  - **Example:** B1 ↔ B2: 52 nets (max) → place close; B1 ↔ I2 (IO): 16 nets → place B1 near I2
  - **Heuristic:** Strong connectivity (high net count) → place together (↓wire length, ↓congestion)
- **Predictive routing:** Rough routing (fast, not final quality) → identify congestion hotspots → adjust macro placement

**Macro placement guidelines:**
1. **Contiguous regions for standard cells:** Avoid fragmented regions (continuous preferred; analytical placement algorithms work better)
2. **Avoid narrow channels:** Narrow channels between macros/edge → congestion (few routing tracks), hard to upsize/insert buffers
   - **Fix:** Shift macros (eliminate narrow channel), change aspect ratio (flexible macros)
3. **Halos (placement blockages):** Empty space around macro corners → avoid congestion (cells near corners have restricted routing)
   - **Why:** Routing over macro already used → all routing around periphery → corners congest → halo prevents cell placement near corners
4. **Orientation flexibility:** 8 orientations (rotate 90°, mirror x/y-axis) → try all → choose best QR
   - **Caution:** Power lines also rotate → verify alignment with power grid
5. **Flexible macros:** Change aspect ratio (same area, different W×H) or shape (rectangular → rectilinear: L-shape, U-shape)
6. **Pin assignment:** Try different pin placements → reduce wire length (e.g., {A,B,C} → {B,C,A} if A connects to bottom objects)

**Standard cell rows:**
- **Creation:** Abutment (rows sticking together); alternate rows rotated 180° (share VDD/GND rails)
  - **Row 1:** VDD (top), GND (bottom); Row 2: GND (top, shared with Row 1), VDD (bottom, shared with Row 3)
  - **Benefit:** Saves routing resources (shared rails)
- **Multiple heights:** Some libraries have cells of different heights (h₁, h₂) → create rows of different heights
- **Routing channels:** Open spaces between rows (if congestion expected; allows horizontal routing)

**Power planning (power delivery network, PDN):**
- **Components:** Power pads → power rings (periphery; VDD/GND; top metal layers for low R) → mesh grid (core)
- **Mesh grid topology:** Rails (horizontal) + straps (vertical) + vias (connections)
  - **Advantages:** (1) Low R (many parallel paths), (2) High reliability (redundant paths; one breaks → others compensate), (3) Uniform current distribution
- **Design decisions:** Layer selection (top layers: thick → low R_s), width (technology min-width + IR drop tolerance), spacing (technology min-spacing)

**Electromigration:**
- **Mechanism:** Unidirectional current → electron momentum transfer → metal atoms migrate (opposite to current) → voids/hillocks → short/open
- **Power grids vulnerable:** Current always unidirectional (VDD → cells; unlike signals: bidirectional → self-healing)
- **Mitigation:** Wider conductors (↓current density), EM-aware tools (flag hotspots → resize)

**IR drop (voltage drop in power lines):**
- **Causes:** R (resistance), L (inductance; package-to-die bond wires) → V_drop = I·R + L·(di/dt)
- **Static:** I·R (steady-state; less critical)
- **Dynamic:** Large during active computation (high I, sharp di/dt) → V_drop significant
- **Impact:** V_supply↓ → delay↑ → performance↓ (cells designed for V_DD=1V; if V=0.8V → slower)
- **IR drop hotspots:** Regions with large V_drop (high activity → high I → large I·R + L·di/dt)
- **Mitigation:** Decoupling capacitors (decaps)
  - **Mechanism:** C charged to V_DD (static) → supplies local charge during active computation (acts as local storage) → reduces I from distant power pads → ↓IR drop
  - **Placement:** Strategic (near hotspots; tools identify via dynamic simulation/VCD analysis)
  - **Cost:** Area overhead, leakage power (C always charged → leakage current)

## Methods/flows
**Macro placement:**
1. Analyze fly lines (net count between macros/IOs) → place high-connectivity macros together
2. Apply guidelines (contiguous standard cell regions, no narrow channels, halos at corners)
3. Predictive routing → identify congestion → adjust macro positions/orientations
4. Iterate until QR acceptable (manual tweaking common)

**Standard cell row creation:**
1. Define site (unit tile: min width/height for cells)
2. Create rows (height = site height; abutment: rows stick together)
3. Alternate orientations (Row 1: VDD top; Row 2: GND top (shared), VDD bottom; Row 3: VDD top (shared))

**Power planning:**
1. Place power pads (number: I_chip / I_max_per_pad; VDD/GND separate from core)
2. Create power rings (periphery; top metal layers)
3. Build mesh grid (rails + straps + vias; top layers; width/spacing per technology + IR drop tolerance)
4. Verify EM (tools flag hotspots → resize conductors)
5. Dynamic IR drop analysis (simulate/VCD → identify hotspots)
6. Insert decaps (near hotspots; size/number minimize area/leakage while fixing IR drop)

## Constraints/assumptions
- **Macro placement:** No optimal algorithm (heuristics; manual intervention common)
- **Flexible macros:** Not all macros flexible (hard macros: fixed aspect ratio; soft macros: flexible)
- **IR drop tolerance:** Design-dependent (e.g., ±10% V_DD acceptable → V_drop_max = 0.1·V_DD)
- **Decap cost:** Area (~1-5% overhead typical), leakage (C_decap × V_DD² × f_leak)

## Examples
**Fly lines:**
- B1 ↔ B2: 52 nets → place close
- B1 ↔ I2 (IO): 16 nets vs B1 ↔ I3: 5 nets → B1 near I2

**Narrow channel (before/after):**
- **Before:** Macros A, B, C close → narrow channels between → congestion
- **After:** Shift C up → eliminate narrow channel; continuous standard cell region

**Halo:**
- Macro corner + nearby cells → routing over macro used → all routing around periphery → congestion at corner
- **Fix:** Halo (e.g., 5μm around macro) → no cells in halo → no congestion

**Standard cell rows (abutment):**
```
Row 1: [VDD]========[GND]  (cells)
Row 2: [GND]========[VDD]  (cells, rotated 180°; share GND with Row 1)
Row 3: [VDD]========[GND]  (cells; share VDD with Row 2)
```

**Mesh grid (simplified):**
- VDD mesh: Rails (M5, horizontal) + straps (M6, vertical) + vias (V5)
- GND mesh: Similar (separate from VDD mesh)
- Cells tap VDD/GND from nearest mesh point

**IR drop:**
- Design: I_chip=1A, R_grid=0.1Ω, L_bond=1nH, di/dt=10A/ns (dynamic)
  - Static: V_drop = 1×0.1 = 0.1V (10% of 1V)
  - Dynamic: V_drop = 1×0.1 + 1n×10 = 0.1 + 0.01 = 0.11V (11%)
- **Hotspot:** Region with V_drop=0.2V (20%; unacceptable) → insert decap

**Decap:**
- Hotspot: I_peak=0.5A, duration=1ns → Q = I·t = 0.5×1n = 0.5nC
- Decap needed: C = Q/V = 0.5nC / 1V = 0.5nF (500pF)
- **Implementation:** Insert 100× 5pF decap cells near hotspot

## Tools/commands
- **Floorplanning:** Innovus `placeInstance` (macro placement), OpenRoad `macro_placement`
- **Power planning:** Innovus `sroute -nets {VDD VSS}`, OpenRoad `pdngen` (mesh grid creation)
- **IR drop analysis:** Voltus (Cadence), RedHawk (Ansys), OpenRoad `check_power_grid`
- **EM check:** Calibre PERC, Voltus EM (flag EM violations)

## Common pitfalls
- Fragmented standard cell regions (analytical placement fails → poor QR)
- Narrow channels (congestion, hard to upsize/insert buffers → timing violations)
- No halos (cells near macro corners → congestion → routing fails)
- Not checking power line alignment after macro rotation (VDD/GND misaligned → shorts)
- Insufficient power pads (I_chip exceeds I_max_per_pad → IR drop, EM risk)
- Ignoring dynamic IR drop (static OK, dynamic fails → voltage droop during operation)
- Over-inserting decaps (area/leakage overhead > benefit; insert strategically, not everywhere)
- Not verifying EM (wire breaks post-fabrication → reliability failures)

## Key takeaways
- Macro placement: Connectivity (fly lines) + guidelines (contiguous regions, no narrow channels, halos, orientation flexibility)
- Fly lines: Show net count → high connectivity → place together (↓wire length, ↓congestion)
- Guidelines: Contiguous standard cell regions (analytical placement works better), avoid narrow channels (congestion, hard to optimize)
- Halos: Placement blockages around macro corners (avoid congestion; routing restricted near corners)
- Orientation: 8 options (rotate, mirror) → try all → verify power alignment
- Flexible macros: Change aspect ratio (same area) or shape (rectangular → rectilinear: L, U)
- Standard cell rows: Abutment (rows stick together), alternate 180° rotation (share VDD/GND rails → save routing)
- Power planning: Power pads → rings (periphery, top layers) → mesh grid (rails + straps + vias; low R, reliable, uniform)
- Electromigration: Unidirectional current → metal atoms migrate → shorts/opens (mitigation: wider wires, EM-aware tools)
- IR drop: V_drop = I·R + L·di/dt; dynamic (active computation) > static (steady-state)
- IR drop impact: V_supply↓ → delay↑ → performance↓ (cells slower at lower voltage)
- Decaps: Local charge storage (C charged to V_DD → supplies charge during transients) → ↓IR drop (cost: area, leakage)
- Decap placement: Strategic (near hotspots; tools identify via dynamic analysis/VCD)

**Cross-links:** See Lec47: Chip planning I (hierarchical design, floorplan basics, IO cells); Lec49: Placement (standard cells); Lec44: Interconnects (sheet resistance, capacitance); Lec45: Signal integrity (IR drop → voltage fluctuations → noise)

---

*This summary condenses Lec48 from ~14,000 tokens, removing redundant macro placement examples, verbose IR drop derivations, and repeated decap insertion explanations.*
