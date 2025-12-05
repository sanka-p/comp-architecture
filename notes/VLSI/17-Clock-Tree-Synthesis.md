## OpenROAD Practical: Clock Tree Synthesis (CTS)

Define clocks and run CTS with buffer/inverter cells and routing layers configured.

```tcl
# Load design at placed stage
read_lef tech.lef stdcell.lef
read_def placed.def
read_liberty fast.lib slow.lib
read_sdc constraints.sdc

# Define (or confirm) clocks in SDC; example:
# create_clock -name clk -period 10 [get_ports clk]

# CTS options: specify buffers/inverters and layers
set_clock_tree_options \
	-buf_list {CLKBUF_X2 CLKBUF_X4} \
	-inv_list {CLKINV_X1} \
	-target_skew 0.05 \
	-root_buffer CLKBUF_X8 \
	-cts_layers {metal5 metal6}

# Run CTS
cts

# Post-CTS checks
report_clock_tree
write_def cts.def
```

Notes:
- Ensure buffer/inverter names match your library.
- Use appropriate Liberty corners and SDC constraints before CTS.
# Clock Tree Synthesis (CTS)

> **Chapter Overview:** CTS builds a realistic clock distribution network to minimize skew and meet timing, replacing the ideal clock assumption from synthesis. This chapter covers skew/insertion delay, global vs local networks, tree/mesh architectures, useful skew, and post-CTS timing updates.

**Prerequisites:** [[16-Placement]]  
**Related Topics:** [[18-Routing]], [[08-Static-Timing-Analysis]]

---

## 1. Why CTS (Lec51)

- Synthesis assumes ideal clock (zero skew); physical clock has delay and skew.
- CTS objective: minimize skew, maintain signal quality, and manage power (clock nets can be 25–70% of dynamic power).

---

## 2. Terminology

- Source: clock origin (SDC create_clock / generated_clock)
- Sinks: FF clock pins
- Insertion delay (latency): source → sink delay
- Skew: time difference between sinks (global skew = max |δ|)

---

## 3. Clock Distribution

### 3.1 Buffers/Inverters

- Split long wires to reduce delay and restore slew; enhance drive for large loads.

### 3.2 Global vs Local

- Global distribution (planned, large buffers) feeds local trees (automated CTS to individual FFs).

### 3.3 Architectures

- Symmetric trees: H-tree/X-tree (equal lengths → near-zero skew ideal; PVT variations remain)
- Non-tree: cross-links; mesh (redundant paths → very low skew, robust; higher power)

---

## 4. Useful Skew

- Controlled skew to rebalance slack across FFs; can improve f_max.
- Compute optimum delay; check hold (setup improves, hold can worsen).
- Side benefit: reduces instantaneous current peaks (IR drop) by staggering FF toggling.

---

## 5. Post-CTS Timing and Flow (Lec51, Lec54)

- Build buffers, route clock nets (and local trees), place inserted cells.
- Update timing to use actual clock latencies: `set_propagated_clock [all_clocks]`.
- Run parasitic estimate (placement-based) and repair timing (setup/hold), then freeze clock network.

---

## 6. Key Takeaways

1. CTS minimizes skew but cannot eliminate it (PVT variations).
2. Trees vs mesh: mesh lowers skew but raises power.
3. Useful skew must be computed and verified for both setup and hold.
4. Post-CTS, use propagated clocks and repair timing before freezing the clock network.

---

## Tools

- CTS: Innovus `clock_design`, ICC2 `clock_opt`, OpenROAD `clock_tree_synthesis`
- Timing repair: `repair_timing`, STA updates with propagated clocks

---

## Common Pitfalls

- Assuming zero skew achievable
- Over-buffering (power explosion)
- Applying useful skew without hold checks
- Forgetting to switch to propagated clocks post-CTS

---

## Further Reading

- [[18-Routing]]: Signal routing after CTS
- [[08-Static-Timing-Analysis]]: Setup/hold and skew interaction
- [[15-Chip-Planning-and-Floorplanning]]: Power planning affects clock distribution
