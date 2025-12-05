# Physical Design Basics

> **Chapter Overview:** Physical design turns the netlist into manufacturable layout. This chapter covers fabrication context (FEOL/BEOL), interconnect resistance/capacitance, preferred routing directions, signal integrity, antenna effect, and the role of LEF.

**Prerequisites:** [[07-Technology-Libraries]]  
**Related Topics:** [[15-Chip-Planning-and-Floorplanning]], [[16-Placement]], [[18-Routing]]

---

## 1. Fabrication Context (Lec44)

- FEOL: Devices (ion implantation, STI, gate stack)
- BEOL: Interconnect (dual-damascene: etch → barrier (Ta/TiN) → Cu electroplate → CMP)
- Upper metals are thicker → lower sheet resistance; use for clocks/power

---

## 2. Interconnect Parasitics (Lec44)

### 2.1 Resistance

- Sheet resistance: \(R_s = \rho / T\) (Ω/□); wire \(R = R_s \cdot L/W\)
- Skin effect at high frequency → effective area ↓ → R ↑ on wide/thick clock routes

### 2.2 Capacitance

- Components: parallel-plate (bottom↔substrate), fringe (sidewalls), lateral (same-layer neighbors), overlap (cross-layer)
- Reduce C: increase spacing, reduce overlap, use low-κ dielectrics

### 2.3 Preferred Direction

- Alternating layer directions (e.g., M1 vertical, M2 horizontal) eases routing; turns require vias

---

## 3. Signal Integrity (Lec45)

### 3.1 Crosstalk

- Coupling C causes dynamic delay variation: same-direction transitions → negative increment; opposite → positive increment
- Glitches: aggressor toggles, victim held → transient bumps/dips; critical on clock/reset/control

### 3.2 SI-aware STA

- Base delay ± incremental delay from coupling → adjusted slack
- Noise propagation models in libraries support glitch analysis

---

## 4. Antenna Effect (Lec45)

- Plasma charging during BEOL → discharge through thin gate oxide → damage
- Antenna ratio = conductor area / gate oxide area; foundry enforces max limits
- Fixes: layer jumps, diode insertion, wire splitting

---

## 5. LEF Files (Lec45)

- Technology LEF: layers, directions, width/spacing, pitch, R_s, C per unit, antenna rules
- Cell LEF: abstract cell geometry (size, pin locations, obstructions) for placement/routing

---

## 6. Key Takeaways

1. Interconnect parasitics dominate timing/power at advanced nodes.
2. SI and antenna rules are first-class constraints alongside timing.
3. LEF abstracts layout to enable fast place & route.

---

## Tools

- Extraction: StarRC, Quantus (→ SPEF)
- SI-aware STA: PrimeTime SI, Tempus
- DRC/antenna: Calibre, ICV

---

## Common Pitfalls

- Ignoring fringe/lateral C in advanced nodes
- Not performing SI-aware timing (miss real violations)
- Neglecting antenna fixes post-route

---

## Further Reading

- [[16-Placement]]: Placement stages and timing-driven methods
- [[18-Routing]]: Routing algorithms, DRCs, SI fixes
- [[15-Chip-Planning-and-Floorplanning]]: Die/utilization, IO planning, macros
