# Timing-Driven Optimization

> **Chapter Overview:** After technology mapping, tools target critical paths to meet timing while balancing area and power. This chapter covers resizing, restructuring, fan-out optimization, retiming, and area recovery.

**Prerequisites:** [[08-Static-Timing-Analysis]], [[10-Technology-Mapping]]  
**Related Topics:** [[09-Timing-Constraints]], [[12-Power-Analysis-and-Optimization]]

---

## 1. Flow Overview (Lec35)

1. Run STA → identify critical/near-critical paths
2. If slack < target → optimize
3. Apply transformations (iteratively)
4. Incremental STA on affected cones
5. Stop when timing target met or no improvement
6. Area recovery on non-critical paths

Slack target > 0 before physical design (unknown wire delays) → margin (e.g., 100ps). After P&R, target can be 0.

---

## 2. Transformations

### 2.1 Resizing (Gate Sizing)

- Upsize: faster, lower output slew; higher area/power; higher input cap (hurts driver)
- Downsize: smaller, lower input cap; higher delay/output slew
- Balance fan-in vs fan-out effects; iterate

### 2.2 Restructuring / Rewiring

- Move late-arriving signals closer to outputs
- Symmetric gates: reorder inputs; Asymmetric: Shannon expansion → MUX with cofactors
- Improves critical arrival; increases area (extra MUX, cofactors)

### 2.3 Fan-out Optimization (Buffering)

- High fan-out nets → high load
- Insert buffers to isolate critical sinks or build buffer trees
- Fix max transition/cap violations and improve critical path delay

### 2.4 Retiming

- Move FFs to balance logic across stages
- May add FFs; preserves functional behavior (cycle shift)
- Improves f_max; area/power increase from extra FFs

### 2.5 Area Recovery

- After timing met, downsize non-critical cells to reduce area/power within slack budget

---

## 3. Key Takeaways

1. Post-mapping optimization focuses on critical paths using STA feedback.
2. Resizing trades delay vs area/power via drive strength changes.
3. Restructuring moves critical signals; costs area for cofactors/MUX.
4. Buffering reduces load on critical branches; fixes transition/cap violations.
5. Retiming balances stage delays at the cost of extra FFs.
6. Area recovery reduces area/power once timing is met.

---

## Tools

- Synthesis: Design Compiler (`compile_ultra -timing_driven`), Genus
- STA: PrimeTime, Tempus
- Commands: Timing derates (OCV), PBA for accurate path analysis

---

## Common Pitfalls

- Upsizing indiscriminately (fan-in penalties)
- Restructuring non-critical cones (no timing benefit)
- Over-buffering (area/power explosion)
- Retiming without necessary replication (functional errors)
- Skipping area recovery

---

## Further Reading

- [[12-Power-Analysis-and-Optimization]]: Complementary power-focused techniques
- [[08-Static-Timing-Analysis]]: GBA/PBA, OCV, MMMC
- [[09-Timing-Constraints]]: Constraints shaping optimization
