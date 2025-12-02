# Lec32 — Constraints Part I: Clock Constraints

## Overview
Introduces SDC (Synopsys Design Constraints) format for conveying design requirements to synthesis/STA tools. Covers clock constraints (create_clock, create_generated_clock), clock attributes (latency, uncertainty, transition), and role of constraints in implementation vs verification.

## Core concepts
**Constraints purpose:**
- **Convey requirements:** Designer→tools (synthesis, STA); information tools cannot derive (clock frequency, external environment)
- **Common denominator:** Synthesis tries to meet constraints; STA verifies if met
- **Manually written:** Designer knowledge (external clock frequency, I/O timing, modes); automation tools provide templates only

**SDC format:**
- **ASCII file:** Human-readable (.sdc extension, e.g., top.sdc)
- **TCL syntax:** Tool Command Language (scripting; widely used in VLSI)
- **Commands:** create_clock, set_input_delay, set_output_delay, set_false_path, set_multi_cycle_path, etc.

**Primary vs generated clocks:**
- **Primary clock:** Waveform independent of other clocks (e.g., external clock source)
  - `create_clock -name CLK -period 10 -waveform {0 4} [get_ports clk_in]`
  - Period=10 time units; rise edge@0, fall edge@4 (duty cycle≠50%)
- **Generated clock (derived):** Waveform depends on master clock (e.g., clock divider: divide-by-2)
  - `create_generated_clock -name GCLK -divide_by 2 -source [get_pins CS1/clk] [get_pins CS2/gclk]`
  - Derived from master clock (CS1/clk); frequency÷2

**Clock latency:**
- **Source latency:** Delay before clock source (external path: clock generator → design port)
  - `set_clock_latency -source 5 [get_clocks CLK]` (5 time units before clk_port)
- **Network latency:** Delay within design (port → flip-flop clock pins; buffers, wires)
  - `set_clock_latency 10 [get_clocks CLK]` (10 time units from port → FF clock pins)
- Total latency = source latency + network latency

**Clock uncertainty:**
- **Sources:** (1) Jitter (temporal variation in clock period); (2) Skew (spatial variation; clock arrives at different FFs at different times); (3) Safety margins (e.g., wire delay unknown during synthesis)
- **Pessimism:** Makes timing analysis more restrictive (ensures safety)
  - Setup: Decreases required time (subtracts uncertainty from clock period)
  - Hold: Increases required time (adds uncertainty to same-edge constraint)
- **Command:**
  - `set_clock_uncertainty -setup 20 [get_clocks CLK]` (setup uncertainty=20 time units)
  - `set_clock_uncertainty -hold 15 [get_clocks CLK]` (hold uncertainty=15 time units)

**Clock transition (slew):**
- **Purpose:** Model realistic clock edges (not abrupt; finite rise/fall time)
- **Impact:** Affects flip-flop setup/hold times (larger slew → larger setup/hold times from .lib)
- **Command:** `set_clock_transition 10 [get_clocks CLK]` (clock slew=10 time units)

**Design objects:**
- **get_ports:** External interfaces (input/output ports)
  - `get_ports clk_in` (refers to port named clk_in)
- **get_pins:** Internal interfaces (instance pins)
  - `get_pins CS1/clk` (instance CS1, pin clk; format: instance_name/pin_name)
- **get_clocks:** Clock names (defined via create_clock)
  - `get_clocks CLK` (refers to clock named CLK)
- **get_cells:** Instances (cell names)

## Methods/flows
1. **Define primary clocks:** `create_clock -name <name> -period <value> [get_ports <port>]` (at input ports or internal clock generator pins)
2. **Define generated clocks:** `create_generated_clock -name <name> -divide_by <N> -source <master_pin> [get_pins <pin>]` (derived from master clock)
3. **Specify latency:** `set_clock_latency -source <value> [get_clocks <name>]` (source latency); `set_clock_latency <value> [get_clocks <name>]` (network latency)
4. **Specify uncertainty:** `set_clock_uncertainty -setup <value> [get_clocks <name>]`; `-hold <value>` for hold analysis
5. **Specify transition:** `set_clock_transition <value> [get_clocks <name>]` (clock slew)

## Constraints/assumptions
- **Time units:** From .lib file (e.g., ps, ns) or `set_unit -time ps` in SDC
- **create_clock does NOT create hardware:** Only defines constraints (no PLL/clock generator instantiation)
- **Waveform default:** If not specified, duty cycle=50% (rise@0, fall@period/2)
- **Uncertainty combines effects:** Jitter + skew + margins (single parameter for all sources)
- **Latency after CTS:** Network latency computed from actual clock tree (no need to specify); source latency still needed

## Examples
- **Primary clock:** `create_clock -name ext_clk -period 10 -waveform {0 5} [get_ports clock_in]` (period=10, duty cycle=50%)
- **Generated clock (divide-by-2):** `create_generated_clock -name gclk -divide_by 2 -source [get_pins CS1/clk] [get_pins CS2/gclk]` (if master period=10, derived period=20)
- **Latency:** External delay=5, internal delay=10 → `set_clock_latency -source 5 [get_clocks CLK]; set_clock_latency 10 [get_clocks CLK]`
- **Uncertainty:** Jitter+skew=20ps (setup), 15ps (hold) → `set_clock_uncertainty -setup 20 [get_clocks CLK]; set_clock_uncertainty -hold 15 [get_clocks CLK]`
- **Transition:** Clock slew=10ps → `set_clock_transition 10 [get_clocks CLK]`

## Tools/commands
- **SDC commands:**
  - `create_clock -name <name> -period <val> [-waveform {rise fall}] [get_ports <port>]`
  - `create_generated_clock -name <name> -divide_by <N> -source <pin> [get_pins <pin>]`
  - `set_clock_latency [-source] <val> [get_clocks <name>]`
  - `set_clock_uncertainty [-setup|-hold] <val> [get_clocks <name>]`
  - `set_clock_transition <val> [get_clocks <name>]`
- **Design object queries:** `get_ports`, `get_pins`, `get_clocks`, `get_cells`
- **STA tools:** Synopsys PrimeTime, Cadence Tempus, Siemens Questa STA, OpenSTA

## Common pitfalls
- Assuming create_clock instantiates hardware (it only defines timing constraints)
- Forgetting to specify time units (relies on .lib units; can cause mismatch)
- Confusing source latency (external delay) with network latency (internal delay)
- Over-constraining with excessive uncertainty (area/power overhead) or under-constraining (timing failures)
- Using network latency before CTS (should be computed from actual clock tree after CTS)
- Defining generated clock without -source (tool cannot infer master clock)

## Key takeaways
- SDC: Synopsys Design Constraints (TCL syntax, .sdc file); conveys designer requirements to tools
- Constraints manually written (designer knowledge: clock frequency, I/O timing, modes)
- Primary clock: `create_clock -period <val> [get_ports <port>]` (waveform independent of other clocks)
- Generated clock: `create_generated_clock -divide_by <N> -source <master> [get_pins <pin>]` (derived from master; e.g., divide-by-2)
- Latency: Source (external delay before port) + network (internal delay to FFs)
- Uncertainty: Jitter + skew + margins; pessimistic (setup: subtract from period; hold: add to same-edge)
- Transition: Clock slew (finite rise/fall time); affects FF setup/hold times
- Design objects: get_ports (external), get_pins (internal instance pins), get_clocks (clock names)
- create_clock defines constraints (NOT hardware); synthesis/STA tools use constraints to optimize/verify
- Uncertainty balancing: Too high → over-design (area/power); too low → timing failures
- Latency after CTS: Network latency computed from actual tree (no manual spec); source latency still needed

**Cross-links:** See Lec33: I/O constraints, timing exceptions; Lec26: .lib file (setup/hold times depend on clock slew); Lec28-30: STA (uses constraints to compute required times); Lec31: OpenSTA (SDC file usage)

---

*This summary condenses Lec32 from ~15,000 tokens, removing repeated SDC syntax examples, redundant clock waveform diagrams, and verbose constraint derivation walkthroughs.*
