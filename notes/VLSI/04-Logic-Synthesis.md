# Logic Synthesis

> **Chapter Overview:** This chapter covers the complete logic synthesis flow—translating RTL (Verilog/VHDL) into optimized gate-level netlists through parsing, elaboration, construct translation, operator handling, compiler optimizations, and technology mapping using tools like Yosys.

**Prerequisites:** [[02-Hardware-Description-Languages]], [[01 - Integrated Circuits]]  
**Related Topics:** [[05-Logic-Optimization]], [[07-Technology-Libraries]], [[10-Technology-Mapping]]

---

## 1. Logic Synthesis Overview

### 1.1 Role in VLSI Design Flow

**Position in flow:**
```
RTL (Verilog/VHDL)
    ↓ [Logic Synthesis]
Gate-level Netlist
    ↓ [Physical Design]
Layout (GDSII)
```

**Logic synthesis bridge:**
- **Input:** Behavioral description (RTL)
- **Output:** Structural description (netlist)
- **Constraint:** Functional equivalence must be preserved

### 1.2 Synthesis Framework

**Required inputs:**
1. **RTL:** Design source code (Verilog, VHDL, SystemVerilog)
2. **Library (.lib):** Standard cell characterization (timing, power, area)
3. **Constraints (SDC):** Timing, area, power targets

**Output:**
- **Netlist:** Gate-level interconnections using library cells
- **Reports:** Area, timing, power estimates

**Fundamental challenge:** Optimize PPA (performance, power, area) while maintaining functional equivalence to RTL.

### 1.3 Netlist Terminology

| Term | Definition | Example |
|------|------------|---------|
| **Design** | Top-level entity | `module top` |
| **Port** | Interface signal | Primary inputs (PI), Primary outputs (PO) |
| **Cell** | Library entity | AND2X1, DFFPOSX1 |
| **Instance** | Placed cell | `AND2X1 U1(...)` (U1 = instance name) |
| **Pin** | Cell/instance interface | `U1/A`, `U1/B`, `U1/Y` |
| **Net** | Wire connecting pins/ports | `wire n1` connects U1/Y to U2/A |

**Naming convention:**
- Instance pin: `instance_name/pin_name` (e.g., `U1/A`)
- Port-connected nets often named after port

---

## 2. Synthesis Pipeline

### 2.1 Four Major Stages

**1. RTL Synthesis (Translation):**
- Parse RTL → Build syntax tree
- Elaborate hierarchy → Link instances to masters
- Translate Verilog constructs → Generic gates (no transistor detail)
- Arithmetic optimizations (constant propagation, strength reduction)

**2. Logic Optimization:**
- Minimize gates at generic level
- Boolean minimization (Karnaugh-like, scaled to large circuits)
- Remove redundant logic

**3. Technology Mapping:**
- Map generic gates → Standard cells from library
- Choose among multiple drive strengths per function
- Huge solution space (critical optimization step)

**4. Technology-Dependent Optimization:**
- Refine PPA using accurate cell models
- Buffer insertion, gate sizing, retiming
- Iterative until constraints met

### 2.2 Generic vs Standard Cells

**Generic gates:**
- Well-defined Boolean function (AND, OR, NOT, XOR)
- No transistor-level details
- Cannot estimate delay/power accurately
- Used for early optimization (technology-independent)

**Standard cells:**
- Characterized in library (transistor-level known)
- Delay, power, area models available
- Enable accurate PPA estimation
- Multiple drive strengths (X1, X2, X4, X8)

**Why both?**
- Generic → fast early optimization (no library dependence)
- Standard → accurate PPA modeling (library-specific)

---

## 3. Parsing and Elaboration

### 3.1 Parsing Tasks

**Lexical analysis:**
- Break RTL into tokens (keywords, identifiers, operators, literals)
- Example: `wire [7:0] a;` → tokens: `wire`, `[`, `7`, `:`, `0`, `]`, `a`, `;`

**Syntax checking:**
- Verify grammar compliance
- Report syntax errors

**Parse tree (syntax tree):**
- Hierarchical data structure reflecting parent-child relationships
- Example structure:
  ```
  module top
    ├── always block 1
    │   ├── statement 1 (LHS, RHS)
    │   ├── statement 2
    │   └── statement 3
    └── always block 2
        └── ...
  ```

### 3.2 Elaboration Tasks

**1. Instance-master linkages:**
- Connect instances to their module definitions
- Example: Instance `F1` of type `leaf` → link to `module leaf` definition

**2. Port direction inference:**
- Determine input/output/inout for each pin
- Inferred from master module port declarations

**3. Parameter processing:**
- Create distinct modules for each parameter set
- Example: `counter #(4)`, `counter #(8)`, `counter #(16)` → separate modules
  - `counter_WIDTH_4`
  - `counter_WIDTH_8`
  - `counter_WIDTH_16`

**4. Error detection:**

| Error Type | Description | Consequence |
|------------|-------------|-------------|
| **Black box** | Instance references undefined module | Tool assumes black box; cannot infer pin directions |
| **Port mismatch** | Instance port name doesn't match master | Elaboration error (typo: `.d1(...)` vs `.d(...)`) |
| **Width mismatch** | Bus width inconsistency | Elaboration warning or error |

> **Best practice:** Resolve all elaboration errors before proceeding—missing modules and port mismatches cause downstream failures.

---

## 4. Construct Translation

### 4.1 Synthesizable vs Non-Synthesizable

**Non-synthesizable (simulation-only):**
- Delays: `#10`, `#(delay)`
- Initial blocks
- Fork/join (parallel blocks)
- Force/release
- Real/time data types
- System tasks: `$display`, `$monitor`, `$finish`

> **Synthesis behavior:** Delays ignored; initial blocks rejected; system tasks removed.

**Synthesizable constructs:**
- Continuous assignments (`assign`)
- If-else, case statements
- Always blocks (edge-sensitive, level-sensitive)
- Functions, tasks (with caveats)
- For-loops (constant iteration count)

### 4.2 Continuous Assignment → Combinational Logic

**Bitwise operations:**
```verilog
assign out1 = (a & b) | c;   // AND + OR gates
```
- Translation: 2-input AND (a, b) → AND_out; 2-input OR (AND_out, c) → out1

**Vector operations:**
```verilog
assign out2 = x & y;   // 4-bit AND
```
- Translation: 4 × 2-input AND gates (parallel)

**Conditional (multiplexer):**
```verilog
assign out3 = s ? q : p;   // 2:1 mux
```
- Translation: 2:1 multiplexer (select=s, inputs=q/p)

### 4.3 If-Else → Multiplexer

**Simple 2:1 mux:**
```verilog
if (s == 0)
    out1 = a;
else
    out1 = b;
```
- Translation: 2:1 mux (select=s, inputs=a(s=0)/b(s=1))

**Nested if-else (4:1 mux):**
```verilog
if (sel == 2'b00)      y = a;
else if (sel == 2'b01) y = b;
else if (sel == 2'b10) y = c;
else                   y = d;
```
- Translation: 4:1 mux (2-bit select=sel, inputs={a,b,c,d})

### 4.4 Case Statement → Multiplexer/Priority Logic

**Simple case (full encoding):**
```verilog
case (sel)
    2'b00: y = a;
    2'b01: y = b;
    2'b10: y = c;
    2'b11: y = d;
    default: y = 4'b0;
endcase
```
- Translation: 4:1 mux (2-bit select, 4 inputs)

**Priority case (don't-cares):**
```verilog
case (sel)
    2'b1?: y = a;    // If sel[1]==1 → a
    2'b?1: y = b;    // Else if sel[0]==1 → b
    default: y = c;
endcase
```
- Translation: Priority encoder (check sel[1] first, then sel[0])

> **Synthesis guideline:** Always include `default` case to avoid latch inference.

### 4.5 Edge-Sensitive Always → Flip-Flops

**Positive-edge D flip-flop:**
```verilog
always @(posedge clk)
    q <= d;
```
- Translation: D flip-flop (rising edge triggered)

**Asynchronous reset (active-low):**
```verilog
always @(posedge clk or negedge rst)
    if (!rst)
        q <= 1'b0;
    else
        q <= d;
```
- Translation: D flip-flop with async reset pin

**Synchronous reset:**
```verilog
always @(posedge clk)
    if (!rst)
        q <= 1'b0;
    else
        q <= d;
```
- Translation: D flip-flop + 2:1 mux (reset synchronous with clock)

### 4.6 Level-Sensitive Always → Combinational or Latches

**All branches update variable → Combinational:**
```verilog
always @(*) begin
    if (s)
        out1 = a;
    else
        out1 = b;
end
```
- Translation: 2:1 mux (combinational)

**Missing branch → Latch (often unintended):**
```verilog
always @(*) begin
    if (en)
        out2 = c;
    // Missing else → holds old value when en=0
end
```
- Translation: D latch (enable=en, data=c)

> **Critical pitfall:** Unintended latches cause timing/synthesis issues. Always initialize variables or include `else` branches.

**Fix for latch avoidance:**
```verilog
always @(*) begin
    out2 = 1'b0;   // Default value
    if (en)
        out2 = c;
end
```
- Translation: Mux (select=en, inputs={0, c})

### 4.7 Blocking vs Non-Blocking in Sequential Always

**Blocking (`=`) → Sequential collapse:**
```verilog
always @(posedge clk) begin
    reg1 = in1;    // Blocking
    reg2 = reg1;
    reg3 = reg2;
    out1 = reg3;
end
```
- **Behavior:** Assignments execute sequentially within timestep
- **Synthesis:** reg1, reg2, reg3 optimized away → Single DFF: out1 = in1
- **Result:** 1 flip-flop (intermediate registers removed)

**Non-blocking (`<=`) → Parallel updates (shift register):**
```verilog
always @(posedge clk) begin
    reg1 <= in1;
    reg2 <= reg1;
    reg3 <= reg2;
    out1 <= reg3;
end
```
- **Behavior:** All RHS evaluated first; LHS updated in parallel at clock edge
- **Synthesis:** 4 flip-flops (shift register)
- **Result:** 4-stage pipeline

> **Coding guideline:** Use non-blocking (`<=`) for sequential logic to match simulation semantics and avoid optimization surprises.

---

## 5. Loop and Function Synthesis

### 5.1 For-Loop Unrolling

**Constant iteration count → Synthesizable:**
```verilog
for (idx = 0; idx < 4; idx = idx + 1) begin
    {carry, sum[idx]} = a[idx] + b[idx] + carry;
end
```
- **Translation:** 4 full adders chained (ripple-carry adder)
- **Requirement:** Loop bound must be compile-time constant

**Variable iteration count → Non-synthesizable:**
```verilog
for (idx = 0; idx < n; idx = idx + 1)  // n is variable
    ...
```
- **Error:** Tool cannot determine hardware extent

### 5.2 Function Synthesis

**Function → Combinational block:**
```verilog
function [7:0] add_and_negate;
    input [7:0] a, b;
    begin
        add_and_negate = -(a + b);
    end
endfunction

// Call
assign out1 = add_and_negate(x, y);
```
- **Translation:** Gates implementing `out1 = -(x + y)` (adder + negation)
- **Multiple calls:** Duplicate logic (no resource sharing unless explicitly optimized)

---

## 6. Operator Handling and Optimizations

### 6.1 Arithmetic Operators

**Internal representation:**
- Tools create operator graphs (not immediate gate mapping)
- Enables operator-level optimizations before gate-level translation

**Example operators:**
- `+`, `-`: Adder, subtractor (ripple-carry, carry-lookahead, etc.)
- `*`: Multiplier (array, Wallace tree, Booth encoding)
- `/`, `%`: Divider, modulo (expensive; avoid if possible)

**Technology mapping:**
- Map to parameterized modules (e.g., `add_WIDTH8` for 8-bit adder)
- Tool chooses architecture based on timing constraints

### 6.2 Resource Sharing

**Concept:** Combine multiple operators into fewer instances (reduce area).

**Example:**
```verilog
if (sel)
    z = a * b;
else
    z = x * y;
```

**Before optimization:** 2 multipliers + 1 output mux

**After resource sharing:** 1 multiplier + 2 input muxes (select operands first)
```
sel ? a : x → operand1
sel ? b : y → operand2
result = operand1 * operand2
```

**Trade-off:**
- **Area:** Reduced (1 multiplier vs 2)
- **Delay:** May increase (mux + multiplier on critical path)

**When beneficial:** Multiplier area >> mux area (typically true)

### 6.3 Speculation (Resource Unsharing)

**Concept:** Eager computation—compute both results, select later (reduce critical path delay).

**Example:**
```verilog
if (sel)
    y = b;
else
    y = c;
z = a + y;
```

**Before:** 1 mux + 1 adder (adder on critical path after mux)

**After speculation:** 2 adders + 1 output mux (adder off critical path)
```
temp1 = a + b;
temp2 = a + c;
z = sel ? temp1 : temp2;
```

**Trade-off:**
- **Delay:** Reduced (mux delay vs adder delay)
- **Area:** Increased (2 adders vs 1)
- **Power:** Increased (compute unused result)

**When beneficial:** Critical path timing-critical; area/power budget allows.

### 6.4 Compiler Optimizations

**1. Constant propagation:**
```verilog
a = 8 * 8;           // a = 64 (no multiplier)
b = a * 1024 / 32;   // b = 64 * 1024 / 32 = 2048 (no mult/div)
c = b + 32;          // c = 2080 (no adder)
```
- **Result:** All expressions collapsed to constants

**2. Common subexpression elimination (CSE):**
```verilog
x = p + a * b;
y = q + a * b;
```
- **Before:** 2 multipliers
- **After CSE:**
  ```verilog
  temp = a * b;
  x = p + temp;
  y = q + temp;
  ```
- **Result:** 1 multiplier (save 1 multiplier)

**3. Strength reduction:**

**Multiply/divide by power-of-2 → Shift:**
```verilog
x = a * 64;    // x = a << 6
y = b / 4;     // y = b >> 2
```

**Multiply by constant → Shift + add:**
```verilog
z = c * 17;    // z = (c << 4) + c  (17 = 16 + 1)
```

**Benefit:** Shift and add cheaper than multiplier.

---

## 7. Yosys Synthesis Workflow

### 7.1 Tool Overview

**Yosys Open Synthesis Suite:**
- Free, open-source RTL synthesis tool
- Alternative to commercial tools (Synopsys Design Compiler, Cadence Genus)
- Supports Verilog input, outputs gate-level netlist

### 7.2 Installation (Ubuntu/WSL)

**Install dependencies:**
```bash
sudo apt-get install build-essential clang bison flex \
  libreadline-dev gawk tcl-dev libffi-dev git graphviz \
  xdot pkg-config python3 libboost-system-dev \
  libboost-python-dev libboost-filesystem-dev zlib1g-dev
```

**Clone and compile:**
```bash
git clone https://github.com/YosysHQ/yosys.git
cd yosys
make
sudo make install
./yosys   # Launch interactive shell
```

### 7.3 Technology Library

**FreePDK45 (Silvaco Open-Cell 45nm):**
- Free PDK library for educational use
- Acquisition: Fill form at SI2 website (university email required) → download link via email (valid 3 days)
- Format: NLDM (Non-Linear Delay Model) `.lib` file
- Location: Extract from FreePDK45 package → `NLDM/*.lib`

### 7.4 Synthesis Commands

**Interactive mode:**
```tcl
yosys> read_verilog top.v
yosys> techmap
yosys> dfflibmap -liberty /path/to/library.lib
yosys> abc -liberty /path/to/library.lib
yosys> clean
yosys> write_verilog -noattr top_synth.v
```

**TCL script (yosys_commands.tcl):**
```tcl
read_verilog top.v
techmap
dfflibmap -liberty /path/to/FreePDK45.lib
abc -liberty /path/to/FreePDK45.lib
clean
write_verilog -noattr top_synth.v
```

**Execute script:**
```bash
yosys
yosys> script yosys_commands.tcl
```

**Command descriptions:**

| Command | Purpose |
|---------|---------|
| `read_verilog <file>` | Load RTL design |
| `techmap` | Map to internal library (generic gates) |
| `dfflibmap -liberty <lib>` | Map sequential elements (flip-flops) to standard cells |
| `abc -liberty <lib>` | Map combinational logic to standard cells |
| `clean` | Remove unused wires/cells |
| `write_verilog -noattr <output>` | Export netlist (suppress attributes for readability) |

### 7.5 Example: 2:1 Mux + D Flip-Flop

**Input (top.v):**
```verilog
module top(
    input wire a, b, clk, select,
    output reg out
);
    wire y;
    assign y = (select) ? b : a;
    always @(posedge clk)
        out <= y;
endmodule
```

**Synthesis:**
```bash
yosys> script yosys_commands.tcl
```

**Output (top_synth.v):**
```verilog
module top(a, b, clk, select, out);
    input a, b, clk, select;
    output out;
    wire y;
    
    MUX2X1 _0_ (.A(a), .B(b), .S(select), .Y(y));
    DFFPOSX1 _1_ (.CLK(clk), .D(y), .Q(out));
endmodule
```

**Result:** Instantiated standard cells from library (MUX2X1, DFFPOSX1).

---

## Key Takeaways

1. **Logic synthesis:** RTL → gate-level netlist; preserves functional equivalence while optimizing PPA
2. **Pipeline:** RTL synthesis (parse, elaborate, translate) → logic optimization → technology mapping → tech-dependent optimization
3. **Netlist terminology:** Design (top module), ports (PI/PO), cells (library), instances (placed cells), pins (interfaces), nets (wires)
4. **Generic vs standard:** Generic gates (early optimization, technology-independent) vs standard cells (accurate PPA, library-specific)
5. **Parsing:** Lexical analysis (tokenize) → syntax check → parse tree (hierarchy)
6. **Elaboration:** Link instances to masters → infer port directions → process parameters (create variants) → detect errors (black boxes, mismatches)
7. **Translation rules:** `assign`/if-else/case → mux; edge-sensitive always → flip-flops; level-sensitive always → combinational (all paths) or latches (missing updates)
8. **Blocking vs non-blocking:** Blocking (`=`) in sequential → collapse; non-blocking (`<=`) → shift register (use `<=` for sequential logic)
9. **Loops:** Constant iteration count → unroll; variable count → non-synthesizable
10. **Functions:** Combinational blocks; multiple calls duplicate logic
11. **Resource sharing:** Fewer operators (save area) but may increase delay; speculation: more operators (increase area) but reduce critical path delay
12. **Compiler optimizations:** Constant propagation, CSE (eliminate redundant ops), strength reduction (shift/add cheaper than multiply)
13. **Yosys workflow:** `read_verilog` → `techmap` → `dfflibmap` (sequential) → `abc` (combinational) → `clean` → `write_verilog`
14. **No SDC:** Yosys example lacks SDC → synthesis optimizes for minimum area only (timing constraints require SDC file)

---

## Tools and Commands

| Tool | Command/Usage | Purpose |
|------|---------------|---------|
| **Yosys** | `yosys` | Interactive synthesis shell |
| **Read RTL** | `read_verilog <file.v>` | Load design |
| **Tech map** | `techmap` | Map to internal library |
| **Sequential map** | `dfflibmap -liberty <lib>` | Map flip-flops |
| **Comb map** | `abc -liberty <lib>` | Map combinational logic |
| **Clean** | `clean` | Remove unused elements |
| **Write netlist** | `write_verilog -noattr <out.v>` | Export netlist |
| **Script** | `script <file.tcl>` | Execute TCL commands |
| **FreePDK45** | Download from SI2 | Free 45nm PDK library |

---

## Common Pitfalls

1. **Unintended latches:** Missing `default` in case or `else` in if → latch inference (add defaults/initialize variables)
2. **Black boxes:** Missing module files → elaboration assumes black box → downstream errors
3. **Port name typos:** `.d1(...)` vs `.d(...)` → elaboration error
4. **Using blocking in sequential:** `=` instead of `<=` in flip-flops → unexpected optimization (registers collapsed)
5. **Variable loop bounds:** Non-constant iteration → synthesis error
6. **Over-speculation:** Compute unused results → waste area/power (only apply on critical paths)
7. **Ignoring timing when resource sharing:** Mux + multiplier delay > mux alone → timing violations
8. **Forgetting `-liberty` flag:** Yosys dfflibmap/abc require library path
9. **Not including `-noattr`:** Attributes clutter netlist readability
10. **Assuming HLS/synthesis perfect:** Always verify generated RTL/netlist vs original intent

---

## Further Reading

- [[05-Logic-Optimization]]: Two-level, multi-level, FSM optimization techniques
- [[07-Technology-Libraries]]: Library characterization, timing models, NLDM format
- [[10-Technology-Mapping]]: Detailed mapping algorithms, PPA trade-offs
- [[11-Timing-Driven-Optimization]]: Gate sizing, buffering, retiming post-synthesis
- [[02-Hardware-Description-Languages]]: Verilog constructs, simulation semantics
- [[06-Formal-Verification]]: Equivalence checking (RTL ↔ netlist validation)
- [[21-EDA-Tools-and-Tutorials]]: Practical tool workflows (Yosys, Icarus, OpenRoad)
