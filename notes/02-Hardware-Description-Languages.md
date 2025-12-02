# Hardware Description Languages

> **Chapter Overview:** This chapter covers essential tools and languages for VLSI design, including Unix/WSL environment setup, TCL scripting for EDA automation, and comprehensive Verilog fundamentals—from syntax and data types to simulation mechanics and verification methodologies.

**Prerequisites:** [[01-Introduction-to-VLSI-Design]]  
**Related Topics:** [[04-Logic-Synthesis]], [[06-Formal-Verification]], [[21-EDA-Tools-and-Tutorials]]

---

## 1. Development Environment Setup

### 1.1 WSL (Windows Subsystem for Linux)

**Purpose:** Provides Unix environment on Windows for running EDA tools and scripts.

**Installation (Administrator PowerShell):**
```powershell
wsl --install
# Reboot system
# Set username and password on first launch
```

**Post-installation:**
- Ubuntu image installed by default
- Access via "Ubuntu" terminal
- Update packages: `sudo apt-get update`

### 1.2 Essential Unix Commands

**Navigation and File Operations:**

| Command | Purpose | Example |
|---------|---------|---------|
| `pwd` | Print working directory | `pwd` → `/home/user` |
| `ls` | List directory contents | `ls -la` (detailed, including hidden) |
| `cd` | Change directory | `cd /home/user/projects` |
| `mkdir` | Create directory | `mkdir tutorial1` |
| `mv` | Move or rename | `mv file.txt newname.txt` |
| `cp` | Copy files | `cp source.v dest.v` |
| `touch` | Create empty file | `touch test.txt` |
| `rm` | Remove files | `rm -r dirname` (recursive for directories) |
| `cat` | Display file contents | `cat design.v` |

**Command Discovery:**
- `which cmd`: Show executable path (e.g., `which ls` → `/bin/ls`)
- `man cmd`: Manual pages (e.g., `man ls`)

**System Administration:**
- `sudo`: Execute as administrator (requires password)
  - Example: `sudo apt-get install iverilog`
- `apt-get update`: Update package lists
- `apt-get install pkg`: Install software

**Resource Monitoring:**

| Command | Purpose | Options |
|---------|---------|---------|
| `du` | Disk usage per folder | `du -h` (human-readable: KB, MB, GB) |
| `df` | Filesystem free space | `df -h` |
| `ps` | List processes | `ps aux` (all users, detailed) |
| `top` | Live process monitor | Interactive; press `q` to quit |

**Job Control:**
- `jobs`: List background/suspended jobs
- `bg %1`: Resume job 1 in background
- `fg %1`: Bring job 1 to foreground
- `Ctrl+Z`: Suspend foreground job
- `Ctrl+C`: Kill foreground job

**History and User Info:**
- `history`: Show command history
- `whoami`: Display current username

> **Note:** Master these commands—they're essential for navigating EDA tool directories, managing simulation outputs, and monitoring long-running synthesis/P&R jobs.

---

## 2. TCL Scripting for EDA Automation

### 2.1 TCL Fundamentals

**TCL (Tool Command Language):** Scripting language for EDA tool automation, customization, and integration.

**Why TCL in VLSI?**
- Automate repetitive tasks (batch synthesis, constraint generation, report parsing)
- Customize tool flows (placement strategies, optimization directives)
- Integrate tools (pass data between synthesis, STA, P&R)

### 2.2 Variables and Data Types

**Variable declaration and access:**
```tcl
set varName value    # Set variable
puts $varName        # Access with $ prefix
```

**Lists:**
```tcl
set myList {elem1 elem2 elem3}
# Iterate
foreach item $myList {
    puts $item
}
# Modify element
lset myList 0 newValue    # Set index 0 to newValue
```

**Key rule:** Use `$` to access variable value; omit for declaration.

### 2.3 Control Flow

**If-else:**
```tcl
if {$var == 1} {
    puts "Var is 1"
} else {
    puts "Var is not 1"
}
```

**Foreach loop:**
```tcl
set numbers {1 2 3 4 5}
foreach num $numbers {
    if {$num % 2 == 0} {
        puts "$num is even"
    }
}
```

**While loop:**
```tcl
set i 0
while {$i < 10} {
    puts $i
    incr i    # Increment i by 1
}
```

**Continue and break:**
- `continue`: Skip to next iteration
- `break`: Exit loop

### 2.4 Expressions and Command Substitution

**Expression evaluation:**
```tcl
set result [expr {($a + $b) * $c}]
# expr evaluates arithmetic/logic expressions
```

**Square brackets `[]`:** Evaluate command first, substitute result
```tcl
set files [exec ls]        # Run ls, assign output to files
set sum [expr {$a + $b}]   # Evaluate expression
```

**Curly braces `{}`:** Defer evaluation, group as single argument
```tcl
if {$x > 0} { ... }   # Condition not evaluated until if runs
```

> **Critical distinction:** `[]` evaluates immediately; `{}` delays evaluation. Misusing these causes subtle bugs.

### 2.5 Procedures (Functions)

**Definition:**
```tcl
proc printSumProduct {x y z} {
    set sum [expr {$x + $y + $z}]
    set product [expr {$x * $y * $z}]
    puts "Sum: $sum"
    puts "Product: $product"
    return $sum    # Optional; stops execution
}
```

**Call:**
```tcl
printSumProduct 2 3 4
# Output:
# Sum: 9
# Product: 24
```

**Return:** Exits procedure and optionally returns value.

### 2.6 File I/O

**Open, write, read, close:**
```tcl
# Write
set fh [open "test.txt" "w+"]   # w+ = write mode (create/truncate)
puts $fh "Hello World"
close $fh

# Read
set fh [open "test.txt" "r"]
set contents [read $fh]
close $fh
puts $contents
# Output: Hello World
```

**File modes:**
- `r`: Read only
- `w`: Write only (create/truncate)
- `a`: Append
- `w+`, `r+`, `a+`: Read/write variants

> **Pitfall:** Always `close` file handles to avoid resource leaks.

### 2.7 System Command Execution

**Execute shell commands:**
```tcl
set files [exec ls]
puts $files

set currentDir [exec pwd]
puts $currentDir
```

**Use case:** Integrate TCL scripts with Unix tools (grep, awk, sed) for report parsing and data extraction.

### 2.8 Practical EDA Example

**Batch synthesis script:**
```tcl
# Loop through designs, synthesize each
set designs {adder multiplier alu}
foreach design $designs {
    puts "Synthesizing $design..."
    read_verilog ${design}.v
    synth -top $design
    write_verilog ${design}_netlist.v
    puts "$design complete"
}
```

**Generate SDC constraints:**
```tcl
proc create_clock_constraint {clk_name period} {
    set cmd "create_clock -name $clk_name -period $period \[get_ports clk\]"
    puts $cmd
    # In actual tool: eval $cmd
}

create_clock_constraint "sys_clk" 10.0
# Output: create_clock -name sys_clk -period 10.0 [get_ports clk]
```

---

## 3. Verilog Hardware Description Language

### 3.1 HDL vs Software Languages

**Distinct HDL features:**

| Feature | HDL (Verilog) | Software (C/Java) |
|---------|---------------|-------------------|
| **Concurrency** | Multiple blocks execute in parallel | Single thread of execution |
| **Timing** | Explicit delays (`#10`, `@posedge`) | No intrinsic timing |
| **Signal strength** | Resolve conflicting drivers | N/A |
| **Bit-level ops** | 4-valued logic (0, 1, x, z) | Binary (0, 1) |

**Example of concurrency:**
```verilog
// Two adders compute simultaneously
always @(*) sum1 = a + b;
always @(*) sum2 = c + d;
// Models parallel hardware, not sequential software
```

### 3.2 Verilog vs VHDL

| Aspect | Verilog | VHDL |
|--------|---------|------|
| **Origin** | Gateway Design (1983-84); "verification + logic" | DoD VHSIC program (1980s) |
| **Syntax** | C-like, concise | Pascal-like, verbose |
| **Type system** | Loose, implicit conversions | Strict, explicit typing |
| **Market share** | ~80% (with SystemVerilog) | ~20% |
| **Standards** | IEEE 1995, 2001, 2009 (SV) | IEEE 1987, 2019 |

**Industry trend:** Verilog/SystemVerilog dominates digital design; VHDL prevalent in aerospace/defense.

### 3.3 Lexical Elements

**White space:** Spaces, tabs, newlines, form feeds (token separators; ignored)

**Comments:**
```verilog
// Single-line comment
/* Block comment
   (no nesting allowed) */
```

**Keywords:** Reserved, lowercase
```verilog
module, input, output, wire, reg, always, begin, end, if, case, for, endmodule
```

**Identifiers:**
- Rules: Start with letter or `_`; alphanumeric + `$`; case-sensitive; max 1024 chars
- Examples: `Mymodule_top`, `Register_123`, `Net_1` ≠ `net_1`
- **Escaped identifiers:** Start with `\`, end with space; allow special chars
  ```verilog
  \net_(a+b)*c    // Space-terminated; allows parens, operators in name
  ```

**Operators:** `!`, `+`, `-`, `*`, `/`, `&&`, `||`, `==`, `!==`, `<<`, `>>`, `&`, `|`, `^`, `~`, `? :`, etc.

### 3.4 Number Representation

**Format:** `[-]<size>'<base><value>`
- **Base:** `b|B` (binary), `o|O` (octal), `d|D` (decimal), `h|H` (hex)
- **Size:** Bit width (default: 32 bits if omitted)

**Examples:**
```verilog
1                // 32-bit decimal 1
1'b1             // 1-bit binary 1
8'ha1            // 8-bit hex = 1010_0001
6'o71            // 6-bit octal = 111_001
-8'd6            // 8-bit 2's complement = 1111_1010
8'b1111_0000     // Underscore for readability (ignored)
```

**Special values:**
- `x` or `X`: Unknown or don't-care
- `z`, `Z`, or `?`: High-impedance (tri-state)

**Size mismatch:**
- Value > size: Truncate left bits
- Value < size: Pad left with 0 (unsigned) or sign-extend (signed)

**Real numbers:**
```verilog
3.14159          // Decimal notation
2.99E8           // Scientific notation
// Stored as IEEE double-precision internally
```

**Strings:**
```verilog
"Hello World"    // 8-bit ASCII per character
```

### 3.5 Four-Valued Logic

| Value | Meaning |
|-------|---------|
| `0` | Logic low (false) |
| `1` | Logic high (true) |
| `x` | Unknown or uninitialized |
| `z` | High-impedance (tri-state) |

**Use cases:**
- `x`: Model uninitialized registers, conflicts
- `z`: Tri-state buses, floating nets

> **Synthesis note:** `x` and `z` are for simulation only; synthesis tools handle them specially (often as don't-cares or errors).

### 3.6 Data Types

#### Nets (Structural Connections)

**Characteristics:** No storage; represent physical wires.

**Keywords:**
- `wire`: Standard net
- `supply0`: Permanent ground (GND)
- `supply1`: Permanent power (VDD)
- `wand`, `wor`: Wired-AND, wired-OR (multiple drivers)

**Declaration:**
```verilog
wire w1, w2;
wire [31:0] databus;    // 32-bit bus
```

#### Variables (Storage Elements)

**Characteristics:** Store last assigned value; keyword `reg`.

> **Critical:** `reg` does NOT imply hardware register. Synthesis context determines implementation:
> - Combinational `always @(*)` → combinational logic
> - Clocked `always @(posedge clk)` → flip-flop
> - Incomplete sensitivity → latch

**Declaration:**
```verilog
reg r1, r2;
reg [7:0] addressbus;    // 8-bit register
```

#### Vectors (Multi-bit Signals)

**Syntax:** `[MSB:LSB]` before identifier

**Examples:**
```verilog
wire [31:0] databus;        // 32-bit bus, bits 31 (MSB) to 0 (LSB)
reg [7:0] byte;             // 8-bit register

// Bit select
assign bit4 = databus[4];   // Select single bit

// Part select
assign nibble = byte[3:0];  // Select bits 3-0 (4 bits)
```

#### Arrays (Multi-dimensional Grouping)

**Syntax:** Range *after* identifier

**Examples:**
```verilog
reg r[15:0];                  // 16 × 1-bit registers (indexed 0 to 15)
wire matrix[9:0][9:0];        // 10 × 10 2D array of wires

// Access
r[5] = 1'b1;                  // Set 6th register to 1
matrix[2][3] = 1'b0;          // Set element (2,3) to 0
```

**Vector vs Array distinction:**
- **Vector:** Range *before* identifier → multi-bit signal
- **Array:** Range *after* identifier → collection of signals

---

## 4. Verilog Module Structure

### 4.1 Modules and Hierarchy

**Module:** Basic building block; encapsulates functionality.

**Structure:**
```verilog
module module_name (port_list);
    // Port declarations
    input ...;
    output ...;
    
    // Internal signals
    wire ...;
    reg ...;
    
    // Logic (gates, assignments, always blocks)
    ...
    
    // Sub-module instantiations
    ...
endmodule
```

**Hierarchy:** Modules instantiate other modules → tree structure
```
Top
├── Mid
│   └── Bottom_1
└── Bottom_2
```

### 4.2 Port Connections

**Implicit (by order):** Match position in declaration
```verilog
mid m1(c, p_in, p_out);
// Connects in order: clock←c, d_in←p_in, d_out←p_out
```
> **Pitfall:** Hard to debug with 100+ ports; order errors cause misconnections.

**Explicit (by name):** Recommended for readability
```verilog
mid m1(.clock(c), .d_in(p_in), .d_out(p_out));
// Order-independent; self-documenting
```

### 4.3 Parameterized Modules

**Definition:**
```verilog
module counter #(parameter WIDTH = 4) (
    input wire clk,
    input wire rst,
    output reg [WIDTH-1:0] count
);
    always @(posedge clk or posedge rst)
        if (rst) count <= 0;
        else count <= count + 1;
endmodule
```

**Instantiation with parameter override:**
```verilog
counter #(16) C1(...);              // WIDTH = 16
counter #(.WIDTH(128)) C2(...);     // WIDTH = 128
counter C3(...);                    // WIDTH = 4 (default)
```

**Tool behavior:** Creates separate modules per parameter set (e.g., `counter_WIDTH_4`, `counter_WIDTH_16`).

### 4.4 Built-in Gates

**Primitives:** `and`, `nand`, `or`, `nor`, `xor`, `xnor`

**Syntax:** `gate_type instance_name(output, input1, input2, ...);`

**Example:**
```verilog
and a1(y1, a, b);     // y1 = a & b
nand n1(y2, c, d);    // y2 = ~(c & d)
xor x1(y3, e, f);     // y3 = e ^ f
```

---

## 5. Operators

### 5.1 Operator Categories

**Arithmetic:** `+`, `-`, `*`, `/`, `%`
```verilog
sum = a + b;
quotient = a / b;
remainder = a % b;
```

**Logical:** `&&` (AND), `||` (OR), `!` (NOT)
```verilog
if (a && b) ...    // True if both a and b non-zero
```

**Bitwise:** `&`, `|`, `~`, `^`
```verilog
result = a & b;    // Bitwise AND
inverted = ~a;     // Bitwise NOT
```

**Relational:** `<`, `>`, `<=`, `>=`, `==`, `!=`
```verilog
if (a == b) ...
if (x > 10) ...
```

**Shift:** `<<` (left), `>>` (right)
```verilog
shifted = a << 2;  // Shift left by 2 (multiply by 4)
```

**Reduction:** Operate on all bits of single operand
```verilog
wire [3:0] A = 4'b1011;
wire y = &A;    // 1 & 0 & 1 & 1 = 0 (AND all bits)
wire z = |A;    // 1 | 0 | 1 | 1 = 1 (OR all bits)
wire p = ^A;    // 1 ^ 0 ^ 1 ^ 1 = 1 (XOR parity)
```

**Concatenation:** `{a, b, c}`
```verilog
wire [1:0] a = 2'b11;
wire [3:0] b = 4'b0101;
wire c = 1'b0;
wire [6:0] result = {a, b, c};  // 7 bits: 11_0101_0
```

**Replication:** `{count{value}}`
```verilog
wire [7:0] extended = {4{2'b10}};  // 10_10_10_10
wire [3:0] padded = {2'b11, 2{1'b0}};  // 11_0_0
```

**Ternary (conditional):** `condition ? true_value : false_value`
```verilog
assign out = sel ? a : b;  // Multiplexer
```

---

## 6. Control Structures and Blocks

### 6.1 Statement Blocks

**Sequential (`begin...end`):** Execute in order
```verilog
begin
    a = b + c;
    d = a * 2;
    // Executes: statement 1, then statement 2
end
```

**Parallel (`fork...join`):** Execute concurrently
```verilog
fork
    #10 a = 1;
    #20 b = 1;
    #5 c = 1;
join
// All scheduled at t=0; updates at t=5, 10, 20
```

**Named blocks:** Optional
```verilog
begin : my_block
    ...
end
```

### 6.2 If-Else

**Syntax:**
```verilog
if (condition)
    statement;
else if (condition2)
    statement2;
else
    statement3;
```

**Multiplexer example:**
```verilog
always @(*) begin
    if (sel == 2'b00)      y = a;
    else if (sel == 2'b01) y = b;
    else if (sel == 2'b10) y = c;
    else                   y = d;
end
```

### 6.3 Case Statement

**Syntax:**
```verilog
case (expression)
    value1: statement1;
    value2: statement2;
    default: default_statement;
endcase
```

**Example:**
```verilog
case (sel)
    2'b00: y = a;
    2'b01: y = b;
    2'b10: y = c;
    default: y = d;
endcase
```

**Variants:**
- `casez`: Treat `z` as don't-care
- `casex`: Treat `x` and `z` as don't-care

> **Synthesis guideline:** Always include `default` to avoid latches.

### 6.4 Loops

**For loop:**
```verilog
integer i;
for (i = 0; i < 8; i = i + 1) begin
    memory[i] = 0;
end
```

**While loop:**
```verilog
integer count = 0;
while (count < 10) begin
    sum = sum + data[count];
    count = count + 1;
end
```

**Repeat loop:**
```verilog
repeat (8) begin
    clk = ~clk;
    #10;
end
```

**Continue and break:**
- `continue`: Skip to next iteration
- `break`: Exit loop

---

## 7. Structured Procedures

### 7.1 Initial Block

**Purpose:** Executes once at t=0; used for testbenches, initialization.

**Example:**
```verilog
initial begin
    clk = 0;
    rst = 1;
    #100 rst = 0;    // De-assert reset after 100 time units
    #2000 $finish;   // End simulation
end
```

> **Note:** Multiple `initial` blocks can exist; no guaranteed execution order (models hardware concurrency).

### 7.2 Always Block

**Purpose:** Executes repeatedly; models hardware behavior.

**Sensitivity list:**
```verilog
// Level-sensitive (combinational)
always @(en or a or b)
    if (en) y = a + b;

// Edge-sensitive (sequential)
always @(posedge clk)
    q <= d;

// Auto-sensitivity (combinational)
always @(*)
    y = a & b;
```

**Event types:**
- `@(signal)`: Level-sensitive (any change)
- `@(posedge clk)`: Rising edge
- `@(negedge clk)`: Falling edge
- `@(posedge clk or negedge rst)`: Multiple events
- `@*`: Automatic (all read signals; combinational only)

### 7.3 Functions

**Characteristics:**
- ≥1 input, exactly 1 output
- No delays (`#`, `@`)
- Combinational only
- Can call other functions

**Syntax:**
```verilog
function [return_width] function_name;
    input [width] input1, input2, ...;
    begin
        function_name = expression;
    end
endfunction
```

**Example:**
```verilog
function [7:0] add_and_negate;
    input [7:0] a, b;
    begin
        add_and_negate = -(a + b);
    end
endfunction

// Call
result = add_and_negate(x, y);
```

### 7.4 Tasks

**Characteristics:**
- 0+ inputs, 0+ outputs/inouts
- Allows delays
- Can model combinational or sequential
- Can call functions and other tasks

**Syntax:**
```verilog
task task_name;
    input ...;
    output ...;
    begin
        ...
    end
endtask
```

**Example:**
```verilog
task full_adder;
    input a, b, cin;
    output sum, cout;
    begin
        sum = a ^ b ^ cin;
        cout = (a & b) | (b & cin) | (cin & a);
    end
endtask

// Call
full_adder(x, y, carry_in, result, carry_out);
```

---

## 8. Assignments

### 8.1 Continuous Assignment

**Purpose:** Model combinational logic; drives nets.

**Syntax:**
```verilog
assign target = expression;
```

**Examples:**
```verilog
assign out = a & b;              // AND gate
assign mux_out = sel ? a : b;    // 2:1 multiplexer
assign {carry, sum} = a + b;     // Adder with carry
```

**Characteristics:**
- Evaluated whenever RHS changes
- Cannot drive `reg` variables (only nets)
- Models structural connections

### 8.2 Procedural Assignments

**Context:** Inside `initial`, `always`, `function`, `task`.

**Types:** Blocking (`=`), Non-blocking (`<=`)

#### Blocking Assignment (`=`)

**Behavior:** Sequential execution; next statement waits.

**Example:**
```verilog
initial begin
    a = #10 1'b1;    // Wait 10, assign a=1 at t=10
    b = #30 1'b1;    // Wait 30 MORE, assign b=1 at t=40
    c = #20 1'b1;    // Wait 20 MORE, assign c=1 at t=60
end
// Timeline: a@10, b@40, c@60
```

**Use case:** Combinational logic, sequential test code.

#### Non-blocking Assignment (`<=`)

**Behavior:** Two-step process (parallel execution)
1. **Evaluate:** RHS evaluated, LHS update scheduled
2. **Update:** All scheduled LHS updates occur at end of timestep

**Example:**
```verilog
initial begin
    p <= #10 1'b1;
    q <= #30 1'b1;
    r <= #20 1'b1;
end
// All RHS evaluated at t=0
// p scheduled to update at t=10
// q scheduled to update at t=30
// r scheduled to update at t=20
// Timeline: p@10, r@20, q@30 (parallel scheduling)
```

**Use case:** Flip-flops, parallel hardware updates.

### 8.3 Blocking vs Non-Blocking Guidelines

**Combinational logic:**
```verilog
always @(*) begin
    temp = a & b;
    out = temp | c;    // Blocking: sequential evaluation
end
```

**Sequential logic (flip-flops):**
```verilog
always @(posedge clk) begin
    q1 <= d1;
    q2 <= q1;    // Non-blocking: parallel update (shift register)
end
```

> **Critical rule:** Never write same variable in multiple `always` blocks → race conditions.

---

## 9. Simulation and Verification

### 9.1 Testbench Framework

**Components:**
1. **DUV (Design Under Verification):** RTL to test
2. **Stimulus generator:** Apply inputs
3. **Response monitor:** Check outputs

**Testbench structure:**
```verilog
module testbench;
    // Declare signals
    reg clk, rst;
    wire [3:0] count;
    
    // Instantiate DUV
    counter DUV(.clk(clk), .rst(rst), .count(count));
    
    // Generate clock
    initial clk = 0;
    always #50 clk = ~clk;    // Period 100
    
    // Apply stimulus
    initial begin
        rst = 1;
        #100 rst = 0;
        #2000 $finish;
    end
    
    // Monitor outputs
    initial begin
        $dumpfile("sim.vcd");
        $dumpvars;
        $monitor("Time=%0t clk=%b rst=%b count=%h", 
                 $time, clk, rst, count);
    end
endmodule
```

### 9.2 System Tasks for Simulation

| Task | Purpose | Example |
|------|---------|---------|
| `$display` | Print once | `$display("Value=%d", x);` |
| `$monitor` | Print on change | `$monitor("clk=%b q=%b", clk, q);` |
| `$dumpfile` | Specify VCD file | `$dumpfile("waves.vcd");` |
| `$dumpvars` | Enable waveform dump | `$dumpvars;` (all signals) |
| `$time` | Current simulation time | `$display("Time=%0t", $time);` |
| `$finish` | End simulation | `$finish;` |
| `$stop` | Pause simulation | `$stop;` |
| `$random` | Random number | `data = $random;` |

### 9.3 Coverage Models

**Code coverage:** Measures RTL execution

| Type | Measures | Use |
|------|----------|-----|
| **Line** | Statements executed | Identify unexecuted code |
| **Branch** | If/else, case paths taken | Ensure both true/false tested |
| **State** | FSM states visited | Verify all states reachable |
| **Toggle** | Signals toggled 0→1, 1→0 | Detect stuck-at faults |

**Limitation:** Only measures existing code; cannot detect missing features.

**Functional coverage:** Measures design features exercised
- Requires manual coverage model (feature list)
- Detects missing implementation
- Example: "Did we test all opcodes?" (code coverage can't answer if opcode missing)

### 9.4 Simulation Mechanics

**Event-driven simulation:**
1. **Update events:** Signal value changes
2. **Evaluation events:** Process triggered by update
3. **Timing wheel:** Queue events by simulation time

**Stratified event queue (within single timestep):**
```
1. Active events      → assign, blocking =, RHS of <=, $display
2. Inactive events    → #0 delays (avoid)
3. NBA update         → LHS of <= updated
4. Monitor events     → $monitor, $strobe
5. Future events      → Next time slot
```

**Key insight:** Within active events, no guaranteed order → models hardware concurrency.

**Example:**
```verilog
initial begin
    a = 1'b0;            // Active: a=0
    a <= 1'b1;           // Active: eval RHS; NBA: schedule a=1
    $display("%b", a);   // Active: displays 0 (a not yet updated)
end                      // NBA update: a=1 (after display)
// Output: 0
```

### 9.5 Race Conditions

**Definition:** Results depend on arbitrary event execution order.

**Example (race):**
```verilog
initial a = 1'b0;    // Block 1
initial a = 1'b1;    // Block 2
// Result: a = 0 or 1 (simulator-dependent)
```

**Avoidance guidelines:**
1. Use blocking (`=`) for combinational, non-blocking (`<=`) for sequential
2. Never write same variable in multiple `always` blocks
3. Follow consistent coding styles

---

## Key Takeaways

1. **Unix/WSL:** Essential for VLSI workflows; master navigation (`cd`, `ls`), file ops (`cp`, `rm`), resource monitoring (`du`, `df`, `ps`, `top`), job control (`bg`, `fg`)
2. **TCL scripting:** Automate EDA tasks; master variables (`set`/`$`), control flow (`if`, `foreach`), expressions (`expr`, `[]`), procedures (`proc`), file I/O (`open`/`puts`/`close`), system exec (`exec`)
3. **Verilog fundamentals:** 4-valued logic (0, 1, x, z); nets (`wire`) vs variables (`reg`); vectors vs arrays; identifiers (case-sensitive, max 1024 chars)
4. **Number formats:** `<size>'<base><value>` (e.g., `8'ha1`, `-8'd6`); underscores for readability; size mismatch rules
5. **Modules:** Hierarchical design; explicit port mapping (`.port(net)`) recommended; parameterized modules (`parameter WIDTH=4; #(16)`)
6. **Operators:** Reduction (`&A`), concatenation (`{a,b}`), replication (`{4{a}}`), ternary (`c?a:b`)
7. **Control structures:** `if`/`case` (always include `default`), loops (`for`, `while`, `repeat`), blocks (`begin...end` sequential, `fork...join` parallel)
8. **Procedures:** Initial (once at t=0), always (repeated; level/edge-sensitive), functions (1 output, no delays), tasks (multiple outputs, allows delays)
9. **Assignments:** Continuous (`assign`; combinational), blocking (`=`; sequential code), non-blocking (`<=`; flip-flops, parallel updates)
10. **Simulation:** Testbench = stimulus + DUV + monitor; VCD for waveforms; coverage (code: line/branch/state/toggle; functional: feature list)
11. **Event mechanics:** Stratified queue (active → NBA update → monitor); active events no priority (models concurrency)
12. **Race conditions:** Avoid by using blocking for combinational, non-blocking for sequential; never write variable in multiple blocks

---

## Tools and Commands

| Category | Tool/Command | Purpose |
|----------|--------------|---------|
| **Unix** | `pwd`, `ls`, `cd`, `mkdir`, `cp`, `mv`, `rm`, `cat` | Navigation, file management |
| **Unix** | `which`, `man`, `sudo`, `apt-get` | Command discovery, admin |
| **Unix** | `du`, `df`, `ps`, `top`, `jobs`, `bg`, `fg` | Resource monitoring, job control |
| **TCL** | `tclsh`, `set`, `expr`, `foreach`, `proc`, `open`, `exec` | Scripting, automation |
| **Verilog** | `iverilog`, `vvp`, `gtkwave` | Compile, simulate, view waveforms |
| **Simulation** | `$dumpfile`, `$dumpvars`, `$monitor`, `$display`, `$finish` | Testbench utilities |

---

## Common Pitfalls

1. **WSL/Unix:** Forgetting `sudo` for admin tasks; misusing `rm` without `-r` for directories
2. **TCL:** Forgetting `$` for variable access; confusing `[]` (evaluate) vs `{}` (defer); not closing file handles
3. **Verilog identifiers:** Case-sensitivity (`Net_1` ≠ `net_1`); exceeding 1024 char limit
4. **Numbers:** Forgetting default size is 32 bits; misunderstanding size mismatch rules
5. **reg keyword:** Assuming `reg` = hardware register (synthesis context determines implementation)
6. **Port connections:** Using implicit (by order) for large designs → hard to debug
7. **Assignments:** Using blocking for sequential or non-blocking for combinational → race conditions
8. **Case statements:** Missing `default` → unintended latches
9. **Multiple always:** Writing same variable in multiple blocks → non-deterministic results
10. **Simulation:** Redundant stimuli (use coverage to guide); missing branches (incomplete testing)

---

## Further Reading

- [[04-Logic-Synthesis]]: RTL → gate-level netlist transformation
- [[06-Formal-Verification]]: Equivalence checking, model checking
- [[21-EDA-Tools-and-Tutorials]]: Practical tool workflows (Icarus, Yosys, OpenRoad)
- [[08-Static-Timing-Analysis]]: Timing verification fundamentals
- [[13-Design-for-Test]]: Testability, scan design, ATPG
