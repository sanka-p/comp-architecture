# Power Analysis and Optimization

> **Chapter Overview:** Power comprises dynamic (switching + short-circuit) and static (leakage) components. This chapter explains the models and flows for estimating power and practical techniques to reduce it—DVFS, power gating, clock gating, and resizing—with tool-based checks.

**Prerequisites:** [[07-Technology-Libraries]], [[08-Static-Timing-Analysis]]  
**Related Topics:** [[11-Timing-Driven-Optimization]], [[21-EDA-Tools-and-Tutorials]]

---

## 1. Power Components (Lec37)

### 1.1 Dynamic Power

- Switching: \(P_{sw} = C_L \cdot V_{DD}^2 \cdot \alpha \cdot f_{clk}\)
- Short-circuit: \(P_{sc} = V_{DD} \cdot I_{SC}\) (PMOS and NMOS both ON during slow input transitions)
- Total dynamic: \(P_{dyn} = P_{sw} + P_{sc}\)

### 1.2 Static Power

- Leakage: \(P_{leak} = V_{DD} \cdot I_{leak}\)
- Sources: sub-threshold, gate oxide tunneling, junction leakage

### 1.3 Total Power

\(P_{total} = P_{dyn} + P_{leak} = (C_L\,V_{DD}^2\,\alpha\,f_{clk} + V_{DD}\,I_{SC}) + V_{DD}\,I_{leak}\)

---

## 2. Library Power Models

- Internal power (NLP): energy/transition as a 2D table vs input slew and output load; multiply by \(\alpha\,f_{clk}\) to get power
- External power: energy in external capacitances (wire + pin caps) \(E_{ext} = (C_{wire}+\sum C_{pin})\,V_{DD}^2\)
- Leakage: `cell_leakage_power` and conditional `leakage_power { when: ... }` based on input values

---

## 3. Estimation Flows

### 3.1 Simulation-Based (Vector)

- RTL/gate simulation → VCD → SAIF (activity) → tool computes \(\alpha\)
- High accuracy if workload representative; application-dependent

### 3.2 Probabilistic (Vectorless)

- Assume input probabilities → propagate through logic → infer activity; less accurate (correlations)

### 3.3 Inputs

- Netlist, .lib (NLP/leakage), SPEF (post-route), activity (SAIF or defaults)

---

## 4. Optimization Techniques (Lec38)

### 4.1 DVFS (Dynamic Voltage/Frequency Scaling)

- Reduce \(V_{DD}\) and \(f_{clk}\) based on workload; power \(\propto V^2 f\); energy improves but less than power (longer runtime)
- Controller adjusts rails and clock; firmware/hardware loop

### 4.2 Power Gating

- Disconnect supply for idle blocks (switching cells: header/footer); add retention cells (save/restore) and isolation cells (force outputs)
- Eliminates dynamic + leakage during sleep; area/complexity overhead

### 4.3 Clock Gating

- Disable clock when data not updating; use ICG (latch + AND) to avoid glitches
- 20–40% dynamic savings in clock tree + FF internals

### 4.4 Resizing (for Power)

- Downsize non-critical cells to reduce input caps → lower driver switching power; verify timing via slack

---

## 5. OpenSTA Tutorial Highlights (Lec41)

- Internal power from NLP tables (energy/transition × activity × frequency)
- Switching power from external C_L and \(V_{DD}^2\)
- Leakage from `cell_leakage_power`
- `set_power_activity` controls activity; post-route adds wire capacitance via SPEF

---

## 6. Key Takeaways

1. Dynamic power scales with \(V^2\), frequency, activity, and load; leakage grows with technology scaling.
2. Libraries provide internal power and leakage; tools compute external switching from parasitics and pin loads.
3. Use representative workloads (VCD→SAIF) for credible estimates.
4. Combine DVFS, clock gating, power gating, and resizing for practical savings.
5. Verify timing after power optimizations (clock gating, resizing can affect timing).

---

## Tools

- Analysis: PrimeTime PX, Voltus; OpenSTA for learning
- Synthesis: Power Compiler (gating insertion)
- Simulation: VCS, Xcelium (VCD/SAIF generation)

---

## Common Pitfalls

- Treating energy values as power (forgetting \(\times \alpha f\))
- Assuming accurate C_L pre-route (wire C unknown)
- Clock gating with simple AND (glitches; must use ICG)
- Power gating without retention/isolation (functional errors)

---

## Further Reading

- [[11-Timing-Driven-Optimization]]: Interplay with timing
- [[21-EDA-Tools-and-Tutorials]]: Scripts for activity and power reporting
