# Lec46 — Tutorial: Installation of OpenRoad

## Overview
Step-by-step installation tutorial for OpenRoad (open-source physical design tool): clone repository, install dependencies, build (2 hours), verify installation, and explore test examples (Nangate45, ASAP7, Sky130).

## Core concepts
**OpenRoad:**
- **Purpose:** Integrated circuit physical design tool (logic synthesis netlist → final routed layout)
- **Stages covered:** Chip planning (floorplan, power plan), placement, CTS, routing
- **Open-source:** Free alternative to commercial P&R tools (Innovus, ICC2)

**Installation workflow:**
1. **Clone repository:** `git clone --recursive <GitHub_URL>` (recursive: includes submodules)
2. **Install dependencies:** `sudo ./etc/DependencyInstaller.sh` (downloads required libraries, compilers; takes time)
3. **Build OpenRoad:** `mkdir build && cd build && cmake .. && make` (compilation: ~2 hours)
4. **Install:** `sudo make install` (copies binaries to system path)
5. **Verify:** `openroad` (launches interactive shell)

**Test examples (in OpenRoad/test/):**
- **Libraries:** Nangate45 (45nm), ASAP7 (7nm predictive), Sky130 (130nm open-source)
- **Example designs:** GCD (greatest common divisor), ibex (RISC-V core), etc.
- **Files:** TCL scripts (.tcl), Verilog netlists (.v), constraints (.sdc)

## Methods/flows
**Installation steps (WSL/Linux):**
1. Open WSL/terminal
2. `git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD.git`
3. `cd OpenRoad`
4. `sudo ./etc/DependencyInstaller.sh` (installs Tcl, Boost, Eigen, Python libs, etc.)
5. `mkdir build && cd build`
6. `cmake ..` (configure build; checks dependencies)
7. `make` (~2 hours; compiles OpenRoad + sub-tools: TritonRoute, RePlAce, etc.)
8. `sudo make install` (installs to /usr/local/bin)
9. Verify: `openroad` → interactive shell prompt

**Exploring examples:**
- Navigate: `cd OpenRoad/test`
- Libraries: `ls` → Nangate45/, ASAP7/, sky130hs/
- GCD example: `cd Nangate45/gcd` → scripts (gcd_nangate45.tcl), Verilog (gcd.v), SDC (gcd.sdc)

## Constraints/assumptions
- **Platform:** Linux/WSL (Windows Subsystem for Linux); macOS also supported
- **Build time:** ~2 hours (depends on CPU; 4+ cores recommended)
- **Dependencies:** Auto-installed by DependencyInstaller.sh (Tcl8.6, Boost, Eigen, SWIG, Python3, etc.)
- **Disk space:** ~5GB (build artifacts, dependencies, examples)

## Examples
**Clone repository:**
```bash
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD.git
```

**Install dependencies:**
```bash
cd OpenRoad
sudo ./etc/DependencyInstaller.sh
```

**Build:**
```bash
mkdir build && cd build
cmake ..
make  # ~2 hours
sudo make install
```

**Verify installation:**
```bash
openroad
# Expected: OpenRoad interactive shell prompt
# Type 'exit' to quit
```

**Test folder structure:**
```
OpenRoad/test/
├── Nangate45/          # 45nm library examples
│   ├── gcd/            # GCD design
│   │   ├── gcd.v       # Verilog netlist
│   │   ├── gcd.sdc     # Constraints
│   │   └── *.tcl       # Scripts (floorplan, placement, etc.)
├── ASAP7/              # 7nm predictive library
└── sky130hs/           # Sky130 130nm open-source
```

## Tools/commands
- **OpenRoad:** `openroad` (interactive shell); `openroad -gui` (GUI mode); `openroad script.tcl` (batch mode)
- **Build tools:** cmake, make (required for compilation)
- **Git:** `git clone --recursive` (clone with submodules; OpenRoad has multiple sub-tools as submodules)

## Common pitfalls
- Forgetting `--recursive` flag (clone without submodules → incomplete build)
- Insufficient dependencies (DependencyInstaller.sh may fail on unsupported distros; manual install needed)
- Build errors: Check cmake output (missing libs, compiler version); re-run DependencyInstaller.sh
- Long build time: ~2 hours normal (parallel build: `make -j4` for 4 cores; speeds up)
- Not installing: `sudo make install` required (otherwise `openroad` command not in PATH)

## Key takeaways
- OpenRoad: Open-source physical design tool (netlist → layout; covers floorplan, placement, CTS, routing)
- Installation: Clone (recursive) → install dependencies (DependencyInstaller.sh) → build (cmake + make; ~2 hours) → install (sudo make install)
- Test examples: Nangate45, ASAP7, Sky130 libraries; GCD design (tutorial focus)
- Verification: `openroad` → interactive shell (confirms successful installation)
- Next steps: Use OpenRoad for chip planning, placement (next tutorials)
- Libraries included: Nangate45 (45nm; educational), ASAP7 (7nm predictive; academic), Sky130 (130nm; open-source PDK from Google/SkyWater)
- Files: TCL scripts (automation), Verilog (netlist), SDC (timing constraints), LEF (physical abstractions)
- Build time: ~2 hours (normal; use `make -j<N>` for parallel build; N=core count)
- Dependencies: Auto-installed (Tcl, Boost, Eigen, SWIG, Python, etc.; saves manual effort)
- Future tutorials: Floorplan, placement, CTS, routing using OpenRoad + GCD example (Nangate45)

**Cross-links:** See Lec47-48: Chip planning (floorplan, power plan); Lec49: Placement; Lec50: CTS/routing; Lec06: VLSI design flow (physical design overview)

---

*This summary condenses tutorial Lec46 from ~2,000 tokens, removing verbose installation command echoes, redundant folder listings, and step-by-step GUI navigation.*
