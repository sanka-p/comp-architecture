# Lec14 — Tutorial: High-Level Synthesis using Bambu

## Overview
Practical tutorial on using Bambu, an open-source HLS tool, to convert C/C++ behavioral descriptions into RTL (Verilog/VHDL). Covers installation steps, dependencies, and a simple example synthesizing a C function with conditionals (if-else) into hardware modules.

## Core concepts
**High-Level Synthesis (HLS):**
- **Goal:** Convert high-level languages (C, C++, SystemC) → optimized hardware (RTL in Verilog/VHDL)
- **Abstraction:** Designer writes algorithmic behavior; tool generates registers, datapaths, controllers, FSMs
- **Bambu:** Open-source HLS tool (https://release.bambuhls.eu); generates Verilog from C code

**Tool workflow:**
1. Write C/C++ function with hardware-suitable algorithm
2. Run Bambu with `--top-fname=<function>` to specify accelerator function
3. Tool generates Verilog modules (datapath, controller, arithmetic/logic units)

## Methods/flows
**Installation (Ubuntu/WSL):**
1. Update system: `sudo apt-get update`
2. Install dependencies:
   ```bash
   sudo apt-get install -y --no-install-recommends build-essential ca-certificates \
     gcc-multilib git iverilog verilator wget
   ```
3. Download Bambu AppImage:
   ```bash
   wget https://release.bambuhls.eu/appimage/bambu-0.9.7.AppImage
   ```
4. Make executable: `chmod +x bambu-0.9.7.AppImage`
5. Install libfuse2 (required for AppImages):
   ```bash
   sudo add-apt-repository universe
   sudo apt install libfuse2
   ```
6. Verify installation: `./bambu-0.9.7.AppImage --version` (or similar check)

**Running Bambu:**
```bash
./bambu-0.9.7.AppImage <path-to-c-file> --top-fname=<function-name>
```
- `<path-to-c-file>`: Input C file
- `--top-fname=<function-name>`: Function to synthesize into hardware
- Output: `<function>.v` (Verilog RTL description)

**Example C code:**
```c
long func(int,int,int,int);
main() { int j,k,c,d; int res = func(j,k,c,d); return 0; }
long func(int j,int k, int c, int d) {
  int i=0;
  if(c > 2) { i = j - k; }
  else if (d < 5) { i = j + k; }
  else { i = 12; }
  return i;
}
```
- Logic: If `c>2` → subtract (j-k); else if `d<5` → add (j+k); else → constant 12

**Generated Verilog modules (func.v):**
- Conditional expression module
- Greater-than expression (`c > 2`)
- Less-than-equal-to expression (`d < 5`)
- Minus expression (`j - k`)
- Plus expression (`j + k`)
- Datapath module (connects arithmetic units, muxes)
- Controller module (FSM managing control signals)

## Constraints/assumptions
- Bambu supports subset of C/C++ (hardware-synthesizable constructs: no dynamic memory, limited pointers, loops must be bounded)
- Generated RTL is functionally equivalent to C behavior but optimized for hardware (parallelism, pipelining)
- Tool-specific naming conventions for modules (analyze generated .v file for hierarchy)

## Examples
**Command:**
```bash
./bambu-0.9.7.AppImage example.c --top-fname=func
```
**Input:** C function with if-else conditionals (shown above)
**Output:** `func.v` containing:
- Arithmetic modules (plus_expr, minus_expr)
- Comparator modules (gt_expr for `c>2`, le_expr for `d<5`)
- Datapath (muxes selecting j-k, j+k, or 12)
- Controller FSM (schedules operations based on conditions)

## Tools/commands
- **Bambu:** HLS tool (AppImage v0.9.7)
- **Dependencies:** gcc-multilib, iverilog (Verilog simulator), verilator (Verilog-to-C++ compiler for simulation)
- **Verification:** Simulate `func.v` with iverilog or verilator to verify against C behavior

## Common pitfalls
- Forgetting `--top-fname` → Bambu may not know which function to synthesize (error/ambiguity)
- C code with unsynthesizable constructs (dynamic malloc, unbounded loops, file I/O) → synthesis errors
- Not analyzing generated .v file → miss understanding of HLS mapping (datapath vs controller separation)

## Key takeaways
- Bambu automates RTL creation from C/C++ (HLS abstracts away register-transfer details)
- Installation requires dependencies (build-essential, iverilog, verilator, libfuse2)
- Command: `./bambu-0.9.7.AppImage <c-file> --top-fname=<function>`
- Generated Verilog modular: datapath (arithmetic/logic), controller (FSM), individual operators
- HLS useful for rapid prototyping, algorithm exploration (compare area/latency/throughput trade-offs without manual RTL coding)

**Cross-links:** See Lec04: HLS concepts, IP assembly; Lec06: RTL synthesis (manual Verilog → netlist); Lec15: RTL synthesis details

---

*This summary condenses the tutorial from ~3,000 tokens, removing installation wait-time narration ("it is updating...", "installation is complete"), on-screen command echoes, and TA introduction.*
