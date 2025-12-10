## Overview of Physical Design 

**Physical design** is the process by which a design in the form of a **netlist** is converted to an equivalent design in the form of a **layout** (GDS - Geometric Data Stream).
### Inputs to Physical Design

1. **Netlist**
   - Design obtained after logic synthesis
   - Contains standard cells picked from technology libraries
   
2. **Technology Library (Liberty format)**
   - Same library used during logic synthesis
   - Contains timing, power, and functional information
   
3. **Physical Library (LEF - Library Exchange Format)**
   - Contains physical information of standard cells in abstract form
   - Includes:
     - Bounding box dimensions
     - Pin locations
     - Sheet resistance
     - Technology information
   - Required for placement and routing decisions
   
4. **Constraints (SDC format)**
   - Modified version of constraints used in logic synthesis
   - Defines design goals:
     - Expected timing behavior
     - Maximum operable frequency
     - Input/output signal characteristics
   - Additional information about wires and routing
   
5. **Floorplan**
   - Die size and shape (aspect ratio)
   - Predefined locations for entities (I/O pins/pads, blocks)
   - Given in proprietary format understood by physical design tools

### Output of Physical Design

- **Layout (GDS format)**
  - All entities placed at specific locations
  - Connectivity same as in netlist
  - Includes:
    - **Placement** information for all entities
    - **Routing** information (wires on different metal layers)

---

## Major Physical Design Tasks

1. **Chip Planning**
2. **Placement**
3. **Clock Tree Synthesis (CTS)**
4. **Global Routing**
5. **Detailed Routing**
6. **ECO (Engineering Change Order)**
7. **Write GDS**

## 5. ECO (Engineering Change Order) (Lec07)

After implementation is complete, **ECO** makes small, controlled changes to fix problems found during verification or to address new requirements.

### Characteristics:
- Very careful approach to avoid introducing new bugs
- Small, targeted fixes
- Controlled changes to maintain design integrity

---

## 6. Tapeout (Lec07)

**Tapeout** is the final step where the completed GDS is sent to the foundry for fabrication.

- GDS defines features on the mask for photolithography
- Marks the end of the design implementation phase
- Occasion for celebration for the design team

---

## 7. Optimization Steps (Lec07)

Between major physical design tasks, **optimization steps** are introduced for incremental refinements.

### Optimization Techniques:

1. **Buffering**
   - Insert buffers on long wires to improve delay
   - Change buffer locations or sizes

2. **Cell Sizing**
   - Increase size: improve performance, meet slew criteria
   - Decrease size: improve power, meet design goals

3. **Placement Tweaking**
   - Minor location changes to optimize timing

4. **Routing Adjustments**
   - Small routing changes to improve timing/QoR

### Optimization Principles:

- **Incremental changes only** - avoid large disruptions
- **Targeted optimization** - fix specific regions, not entire layout
- **Convergence** - ensure design closure is achievable
	- Iterative process - one task may require that previous tasks retract some design decisions
	- This creates loops in the physical design flow

---

## 8. Verification and Design Closure (Lec07)

Throughout physical design, verification is performed for:
- Timing
- Power
- Signal integrity

**Design Closure:** Achieved when all properties the design should satisfy are met.

**Challenge:** Achieving design closure is difficult because:
- Design tasks are interdependent
- Changes in one area can affect others
- Iterative process to converge on solution

---

## 10. Fabrication Context (Lec44)

- FEOL: Devices (ion implantation, STI, gate stack)
- BEOL: Interconnect (dual-damascene: etch → barrier (Ta/TiN) → Cu electroplate → CMP)
- Upper metals are thicker → lower sheet resistance; use for clocks/power

---

## 11. Interconnect Parasitics (Lec44)

### 11.1 Resistance

- Sheet resistance: \(R_s = \rho / T\) (Ω/□); wire \(R = R_s \cdot L/W\)
- Skin effect at high frequency → effective area ↓ → R ↑ on wide/thick clock routes

### 11.2 Capacitance

- Components: parallel-plate (bottom↔substrate), fringe (sidewalls), lateral (same-layer neighbors), overlap (cross-layer)
- Reduce C: increase spacing, reduce overlap, use low-κ dielectrics

### 11.3 Preferred Direction

- Alternating layer directions (e.g., M1 vertical, M2 horizontal) eases routing; turns require vias

---

## 12. Signal Integrity (Lec45)

### 12.1 Crosstalk

- Coupling C causes dynamic delay variation: same-direction transitions → negative increment; opposite → positive increment
- Glitches: aggressor toggles, victim held → transient bumps/dips; critical on clock/reset/control

### 12.2 SI-aware STA

- Base delay ± incremental delay from coupling → adjusted slack
- Noise propagation models in libraries support glitch analysis

---

## 13. Antenna Effect (Lec45)

- Plasma charging during BEOL → discharge through thin gate oxide → damage
- Antenna ratio = conductor area / gate oxide area; foundry enforces max limits
- Fixes: layer jumps, diode insertion, wire splitting

---

## 14. LEF Files (Lec45)

- Technology LEF: layers, directions, width/spacing, pitch, R_s, C per unit, antenna rules
- Cell LEF: abstract cell geometry (size, pin locations, obstructions) for placement/routing

---

## 15. Key Takeaways

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
