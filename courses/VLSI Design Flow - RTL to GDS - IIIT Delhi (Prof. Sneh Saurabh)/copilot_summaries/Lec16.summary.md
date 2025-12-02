# Lec16 — RTL Synthesis Part II: Loops, Functions, Operators, and Optimizations

## Overview
Covers RTL synthesis of for-loops (unrolling), functions (combinational blocks), arithmetic/relational operators (resource sharing, speculation, strength reduction), compiler optimizations (constant propagation, common subexpression elimination), and operator-level transformations to reduce area or improve timing.

## Core concepts
**For-loop synthesis:**
- Loop unrolled if iteration count is constant (known at synthesis time)
- Each iteration expanded → instantiate corresponding gates (e.g., full adders for ripple-carry)
- Variable loop count → non-synthesizable (tool cannot infer hardware extent)

**Function synthesis:**
- Functions → combinational logic blocks (1 output, scalar/vector)
- Function call → instantiate combinational logic with inputs mapped from call arguments
- Example: `myfunc(x, y, z)` → gates implementing `x - y + z`; multiple calls duplicate logic

**Operator handling:**
- **Logical/bitwise operators:** Direct translation to gates (AND, OR, NOT); optimized later in logic optimization
- **Arithmetic/relational operators:** Expensive (area/timing); internal representations (graphs) enable operator-level optimizations before gate mapping
  - Map to parameterized modules (e.g., `add_WIDTH8` for 8-bit adder)
  - Tool chooses architecture (ripple-carry vs carry-lookahead) based on timing constraints

**Resource sharing:**
- Combine multiple operators into fewer instances (reduce area)
- Example: `if (sel) z=a*b; else z=x*y;` → 2 multipliers → 1 multiplier + 2 input muxes (select operands first, then multiply)
- Trade-off: May increase delay (mux + multiplier on critical path vs mux alone)

**Speculation (resource unsharing):**
- Eager computation: Compute both results, select later
- Example: `if (sel) y=b; else y=c; z=a+y;` → 1 adder + mux → 2 adders (a+b, a+c) + mux (remove adder from critical path)
- Trade-off: Increases area/power to reduce delay on critical path

**Compiler optimizations:**
- **Constant propagation:** Replace expressions with constants when operands known (`a=8*8` → `a=64`; `b=a*1024/32` → `b=2048`)
- **Common subexpression elimination:** Extract shared subexpressions (`x=p+a*b; y=q+a*b` → `c=a*b; x=p+c; y=q+c`; save 1 multiplier)
- **Strength reduction:** Replace expensive ops with cheaper equivalents
  - Multiply/divide by power-of-2 → shift (`a*64` → `a<<6`, `b/4` → `b>>2`)
  - Multiply by constant → shift + add (`c*17` → `(c<<4)+c`)

## Methods/flows
1. **For-loop unrolling:** Check if loop count constant → expand iterations → instantiate gates per iteration
2. **Function synthesis:** Inline function logic where called; inputs from call arguments; outputs to receiving signal
3. **Operator translation:** Arithmetic/relational → internal graph representation → apply resource sharing/speculation/strength reduction → map to modules (adder, multiplier, comparator)
4. **Compiler optimizations:** Parse tree transformations (constant propagation, CSE, strength reduction) in multiple passes

## Constraints/assumptions
- For-loop iteration count must be compile-time constant (else non-synthesizable)
- Functions model combinational logic only (no delays, 1 output)
- Resource sharing beneficial when mux area << saved operator area (typically true for multipliers)
- Speculation assumes timing-critical paths identified (else wastes area/power)
- Strength reduction applies to power-of-2 constants (shift) and specific patterns (shift+add)

## Examples
- **For-loop (ripple-carry adder):** `for (idx=0; idx<4; idx++) {carry, sum[idx]} = a[idx]+b[idx]+carry;` → 4 full adders chained
- **Function:** `out1 = myfunc(a,b,c);` where `myfunc(x,y,z) = x-y+z;` → out1 = a-b+c (gates: subtract, add)
- **Resource sharing:** 2 multipliers + mux → 1 multiplier + 2 input muxes (8-bit: save ~100 gates)
- **Speculation:** `if (sel) y=b; else y=c; z=a+y;` → `z=(sel)?a+b:a+c;` (2 adders, remove adder from critical path)
- **Constant prop:** `a=8*8; b=a*32; c=b+32;` → `a=64; b=2048; c=2080` (no multipliers/adders)
- **CSE:** `x=p+a*b; y=q+a*b;` → `c=a*b; x=p+c; y=q+c;` (1 multiplier vs 2)
- **Strength reduction:** `x=a*64` → `x=a<<6`; `y=b/4` → `y=b>>2`; `z=c*17` → `z=(c<<4)+c`

## Tools/commands
- **RTL synthesis tools:** Synopsys Design Compiler, Cadence Genus, Yosys (open-source)
- Internal parameterized modules: Tool-specific adder/multiplier/comparator implementations
- Timing analysis: Identify critical paths for speculation decisions

## Common pitfalls
- Variable loop count → synthesis error (tool cannot determine hardware extent)
- Over-speculation: Compute unused results → waste area/power (only apply on critical paths)
- Ignoring timing when resource sharing: Mux+multiplier delay > mux alone (can violate timing)
- Applying strength reduction to non-power-of-2 multiplies (no benefit)

## Key takeaways
- For-loops synthesize via unrolling (constant iteration count required)
- Functions → combinational blocks; multiple calls duplicate logic
- Arithmetic/relational operators: Internal graph representation enables resource sharing/speculation/strength reduction
- Resource sharing: Fewer operators (save area) but may increase delay; speculation: More operators (increase area) but reduce critical path delay
- Compiler optimizations: Constant propagation, CSE (eliminate redundant multipliers/adders), strength reduction (shift/add cheaper than multiply)
- Operator-level optimizations trade off area vs timing (tool chooses based on constraints)

**Cross-links:** See Lec06: logic synthesis overview; Lec15: RTL synthesis Part I (parsing, elaboration, construct translation); Lec17-19: logic optimization (2-level, multi-level)

---

*This summary condenses Lec16 from ~11,000 tokens, removing repeated code walkthroughs, redundant explanations of resource sharing vs speculation trade-offs, and pedagogical scaffolding.*
