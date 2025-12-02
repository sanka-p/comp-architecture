# Lec31 — Tutorial: Static Timing Analysis using OpenSTA

## Overview
Hands-on tutorial demonstrating OpenSTA (open-source STA tool) installation, usage, and report interpretation. Covers setup/hold checks for gate-level netlist using constraint file (top.sdc), technology library (toy.lib), and TCL script (test.tcl).

## Core concepts
**OpenSTA inputs:**
1. **Verilog netlist:** Gate-level design (top.v) with instantiated standard cells
2. **Constraint file (top.sdc):** Clock definition, input/output delays (SDC format)
3. **Technology library (toy.lib):** Timing models for standard cells (.lib, Liberty format)
4. **TCL script (test.tcl):** Commands to read files, link design, run STA

**Setup check (max delay path):**
- **Path:** Launch FF (F1) → combinational logic → capture FF (F2)
- **Data arrival time:** Sum of delays (F1 clk→q: 5.66ps, I2: 1.63ps, B1: 5.20ps, N1: 1.91ps, I3: 1.85ps) = 16.25ps
- **Data required time:** Clock period (1000ps) - library setup time (8.36ps) = 991.64ps
- **Slack:** Required - arrival = 991.64 - 16.25 = 975.39ps (positive → PASS, no setup violation)

**Hold check (min delay path):**
- **Path:** Launch FF (F2) → combinational logic → capture FF (F3)
- **Data arrival time:** F2 clk→q (5.85ps) + combinational delay (0ps, no logic) = 5.85ps
- **Data required time:** Clock period (0ps, same edge) + library hold time (1.70ps) = 1.70ps
- **Slack:** Arrival - required = 5.85 - 1.70 = 4.15ps (positive → PASS, no hold violation)

**Constraint file (top.sdc) example:**
```tcl
create_clock -name CLK -period 1000 [get_ports clock]  # Clock period=1000ps
set_input_delay -clock CLK 5 [get_ports A]              # Input arrival time=5ps (w.r.t. CLK)
set_input_delay -clock CLK 5 [get_ports B]
set_output_delay -clock CLK 10 [get_ports out]          # Output constraint (10ps before next clock)
```

**TCL script (test.tcl) commands:**
```tcl
read_liberty toy.lib               # Load technology library
read_verilog top.v                 # Load netlist
link_design top                    # Link design with timing cells (top=main module)
read_sdc top.sdc                   # Load constraints
```

## Methods/flows
1. **Installation:** Git clone OpenSTA repo → `mkdir build; cd build` → `cmake ..` → `make` → `sudo make install` → verify: `sta` (opens environment)
2. **Running STA:**
   - **Interactive:** `sta` → `source test.tcl` → `report_checks -path_delay max -format full` (setup) / `-path_delay min` (hold)
   - **Batch:** `sta -f test.tcl -exit` (run script, exit)
3. **Setup check:** `report_checks -path_delay max -format full` → displays path group, delays, arrival/required times, slack
4. **Hold check:** `report_checks -path_delay min -format full` → displays hold timing arc, slack

## Constraints/assumptions
- **Dependencies:** Git, CMake, Make, Tcl-dev, Flex, Bison (install before OpenSTA)
- **Library units:** Timing units (ps) from .lib file
- **Setup check:** Next clock edge (clock period considered)
- **Hold check:** Same clock edge (clock period=0)
- Virtual flip-flops at output ports (setup/hold time=0; constraints via set_output_delay)

## Examples
- **Design (top.v):** 2 flip-flops (F1, F2), combinational gates (I2, B1, N1, I3), input ports (A, B), output (out)
- **Setup path:** F1.clk → F1.Q (5.66ps) → I2 (1.63ps) → B1 (5.20ps) → N1 (1.91ps) → I3 (1.85ps) → F2.D (arrival=16.25ps; required=991.64ps; slack=975.39ps)
- **Hold path:** F2.clk → F2.Q (5.85ps) → F3.D (arrival=5.85ps; required=1.70ps; slack=4.15ps)
- **Positive slack:** No violations (design meets timing at 1000ps clock period → f_max ≥ 1GHz)

## Tools/commands
- **OpenSTA:** `sta` (interactive), `sta -f script.tcl -exit` (batch)
- **Report commands:**
  - `report_checks -path_delay max -format full` — Setup check (worst max delay path)
  - `report_checks -path_delay min -format full` — Hold check (worst min delay path)
  - `report_checks -path_delay max > setup_report.txt` — Save to file
- **Installation:** `git clone https://github.com/The-OpenROAD-Project/OpenSTA.git; cd OpenSTA; mkdir build; cd build; cmake ..; make; sudo make install`
- **Documentation:** https://github.com/The-OpenROAD-Project/OpenSTA (GitHub), OpenSTA User Guide (PDF)

## Common pitfalls
- Forgetting to install dependencies (Tcl-dev, Flex, Bison) → CMake fails
- Using `report_checks` without specifying `-path_delay max/min` → may not show critical paths
- Confusing setup (max delay, next edge) with hold (min delay, same edge)
- Assuming negative slack always means design failure (check if margin added; slack target may be >0ps for early stages)
- Not linking design (`link_design top`) → STA fails (no timing arcs)

## Key takeaways
- OpenSTA: Open-source STA tool (part of OpenROAD project); reads Verilog netlist, .lib, SDC constraints
- Inputs: Netlist (top.v), library (toy.lib), constraints (top.sdc), TCL script (test.tcl)
- Setup check: Max delay path (launch FF → capture FF); arrival ≤ required (clock period - setup time)
- Hold check: Min delay path (same clock edge); arrival ≥ required (hold time)
- Slack: Setup = required - arrival; Hold = arrival - required (positive → pass, negative → violation)
- Report commands: `report_checks -path_delay max` (setup), `-path_delay min` (hold), `-format full` (detailed)
- Installation: Git clone → CMake → Make → Install (requires Tcl-dev, Flex, Bison)
- Example results: Setup slack=975.39ps, hold slack=4.15ps (both positive → no violations)

**Cross-links:** See Lec28-30: STA theory (setup/hold requirements, timing graph, slack); Lec26: .lib file (timing models); Lec32-33: SDC constraints (create_clock, set_input/output_delay)

---

*This summary condenses tutorial Lec31 from ~3,500 tokens, removing installation command echoes, repeated report outputs, and verbose file content displays.*
