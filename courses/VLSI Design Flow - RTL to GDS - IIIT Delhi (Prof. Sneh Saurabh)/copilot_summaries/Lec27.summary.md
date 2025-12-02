# Lec27 — Tutorial: Logic Optimization using Yosys (Resource Sharing)

## Overview
Hands-on tutorial demonstrating resource sharing optimization in Yosys Open Synthesis Suite. Compares unoptimized netlist (2 multipliers, area=13,944) vs optimized netlist (1 shared multiplier via muxes, area=7,546) for RTL with conditional multiply operations.

## Core concepts
**Resource sharing:**
- **Goal:** Reduce area by sharing expensive resources (multipliers, adders) across mutually exclusive operations
- **Mechanism:** Replace duplicate operators with single operator + input/output muxes (time-multiplexed resource)
- **Example:** `if (select==0) Z=A*B; else Z=X*Y;` → 2 multipliers (unoptimized) vs 1 multiplier + 2 input muxes (optimized)
- **Trade-off:** Area savings vs potential delay increase (mux overhead); critical path may lengthen

**Yosys optimization commands:**
- `opt` — General optimization (constant propagation, dead code elimination)
- `share -aggressive` — Resource sharing (detect sharable cells via SAT solver)
- SAT solver identifies pairs of cells (e.g., multipliers) that can be shared (mutually exclusive conditions)

## Methods/flows
**Unoptimized synthesis:**
1. `read_verilog top.v` — Load design
2. `proc` — Convert processes (always blocks) to netlist
3. `clean` — Remove unused cells/wires
4. `show` — Display schematic (2 multipliers visible)
5. `techmap` — Map to internal library
6. `dfflibmap -liberty <lib>` — Map flip-flops
7. `abc -liberty <lib>` — Map combinational logic to standard cells
8. `stat` — Report area (13,944 library units)
9. `write_verilog -noattr netlist_final_unopt.v` — Export netlist

**Optimized synthesis:**
1. `read_verilog top.v; proc; clean; show` — Load, display (2 multipliers initially)
2. `opt; share -aggressive` — SAT-based resource sharing (1 multiplier after optimization)
3. `show` — Display schematic (1 multiplier + input muxes)
4. `techmap; dfflibmap -liberty <lib>; abc -liberty <lib>; clean` — Technology mapping
5. `stat` — Report area (7,546 library units, ~46% reduction)
6. `write_verilog -noattr netlist_final_opt.v` — Export optimized netlist

## Constraints/assumptions
- Resource sharing applies only to mutually exclusive operations (cannot execute simultaneously)
- SAT solver confirms shareability (conservative; may miss opportunities if SAT timeout)
- Assumes multipliers dominate area (valid for most arithmetic-heavy designs)
- No timing constraints specified (synthesis optimized for minimum area only)

## Examples
**RTL design (top.v):**
```verilog
module top(input clk, input select, input [7:0] A, B, X, Y, output reg [15:0] out);
  wire [15:0] y;
  assign y = (select) ? X*Y : A*B;  // Mux + 2 multipliers (unoptimized)
  always @(posedge clk) out <= y;    // D flip-flop
endmodule
```

**Unoptimized netlist:** 2 multiplier instances, 1 mux instance, 1 D flip-flop → area=13,944
**Optimized netlist:** 1 multiplier instance, 3 mux instances (2 input, 1 output), 1 D flip-flop → area=7,546 (~46% reduction)

## Tools/commands
- **Yosys invocation:** `yosys` (interactive shell) or `yosys -s script.tcl` (batch mode)
- **Optimization:** `opt; share -aggressive` (SAT-based resource sharing)
- **Display:** `show` (GTKWave-like schematic viewer)
- **Technology mapping:** `techmap`, `dfflibmap`, `abc`
- **Statistics:** `stat` (reports area, cell count)
- **Export:** `write_verilog -noattr <file>` (generate synthesized netlist)

## Common pitfalls
- Forgetting `share -aggressive` (default `share` less aggressive; may not detect opportunities)
- Not specifying `-liberty <lib>` for `dfflibmap`/`abc` (fails to map to standard cells)
- Over-optimizing (excessive muxing increases delay; may violate timing in high-frequency designs)
- Assuming resource sharing always beneficial (small operators like adders: area savings < mux overhead)

## Key takeaways
- Resource sharing: Reduce area by time-multiplexing expensive operators (multipliers, dividers)
- Yosys `share -aggressive`: SAT-based shareability detection (identifies mutually exclusive operations)
- Trade-off: Area reduction (~46% in example) vs delay increase (mux latency)
- Unoptimized: 2 multipliers, area=13,944; Optimized: 1 multiplier + muxes, area=7,546
- Applicable when: (1) Operations mutually exclusive (if-else, case); (2) Operator expensive (multiplier >> mux area)
- Not always beneficial: Small operators (adders), timing-critical paths (mux delay unacceptable)

**Cross-links:** See Lec13: RTL synthesis (resource sharing strategies); Lec16: arithmetic optimization (strength reduction, speculation); Lec22: Yosys installation/basic usage; Lec06: synthesis overview

---

*This summary condenses tutorial Lec27 from ~4,000 tokens, removing command output echoes, repeated area number displays, and verbose schematic descriptions.*
