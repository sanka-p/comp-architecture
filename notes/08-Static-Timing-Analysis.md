# Static Timing Analysis (STA)

> **Chapter Overview:** STA verifies that a synchronous design meets timing without test vectors by analyzing delays, slews, and constraints across data and clock paths. This chapter covers setup/hold, timing graphs, slew propagation (GBA/PBA), and variations (MMMC/OCV), with practical OpenSTA checks.

**Prerequisites:** [[07-Technology-Libraries]]  
**Related Topics:** [[09-Timing-Constraints]], [[11-Timing-Driven-Optimization]]

---

## 1. Goals and Concepts

- Ensure valid states each cycle (no zero/double clocking)
- Verify frequency target from SDC clock period
- Check setup (late) and hold (early) constraints for every FF pair
- Static (no vectors), pessimistic worst-case analysis

---

## 2. Setup and Hold (Lec28)

### 2.1 Setup (avoid zero clocking)

Constraint:
$$T_{period} \ge \delta_{LC} + T_{clk\to q}^{max} + T_{data}^{max} + T_{setup}^{max}$$

- Data arrives before capture edge
- Uses max (late) delays; depends on clock period

### 2.2 Hold (avoid double clocking)

Constraint:
$$\delta_{LC}^{min} + T_{clk\to q}^{min} + T_{data}^{min} \ge T_{hold}^{max}$$

- Data doesn't reach capture FF too early (same edge)
- Uses min (early) delays; independent of clock period

---

## 3. Timing Graph and Delay Calculation (Lec29)

### 3.1 Graph G=(V, E)

- Vertices: pins/ports
- Edges: timing arcs (cell arcs from .lib, net arcs from netlist)

### 3.2 Stage Model

- Driver cell + interconnect + receivers
- Delay calculator uses .lib tables (NLDM/CCS), SPEF RC, input slew → outputs edge delay and output slew

### 3.3 Arrival and Required Times

- Arrival (forward): A_j = max(A_i + D_ij)
- Required (backward): R_i = min(R_j - D_ij) for setup; max for hold

---

## 4. Slew Propagation and Variations (Lec30)

- Monotonicity: ↑ input slew → ↑ delay, ↑ output slew

#### GBA (Graph-Based Analysis)
- Fast, safe; pessimistic (arrival and slew may come from different paths)
#### PBA (Path-Based Analysis)
- Propagate arrival and slew along same path
- Accurate, expensive; use on failing GBA paths to remove false violations

- OCV: On-chip variation derating (local variations)
  - Setup (late): data/clock-launch derate > 1, clock-capture derate < 1
  - Hold (early): data/clock-launch derate < 1, clock-capture derate > 1
---

## 5. OpenSTA Tutorial Highlights (Lec31)

Inputs:
- Constraints (SDC)

Commands:

Observations:
- Arrival = input delay + path delay
- Required = period − output delay − uncertainty
- Slack decreases with higher input transition or output load

---

## 6. Key Takeaways

1. STA checks timing safety without vectors; pessimistic worst-case ensures robustness.
2. Setup uses late (max) delays; hold uses early (min) delays; hold independent of period.
3. Timing graph traversal is single-pass; store rise/fall, min/max bounds.
4. Slew propagation needs bounds; GBA default (fast), PBA for critical paths (accurate).
5. MMMC handles global PVT/mode/RC scenarios; OCV derates for local variations.
6. OpenSTA replicates commercial flows for learning and validation.

---

## Common Pitfalls

- Confusing setup with hold effects
- Ignoring slew propagation (delay depends on slew)
- Forgetting net arcs/SPEF (interconnect can dominate)
- Assuming PBA by default (most tools use GBA and selective PBA)
- Misapplying OCV (same derate for all paths)

---

## Further Reading

- [[09-Timing-Constraints]]: SDC clocks, I/O delays, exceptions
- [[11-Timing-Driven-Optimization]]: Gate sizing, buffering, retiming
- [[07-Technology-Libraries]]: Liberty models used by STA
