# Lec18 — Tutorial: Simulation-Based Verification using Icarus Verilog and GTKWave

## Overview
Practical tutorial on installing and using Icarus Verilog (iverilog) for simulation, GTKWave for waveform analysis, and Covered for code coverage analysis. Demonstrates full verification flow: compile design → execute → view VCD waveforms → check coverage reports.

## Core concepts
**Icarus Verilog (iverilog):**
- Open-source Verilog simulator (compile + execute flow)
- Compiles `.v` files → executable → runs to generate VCD file
- Alternative to commercial simulators (VCS, ModelSim, Xcelium)

**GTKWave:**
- Open-source waveform viewer for VCD (Value Change Dump) files
- Displays signal traces over time (clock, inputs, outputs)
- Analyze timing, transitions, verify functional behavior

**Covered:**
- Open-source code coverage tool
- Reports line, toggle, combinational logic, FSM coverage
- Identifies untested code regions (guide testbench improvement)

## Methods/flows
**Installation (Ubuntu/WSL):**
1. **Icarus Verilog:**
   ```bash
   git clone https://github.com/steveicarus/iverilog.git
   cd iverilog
   sudo apt-get update
   sudo apt-get install gperf autoconf gcc g++ flex bison make
   sh autoconf.sh
   ./configure
   make
   sudo make install
   iverilog  # Verify installation
   ```

2. **GTKWave:**
   ```bash
   sudo apt install gtkwave
   gtkwave  # Launch tool
   ```

3. **Covered:**
   ```bash
   git clone https://github.com/chiphackers/covered
   cd covered
   sudo apt update
   sudo apt-get install zlib1g-dev tcl8.6 tcl8.6-dev tk8.6 tk8.6-dev doxygen
   git clone https://git.savannah.gnu.org/git/libiconv.git  # libiconv dependency
   ./configure
   make
   sudo make install
   ```

**Simulation workflow:**
1. **Write design:** `Mycounter.v` (4-bit synchronous counter: reset → 0; else increment on posedge clock)
2. **Write testbench:** `Testbench.v` (instantiate counter, generate clock/reset, dump VCD)
   ```verilog
   initial begin
     Clock=0; Reset=1; #100 Reset=0; #2000 $finish;
     $dumpfile("count.vcd"); $dumpvars;
   end
   always #50 Clock = ~Clock;  // Period 100
   ```
3. **Compile:** `iverilog -o Mycounter Mycounter.v Testbench.v`
4. **Execute:** `vvp Mycounter` → generates `count.vcd`
5. **View waveforms:** `gtkwave count.vcd` → analyze CLK, RST, OUT signals
6. **Check coverage:** `covered score -t Testbench -v Testbench.v -v Mycounter.v -vcd count.vcd -o Mycounter.cdd`
7. **View coverage report:** `covered report -d v Mycounter.cdd` → line/toggle/combinational/FSM coverage

## Constraints/assumptions
- Icarus requires Linux/WSL (Windows native port exists but WSL recommended)
- Dependencies: flex, bison, gcc, gperf, autoconf, make, zlib1g-dev, tcl/tk (for Covered)
- VCD files can be large for long simulations (use `$dumpvars(1, top)` to limit scope)
- Covered reports identify untested code but not missing functionality (functional coverage requires manual effort)

## Examples
**4-bit counter verification:**
- **Design:** `Mycounter.v` (inputs: RST, CLK; output: OUT[3:0])
  - Behavior: Reset=1 → OUT=0; Reset=0 → OUT++ on posedge CLK
- **Testbench:** Initialize Clock=0, Reset=1; after 100 time units Reset=0; simulate 2000 time units
- **Waveform analysis:** 
  - T=0: RST=1 → OUT=0 (reset active)
  - T=100: RST=0 → OUT increments (0→1→2→...→F→0→1...)
  - Mid-simulation: RST=1 (negative edge) → no effect until positive clock edge → OUT=0
- **Coverage:** Line coverage shows % of statements executed; toggle coverage shows signals toggled 0→1 and 1→0

## Tools/commands
- **Compile:** `iverilog -o <output> <design.v> <testbench.v>`
- **Execute:** `vvp <output>`
- **Waveform:** `gtkwave <file.vcd>`
- **Coverage score:** `covered score -t <testbench_module> -v <testbench.v> -v <design.v> -vcd <file.vcd> -o <output.cdd>`
- **Coverage report:** `covered report -d v <output.cdd>`
- **Text editors:** gedit, nano, vim (for editing `.v` files)

## Common pitfalls
- Missing dependencies during installation (follow tutorial sheet; install one-by-one)
- Forgetting `$dumpfile` and `$dumpvars` in testbench → no VCD generated
- VCD file not found when running GTKWave (check current directory)
- Coverage tool requires exact module names (`-t Testbench` must match testbench module name)
- Reset timing: Reset on negative edge won't affect counter until positive clock edge (check waveform timing carefully)

## Key takeaways
- Icarus Verilog: Free, open-source simulator for Verilog (compile with `iverilog`, execute with `vvp`)
- GTKWave: Visualize VCD waveforms to verify functional behavior (clock edges, reset timing, output sequences)
- Covered: Code coverage tool (line, toggle, combinational, FSM) identifies untested code regions
- Full verification flow: Write testbench → compile → execute → view waveforms → check coverage → iterate
- Coverage guides testbench improvement (add stimuli to cover untested branches/states)
- Installation requires dependencies (flex, bison, gcc, tcl/tk); follow tutorial sheet carefully

**Cross-links:** See Lec13: simulation mechanics, testbench framework, coverage models; Lec11-12: Verilog syntax for writing designs/testbenches; Lec15: synthesis (verify pre- vs post-synthesis equivalence)

---

*This summary condenses tutorial Lec18 from ~6,000 tokens, removing installation wait narrations ("it is done now..."), command output echoes, and step-by-step screen interactions.*
