# Lec47 — Chip Planning - I

## Overview
Covers hierarchical design methodology (partitioning, budgeting, block implementation, top-level assembly), floorplanning basics (die size, utilization, IO cell placement), and design for flexibility (orientation, aspect ratio changes).

## Core concepts
**Hierarchical design implementation (divide and conquer):**
- **Motivation:** Flat design impractical for multi-million gate designs (tools struggle, designers overwhelmed)
- **Steps:** (1) Partitioning, (2) Budgeting, (3) Block implementation, (4) Top-level assembly
- **Partitioning:** Divide big design into smaller blocks
  - **Functional partitioning:** Group by function (CPU → controller, ALU, register bank; ALU → decoder, multiplier, etc.)
  - **Min-cut algorithms:** Minimize nets crossing blocks (reduces routing complexity, improves timing, fewer pins)
  - **Reason for min-cut:** Fewer cuts → easier routing, better timing (no inter-block delays), fewer pins → simpler block P&R
- **Budgeting:** Allocate fraction of clock period to blocks (timing budgets pushed down from top-level)
  - **Timing budgets:** Create block-level SDC files (e.g., B1.sdc: 10% clock period; B2.sdc: 70%; B3.sdc: 10%; top.sdc: 10%)
  - **Physical constraints:** Routing resources (top-level routing over block → reserve space in block), DFT (scan chain I/O)
- **Block implementation:** Separate teams implement blocks (honor timing budgets, physical/DFT constraints)
- **Top-level assembly:** Integrate blocks; abstract models (ETM: extracted timing model; ILM: interface logic model)
  - **Abstract models:** Retain interface paths (input→FF, FF→output, input→output); discard internal paths (FF→FF; already verified at block level)
  - **Benefit:** Reduced verification complexity (no internal paths; focus on inter-block timing)

**Floorplanning (planning for layout):**
- **Objective:** Decide die size, aspect ratio, IO cell locations, macro placement, standard cell rows
- **Impact:** Huge impact on QR (routability, performance, power); subsequent stages (placement, CTS, routing) heavily dependent
- **Die size:** Smallest size fitting design (↓area → ↑yield, ↓cost; yield ∝ 1/area)
  - **Components:** IO cells (pads), standard cells (rows), macros/blocks, halo (empty space around macros), interconnects
  - **Utilization:** (cell area + macro area + halo area) / core area (0.6-0.8 typical; leaves space for routing)
    - **Core area:** Die area minus IO cell area
    - **100% utilization:** No space for routing (ideal: all routing over cells/macros; impractical for tools)
    - **60-80% utilization:** Allocates routing channels (empirical; from previous designs)
  - **Package size:** Also determines die size/aspect ratio (die fits in package; alignment important)

**IO cells (pads):**
- **Purpose:** Interface with external world (signals enter/exit chip)
- **Types:** Input, output, bidirectional (OE pin: output enable; OE=0→input mode; OE=1→output mode)
- **Functions:** (1) Drive capability (buffers; external loads larger than internal), (2) Voltage transformation (level shifters; core ≠ I/O voltage), (3) ESD protection (electrostatic discharge; kV pulses → prevent core damage)
- **Connection:** IO cell (MPAD) → bond wire → package pin
- **Power pads:** Supply VDD/GND to chip (separate from IO cells; avoid noise coupling)
  - **Number of power pads:** Depends on current draw (I_chip / I_max_per_pad); more current → more pads
  - **Separate power:** IO cell power ≠ core power (IO draws large transient current → voltage fluctuations → isolate from core)

**IO cell placement (heuristics):**
1. Place jointly-driven inputs nearby (e.g., 2 inputs driving multi-input gate → place IOs close)
2. Spread power-hungry IOs (avoid IR drop hotspots)
3. Avoid sensitive signals (clock, reset) near high-current IOs (reduce crosstalk/noise)
4. Flip-chip packaging: IOs can be inside chip (bumps on top layer; not just periphery) → more flexibility, shorter routes

## Methods/flows
**Hierarchical design flow:**
1. **Partition:** Top-level design → blocks (functional groups, min-cut algorithms; e.g., 10M gates → 10 blocks of 1M each)
2. **Budget:** Create block SDC files (timing budgets: % clock period; physical constraints: routing reserved for top-level)
3. **Block implementation:** Teams implement blocks (honor budgets; verify at block level)
4. **Top-level assembly:** Integrate blocks using abstract models (ETM/ILM; interface paths only); verify inter-block timing

**Floorplanning flow:**
1. **Die size:** Estimate cell area (from netlist + library), macro area, halo → utilization (0.6-0.8) → core area → add IO cells → die area
2. **IO cell placement:** Apply heuristics (jointly-driven nearby, spread power-hungry, avoid sensitive near high-current)
3. **Macro placement:** (Next lecture: Lec48)
4. **Standard cell rows:** Allocate regions (contiguous preferred; create rows with site width/height)

**Utilization calculation:**
- **Example:** Cell area=10mm², macro area=5mm², halo area=2mm², core area=25mm²
  - Utilization = (10+5+2)/25 = 0.68 (68%; 32% left for routing)

## Constraints/assumptions
- **Flat design:** Suitable for small designs (<1M gates); larger designs → hierarchical mandatory
- **Min-cut partitioning:** NP-complete (heuristics used; may not be optimal)
- **Budgeting:** Requires designer judgment (allocate % clock period based on expected logic depth per block)
- **Abstract models:** Commercial tools provide (ETM, ILM); manual implementation complex

## Examples
**Partitioning (functional):**
- **Top-level chip:** CPU, Media Processor, ROM, PLL, Power Controller → 5 blocks
- **CPU block:** Controller, ALU, Register Bank → 3 sub-blocks
- **ALU block:** Decoder, Computational Unit, Multiplier, DCT Unit → 4 sub-blocks

**Min-cut example:**
- **Before:** Block B1 ↔ B2: 52 nets (max); minimize cuts
- **After partitioning:** Keep B1, B2 together (short wires, few pins, easy routing)

**Budgeting (timing):**
- **Path:** FF1 (B1) → D1 → D2 (top) → D3 (B2) → D4 (B3) → FF2 (clock period = 10ns)
- **Allocation:** B1: 10% (1ns), B2: 70% (7ns, most logic), B3: 10% (1ns), top: 10% (1ns, routing delay)
- **SDC files:** B1.sdc: `set_input_delay -max 1 ...`; B2.sdc: `-max 7 ...`

**Utilization:**
- **Design:** Cell area=100mm², macro=50mm², halo=20mm²; utilization=0.7 → core area = (100+50+20)/0.7 ≈ 243mm²
- **Routing space:** 243 - 170 = 73mm² (30% for interconnects)

**IO cell (bidirectional):**
- **Structure:** MPAD → buffer (X1) → core; core → tri-state buffer (OE control) → MPAD
- **Modes:** OE=0 (input: external signal → core via X1; tri-state=high-Z); OE=1 (output: core → external via tri-state)

## Tools/commands
- **Partitioning:** hMetis, MLPart (min-cut algorithms; academic); commercial: Innovus Partition, ICC2 Hierarchical
- **Budgeting:** SDC files (per-block constraints); tools: PrimeTime (verify budgets), Innovus (push-down constraints)
- **Floorplanning:** Innovus `floorPlan`, ICC2 `initialize_floorplan`; OpenRoad `initialize_floorplan`

## Common pitfalls
- Over-partitioning (too many small blocks → overhead; min-cut difficult)
- Under-budgeting timing (70% to one block → other blocks cannot close; re-budget expensive)
- Not allocating top-level timing budget (routing delays at top → violations)
- Ignoring DFT/physical constraints during budgeting (scan chain routing fails; top-level routing blocked)
- 100% utilization (no routing space → congestion, DRC violations)
- IO cell placement without heuristics (random → long wires, hotspots, crosstalk)
- Not separating IO/core power (voltage fluctuations → core logic errors)

## Key takeaways
- Hierarchical design: Partition (functional, min-cut) → budget (timing, physical, DFT) → block implementation → top-level assembly (abstract models)
- Partitioning: Minimize cuts (fewer nets crossing blocks → easier routing, better timing, fewer pins)
- Budgeting: Allocate % clock period per block (push down timing constraints; also physical constraints: routing reserves, DFT)
- Abstract models: Retain interface paths (input→FF, FF→output, input→output); discard internal (FF→FF; verified at block level) → reduce top-level complexity
- Floorplanning: Decide die size (smallest fitting design; ↓area → ↑yield, ↓cost), aspect ratio, IO cell locations
- Die size: Cell area + macro area + halo + routing (via utilization: 0.6-0.8 typical)
- Utilization: (cell + macro + halo) / core area; 60-80% → leaves 20-40% for routing (empirical; adjust per design)
- IO cells: Interface (buffers, level shifters, ESD protection); power pads (VDD/GND; separate from core power)
- IO cell placement: Heuristics (jointly-driven nearby, spread power-hungry, avoid sensitive near high-current)
- Flip-chip: IOs inside chip (bumps on top; not just periphery) → more flexibility, shorter routes
- Impact: Chip planning decisions (partition, die size, utilization) → huge impact on downstream (placement, CTS, routing)

**Cross-links:** See Lec48: Chip planning II (macro placement, power planning, IR drop, decap); Lec49: Placement (standard cells); Lec44: IC fabrication (device layers, interconnects); Lec45: LEF files (technology LEF, cell LEF)

---

*This summary condenses Lec47 from ~16,000 tokens, removing verbose examples, redundant heuristic explanations, and repeated chip planning motivation.*
