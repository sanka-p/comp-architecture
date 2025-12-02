# Lec37 — Power Analysis

## Overview
Covers power dissipation components in CMOS circuits (dynamic: switching + short-circuit; static: leakage), library power models (NLP for dynamic, leakage for static), and power estimation techniques (simulation-based vs probabilistic).

## Core concepts
**Dynamic power dissipation:**
- **Switching power:** P_sw = C_L · V²_DD · α · f_clk
  - C_L: Load capacitance (C_drain + C_wire + Σ C_input_pins)
  - V_DD: Supply voltage
  - α: Activity factor (0 ≤ α ≤ 1; α=1 → 1 full transition per clock cycle; α=0.2 → 1 transition per 5 cycles)
  - f_clk: Clock frequency
  - Energy per transition: E_sw = C_L · V²_DD (charges capacitor: ½C_LV²_DD dissipated in PMOS; discharges: ½C_LV²_DD dissipated in NMOS)
- **Short-circuit power:** P_sc = V_DD · I_SC
  - I_SC: Short-circuit current (flows when PMOS + NMOS both ON during input transition)
  - Occurs when input slew is slow (longer duration with both transistors ON)
- **Total dynamic:** P_dyn = P_sw + P_sc

**Static power dissipation:**
- **Leakage power:** P_leak = V_DD · I_leak
  - I_leak: Leakage current (flows even when transistor OFF)
  - **Sources:** (1) Sub-threshold current (electrons tunnel from drain→source when V_GS < V_TH); (2) Gate leakage (tunneling through thin gate oxide); (3) Junction leakage (reverse-biased junctions)
  - **Dominates at advanced nodes:** Sub-threshold leakage >> gate + junction leakage (due to low V_TH for speed)

**Total power:**
- P_total = P_dyn + P_leak = (C_L·V²_DD·α·f_clk + V_DD·I_SC) + V_DD·I_leak

**Library power models:**
1. **Non-Linear Power (NLP) model:**
   - **Internal power:** Energy dissipated inside cell (C_drain charging/discharging + short-circuit)
   - **2D table:** E_int = f(input slew, output load) (similar to NLDM for delay)
   - **Attributes:** `internal_power` (per timing arc); `rise_power`, `fall_power` (separate for rise/fall transitions)
   - **Values:** Energy per transition (not power; multiply by α·f_clk to get power)
2. **External power:**
   - **Not in library:** Depends on wire capacitance (C_wire) + input pin capacitances (C_pins) → computed by tool at power estimation time
   - E_ext = (C_wire + ΣC_pins) · V²_DD
3. **Leakage power:**
   - **When condition:** Leakage depends on input values (e.g., NAND: leakage(A=0,B=0) ≠ leakage(A=1,B=1))
   - **Format:** `leakage_power(<value>) { when: "!A & !B"; }` (per input combination)
   - **Average value:** Cell_leakage_power (used when input probabilities unknown)

**Power estimation techniques:**
1. **Simulation-based (vector-based):**
   - **Method:** Run RTL simulation with testbench → save signal transitions to VCD (Value Change Dump) → convert to SAIF (Switching Activity Interchange Format) → extract activity (α) → compute power
   - **Accuracy:** High (real workload) if representative testbench; low if non-representative
   - **Challenge:** Activity depends on application (video rendering vs document editing → different α)
2. **Probabilistic (vectorless):**
   - **Method:** Assume input signal probabilities → propagate through logic → compute output probabilities → infer activity
   - **Example:** P(A=1)=0.5, P(B=1)=0.3; AND gate: P(Y=1) = 0.5×0.3 = 0.15; OR gate: P(Y=1) = 1 - P(A=0)×P(B=0) = 1 - 0.5×0.7 = 0.65
   - **Challenge:** Signal correlations (reconvergent fanout) → accurate probability computation difficult
   - **Accuracy:** Lower than simulation-based (assumptions about probabilities)

**C_L components:**
- **C_drain (C_D):** Drain diffusion capacitance (internal to cell)
- **C_wire (C_W):** Interconnect capacitance (wire from cell output → load inputs)
- **C_input (C_I):** Sum of input pin capacitances (Σ C_i for M loads)
- C_L = C_D + C_W + C_I

## Methods/flows
1. **Power estimation flow:**
   - **Inputs:** Netlist (library cells), SPEF (parasitic RC for C_wire), library (.lib: NLP, leakage), activity (SAIF or default)
   - **Internal power:** Lookup NLP table (input slew, output load) → E_int; multiply by α·f_clk → P_int
   - **External power:** Compute C_ext = C_wire + ΣC_pins → E_ext = C_ext·V²_DD; multiply by α·f_clk → P_ext
   - **Leakage:** Lookup cell leakage (per input combination or average) → sum across all cells → P_leak
   - **Total:** P_total = P_int + P_ext + P_leak
2. **Simulation-based activity extraction:**
   - Run RTL simulation → VCD file → convert to SAIF (switching activity) → power analysis tool reads SAIF → computes α per net
3. **Probabilistic propagation:**
   - Assign input probabilities → propagate through gates (AND: P(Y=1)=P(A=1)×P(B=1); OR: P(Y=1)=1-P(A=0)×P(B=0)) → infer activity (α ≈ 2·P(Y=1)·P(Y=0) for toggle rate)

## Constraints/assumptions
- **C_L accuracy:** Depends on design stage (RTL: C_L unknown; post-mapping: pin loads known, wire C unknown; post-routing: C_L accurate)
- **Activity challenges:** Application-dependent (video vs idle → different α); requires representative testbench
- **Leakage dominance:** Advanced nodes (low V_TH) → I_leak significant (can be 20-40% of total power)
- **Short-circuit power:** Typically 10-15% of dynamic power (lower if input slew is fast)
- **Probabilistic limitations:** Assumes uncorrelated signals (reconvergent fanout → correlated → errors)

## Examples
**Switching power calculation:**
- C_L=10fF, V_DD=1V, α=0.2, f_clk=1GHz → P_sw = 10×10⁻¹⁵ × 1² × 0.2 × 10⁹ = 2×10⁻⁶ W = 2µW

**Activity factor:**
- α=1: 1 full transition (0→1→0) per clock cycle (100% activity)
- α=0.2: 1 transition per 5 clock cycles (20% activity; e.g., signal changes every 5th cycle)

**Probabilistic propagation:**
- AND gate: P(A=1)=0.5, P(B=1)=0.3 → P(Y=1) = 0.5×0.3 = 0.15
- OR gate: P(A=1)=0.5, P(B=1)=0.3 → P(Y=0) = P(A=0)×P(B=0) = 0.5×0.7 = 0.35 → P(Y=1) = 1-0.35 = 0.65

**NLP table (internal power):**
```
internal_power() {
  related_pin: "A";
  rise_power(energy_template_2D) {
    index_1("0.1, 100");  # Input slew (ps)
    index_2("0.1, 100");  # Output load (fF)
    values("50, 60", "70, 80");  # Energy (fJ) per transition
  }
}
```
- Input slew=0.1ps, output load=100fF → E_int=60fJ; P_int = 60×10⁻¹⁵ × α × f_clk

## Tools/commands
- **Power analysis:** Synopsys PrimeTime PX, Cadence Voltus, Siemens PowerPro
- **Activity extraction:** VCD→SAIF conversion (vcd2saif tool, Synopsys VCS `-saif` option)
- **Simulation:** ModelSim, VCS, Xcelium (generate VCD during RTL simulation)

## Common pitfalls
- Assuming C_L accurate before routing (wire capacitance unknown → power estimates inaccurate)
- Not using representative testbench (low activity → underestimates power; idle testbench → misleading)
- Ignoring leakage power (advanced nodes: I_leak significant; can dominate in standby mode)
- Confusing energy (E_sw = C_L·V²_DD) with power (P_sw = E_sw·α·f_clk)
- Using default activity (α=0.2) for all nets (real activity varies widely; can be 0.001 to 0.8)
- Probabilistic with reconvergent fanout (assumes independence → errors; e.g., XOR(A, A) = 0, but probabilistic gives non-zero)

## Key takeaways
- Dynamic power: P_dyn = C_L·V²_DD·α·f_clk (switching) + V_DD·I_SC (short-circuit)
- Static power: P_leak = V_DD·I_leak (sub-threshold + gate + junction leakage)
- Switching power dominates: V²_DD quadratic dependence → reducing V_DD most effective (but increases delay)
- Activity factor (α): Fraction of clock cycles with transitions (α=1: every cycle; α=0.2: 1 in 5 cycles)
- C_L components: C_drain (internal) + C_wire (interconnect) + C_pins (input loads)
- NLP model: Internal power (2D table: input slew, output load) → energy per transition (multiply by α·f_clk for power)
- External power: Not in library (C_wire + C_pins unknown until routing) → tool computes at power estimation
- Leakage in library: When condition (per input combination) or average (cell_leakage_power)
- Simulation-based: VCD→SAIF → accurate activity (if testbench representative)
- Probabilistic: Propagate probabilities through logic → less accurate (correlation issues)
- C_L accuracy: RTL (unknown) → post-mapping (pin loads) → post-routing (C_L accurate with SPEF)
- Advanced nodes: Leakage dominates (20-40% of total power; low V_TH for speed)

**Cross-links:** See Lec26: Technology library (.lib: NLP, leakage models); Lec38: Power optimization (DVFS, power gating, clock gating); Lec34: Technology mapping (library cells, sizes); Lec06: VLSI design flow (power analysis phase)

---

*This summary condenses Lec37 from ~11,000 tokens, removing repeated power equation derivations, redundant CMOS inverter circuit diagrams, and verbose probabilistic propagation examples.*
