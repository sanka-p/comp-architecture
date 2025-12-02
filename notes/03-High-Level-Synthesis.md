# High-Level Synthesis

> **Chapter Overview:** This chapter introduces High-Level Synthesis (HLS), a methodology for automatically translating high-level algorithmic descriptions (C/C++, SystemC) into optimized hardware (RTL) using tools like Bambu, enabling rapid prototyping and design space exploration.

**Prerequisites:** [[01-Introduction-to-VLSI-Design]], [[02-Hardware-Description-Languages]]  
**Related Topics:** [[04-Logic-Synthesis]], [[11-Timing-Driven-Optimization]]

---

## 1. High-Level Synthesis Fundamentals

### 1.1 Motivation and Benefits

**Design abstraction gap:**
- Manual RTL coding is time-consuming, error-prone
- Algorithm changes require extensive RTL rewriting
- Design space exploration (latency vs area vs throughput) is laborious

**HLS solution:**
- **Input:** Untimed algorithm (C/C++, SystemC, MATLAB)
- **Output:** Cycle-accurate RTL (Verilog/VHDL)
- **Tool responsibility:** Generate registers, datapaths, controllers, FSMs

**Benefits:**
1. **Productivity:** Faster design iteration (algorithm tweaks vs RTL rewrites)
2. **Exploration:** Automated trade-off analysis (constraints → multiple implementations)
3. **Verification:** Algorithm-level testbenches reuse (C testbench validates both C and RTL)
4. **Accessibility:** Software engineers can contribute to hardware design

### 1.2 HLS Workflow

**Inputs:**
1. **Algorithmic description:** C/C++ function (untimed behavior)
2. **Constraints:** Resources (adders, multipliers), frequency, latency, power budget
3. **Resource library:** Available operators (adder types, multiplier architectures)

**HLS transformations:**
- **Scheduling:** Assign operations to clock cycles (minimize latency or resource usage)
- **Binding:** Map operations to physical resources (share adders across cycles)
- **Controller synthesis:** Generate FSM to orchestrate datapath
- **Register allocation:** Determine storage for intermediate values

**Outputs:**
- **RTL:** Verilog/VHDL modules (datapath + controller)
- **Performance metrics:** Area (gates, registers), latency (cycles), fmax, power, throughput

### 1.3 Design Trade-offs

**Example: Y = a + b + c**

**RTL-1: Parallel (minimize latency)**
```c
// Two adders in parallel
temp = a + b;
Y = temp + c;
```
- **Latency:** 1 cycle
- **Critical path:** 2 adder delays (`d_max ≈ 2 × t_add`)
- **Area:** 2 adders
- **fmax:** Limited by combinational delay

**RTL-2: Pipelined (maximize fmax)**
```c
// Insert pipeline register
cycle 1: temp = a + b;  // Store in register
cycle 2: Y = temp + c;
```
- **Latency:** 2 cycles
- **Critical path:** 1 adder delay (`d_max ≈ t_add`)
- **Area:** 2 adders + 1 register
- **fmax:** 2× higher than RTL-1

**RTL-3: Resource-shared (minimize area)**
```c
// Single adder with muxing/control
cycle 1: temp = a + b;
cycle 2: Y = temp + c;
```
- **Latency:** 2 cycles
- **Critical path:** Adder + mux delay (`d_max ≈ t_add + t_mux`)
- **Area:** 1 adder + control logic
- **fmax:** Slightly lower than RTL-2

**Constraint-driven selection:**
- Minimize area → RTL-3
- Minimize latency → RTL-1
- Maximize frequency → RTL-2

---

## 2. Bambu HLS Tool

### 2.1 Tool Overview

**Bambu:** Open-source HLS framework
- **Website:** https://release.bambuhls.eu
- **Input:** C/C++ code
- **Output:** Verilog RTL
- **License:** Free, open-source

**Capabilities:**
- Converts C functions to hardware accelerators
- Generates modular Verilog (datapath, controller, operators)
- Supports common C constructs (conditionals, loops with bounds)

### 2.2 Installation (Ubuntu/WSL)

**Update system:**
```bash
sudo apt-get update
```

**Install dependencies:**
```bash
sudo apt-get install -y --no-install-recommends \
  build-essential ca-certificates gcc-multilib git \
  iverilog verilator wget
```

**Download Bambu AppImage:**
```bash
wget https://release.bambuhls.eu/appimage/bambu-0.9.7.AppImage
chmod +x bambu-0.9.7.AppImage
```

**Install libfuse2 (required for AppImages):**
```bash
sudo add-apt-repository universe
sudo apt install libfuse2
```

**Verify installation:**
```bash
./bambu-0.9.7.AppImage --version
```

### 2.3 Basic Usage

**Command syntax:**
```bash
./bambu-0.9.7.AppImage <c-file> --top-fname=<function-name>
```

**Parameters:**
- `<c-file>`: Path to C source file
- `--top-fname=<function>`: Function to synthesize (hardware accelerator entry point)

**Output:**
- `<function>.v`: Verilog RTL description
- Modular structure: Datapath, controller, operators

### 2.4 Example: Conditional Logic Synthesis

**Input C code (example.c):**
```c
long func(int,int,int,int);

main() {
    int j, k, c, d;
    int res = func(j, k, c, d);
    return 0;
}

long func(int j, int k, int c, int d) {
    int i = 0;
    if (c > 2) {
        i = j - k;
    } else if (d < 5) {
        i = j + k;
    } else {
        i = 12;
    }
    return i;
}
```

**Logic flow:**
- If `c > 2` → `i = j - k` (subtraction)
- Else if `d < 5` → `i = j + k` (addition)
- Else → `i = 12` (constant)

**Synthesis command:**
```bash
./bambu-0.9.7.AppImage example.c --top-fname=func
```

**Generated modules (func.v):**

1. **Conditional expression module:** Top-level control logic
2. **Greater-than module (`gt_expr`):** Comparator for `c > 2`
3. **Less-than-equal module (`le_expr`):** Comparator for `d < 5`
4. **Minus module (`minus_expr`):** Subtractor for `j - k`
5. **Plus module (`plus_expr`):** Adder for `j + k`
6. **Datapath module:** Connects arithmetic units, multiplexers (select j-k, j+k, or 12)
7. **Controller module:** FSM managing control signals (schedules operations based on conditions)

**Verification:**
```bash
iverilog func.v testbench.v
vvp a.out
gtkwave func.vcd
```

---

## 3. HLS Design Considerations

### 3.1 Synthesizable C Subset

**Supported constructs:**
- Integer arithmetic (+, -, *, /, %)
- Bitwise operations (&, |, ^, ~, <<, >>)
- Conditionals (if-else, switch-case)
- Bounded loops (for, while with compile-time determinable bounds)
- Functions (inlined into hardware)
- Arrays (mapped to registers or memories)

**Unsupported/limited constructs:**
- **Dynamic memory allocation:** `malloc`, `free` (runtime heap not synthesizable)
- **Unbounded loops:** Loop count must be determinable at synthesis time
- **Pointers:** Limited support (constant offsets OK; pointer arithmetic risky)
- **Recursion:** Generally unsupported (static call graph required)
- **File I/O:** `fopen`, `fread`, `printf` (simulation-only; remove for synthesis)
- **Floating-point:** Limited/expensive (use fixed-point when possible)

> **Guideline:** Write "hardware-friendly" C—avoid dynamic features, ensure bounded iteration, use explicit bit-widths.

### 3.2 Performance Tuning

**Constraints to tune:**

| Constraint | Effect | Trade-off |
|------------|--------|-----------|
| **Clock period** | Faster clock → more stages, registers | Higher fmax ↔ higher latency |
| **Resource limits** | Fewer adders → more sharing, control | Lower area ↔ higher latency |
| **Latency target** | Min cycles → parallel execution | Lower latency ↔ higher area |
| **Throughput** | Initiation interval → pipelining | Higher throughput ↔ higher area |

**Optimization directives (tool-specific):**
- **Loop unrolling:** Replicate loop body → parallel execution
- **Pipelining:** Insert registers between loop iterations
- **Array partitioning:** Split array into banks → parallel access
- **Function inlining:** Remove call overhead

### 3.3 Validation and Debugging

**Co-simulation:**
- Run C testbench and RTL simulation side-by-side
- Compare outputs at transaction boundaries
- Catch algorithmic vs RTL mismatches

**Formal verification:**
- Prove functional equivalence between C and RTL
- Tools: Cadence JasperGold, Synopsys VC Formal

**Common issues:**
- **Bit-width mismatches:** C `int` (32-bit) vs hardware (custom width)
- **Undefined behavior:** C left-shift overflow vs hardware wrap-around
- **Memory access patterns:** Sequential C vs concurrent hardware

---

## Key Takeaways

1. **HLS abstracts RTL:** C/C++ algorithm → tool generates datapath + controller + FSMs
2. **Benefits:** Faster iteration, design space exploration, software engineer accessibility
3. **Trade-offs:** Latency vs area vs fmax; constraints drive implementation choice
4. **Example implementations:** Parallel (low latency, high area), pipelined (high fmax, moderate area), resource-shared (low area, higher latency)
5. **Bambu workflow:** Install dependencies → write C function → run `bambu <file> --top-fname=<func>` → generate Verilog
6. **Generated modules:** Modular structure (operators, datapath, controller); verify with iverilog/gtkwave
7. **Synthesizable subset:** Integer ops, bounded loops, conditionals, functions; avoid dynamic memory, unbounded loops, recursion
8. **Validation:** Co-simulation (C testbench vs RTL), formal verification (C ↔ RTL equivalence)
9. **Performance tuning:** Adjust clock period, resource limits, latency targets; use loop unrolling, pipelining, array partitioning
10. **Common pitfalls:** Bit-width mismatches, undefined C behavior, memory access patterns

---

## Tools and Commands

| Tool | Command | Purpose |
|------|---------|---------|
| **Bambu** | `./bambu-0.9.7.AppImage <c-file> --top-fname=<func>` | C → Verilog HLS |
| **Dependencies** | `sudo apt-get install build-essential gcc-multilib git iverilog verilator` | Build tools, simulators |
| **libfuse2** | `sudo apt install libfuse2` | AppImage support |
| **Icarus Verilog** | `iverilog func.v tb.v`, `vvp a.out` | RTL simulation |
| **GTKWave** | `gtkwave func.vcd` | Waveform viewer |

---

## Common Pitfalls

1. **Missing `--top-fname`:** Bambu doesn't know which function to synthesize → error/ambiguity
2. **Unsynthesizable C:** Dynamic malloc, unbounded loops, file I/O → synthesis errors
3. **Not analyzing generated Verilog:** Miss understanding of datapath vs controller separation
4. **Ignoring verification:** Assume HLS output correct without co-simulation → functional bugs
5. **Bit-width assumptions:** C `int` defaults (32-bit) vs hardware needs (custom width) → area waste
6. **Unbounded loops:** `while (condition)` without guaranteed termination → tool error
7. **Pointer arithmetic:** Complex pointer math → unpredictable hardware mapping
8. **Over-constraining:** Tight latency + tight area → tool fails to find solution

---

## Further Reading

- [[01-Introduction-to-VLSI-Design]]: System-level design, HW/SW partitioning, IP assembly (SoC methodology)
- [[04-Logic-Synthesis]]: RTL → gate-level transformation (complements HLS: C → RTL)
- [[11-Timing-Driven-Optimization]]: Timing optimization techniques (pipelining, buffering, retiming)
- [[02-Hardware-Description-Languages]]: Verilog fundamentals (understand HLS-generated RTL)
- [[21-EDA-Tools-and-Tutorials]]: Tool workflows (Icarus Verilog, Yosys, verification flows)
