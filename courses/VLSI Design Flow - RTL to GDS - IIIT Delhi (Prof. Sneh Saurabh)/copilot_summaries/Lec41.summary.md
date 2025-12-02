# Lec41 — Tutorial: Power Analysis using OpenSTA

## Overview
Hands-on tutorial demonstrating power analysis with OpenSTA: computing internal power (NLP table lookup), switching power (C_L·V²_DD·α·f_clk), and leakage power (cell_leakage_power) from .lib file, activity, and constraints.

## Core concepts
**Power components (OpenSTA report):**
- **Internal power:** Energy dissipated inside cell (drain capacitance charging/discharging + short-circuit current)
- **Switching power:** External capacitance (wire + pin loads) charging/discharging
- **Leakage power:** Static power dissipation (from cell_leakage_power attribute in .lib)
- **Total power:** P_total = P_internal + P_switching + P_leakage

**Internal power calculation (from NLP table):**
- **NLP table (toy.lib):** 2D table (input slew, output load) → energy per transition (fJ)
- **Characterization points:** Input slew: {0.1ps, 100ps}; Output load: {0.1fF, 100fF}
- **Values:** Fall power: {1, 2, 3, 4}; Rise power: {2, 4, 6, 10} (toy library; real libraries: 8×8 or larger)
- **Lookup:** Input slew=0.1ps, output load=0.1fF → fall=1fJ, rise=2fJ → average=1.5fJ
- **Power:** P_int = E_int × transitions/sec = 1.5×10⁻¹⁵ J × (α·f_clk) = 1.5×10⁻¹⁵ × (0.1 × 10⁹ Hz) = 1.5×10⁻⁷ W

**Switching power calculation:**
- **Formula:** P_sw = ½C_L·V²_DD × (2·α·f_clk) = C_L·V²_DD·α·f_clk (factor of 2: charge + discharge)
- **Example:** C_L=0.1fF, V_DD=1V, α=0.1, f_clk=1GHz
  - Energy per transition: ½ × 0.1×10⁻¹⁵ × 1² = 5×10⁻¹⁷ J
  - Power: 5×10⁻¹⁷ × (0.1 × 10⁹) = 5×10⁻⁹ W (5nW)

**Leakage power:**
- **Library attribute:** cell_leakage_power=150pW (from toy.lib header: leakage_power_unit=1pW)
- **Conversion:** 150pW = 1.5×10⁻¹⁰ W

**Activity factor (α):**
- **Set in TCL:** `set_power_activity 0.1` (0.1 = 1 transition per 10 clock cycles)
- **Default:** Tools assume α=0.2 if not specified
- **Transitions/sec:** α × f_clk (e.g., 0.1 × 10⁹ = 10⁸ transitions/sec)

## Methods/flows
**OpenSTA power analysis workflow:**
1. `read_liberty toy.lib` (load library with NLP, leakage models)
2. `read_verilog test.v` (load design; 1 inverter in tutorial)
3. `link_design top` (link instances to library cells)
4. `read_sdc test.sdc` (constraints: clock period, I/O delays, input transition, output load)
5. `set_power_activity 0.1` (set activity factor; defaults to 0.2)
6. `report_power` (displays internal, switching, leakage, total power)

**Manual verification (tutorial):**
- Internal power: Read NLP table from .lib → average fall/rise energy → multiply by α·f_clk
- Switching power: C_L·V²_DD (energy) → multiply by α·f_clk
- Leakage: Read cell_leakage_power from .lib → convert units (pW→W)
- Total: Sum all three components

## Constraints/assumptions
- **Toy library:** Only 2×2 NLP table (realistic: 8×8 or larger)
- **Simple design:** 1 inverter (tutorial for easy manual verification; real designs: millions of gates)
- **Activity:** Set manually (0.1 in tutorial); realistic designs: extract from VCD/SAIF simulation
- **No wire capacitance:** Only output load specified (0.1fF); post-routing: SPEF provides C_wire

## Examples
**Design (test.v):**
- 1 input (A), 1 output (OUT), 1 inverter instance (i1: inv from toy.lib)

**Constraints (test.sdc):**
- Virtual clock: period=1000ps (f_clk=10⁹ Hz)
- Input/output delay: 5ps (not used in power calculation)
- Input transition: 0.1ps (for NLP lookup)
- Output load: 0.1fF (set_load; for NLP lookup + switching power)

**Power calculation (manual verification):**
1. **Internal power:**
   - NLP table: slew=0.1ps, load=0.1fF → fall=1fJ, rise=2fJ → avg=1.5fJ
   - Power: 1.5×10⁻¹⁵ J × (0.1 × 10⁹ Hz) = 1.5×10⁻⁷ W
2. **Switching power:**
   - Energy: ½ × 0.1×10⁻¹⁵ × 1² = 5×10⁻¹⁷ J
   - Power: 5×10⁻¹⁷ × (0.1 × 10⁹) = 5×10⁻⁹ W
3. **Leakage:**
   - cell_leakage_power=150pW → 1.5×10⁻¹⁰ W
4. **Total:** 1.5×10⁻⁷ + 5×10⁻⁹ + 1.5×10⁻¹⁰ = 1.556×10⁻⁷ W

**OpenSTA report matches manual calculation.**

## Tools/commands
- **OpenSTA:** `sta` (interactive mode); `source test.tcl` (batch mode)
- **Commands:** `read_liberty`, `read_verilog`, `link_design`, `read_sdc`, `set_power_activity`, `report_power`
- **File viewing:** `vim toy.lib` (view NLP table, leakage values)

## Common pitfalls
- Confusing energy (NLP table values in fJ) with power (multiply by α·f_clk)
- Not setting activity (defaults to 0.2; may not match actual design)
- Using toy library for realistic designs (only 2×2 table; inaccurate interpolation)
- Forgetting to convert units (pW→W, fJ→J, ps→s)
- Expecting wire capacitance in power (C_wire=0 in tutorial; post-routing: SPEF provides C_wire)

## Key takeaways
- Power components: Internal (inside cell), switching (external C_L), leakage (static)
- Internal power: NLP table (2D: input slew, output load) → energy/transition → multiply by α·f_clk
- Switching power: C_L·V²_DD·α·f_clk (external capacitances: wire + pins)
- Leakage: cell_leakage_power (from .lib; static power, always dissipated)
- Activity factor (α): Transitions per cycle (0.1 = 1 transition per 10 cycles)
- Manual verification: Read NLP table → lookup energy → multiply by activity × frequency
- OpenSTA: Automates power analysis (reads .lib, constraints, activity → reports power)
- Simple design (1 inverter): Easy manual verification; realistic designs need tool automation
- Hands-on learning: Link lecture concepts (Lec37: power analysis theory) with tool (OpenSTA) behavior
- Experiments: Vary activity, clock period, load, input transition → observe power changes

**Cross-links:** See Lec37: Power analysis (dynamic/static power, NLP model, activity); Lec26: Technology library (.lib: NLP tables, leakage_power); Lec36: OpenSTA tutorial (installation, usage); Lec32-33: SDC constraints (clock, I/O delays)

---

*This summary condenses tutorial Lec41 from ~4,000 tokens, removing repeated NLP table displays, redundant manual calculation steps, and verbose command echoes.*
