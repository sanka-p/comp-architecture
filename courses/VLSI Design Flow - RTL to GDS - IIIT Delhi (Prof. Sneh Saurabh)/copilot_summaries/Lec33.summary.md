# Lec33 — Constraints Part II: I/O Constraints and Timing Exceptions

## Overview
Covers environmental constraints (set_input_delay, set_output_delay, set_input_transition, set_driving_cell, set_load) to model external environment, and functional constraints (set_false_path, set_multi_cycle_path, set_case_analysis) for timing exceptions and multi-mode analysis.

## Core concepts
**Environmental constraints (I/O):**
- **Purpose:** Model external circuit delays (before input ports, after output ports); ensure setup/hold met for external flip-flops
- **Why needed:** Design is part of larger system (top-level + sub-blocks); external delays consume part of clock cycle → must be accounted for
- **Input delay:** `set_input_delay <val> -clock <clk> [get_ports <port>]`
  - Value = delay of external combinational logic + external FF clock→Q + external wire delay
  - Example: External FF (T_clk→q=0.2ns) + logic (D_ext=0.4ns) + wire (0.1ns) → set_input_delay 0.7 [get_ports IN]
- **Output delay:** `set_output_delay <val> -clock <clk> [get_ports <port>]`
  - Value = external wire delay - external clock delay + external FF setup time
  - **Derivation (setup):** T_int + T_OD < T_clk (internal delay + output delay < clock period)
    - Actual constraint: T_int + D_wire < T_clk + T_clk_ext - T_setup_ext
    - → T_OD = D_wire - T_clk_ext + T_setup_ext (ensure equivalence)
  - Example: D_wire=400ps, T_clk_ext=20ps, T_setup_ext=30ps → T_OD=400-20+30=410ps
- **Input transition:** `set_input_transition <val> [get_ports <port>]`
  - Specifies slew of incoming signal (needed for delay calculation of gates connected to input port)
  - Separate values for rise/fall, max/min: `-max`, `-min`, `-rise`, `-fall`
- **Driving cell:** `set_driving_cell -lib_cell <cell> -library <lib> [get_ports <port>]`
  - Alternative to set_input_transition (more accurate; models non-linear driver behavior)
  - Creates virtual stage: driver cell → wire → input port (delay calculator computes waveform at port)
- **Output load:** `set_load <val> [get_ports <port>]`
  - Specifies external capacitive load (wire + input pin capacitance)
  - Needed for accurate delay calculation of gates driving output port

**Timing exceptions:**
- **False path:** `set_false_path -from <start> -to <end>`
  - Disables timing analysis for specified path (signal functionally cannot propagate; e.g., mutually exclusive conditions)
  - **Benefit:** Avoids false violations; relaxes timing → area/power savings
  - Example: `set_false_path -from [get_pins FF1/Q] -to [get_pins FF2/D]` (if signal never propagates FF1→FF2 due to Boolean logic)
- **Multi-cycle path:** `set_multi_cycle_path <N> -setup -from <start> -to <end>`
  - Allows data N clock cycles to propagate (instead of default 1 cycle)
  - **Setup:** `-setup <N>` → check at Nth clock edge (instead of 1st edge)
  - **Hold:** `-hold <N-1>` → check at (N-1)th edge (instead of 0th edge; expands window)
  - **Reason:** Functional behavior (e.g., data valid every 4 cycles) → relax timing → area savings
  - Example: `set_multi_cycle_path 4 -setup -from FF1/CP -to FF2/D; set_multi_cycle_path 3 -hold -from FF1/CP -to FF2/D` (setup@4th edge, hold@0th edge)
- **Case analysis:** `set_case_analysis <0|1> [get_ports <port>]`
  - Forces port/pin to constant value for specific mode (used in MMMC for mode-specific SDC files)
  - Example: scan.sdc: `set_case_analysis 1 [get_ports scan_enable]` (scan mode: scan_enable=1)

**Virtual flip-flop (output port):**
- **Model:** STA tool assumes ideal FF at output port (setup/hold time=0, no clock delay)
- **set_output_delay encodes external constraints:** T_OD = external delays + external setup time
- **Equivalence:** Actual circuit (external FF with setup time) ≡ virtual circuit (ideal FF + output delay constraint)

## Methods/flows
1. **Input constraints:**
   - Compute input delay: T_in_delay = T_clk→q_ext + D_comb_ext + D_wire_ext
   - `set_input_delay <T_in_delay> -clock <clk> [get_ports <port>]`
   - `set_input_transition <slew> [get_ports <port>]` OR `set_driving_cell -lib_cell <cell> [get_ports <port>]`
2. **Output constraints:**
   - Compute output delay: T_out_delay = D_wire_ext - T_clk_ext + T_setup_ext (setup); = D_wire_ext - T_clk_ext + T_hold_ext (hold)
   - `set_output_delay <T_out_delay> -clock <clk> [get_ports <port>]`
   - `set_load <C_load> [get_ports <port>]` (external wire + pin capacitance)
3. **False path:** `set_false_path -from [get_pins <start>] -to [get_pins <end>]` (disable timing on path)
4. **Multi-cycle path:** `set_multi_cycle_path <N> -setup -from <start> -to <end>; set_multi_cycle_path <N-1> -hold -from <start> -to <end>` (N cycles for data propagation)
5. **Mode-specific:** Create separate SDC files (func.sdc, scan.sdc, sleep.sdc); use `set_case_analysis` to force mode signals

## Constraints/assumptions
- **Synchronous system:** Top-level + sub-blocks share clock source (I/O constraints ensure global setup/hold)
- **Virtual FF assumption:** Output port has ideal FF (setup/hold=0) → actual external FF constraints encoded in set_output_delay
- **Input transition vs driving cell:** set_input_transition assumes linear waveform (limited accuracy); set_driving_cell more accurate (non-linear CCS/ECS models)
- **False path:** Use only if signal functionally cannot propagate (verified via simulation/formal); incorrect usage → missing real violations
- **Multi-cycle path:** Requires functional guarantee (data valid every N cycles); incorrect N → violations

## Examples
- **Input delay:** External FF (clk→q=0.2ns) + logic (0.4ns) + wire (0.1ns) → `set_input_delay 0.7 -clock CLK [get_ports IN]`
- **Output delay:** Wire delay=400ps, ext. clock delay=20ps, ext. setup=30ps → OD=400-20+30=410ps → `set_output_delay 410 -max -clock sys_clk [get_ports OUT]`
- **Input transition:** `set_input_transition 10 -max -rise [get_ports A]` (rise slew=10ps)
- **Driving cell:** `set_driving_cell -lib_cell buff_1x -library tech_14nm [get_ports IN]` (virtual buff_1x driver)
- **Output load:** External wire (0.02pF) + pin (0.019pF) → `set_load 0.039 [get_ports OUT]`
- **False path:** `set_false_path -from [get_pins FF1/Q] -to [get_pins FF2/D]` (signal never propagates due to functional logic)
- **Multi-cycle (4 cycles):** `set_multi_cycle_path 4 -setup -from FF1/CP -to FF2/D; set_multi_cycle_path 3 -hold -from FF1/CP -to FF2/D` (setup@4th edge, hold@0th edge)

## Tools/commands
- **I/O constraints:**
  - `set_input_delay [-max|-min] [-rise|-fall] <val> -clock <clk> [get_ports <port>]`
  - `set_output_delay [-max|-min] [-rise|-fall] <val> -clock <clk> [get_ports <port>]`
  - `set_input_transition [-max|-min] [-rise|-fall] <val> [get_ports <port>]`
  - `set_driving_cell -lib_cell <cell> -library <lib> [get_ports <port>]`
  - `set_load <val> [get_ports <port>]`
- **Timing exceptions:**
  - `set_false_path -from [get_pins <start>] -to [get_pins <end>]`
  - `set_multi_cycle_path <N> [-setup|-hold] -from <start> -to <end>`
  - `set_case_analysis <0|1> [get_ports <port>]`

## Common pitfalls
- Forgetting I/O constraints (internal timing OK, but fails when integrated into top-level)
- Incorrect output delay calculation (sign errors: subtract clock delay, add setup time)
- Using set_input_transition for non-linear signals (use set_driving_cell instead)
- False path on functionally valid path (missing real violations → chip failure)
- Multi-cycle without hold adjustment (hold checked at wrong edge → false violations or real violations missed)
- set_case_analysis in all modes (should be mode-specific; e.g., scan_enable=1 only in scan.sdc)

## Key takeaways
- I/O constraints: Model external environment (delays before input, after output; ensure global setup/hold)
- set_input_delay: External FF clk→q + logic + wire delays (consumes part of clock cycle)
- set_output_delay: Wire delay - clock delay + setup time (ensure external FF meets timing)
- set_input_transition: Slew of incoming signal (needed for delay calc); set_driving_cell more accurate (non-linear)
- set_load: External capacitance (wire + pin) for output port delay calculation
- False path: Disable timing analysis (signal functionally cannot propagate) → avoid false violations, relax timing
- Multi-cycle path: Allow N cycles for data propagation (setup@Nth edge, hold@0th edge with `-hold N-1`)
- set_case_analysis: Force port/pin to constant value (mode-specific SDC files: scan.sdc, sleep.sdc)
- Virtual FF: STA assumes ideal FF at output port (setup/hold=0); actual constraints encoded in set_output_delay
- I/O constraints critical: Design OK internally, but fails when integrated (external delays not accounted for)
- Timing exceptions reduce pessimism: False paths, multi-cycle → area/power savings (but verify functional correctness)

**Cross-links:** See Lec32: Clock constraints (create_clock, latency, uncertainty); Lec28-30: STA (uses I/O constraints to compute arrival/required times); Lec26: .lib (delay depends on input slew, output load); Lec30: MMMC (mode-specific SDC files)

---

*This summary condenses Lec33 from ~17,000 tokens, removing repeated I/O delay derivation examples, redundant multi-cycle path timing diagrams, and verbose set_output_delay calculation walkthroughs.*
