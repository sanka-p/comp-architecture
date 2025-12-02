# Lec36 — Tutorial: Technology Library and Constraints (OpenSTA Experiments)

## Overview
Hands-on tutorial demonstrating how technology library (.lib) NLDM tables and SDC constraints affect delay calculation and STA using OpenSTA. Explores experiments varying input transition, output load, input/output delays, and clock uncertainty to observe their impact on delay and slack.

## Core concepts
**NLDM (Non-Linear Delay Model):**
- **2D table:** Delay = f(input slew, output load)
- **Characterization points (toy.lib):** Input slew: {0.1ps, 100ps}; Output load: {0.1fF, 100fF}
- **Delay values:** {184ps, 200ps} (for inv cell, timing arc i→Zn)
- **Example lookup:** Input slew=0.1ps, output load=100fF → delay=80ps (1st row, 2nd column)

**Constraints (test.sdc):**
- **Virtual clock:** `create_clock -name CLK -period 1000` (no port; used for I/O constraints)
- **Input delay:** `set_input_delay 5 -clock CLK [get_ports A]` (external delay before input port)
- **Output delay:** `set_output_delay 5 -clock CLK [get_ports OUT]` (external delay after output port; subtracted from required time)
- **Input transition:** `set_input_transition 0.1 [get_ports A]` (input slew for delay calculation)
- **Output load:** `set_load 100 [get_ports OUT]` (output capacitance in fF)

**Design (test.v):**
- **Simple circuit:** 1 input port (A), 1 output port (OUT), 1 inverter instance (i), cell type (inv from toy.lib)
- **Purpose:** Minimal design for easy manual delay verification

**Timing calculation:**
- **Arrival time:** Input delay (5ps) + inverter delay (80ps) = 85ps
- **Required time:** Clock period (1000ps) - output delay (5ps) = 995ps
- **Slack:** Required - arrival = 995 - 85 = 910ps (positive → pass)

## Methods/flows
**Experiment workflow:**
1. **Load files:** `read_liberty toy.lib; read_verilog test.v; link_design top; read_sdc test.sdc`
2. **Report timing:** `report_checks` (displays arrival time, required time, slack)
3. **Modify constraints:** Change SDC parameters (input transition, load, delays, uncertainty) → re-run `report_checks` → observe impact

**Experiments performed:**
1. **Vary input transition:** 0.1ps → 100ps (delay: 80ps → 200ps; 2nd row, 2nd column of NLDM table)
2. **Vary output load:** 100fF → 0.1fF (delay: 200ps → 4ps; 2nd row, 1st column)
3. **Vary input delay:** 5ps → 25ps (arrival time: +20ps; slack: -20ps)
4. **Vary output delay:** 5ps → 35ps (required time: -30ps; slack: -30ps)
5. **Add clock uncertainty:** 100ps (required time: -100ps; slack: -100ps)

## Constraints/assumptions
- **Toy library:** Only 2×2 NLDM table (realistic libraries: 8×8 or larger)
- **Virtual clock:** No associated port (used only for I/O delay constraints)
- **Time units:** From .lib file (ps for time, fF for capacitance)
- **Single inverter:** Simple design for manual verification (realistic designs: millions of gates)

## Examples
**Experiment 1 (baseline):**
- Input transition=0.1ps, output load=100fF → NLDM lookup: row 1, col 2 → delay=80ps
- Arrival=5+80=85ps, required=1000-5=995ps, slack=910ps

**Experiment 2 (increase input transition):**
- `set_input_transition 100 [get_ports A]` → NLDM: row 2, col 2 → delay=200ps
- Arrival=5+200=205ps, slack=995-205=790ps (slack decreased by 120ps)

**Experiment 3 (decrease output load):**
- `set_load 0.1 [get_ports OUT]` → NLDM: row 2, col 1 → delay=4ps
- Arrival=5+4=9ps, slack=995-9=986ps (slack increased)

**Experiment 4 (increase input delay):**
- `set_input_delay 25 -clock CLK [get_ports A]` → arrival=25+200=225ps
- Slack=995-225=770ps (decreased by 20ps; input delay increase propagates to arrival time)

**Experiment 5 (increase output delay):**
- `set_output_delay 35 -clock CLK [get_ports OUT]` → required=1000-35=965ps
- Slack=965-225=740ps (decreased by 30ps; output delay decrease required time)

**Experiment 6 (add clock uncertainty):**
- `set_clock_uncertainty 100 [get_clocks CLK]` → required=965-100=865ps
- Slack=865-225=640ps (pessimistic; uncertainty subtracts from required time)

## Tools/commands
- **OpenSTA:** `sta` (interactive mode)
- **Load files:** `read_liberty <lib>`, `read_verilog <v>`, `link_design <top>`, `read_sdc <sdc>`
- **Report:** `report_checks` (shows arrival, required, slack for critical path)
- **TCL script:** `source test.tcl` (batch execution)

## Common pitfalls
- Not understanding NLDM table indexing (rows=input slew, cols=output load)
- Confusing input delay (adds to arrival time) with output delay (subtracts from required time)
- Expecting delay change when only input/output delay changes (delay depends on slew/load, not I/O delays)
- Forgetting clock uncertainty is pessimistic (subtracts from required time for setup)
- Using toy library for realistic designs (only 2×2 table; real libraries: 8×8 or larger)

## Key takeaways
- NLDM: 2D table (input slew, output load) → delay; interpolation for intermediate values
- Input transition: Affects delay via NLDM lookup (higher slew → higher delay)
- Output load: Affects delay via NLDM lookup (higher load → higher delay)
- Input delay: External delay before input port → adds to arrival time (reduces slack)
- Output delay: External delay after output port → subtracts from required time (reduces slack)
- Clock uncertainty: Pessimistic margin (jitter, skew, safety) → subtracts from required time (reduces slack)
- Virtual clock: No port association; used for I/O delay constraints (common in block-level designs)
- OpenSTA experiments: Manually verify NLDM lookups, constraint impact on slack
- Simple design (1 inverter): Easy manual verification; realistic designs require tool automation
- Hands-on learning: Link lecture concepts (Lec26: .lib, Lec32-33: constraints, Lec28-30: STA) with tool behavior

**Cross-links:** See Lec26: Technology library (.lib, NLDM tables); Lec32-33: SDC constraints (create_clock, set_input/output_delay, set_clock_uncertainty); Lec28-30: STA (arrival/required time, slack); Lec31: OpenSTA tutorial (installation, basic usage)

---

*This summary condenses tutorial Lec36 from ~4,500 tokens, removing repeated command echoes, redundant NLDM table displays, and verbose step-by-step experiment walkthroughs.*
