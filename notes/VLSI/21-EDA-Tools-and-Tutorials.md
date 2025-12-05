# EDA Tools and Tutorials

> **Chapter Overview:** Practical, tool-focused workflows collected from the lecture tutorials: OpenSTA for timing/power, OpenROAD for CTS/routing, and common commercial equivalents.

**Prerequisites:** [[08-Static-Timing-Analysis]], [[17-Clock-Tree-Synthesis]], [[18-Routing]]

---

## 1. OpenSTA — Timing and Power

### 1.1 Core Commands (Lec31, Lec36, Lec41)

- Read inputs:
  - `read_liberty toy.lib`
  - `read_verilog top.v`
  - `link_design top`
  - `read_sdc top.sdc`
- Timing reports:
  - `report_checks -path_delay max -format full` (setup)
  - `report_checks -path_delay min -format full` (hold)
- Constraints highlights:
  - `create_clock -name CLK -period 1000 [get_ports clock]`
  - `set_input_delay 5 -clock CLK [get_ports A]`
  - `set_output_delay 10 -clock CLK [get_ports out]`
  - `set_clock_uncertainty -setup 20 [get_clocks CLK]`
- Power:
  - `set_power_activity 0.1`
  - `report_power` (internal/switching/leakage)

### 1.2 Tips

- Use library units (ps, fF) consistently.
- For power, ensure realistic activity via VCD→SAIF from a representative testbench.

---

## 2. OpenROAD — CTS and Routing (Lec54)

### 2.1 CTS Flow


### 2.2 Routing Flow


### 2.3 Checks and Reports


### 2.4 Tips


## OpenROAD Setup on Windows (WSL)

OpenROAD is best used on Linux; on Windows, run it via WSL.

### Steps

1. Install WSL and a Linux distro (Ubuntu recommended).
2. Inside WSL, install OpenROAD (prebuilt packages or build from source):
  - Prebuilt: follow instructions from the OpenROAD docs/package repo for Ubuntu.
  - Build: install dependencies (gcc, cmake, tcl, boost, swig, etc.), then build per docs.
3. Place your PDK/library files (LEF/Liberty) under your WSL home or a mounted Windows path.
4. Verify:

```bash
openroad -version
```

### Running from Windows PowerShell

```powershell
# Launch OpenROAD inside WSL with a TCL flow
wsl openroad -exit flow.tcl
```

Notes:
- If you have a native `openroad.exe` in PATH, you can run it directly; otherwise prefer WSL.
- For Sky130-based flows, consider OpenROAD-flow-scripts or OpenLane tutorials.
---

## 3. Commercial Equivalents

- STA: PrimeTime, Tempus
- P&R: Innovus, ICC2
- Extraction/Verification: Calibre (DRC/LVS/xRC), StarRC, Quantus QRC
- DFT/ATPG: DFT Compiler, Modus, Tessent

---

## 4. Common Pitfalls

- Forgetting to legalize after CTS buffer insertions.
- Skipping propagated clocks: timing uses estimates instead of actual latencies.
- Not inserting filler cells → well discontinuities, DRC.
- Ignoring SPEF-based signoff STA.

---

## 5. Further Reading

- [[19-Physical-Verification-and-Signoff]]: Extraction and signoff checks
- [[08-Static-Timing-Analysis]]: Constraints and slack
- [[17-Clock-Tree-Synthesis]]: Skew and useful skew
