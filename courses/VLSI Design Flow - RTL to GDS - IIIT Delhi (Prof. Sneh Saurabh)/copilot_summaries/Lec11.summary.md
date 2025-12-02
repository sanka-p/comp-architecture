# Lec11 — Introduction to Verilog I: Basics and Data Types

## Overview
Introduces Verilog as a hardware description language (HDL) for RTL modeling. Covers fundamental features distinguishing HDLs from software languages (concurrency, timing, signal strength) and explores basic Verilog syntax: tokens, identifiers, numbers, data values (4-valued logic), and data types (nets, variables, vectors, arrays).

## Core concepts
**Distinct HDL features:**
- **Concurrency:** Model parallel hardware operations (two adders computing simultaneously)
- **Sequential execution:** Model dependencies (output of adder A feeds adder B)
- **Time modeling:** Delays, clock edges, waveform generation
- **Signal strength:** Resolve conflicts when multiple drivers produce different values
- **Bit-true data types:** Bus-level and bit-level abstractions (mask bits, group operations)

**Verilog vs VHDL:**
- **Verilog:** Created 1983-84 (Gateway Design Automation); derived from "verification + logic"; C-like syntax; standardized IEEE 1995, 2001; ~80% market share with SystemVerilog (2009 standard)
- **VHDL:** From "VHSIC HDL" (Very High-Speed IC); 1980s DoD initiative; verbose, strict type-checking; IEEE 1987, 2019 standards

**Lexical tokens:**
- **White space:** Separators (spaces, tabs, newlines, form feeds)
- **Comments:** Single-line `//` or block `/* */` (no nesting)
- **Keywords:** Reserved lowercase words (`module`, `input`, `output`, `always`, `endmodule`)
- **Operators:** `!`, `+`, `-`, `&&`, `==`, `!==`
- **Identifiers:** Start with letter/underscore; alphanumeric + `$`; max 1024 chars; case-sensitive; escaped identifiers: `\net_(a+b)*c ` (space-terminated)

**Number representation:**
- **Format:** `[-]<size>'<base><value>` where base = `b|B|o|O|d|D|h|H`; default 32-bit
- **Examples:** `1` (32-bit), `1'b1` (1-bit binary), `8'ha1` (8-bit hex = 1010_0001), `6'o71` (6-bit octal = 111_001)
- **Special values:** `x/X` (unknown/don't care), `z/Z/?` (high-impedance)
- **Size mismatch:** Truncate left if size < value; pad left with 0/Z/X if size > value
- **Underscore:** Readability separator (`8'b1111_0000` ignored by tools)
- **Negative:** 2's complement (`-8'd6` = 1111_1010)
- **Real:** Decimal (3.14159) or scientific (2.99E8); IEEE double-precision internally
- **Strings:** `"Hello"` → 8-bit ASCII per character

**Four-valued logic:**
- `0` (logic false), `1` (logic true), `x` (unknown), `z` (high-impedance)

**Data types:**
- **Net:** Structural connections (no storage); keywords: `wire`, `supply0` (GND), `supply1` (VDD), `wand`, `wor`; example: `wire w1, w2;`
- **Variable:** Stores last assigned value; keyword: `reg` (models flip-flops, latches, or combinational logic based on usage); example: `reg r1, r2;`
- **Vector:** Bit-range declaration `[MSB:LSB]`; example: `wire [31:0] databus;`, `reg [7:0] addressbus;`; bit-select: `databus[4]`, part-select: `addressbus[3:0]`
- **Array:** Multi-dimensional grouping; range after identifier; example: `reg r[15:0];` (16 1-bit regs), `wire matrix[9:0][9:0];` (10×10 2D array)

## Methods/flows
1. **Lexical analysis:** Break RTL file into token stream (white space, comments, keywords, operators, identifiers, numbers, strings)
2. **Declare nets/variables:** Use `wire` for structural connections, `reg` for value storage
3. **Define vectors/arrays:** Specify bit-width/dimensions before (vectors) or after (arrays) identifier

## Constraints/assumptions
- Verilog is case-sensitive (keywords lowercase, identifiers case-sensitive)
- Identifiers: max 1024 chars; start with letter/underscore; alphanumeric + `$`
- `reg` ≠ register (can synthesize to combinational logic, flip-flop, or latch)
- Default number size: 32 bits (if unspecified)

## Examples
- **Identifiers:** `Mymodule_top`, `Register_123`, `Net_1` ≠ `net_1` (case-sensitive)
- **Escaped identifier:** `\net_(a+b)*c ` (allow special chars; space-terminated)
- **Number formats:** `8'ha1` → 1010_0001, `6'o71` → 111_001, `-8'd6` → 1111_1010 (2's complement)
- **Vector:** `wire [31:0] databus;` → 32-bit bus; `databus[4]` selects bit 4; `addressbus[3:0]` selects bits 0-3
- **Array:** `reg r[15:0];` → 16 1-bit regs indexed [0] to [15]; `wire matrix[9:0][9:0];` → 10×10 2D array

## Tools/commands
- Verilog XL simulator (early 1980s fast simulation)
- Synopsys Design Compiler (1st RTL synthesis tool)

## Common pitfalls
- Confusing `reg` keyword with hardware registers (synthesis depends on context: can be combinational)
- Identifier length >1024 chars (not all tools support; stay <1024)
- Nested comments not allowed (`/* /* */ */` fails)
- Forgetting default size is 32 bits when unspecified

## Key takeaways
- Verilog models hardware concurrency, timing, signal strength (distinct from software languages)
- 4-valued logic (0, 1, x, z) vs binary; nets (wires) vs variables (storage)
- Identifier rules: case-sensitive, max 1024 chars, start letter/underscore
- Number format flexible (`8'ha1`, `-8'd6`, underscores for readability)
- Vectors vs arrays: range before identifier (vectors) vs after (arrays)
- Verilog's C-like syntax and simulation focus led to ~80% market dominance

**Cross-links:** See Lec12: modules, ports, instances, operators; Lec13: simulation semantics; Lec15: synthesis of constructs

---

*This summary condenses Lec11 from ~13,000 tokens to core technical facts, removing greetings ("Hello everybody"), historical anecdotes (Humpty Dumpty dialogue), and repetitive explanations.*
