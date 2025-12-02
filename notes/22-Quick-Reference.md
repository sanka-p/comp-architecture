## OpenROAD Mini Flow (End-to-End)

This concise TCL flow covers typical steps from floorplan to signoff outputs. Adjust filenames, cell names, layers, and dimensions for your PDK.

```tcl
# --- Setup ---
read_lef tech.lef stdcell.lef io.lef
read_liberty fast.lib slow.lib
read_verilog design.v
link_design top
read_sdc constraints.sdc

# --- Floorplanning & IO ---
initialize_floorplan -die_area "0 0 3000 3000" -core_area "200 200 2800 2800" -site core -utilization 0.6
place_pins -hor_layers {metal2} -ver_layers {metal3} -random -corner_keepout 20
tapcell -distance 14 -tapcell_master TAPCELL_X1 -endcap_master ENDCAP_X1

# --- PDN ---
define_pdn_grid -name core_grid -voltage_domains {core}
add_pdn_stripe -grid core_grid -layer metal5 -width 2.0 -pitch 40 -offset 10
add_pdn_stripe -grid core_grid -layer metal6 -width 2.0 -pitch 40 -offset 10 -followpins
add_pdn_connect -grid core_grid -layers {metal5 metal6}
pdngen
write_def floorplan.def

# --- Placement ---
set_place_density 0.6
global_placement -skip_io -routability_driven
place_detail
write_def placed.def

# --- CTS ---
set_clock_tree_options \
  -buf_list {CLKBUF_X2 CLKBUF_X4} \
  -inv_list {CLKINV_X1} \
  -target_skew 0.05 \
  -root_buffer CLKBUF_X8 \
  -cts_layers {metal5 metal6}
cts
write_def cts.def

# --- Routing ---
global_route
route
repair_antennas -lib_cell ANTENNA_DIODE_X1 -ratio 1.0
write_def routed.def

# --- Signoff (timing/power) ---
read_spef routed.spef
set_propagated_clock [all_clocks]
report_checks -path_delay min_max -fields {slew cap input_pins nets} -digits 3 > timing_report.txt
report_power > power_report.txt
write_sdf timing_postroute.sdf

# Optional: DRC report (if supported)
report_drc > drc_report.txt

# Final save
write_def signoff.def
```

Tips:
- Use real buffer/diode masters from your standard-cell library.
- Set realistic die/core sizes and utilization; iterate based on congestion and timing.
- Multi-corner/multi-mode signoff requires loading appropriate Liberty views and SDCs.

---

## Minimal SDC Example

Use this as a starting point for timing constraints. Adapt names and values to your design.

```sdc
# Define the primary clock (100 MHz)
create_clock -name clk -period 10 [get_ports clk]

# Clock uncertainty (jitter + skew budget)
set_clock_uncertainty -setup 0.1 [get_clocks clk]
set_clock_uncertainty -hold 0.05 [get_clocks clk]

# I/O delays relative to clock (example)
set_input_delay 1 -clock clk [get_ports {din* reset_n}]
set_output_delay 1 -clock clk [get_ports {dout*}]

# Driving cells and loads (optional)
set_driving_cell -lib_cell INV_X1 [get_ports {din* reset_n}]
set_load 0.02 [get_ports {dout*}]

# False paths / exceptions (examples)
# set_false_path -from [get_ports reset_n]
# set_multicycle_path 2 -setup -from [get_pins u_slow/*] -to [get_pins u_slow/*]
```

---

## Try it: Run the Flow

On Windows, the recommended way is to run OpenROAD inside WSL. If you already have OpenROAD in PATH on Windows, you can run it directly.

```powershell
# Option A: Run via WSL (recommended)
wsl openroad -exit flow.tcl

# Option B: Native (if openroad.exe is installed and in PATH)
openroad -exit flow.tcl
```

Where `flow.tcl` contains the mini flow above. Ensure your `tech.lef`, `stdcell.lef`, Liberty, and Verilog files are reachable from the working directory.
# Quick Reference

> Acronyms, formulas, and command snippets for fast lookup.

---

## 1. Acronyms

- STA: Static Timing Analysis
- SDC: Synopsys Design Constraints
- PVT: Process, Voltage, Temperature
- MMMC: Multimode Multicorner
- OCV: On-Chip Variation
- NLDM/CCS: Non-Linear Delay Model / Composite Current Source
- LEF/SPEF: Library Exchange Format / Standard Parasitic Exchange Format
- CTS: Clock Tree Synthesis
- DRC/LVS/ERC: Design/Layout vs Schematic/Electrical Rule Check
- DFT/ATPG/BIST: Design for Test / Automatic Test Pattern Generation / Built-in Self Test

---

## 2. Core Formulas

- Setup: \(T_{period} \ge \delta_{LC} + T_{clk\to q}^{max} + T_{data}^{max} + T_{setup}^{max}\)
- Hold: \(\delta_{LC}^{min} + T_{clk\to q}^{min} + T_{data}^{min} \ge T_{hold}^{max}\)
- Slew monotonicity: \(\uparrow\text{input slew} \Rightarrow \uparrow\text{delay}, \uparrow\text{output slew}\)
- Power (switching): \(P_{sw} = C_L V_{DD}^2 \alpha f_{clk}\)
- Leakage: \(P_{leak} = V_{DD} I_{leak}\)
- Wire resistance: \(R = R_s \cdot L/W\)

---

## 3. SDC Snippets

- `create_clock -name CLK -period 1000 [get_ports clock]`
- `set_input_delay 5 -clock CLK [get_ports A]`
- `set_output_delay 10 -clock CLK [get_ports out]`
- `set_clock_uncertainty -setup 20 [get_clocks CLK]`
- `set_input_transition 0.1 [get_ports A]`
- `set_load 100 [get_ports OUT]`

---

## 4. OpenSTA Snippets

- `read_liberty lib.lib; read_verilog netlist.v; link_design top; read_sdc top.sdc`
- `report_checks -path_delay max -format full`
- `report_checks -path_delay min -format full`
- `set_power_activity 0.1; report_power`

---

## 5. OpenROAD Snippets

- CTS: `repair_clock_inverters; clock_tree_synthesis -buf_list {BUF_X1 BUF_X2} -sink_clustering_enable`
- Routing: `global_route -congestion_iterations 100; write_guides route.guide; detailed_route -guide route.guide`
- Parasitics: `extract_parasitics; write_spef chip.spef`

---

## 6. Checklists

- After CTS:
  - Switch to propagated clocks
  - Estimate parasitics; repair timing
  - Legalize inserted buffers
- After Routing:
  - Extract SPEF
  - Run signoff STA + SI/IR/EM
  - Insert redundant vias; apply antenna fixes
  - Add CMP fills; re-extract and re-run STA

---

## 7. Cross-links

- [[08-Static-Timing-Analysis]]
- [[09-Timing-Constraints]]
- [[17-Clock-Tree-Synthesis]]
- [[18-Routing]]
- [[19-Physical-Verification-and-Signoff]]
