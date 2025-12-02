# Lec44 — Basic Concepts for Physical Design - I

## Overview
Introduces IC fabrication (FEOL: devices, BEOL: interconnects), interconnect properties (metal layers, vias, preferred direction, thickness scaling), and parasitic resistance/capacitance (sheet resistance, parallel-plate/fringe/lateral/overlap capacitances).

## Core concepts
**IC fabrication (FEOL: Front End Of Line):**
- **Devices:** Transistors (MOSFETs), diodes, capacitors (built in silicon substrate)
- **Ion implantation:** Dope silicon with acceptors (B, Al → p-type) or donors (P → n-type) → create source/drain, wells (n-well, p-well)
  - **Process:** Create ions (arc discharge) → accelerate (electric/magnetic fields) → bombard substrate (through photoresist mask) → anneal (activate dopants, heal defects)
  - **Threshold adjustment:** Implant at channel → modulate V_TH (different V_TH for different transistors)
- **Shallow trench isolation (STI):** Isolate devices (prevent substrate interaction) → etch trenches, fill with SiO₂, planarize (CMP)
- **Gate fabrication:** Grow/deposit gate oxide (SiO₂ or HfO₂; 2-3nm thick) → deposit polysilicon (doped for conductivity) → pattern (photolithography + etching)
- **Source/drain:** Ion implantation (n⁺ for NMOS, p⁺ for PMOS) after gate definition

**IC fabrication (BEOL: Back End Of Line):**
- **Interconnects:** Multiple metal layers (wires) separated by interlayer dielectric (ILD, typically SiO₂)
- **Dual damascene process:** Create vias + wires together (single process)
  1. **Etch:** Create hollow spaces for vias + wires (plasma etching through photoresist mask)
  2. **Barrier layer:** Deposit Ta/TiN (prevent Cu diffusion into SiO₂/Si; Cu damages transistors)
  3. **Cu deposition:** Electroplating (fill hollow spaces with copper)
  4. **CMP (Chemical Mechanical Polishing):** Planarize (remove excess Cu; high-pH slurry)
- **Why copper:** Low resistivity, electromigration resistance (vs Al)

**Interconnect layers:**
- **Wiring layers:** Parallel to substrate (M1, M2, ...); carry current horizontally
- **Via layers:** Perpendicular to substrate (V1, V2, ...); connect wiring layers (vertical current flow)
- **Uniform thickness:** For given layer, thickness (T) fixed by foundry (designer controls length L, width W only)
- **2D representation:** Layout shows 2D (L, W); 3rd dimension (T) implicit (from library/LEF)
- **Thickness scaling:** Upper layers thicker (M6 > M5 > ... > M1) → lower resistance (larger cross-section A=T×W)

**Preferred direction:**
- **Alternating:** M1→y, M2→x, M3→y, ... (successive layers orthogonal)
- **Reason:** Eases routing (tools route M1 vertically, M2 horizontally, ...)
- **Cost:** Turns require vias (M1→M2 via at bend; increases via count)
- **Not sacrosanct:** Short jogs allowed (tools auto-adjust; not strict rule)

**Interconnect resistance:**
- **Formula:** R = ρL/(T×W) = R_s(L/W), where R_s = ρ/T (sheet resistance)
- **Sheet resistance (R_s):** ρ/T (Ω/□); fixed for given layer (T fixed); from foundry (in LEF/library)
- **Skin effect:** High frequency → current flows on surface (inner area unused) → effective A↓ → R↑
  - **Impact:** Wider/thicker wires (top layers, clock routes) at high frequency

**Interconnect capacitance:**
- **Origin:** Electric field in surrounding dielectric (ILD) changes when wire voltage changes → energy stored → capacitance
- **Factors:** Geometry (wire dimensions), environment (nearby wires), dielectric property (ε_r)
- **Components (simple: 1 wire, substrate):**
  1. **Parallel-plate capacitance:** C_pp = ε₀·ε_r·(W×L)/T_D (bottom surface ↔ substrate; ε_r=SiO₂≈3.9)
  2. **Fringe capacitance:** C_fringe (field lines from sidewalls → substrate; scales with T×L)
  - **Scaling:** W↓, T constant → sidewall area dominates → C_fringe increasingly important
- **Components (complex: multiple wires):**
  1. **Overlap capacitance:** Between wires in different planes (overlapping regions; e.g., M2 ↔ M3)
  2. **Lateral capacitance:** Between parallel wires in same plane (sidewall-to-sidewall; e.g., M2 ↔ M2_adjacent)
  3. **Fringe capacitance:** Between wires in different planes via sidewalls (non-overlapping)
- **Computation:** Non-trivial (complex 3D geometry) → numerical simulation, field solvers (tools automate)

**Design implications:**
- **Reduce C_L:** Increase spacing (↑D → ↓C_pp), reduce overlap, use low-κ dielectric (ε_r↓ → C↓)
- **Layer selection:** Upper layers (thicker T) → lower R_s → use for critical nets (clock, power)

## Methods/flows
**FEOL (device fabrication):**
1. Ion implantation (wells, source/drain, V_TH adjust) → photoresist mask → anneal
2. STI (isolation) → etch trenches → fill SiO₂ → CMP
3. Gate oxide (grow/deposit 2-3nm SiO₂/HfO₂) → deposit polysilicon → pattern (lithography + etch)

**BEOL (interconnect fabrication, dual damascene):**
1. Etch hollow spaces (vias + wires) in ILD (SiO₂)
2. Deposit barrier layer (Ta/TiN; prevent Cu diffusion)
3. Electroplate Cu (fill hollow spaces)
4. CMP (planarize; remove excess Cu)

**Resistance calculation:**
- R = R_s(L/W); R_s from LEF/library (e.g., M1: R_s=0.1Ω/□; L=10μm, W=0.5μm → R=0.1×(10/0.5)=2Ω)

**Capacitance estimation (simple model):**
- C_pp = ε₀·ε_r·(W×L)/T_D (ε₀=8.85×10⁻¹² F/m, ε_r=3.9 for SiO₂)
- **Example:** W=0.5μm, L=10μm, T_D=1μm → C_pp = 8.85×10⁻¹² × 3.9 × (0.5×10)/1 ≈ 172aF

## Constraints/assumptions
- **Thickness fixed:** For given layer, T fixed (designer controls L, W only; T from foundry)
- **Preferred direction:** Not strict rule (short jogs allowed; eases routing)
- **Capacitance approximation:** Simple models (parallel-plate, fringe) for intuition; tools use field solvers (accurate 3D)
- **Copper migration:** Barrier layer (Ta/TiN) mandatory (Cu diffuses into SiO₂/Si; damages transistors)

## Examples
**Sheet resistance (M1):**
- ρ_Cu=1.7×10⁻⁸ Ω·m, T_M1=0.5μm → R_s = 1.7×10⁻⁸/(0.5×10⁻⁶) = 0.034Ω/□
- Wire: L=10μm, W=0.5μm → R = 0.034×(10/0.5) = 0.68Ω

**Capacitance (parallel-plate):**
- W=0.5μm, L=10μm, T_D=1μm, ε_r=3.9 → C_pp = 8.85×10⁻¹² × 3.9 × (0.5×10⁻⁶ × 10×10⁻⁶)/(1×10⁻⁶) = 172aF

**Scaling impact:**
- W↓ (0.5μm→0.2μm), T constant (0.5μm) → sidewall area (T×L) dominates bottom area (W×L) → C_fringe > C_pp

## Tools/commands
- **Field solvers:** Cadence Quantus QRC, Synopsys StarRC (parasitic extraction; compute R, C from layout)
- **LEF files:** Contain R_s, C_per_unit_area for each layer (read by place & route tools)
- **SPEF:** Standard Parasitic Exchange Format (post-routing; R, C values for nets)

## Common pitfalls
- Assuming thickness (T) controllable by designer (T fixed for given layer; only L, W controllable)
- Ignoring fringe capacitance (advanced nodes: W↓, T constant → C_fringe dominates)
- Using simple C_pp formula for complex geometries (multiple nearby wires → need field solvers)
- Violating preferred direction excessively (increases via count, routing congestion)
- Not considering skin effect (high-frequency clocks on wide/thick wires → R↑)
- Forgetting barrier layer (Cu diffuses → transistor damage; Ta/TiN mandatory)

## Key takeaways
- IC fabrication: FEOL (devices in Si substrate: transistors via ion implantation, STI, gate oxide/poly), BEOL (metal interconnects via dual damascene: etch→barrier→Cu→CMP)
- Interconnects: Wiring layers (parallel to substrate; M1, M2, ...), via layers (perpendicular; V1, V2, ...)
- Thickness fixed: For given layer, T fixed by foundry; designer controls L, W (2D layout; T implicit)
- Thickness scaling: Upper layers thicker (M6>M1) → lower R_s → use for critical nets (clock, power)
- Preferred direction: M1→y, M2→x, M3→y, ... (alternating; eases routing; turns require vias)
- Sheet resistance: R_s=ρ/T (Ω/□); R=R_s(L/W) (from LEF/library; T fixed for layer)
- Skin effect: High frequency → current on surface → effective A↓ → R↑ (wide/thick wires, clocks)
- Capacitance origin: Electric field in ILD changes when wire voltage changes → energy stored
- Capacitance components: Parallel-plate (bottom↔substrate), fringe (sidewalls), lateral (parallel wires in same plane), overlap (wires in different planes)
- Scaling impact: W↓, T constant → sidewall area dominates → fringe capacitance increasingly important
- Capacitance reduction: ↑spacing (↑D → ↓C), ↓overlap, low-κ dielectric (ε_r↓ → C↓)
- Dual damascene: Vias + wires together (etch→barrier(Ta/TiN)→Cu(electroplate)→CMP)
- Copper benefits: Low ρ, electromigration resistance; barrier needed (prevent diffusion→transistor damage)

**Cross-links:** See Lec45: Signal integrity, antenna effect, LEF files; Lec26: Technology library (.lib: sheet resistance, capacitance models); Lec06: VLSI flow (physical design phase)

---

*This summary condenses Lec44 from ~12,000 tokens, removing repeated fabrication process diagrams, redundant parasitic calculation examples, and verbose ion implantation descriptions.*
