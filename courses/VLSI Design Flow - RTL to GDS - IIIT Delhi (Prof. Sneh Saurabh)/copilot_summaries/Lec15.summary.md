# Lec15 — RTL Synthesis Part I: Parsing, Elaboration, and Construct Translation

## Overview
Covers RTL synthesis tasks: parsing (lexical analysis, syntax tree), elaboration (instance-master linkages, parameter processing, black box detection), and translation of Verilog constructs to logic gates (assign, if-else, case, always blocks with blocking/non-blocking assignments, edge-sensitive/level-sensitive behavior).

## Core concepts
**RTL synthesis tasks:**
1. **Parsing:** Read RTL files → lexical analysis (tokenize) → syntax check → build parse tree (hierarchical data structure)
2. **Elaboration:** Link instances to master modules → infer port directions → process parameters → detect errors (missing modules, port mismatches)
3. **Translation:** Map Verilog constructs to logic gates (combinational/sequential circuits)
4. **Optimization:** RTL-specific optimizations (covered in Lec16)

**Parsing:**
- **Lexical analysis:** Break RTL code into tokens (keywords, identifiers, operators, literals)
- **Syntax checking:** Verify grammar compliance (report syntax errors if violated)
- **Parse tree (syntax tree):** Hierarchical data structure reflecting parent-child relationships (modules contain always blocks contain statements)
  - Example: `module top` → root; `always` block → child; statements → children of always block

**Elaboration:**
- **Instance-master linkages:** Connect instances to their module definitions (e.g., instance `F1` → master `leaf`)
- **Port direction inference:** Determine input/output/inout for each pin (inferred from master module)
- **Parameter processing:** Create distinct modules for each parameter set (e.g., `counter_WIDTH_4`, `counter_WIDTH_8`, `counter_WIDTH_16`)
- **Error detection:**
  - **Black box:** Instance references undefined module (missing Verilog file) → tool assumes black box, cannot infer pin directions
  - **Port mismatch:** Instance port name doesn't match master (typo: `.d1(...)` vs `.d(...)`)
  - **Width mismatch:** Bus width inconsistency between instance and master

**Synthesizable vs non-synthesizable constructs:**
- **Non-synthesizable:** Delay (`#12`), initial blocks, fork/join, force/release, real/time data types, system tasks (`$display`, `$monitor`)
  - Delays ignored during synthesis (used only for simulation)
- **Synthesizable:** assign, if-else, case, always blocks, functions, tasks (with caveats)

**Translation of constructs:**
- **Assign statement → Combinational logic:** `assign out1 = (a & b) | c;` → AND + OR gates; `assign out2 = x & y;` (4-bit) → 4 AND gates; `assign out3 = s ? q : p;` → 2:1 mux
- **If-else → Multiplexer:** `if (s==0) out1=a; else out1=b;` → 2:1 mux (select=s, inputs=a/b)
- **Case → Multiplexer/Priority logic:**
  - Simple case: `case(s) 2'b00: a; 2'b01: b; 2'b10: c; 2'b11: d; endcase` → 4:1 mux (2-bit select)
  - Priority case: `case(s) 2'b1?: a; 2'b?1: b; default: c; endcase` → priority encoder (if `s[1]==1` → a, else if `s[0]==1` → b, else c)
- **Always block (edge-sensitive) → Flip-flops:**
  - **Posedge clock:** `always @(posedge clk) q <= d;` → D flip-flop
  - **Async reset:** `always @(posedge clk or negedge rst)` → DFF with async reset (active-low)
  - **Sync reset:** `always @(posedge clk) if (!rst) q<=0; else q<=d;` → DFF + mux (reset synchronous with clock)
- **Always block (level-sensitive) → Combinational or Latches:**
  - **All branches update variable → Combinational:** `always @* if (s) out1=a; else out1=b;` → 2:1 mux
  - **Missing branch → Latch:** `always @* if (en) out2=c;` → D latch (enable=en, data=c; holds old value when en=0)
- **Blocking vs Non-blocking assignments:**
  - **Blocking (`=`) in sequential always:** `always @(posedge clk) begin reg1=in1; reg2=reg1; reg3=reg2; out1=reg3; end` → Single DFF (out1=in1; intermediate regs optimized away)
  - **Non-blocking (`<=`) in sequential always:** `always @(posedge clk) begin reg1<=in1; reg2<=reg1; reg3<=reg2; out1<=reg3; end` → 4-stage shift register (4 DFFs)

## Methods/flows
1. **Parsing:** Tokenize RTL → check syntax → build parse tree (modules → always blocks → statements → LHS/RHS)
2. **Elaboration:** Link instances to masters → infer directions → process parameters (create `module_PARAM_value` variants) → report black boxes/mismatches
3. **Translation:** Map Verilog constructs:
   - `assign` → combinational gates (AND, OR, mux)
   - `if-else` → mux (condition = select)
   - `case` → mux (simple) or priority logic (don't cares)
   - Edge-sensitive always → flip-flops (posedge/negedge)
   - Level-sensitive always → combinational (all paths update) or latches (missing updates)
   - Blocking in always → sequential collapse (optimize redundant regs)
   - Non-blocking in always → parallel updates (shift registers)

## Constraints/assumptions
- RTL synthesis tools may not support all Verilog constructs (tool-specific; consult documentation)
- Delay specifications (`#`) ignored in synthesis (simulation-only)
- Elaboration requires all referenced modules present (else black box → errors downstream)
- Latch inference often unintended (missing branches in combinational always blocks)

## Examples
- **Parse tree:** Module `top` → child `mid` → child `always` → children: 3 statements (2 non-blocking, 1 blocking)
- **Elaboration:** Instance `I1` master `leaf` → link ports `d`, `clk`, `q` → infer directions (input, input, output)
- **Parameter:** `counter #(16) C1(...)` → elaboration creates `counter_WIDTH_16` module (distinct from default `counter_WIDTH_4`)
- **Assign:** `assign out1 = (a & b) | c;` → AND gate (a, b) → OR gate (AND_out, c) → out1
- **If-else:** `if (s==0) out1=a; else out1=b;` → 2:1 mux (s=0 → a, s=1 → b)
- **Case priority:** `case(s) 2'b1?: a; 2'b?1: b; default: c; endcase` → if s[1]=1 → a; else if s[0]=1 → b; else c
- **Edge-sensitive:** `always @(posedge clk) q<=d;` → D flip-flop
- **Latch (unintended):** `always @* if (en) out2=c;` → D latch (missing else branch → holds old value)
- **Blocking collapse:** `always @(posedge clk) begin r1=in1; r2=r1; r3=r2; out1=r3; end` → 1 DFF (out1=in1; r1/r2/r3 optimized)
- **Non-blocking shift:** `always @(posedge clk) begin r1<=in1; r2<=r1; r3<=r2; out1<=r3; end` → 4 DFFs (shift register)

## Tools/commands
- **RTL synthesis tools:** Synopsys Design Compiler, Cadence Genus, Yosys (open-source)
- **Language reference:** IEEE Verilog LRM (1364-2001/2005) → authoritative syntax/semantics

## Common pitfalls
- **Black boxes:** Missing module files → elaboration errors (tool assumes undefined modules are black boxes)
- **Port name typos:** `.d1(...)` vs `.d(...)` → elaboration error (port not found in master)
- **Unintended latches:** Forgetting `default` in case or missing `else` in combinational always → latch inference
  - **Fix:** Add `default: var=0;` in case, or initialize variable before if-else (`out1=0; if (en) out1=c;`)
- **Blocking in flip-flop:** Using `=` instead of `<=` in sequential always → unexpected optimization (registers collapsed)
- **Non-blocking in combinational:** Using `<=` in `@*` always → delays updates to NBA queue (simulation correct, synthesis may mismatch)

## Key takeaways
- RTL synthesis: Parsing (tokenize, syntax tree) → Elaboration (link instances, process parameters) → Translation (Verilog → gates)
- Elaboration detects black boxes (missing modules), port/width mismatches; creates parameterized module variants
- Non-synthesizable: delays (`#`), initial blocks, system tasks (simulation-only; ignored by synthesis)
- Translation rules:
  - `assign`, if-else, case → combinational (mux, gates)
  - Edge-sensitive always → flip-flops (async/sync reset variants)
  - Level-sensitive always → combinational (all paths update) or latches (missing updates)
  - Blocking (`=`) → sequential collapse; non-blocking (`<=`) → parallel updates (shift registers)
- Avoid unintended latches: use `default` in case, initialize variables before conditionals
- Verilog semantics follow simulation (synthesis mimics simulation behavior for blocking/non-blocking)

**Cross-links:** See Lec11-12: Verilog constructs; Lec13: simulation mechanics (stratified queue, blocking/non-blocking); Lec16: RTL optimizations, synthesis Part II; Lec06: logic synthesis overview

---

*This summary condenses Lec15 from ~15,000 tokens, removing pedagogical scaffolding ("let us understand...", "now let us take an example..."), redundant circuit diagrams descriptions, and repeated explanations of mux/latch inference.*
