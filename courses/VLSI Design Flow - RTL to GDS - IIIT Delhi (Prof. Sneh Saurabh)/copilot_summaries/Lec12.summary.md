# Lec12 — Introduction to Verilog II: Modules, Operators, Blocks, and Assignments

## Overview
Continues Verilog constructs: modules and hierarchy, ports and instantiation, parameterized modules, built-in gates, operators, statement blocks (sequential/parallel), control structures (if/case/loops), structured procedures (initial/always/function/task), assignments (continuous/procedural/blocking/non-blocking), and system tasks.

## Core concepts
**Modules and hierarchy:**
- **Module:** Basic building block; starts with `module`, ends with `endmodule`; instantiated inside other modules to create hierarchy (tree structure)
- **Instantiation:** Copy module definition into higher-level module; `mid m1(.clock(c), .d_in(p_in), .d_out(p_out));` where `mid` = module name, `m1` = instance name

**Port connections:**
- **By order (implicit):** Ports connected based on position in module declaration; hard to debug (100+ ports ambiguous)
- **By name (explicit):** `.clock(c)` → safer, order-independent; recommended for large designs

**Parameterized modules:**
- Keyword: `parameter WIDTH = 4;` (default value)
- Override at instantiation: `counter #(16) C1(...);` or `counter #(.WIDTH(128)) C2(...);`
- Tool creates separate modules per parameter set (e.g., `counter_WIDTH_4`, `counter_WIDTH_8`)

**Built-in gates:**
- Primitives: `and`, `nand`, `or`, `nor`, `xor`, `xnor`
- Convention: 1st pin = output, rest = inputs; example: `and a1(y1, a, b);`

**Operators:**
- **Arithmetic:** `+`, `-`, `*`, `/`, `%`
- **Logical:** `&&`, `||`, `!`
- **Bitwise:** `&`, `|`, `~`, `^`
- **Relational:** `<`, `>`, `<=`, `>=`, `==`, `!=`
- **Shift:** `<<`, `>>`
- **Reduction:** `&A` (AND all bits of A), `|B`, `^C` (XOR parity)
- **Concatenation:** `{a, b, c}` (combine bits)
- **Replication:** `{4{a}, b, 2{c}}` (4 copies of a, 1 of b, 2 of c)
- **Ternary:** `c ? a : b` (if c then a else b)

**Statement blocks:**
- **Sequential:** `begin ... end` (execute in order: statement-1, statement-2, ...)
- **Parallel:** `fork ... join` (execute concurrently)
- Optional block name: `begin : my_block_name`

**Control structures:**
- **If-else:** `if (condition) ... else ...`
- **Case:** `case(sel) 0: y=a; 1: y=b; 2: y=c; default: y=d; endcase`
  - Variants: `casez` (treat z as don't care), `casex` (treat x and z as don't care)
- **Loops:** `for (i=0; i<8; i=i+1)`, `while (i<8)`, `repeat (8)`

**Structured procedures:**
- **Initial block:** Executes once at t=0, then stops; used for testbenches, initialization
- **Always block:** Executes repeatedly throughout simulation; models hardware
  - Event control: `@(en)` (level-sensitive), `@(posedge clk)` (edge-sensitive), `@(posedge clk or negedge rst)` (sensitivity list), `@*` (auto-sensitivity for all read signals)
- **Function vs Task:**
  - Function: ≥1 input, 1 output; no delays; combinational; can call other functions; example: `function myfunc; input x,y,z; myfunc = x-y+z; endfunction`
  - Task: 0+ inputs, 0+ outputs/inouts; allows delays (`#`, `posedge`); combinational/sequential; can call functions/tasks; example: `task mytask; input x,y; output sum, carry; ... endtask`

**Assignments:**
- **Continuous:** `assign out = (s)?a:b;` → models combinational logic (drives nets)
- **Procedural:** Used in initial/always/function/task; drives variables (reg, integer)
  - **Blocking (`=`):** Sequential execution (next statement waits); example: `a = #10 1'b1;` then `b = #30 1'b1;` → t=10, 40
  - **Non-blocking (`<=`):** Parallel execution in 2 steps: (1) evaluate RHS, schedule LHS update, (2) update all LHS at end of timestep; example: `p <= #10 1'b1; q <= #30 1'b1; r <= #20 1'b1;` → all RHS evaluated first, then LHS updated at t=10, 30, 20 respectively

**System tasks/functions:**
- Names start with `$`: `$display`, `$monitor`, `$stop`, `$finish`, `$random`, `$time`, etc.
- Debugging and verification utilities

## Methods/flows
1. **Module definition:** `module top(...); ... endmodule`
2. **Instantiation:** Explicit port mapping preferred (`mid m1(.clock(c), ...);`)
3. **Parameterize:** Define `parameter WIDTH=4;`, override at instantiation `#(16)`
4. **Control flow:** Use `if`, `case`, `for`/`while`/`repeat` for behavioral modeling
5. **Always blocks:** Level-sensitive (`@(en)`) or edge-sensitive (`@(posedge clk)`)
6. **Assignments:** Continuous for combinational; blocking for sequential in procedural; non-blocking for flip-flop/parallel updates

## Constraints/assumptions
- Module = topmost design entity; can have multiple modules, initial/always blocks (no predefined execution order → models hardware concurrency)
- Initial blocks execute once; always blocks loop forever
- No precedence between initial/always blocks → simulator free to choose order (designer must ensure order-independent correctness)
- Blocking assignment blocks next statement; non-blocking schedules update (completes at end of timestep)

## Examples
- **Hierarchy:** `module top; mid m1(...); bottom_2 b2(...); endmodule` → tree: Top → {Mid, Bottom_2}, Mid → {Bottom_1}
- **Explicit connection:** `mid m1(.clock(c), .d_in(p_in), .d_out(p_out));` → safer than positional
- **Parameter:** `counter #(16) C1(...);` → WIDTH=16; `counter C2(...);` → WIDTH=4 (default)
- **Reduction:** `A = 4'b1011; y = &A;` → 1 & 1 = 1, 1 & 0 = 0, 0 & 1 = 0 → y=0
- **Concatenation:** `{a[1:0], b[3:0], c}` → 2+4+1=7 bits
- **Non-blocking timing:** `initial begin p<=#10 1'b1; q<=#30 1'b1; r<=#20 1'b1; end` → p scheduled t=10, q at t=30, r at t=20 (all evaluate at t=0, update at respective times)
- **Function call:** `out1 = myfunc(a, b, c);` → out1 = a - b + c
- **Task call:** `mytask(a, b, s1, c1);` → inputs a, b; outputs sum=s1, carry=c1

## Tools/commands
- Verilog simulators (commercial/open-source): execute initial/always blocks
- Synthesis tools: interpret modules, always blocks for netlist generation

## Common pitfalls
- Implicit port connection (by order) hard to debug (use explicit `.port(net)`)
- Forgetting `default` in `case` → unintended latches
- Confusing blocking vs non-blocking: use blocking for combinational (sequential execution), non-blocking for sequential circuits (flip-flops)
- Race conditions if results depend on arbitrary order of initial/always blocks

## Key takeaways
- Modules are hierarchical building blocks; explicit port mapping reduces errors
- Parameterized modules enable reusable, configurable designs (one module, multiple widths)
- Always blocks model hardware (level/edge-sensitive); initial blocks for testbenches
- Blocking (`=`) vs non-blocking (`<=`): blocking for sequential code, non-blocking for parallel hardware updates (flip-flops)
- Functions (1 output, no delays) vs tasks (multiple outputs, allows delays)
- Operators include reduction (`&A`), concatenation (`{a,b}`), replication (`{4{a}}`)

**Cross-links:** See Lec11: basic syntax, data types; Lec13: simulation mechanics, stratified event queue; Lec15: synthesis of always blocks, if/case

---

*This summary condenses Lec12 from ~11,000 tokens, removing meta-discussion ("this lecture covers..."), redundant examples, and lecturer asides.*
