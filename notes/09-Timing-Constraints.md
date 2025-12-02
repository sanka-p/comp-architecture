# Timing Constraints (SDC)

> **Chapter Overview:** The Synopsys Design Constraints (SDC) file conveys design requirements to synthesis and STA tools—clock definitions, I/O environment, and timing exceptions. This chapter covers clock constraints, I/O delays/loads/slews, and exceptions like false paths and multi-cycle paths.

**Prerequisites:** [[08-Static-Timing-Analysis]]  
**Related Topics:** [[11-Timing-Driven-Optimization]], [[21-EDA-Tools-and-Tutorials]]

---

## 1. Role of Constraints

- Constraints are written by designers to encode requirements tools cannot infer.
- Synthesis strives to meet constraints; STA verifies if they are met.
- Format: ASCII `.sdc` (TCL syntax) with commands that reference design objects.

---

## 2. Clock Constraints (Lec32)

### 2.1 Primary and Generated Clocks

- Primary: `create_clock -name CLK -period 10 [get_ports clk_in]` (waveform independent)
- Generated: `create_generated_clock -name GCLK -divide_by 2 -source [get_pins U1/clk] [get_pins U2/gclk]`

### 2.2 Latency and Uncertainty

- Source latency (external), network latency (internal)
  - `set_clock_latency -source 5 [get_clocks CLK]`
  - `set_clock_latency 10 [get_clocks CLK]`
- Uncertainty (jitter+skew+margins): pessimistic
  - Setup: subtract from required time; Hold: add to required time
  - `set_clock_uncertainty -setup 20 [get_clocks CLK]`
  - `set_clock_uncertainty -hold 15 [get_clocks CLK]`

### 2.3 Clock Transition

- Models finite clock slew; affects FF setup/hold
  - `set_clock_transition 10 [get_clocks CLK]`

---

## 3. I/O Constraints (Lec33)

### 3.1 Input Delay and Transition

- `set_input_delay <val> -clock CLK [get_ports IN]`
  - External FF clk→q + external comb delay + wire
- Slew: `set_input_transition <val> [get_ports IN]` or more accurate `set_driving_cell -lib_cell <cell> [get_ports IN]`

### 3.2 Output Delay and Load

- `set_output_delay <val> -clock CLK [get_ports OUT]`
  - Derivation (setup): wire − external clock delay + external setup
- Load: `set_load <cap> [get_ports OUT]` (wire + pin capacitance)

### 3.3 Virtual FF Model

- STA assumes ideal FF at output ports (setup/hold=0)
- `set_output_delay` encodes external FF constraints equivalently

---

## 4. Timing Exceptions

### 4.1 False Path

- Disable timing analysis along functional non-propagating paths
  - `set_false_path -from [get_pins FF1/Q] -to [get_pins FF2/D]`

### 4.2 Multi-Cycle Path

- Allow N cycles for data propagation
  - `set_multi_cycle_path N -setup -from <start> -to <end>`
  - `set_multi_cycle_path N-1 -hold -from <start> -to <end>`

### 4.3 Case Analysis (Mode-specific)

- Force signals for mode SDCs: `set_case_analysis 1 [get_ports scan_enable]`

---

## 5. Key Takeaways

1. Constraints encode designer intent: clocks, environment, exceptions.
2. Uncertainty is pessimistic (setup decreases required, hold increases required).
3. I/O delays/loads/slews model the external system attached to the block.
4. Use `set_driving_cell` for realistic input slews; `set_load` for realistic output loads.
5. Exceptions (false/multi-cycle) reduce pessimism—apply only when functionally valid.

---

## Common Pitfalls

- Assuming `create_clock` creates hardware (it doesn't)
- Wrong sign in output delay derivation
- Forgetting hold adjustment for multi-cycle (`-hold N-1`)
- Global `set_case_analysis` applied to all modes

---

## Further Reading

- [[08-Static-Timing-Analysis]]: How STA uses SDC
- [[11-Timing-Driven-Optimization]]: Optimization responding to constraints
- [[21-EDA-Tools-and-Tutorials]]: OpenSTA scripts and usage
