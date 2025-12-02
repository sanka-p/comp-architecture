# Lec22 — Tutorial: Logic Synthesis using Yosys

## Overview
Practical tutorial on installing and using Yosys Open Synthesis Suite for RTL synthesis and technology mapping. Demonstrates compiling source, cloning library PDK, writing TCL scripts for synthesis commands, and generating netlists mapped to standard cells.

## Core concepts
**Yosys Open Synthesis Suite:**
- Open-source RTL synthesis tool (alternative to Synopsys Design Compiler, Cadence Genus)
- Flow: Read RTL → techmap (internal library) → dfflibmap (sequential logic) → abc (combinational mapping) → clean → write netlist
- Output: Verilog netlist with instantiated standard cells

**Technology library:**
- Silvaco Open-Cell 45nm FreePDK (free PDK library)
- NLDM format (Non-Linear Delay Model)
- Contains standard cells (gates, flip-flops) with delay/power/area models

**TCL scripting:**
- Automate synthesis commands (read, techmap, dfflibmap, abc, clean, write)
- Execute via `script <filename.tcl>` in Yosys shell

## Methods/flows
**Installation (Ubuntu/WSL):**
1. **Install dependencies:**
   ```bash
   sudo apt-get install build-essential clang bison flex libreadline-dev gawk tcl-dev libffi-dev git graphviz xdot pkg-config python3 libboost-system-dev libboost-python-dev libboost-filesystem-dev zlib1g-dev
   ```
2. **Clone Yosys:**
   ```bash
   git clone https://github.com/YosysHQ/yosys.git
   cd yosys
   ```
3. **Compile:**
   ```bash
   make
   sudo make install
   ./yosys  # Launch tool
   ```

**FreePDK45 library acquisition:**
1. Fill form at SI2 website (university email required)
2. Download link via email (valid 3 days)
3. Extract NLDM file from FreePDK45 package

**Synthesis workflow:**
1. **Write Verilog design:** `top.v` (e.g., 2:1 mux + D flip-flop)
   ```verilog
   assign y = (select) ? b : a;  // Mux
   always @(posedge clk) out <= y;  // D flip-flop
   ```
2. **Write TCL script:** `yosys_commands.tcl`
   ```tcl
   read_verilog top.v
   techmap
   dfflibmap -liberty <path_to_library.lib>
   abc -liberty <path_to_library.lib>
   clean
   write_verilog -noattr top_synth.v
   ```
3. **Run synthesis:**
   ```bash
   yosys
   yosys> script yosys_commands.tcl
   ```
4. **View netlist:** `top_synth.v` (instantiated mux, D flip-flop from library)

## Constraints/assumptions
- No SDC (Synopsys Design Constraints) file → synthesis optimized for minimum area only (no timing constraints)
- FreePDK45 requires university affiliation (SI2 verifies credentials)
- Dependencies: build-essential, clang, bison, flex, tcl-dev, libboost libraries
- NLDM library location: `FreePDK45/NLDM/*.lib`

## Examples
**2:1 Mux + D flip-flop design:**
- **Inputs:** a, b, clk, select
- **Outputs:** out
- **Behavior:** y = (select) ? b : a; out = y @ posedge clk
- **Synthesized netlist:** Instantiates `MUX2X1` and `DFFPOSX1` from Nangate library
  ```verilog
  MUX2X1 _0_ (.A(a), .B(b), .S(select), .Y(y));
  DFFPOSX1 _1_ (.CLK(clk), .D(y), .Q(out));
  ```

## Tools/commands
- **Yosys installation:** `git clone`, `make`, `sudo make install`, `./yosys`
- **Synthesis commands (TCL script):**
  - `read_verilog <file.v>` — Read RTL design
  - `techmap` — Map to internal library
  - `dfflibmap -liberty <lib>` — Map sequential elements (flip-flops)
  - `abc -liberty <lib>` — Map combinational logic to standard cells
  - `clean` — Remove unused wires/cells
  - `write_verilog -noattr <output.v>` — Export netlist
- **Run script:** `yosys> script yosys_commands.tcl`
- **FreePDK45 download:** SI2 website form submission

## Common pitfalls
- Missing dependencies (install all at once to avoid repeated `apt-get`)
- Forgetting `-liberty` flag (dfflibmap, abc require library path)
- Using wrong library path (NLDM folder contains `.lib` file)
- Not specifying `-noattr` in write_verilog (attributes clutter netlist)
- FreePDK45 link expires (download within 3 days)

## Key takeaways
- Yosys: Free, open-source RTL synthesis tool (read Verilog → synthesize → map to standard cells → write netlist)
- Technology library: FreePDK45 (45nm, free PDK); NLDM format (delay/power/area models)
- Synthesis flow: `read_verilog` → `techmap` → `dfflibmap` (sequential) → `abc` (combinational) → `clean` → `write_verilog`
- TCL scripts automate synthesis (easier than typing commands interactively)
- No SDC → synthesis for minimum area only (timing constraints require SDC file)
- Output netlist: Verilog with instantiated standard cells (MUX, D flip-flop from library)

**Cross-links:** See Lec06: logic synthesis overview; Lec15-16: RTL synthesis details; Lec10: TCL scripting; Lec18: simulation (Icarus Verilog); Lec26-27: standard cell libraries, timing models

---

*This summary condenses tutorial Lec22 from ~3,000 tokens, removing installation wait narrations, form-filling screenshots, and command output echoes.*
