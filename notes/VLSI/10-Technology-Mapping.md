# Technology Mapping

> **Chapter Overview:** Technology mapping converts an optimized generic netlist into a netlist of standard cells from a technology library. The goal is to preserve functionality while meeting area, delay, and power objectives guided by constraints.

**Prerequisites:** [[05-Logic-Optimization]], [[07-Technology-Libraries]]  
**Related Topics:** [[11-Timing-Driven-Optimization]], [[06-Formal-Verification]]

---

## 1. Inputs and Objectives

- Technology libraries (.lib): functions with sizes (1x/2x/4x), flavors (LVT/HVT)
- Unmapped netlist: generic gates (AND/OR/XOR) with no transistor realization
- Constraints (SDC): clocks, I/O delays, exceptions
- Objective: minimize area, minimize delay, or minimize power (effort-dependent)

---

## 2. Functional Equivalence Requirement

- Mapped netlist must be functionally equivalent to unmapped netlist
- Verified by CEC (Combinational Equivalence Checking) → see [[06-Formal-Verification]]

---

## 3. Multiple Valid Mappings (PPA Trade-offs)

Same logic function → many implementations:

- Min-area: small cells, higher delay
- Min-delay: large cells, higher area/power
- Min-power: HVT cells, longer delay

Example (Y = (A·B + C)'):
- NAND-NAND + INVs (min area)
- NAND-AND + INV (min delay)
- LVT/HVT variants (power vs speed)

---

## 4. Mapping Approaches

### 4.1 Structural Mapping

- Represent library and netlist in base functions (e.g., NAND + INV)
- Structurally match portions to cells; find min-cost cover
- Fast but may miss matches (same Boolean function has many structures)

### 4.2 Boolean Mapping

- Functional comparison (BDDs/Boolean equivalence) between netlist portions and cells
- Canonical representations catch all matches independent of structure
- Preferred in modern tools for accuracy

---

## 5. Flow

1. Load .lib, unmapped netlist, SDC constraints
2. Partition netlist into logic cones
3. For each cone, find candidate cells (structural/Boolean matching)
4. Select cells to meet objective (area/delay/power)
5. Replace generic gates with selected cells
6. Run CEC to verify equivalence

---

## 6. Key Takeaways

1. Technology mapping preserves functionality while choosing standard cells to meet PPA goals.
2. Library richness (sizes, VT options) increases mapping choices and QoR.
3. Multiple valid mappings exist—objective dictates choice.
4. Boolean matching is robust; structural can be fast but incomplete.
5. Always follow with equivalence checking.

---

## Tools

- Yosys: `techmap`, `abc -liberty <lib>`
- Commercial: Design Compiler, Genus
- Equivalence: Formality, Conformal

---

## Common Pitfalls

- Treating mapping as purely structural (misses matches)
- Ignoring constraints (overusing big cells → area/power bloat)
- Skipping CEC (risk of functional mismatch)

---

## Further Reading

- [[11-Timing-Driven-Optimization]]: Post-mapping timing improvements
- [[07-Technology-Libraries]]: Library models and PVT corners
- [[06-Formal-Verification]]: Equivalence checking methods
