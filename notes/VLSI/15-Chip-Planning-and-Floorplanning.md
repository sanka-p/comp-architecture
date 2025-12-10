## OpenROAD Practical: Chip Planning & Floorplanning

Use the following TCL in OpenROAD to set up die/core, IOs, tapcells, and power grid.

```tcl
# Libraries and design
read_lef tech.lef stdcell.lef io.lef
read_verilog design.v
link_design top

# Floorplan: die/core size and utilization
initialize_floorplan -die_area "0 0 3000 3000" -core_area "200 200 2800 2800" -site core -utilization 0.6

# IO pin placement (example)
place_pins -hor_layers {metal2} -ver_layers {metal3} -random -exclude -corner_keepout 20

# Add well taps and endcaps
tapcell -distance 14 -tapcell_master TAPCELL_X1 -endcap_master ENDCAP_X1

# Power Distribution Network (PDN)
define_pdn_grid -name core_grid -voltage_domains {core}
add_pdn_stripe -grid core_grid -layer metal5 -width 2.0 -pitch 40 -offset 10
add_pdn_stripe -grid core_grid -layer metal6 -width 2.0 -pitch 40 -offset 10 -followpins
add_pdn_connect -grid core_grid -layers {metal5 metal6}
pdngen

# Save floorplan
write_def floorplan.def
```

Notes:
- Replace LEF/Verilog file names and masters with your PDK/library.
- Adjust utilization, site, and PDN parameters per technology.
# Chip Planning and Floorplanning

> **Chapter Overview:** Plan the chip before placement: partition hierarchically, budget timing, choose die size/utilization, place IOs and macros, and set up rows. Good planning makes downstream stages easier.

**Prerequisites:** [[14-Physical-Design-Basics]]  
**Related Topics:** [[16-Placement]], [[17-Clock-Tree-Synthesis]]

## Chip Planning

**Chip planning** is the first and most critical step in physical design. At this stage, there is maximum flexibility and decisions made here have significant impact on final Quality of Results (QoR).

### Major Tasks in Chip Planning

- **Design Partitioning**
  - Partition large designs into subsystems/blocks
  - Perform physical design for subsystems individually
  - Combine results at top level

- **Block/Macro Placement**
  - Define locations of bigger blocks (CPU core, memory, controllers)
  - Manual intervention often required for optimal placement
  - Decide shape for flexible macros (rectangular or rectilinear: I, L, U)

- **Standard Cell Row Allocation**
  - Allocate rows where standard cells will be placed
  - Individual cell locations determined later in placement step
  - Millions of cells make individual placement impractical at this stage

- **I/O Cell Placement**
  - Define location of input/output cells
  - Typically at periphery (depends on packaging)
  - Plan signal entry/exit points

- **Power Planning (PDN - Power Delivery Network)**
  - Critical requirement: voltage drop within tolerance limits
  - Deliver power from input pins to all entities across layout
  - Minimize IR drop (resistance × current)
  - Considerations: power line resistance, current flow, acceptable voltage drop

- **Congestion Management**
  - Congestion = many nets running through same region
  - Caused by poor block placement
  - Consequences: routability problems, routing failures, timing violations (longer wire delays)


---

## 1. Hierarchical Design Implementation

### 1.1 Design Implementation Methodologies

There are two main approaches to physical design implementation:

#### **Flat Design Implementation**
- Suitable for **small designs**
- All hierarchy is flattened - instances are replaced with their contents
- Top level contains only standard cells, library instances, and hard macros
- Everything is implemented in one go
- **Limitations:** Not suitable for large designs (millions/billions of instances)
  - Too difficult for designers to manage
  - EDA tools struggle with complexity

#### **Hierarchical Design Implementation (Divide and Conquer)**
- Required for **multi-million gate designs** in industry
- Major tasks:
  1. **Partitioning** - Divide design into smaller blocks
  2. **Budgeting** - Allocate constraints to each block
  3. **Block Implementation** - Physical design of individual blocks
  4. **Top-Level Assembly** - Integrate all blocks together

### 1.2 Partitioning Strategies

> "A journey of a thousand miles begins with a single step" - Lao Tzu
> 
> Planning must be done at the beginning when there is maximum flexibility. Wrong decisions at this stage will impact the entire design flow.

#### **Method 1: Functional Partitioning**
- **Most natural approach** - partition based on logical functionality
- Group components by what they do
- Example chip structure:
  ```
  Top Level:
  ├── Main CPU
  │   ├── Controller
  │   ├── ALU
  │   │   ├── Decoder
  │   │   ├── Computational Unit
  │   │   ├── Multiplier
  │   │   └── DCT Unit
  │   └── Register Bank
  ├── Media Processor
  ├── Shared Cache
  ├── ROM
  ├── PLL
  └── Power Controller
  ```
- **Recursive/Iterative:** If a partition is still too large, further subdivide it
- The resulting entities are called **blocks**
- Blocks can contain sub-blocks (hierarchical structure)

#### **Method 2: Module Clustering**
- Group modules into clusters based on similarity
- Not necessarily based on functionality
- Can be based on block size or other metrics
- Helps balance partition sizes

#### **Method 3: Algorithm-Based Partitioning (Min-Cut)**
- Used when you have a **flat netlist with millions of standard cells**
- Need to break into smaller blocks (e.g., 10M cells → 10 blocks of 1M cells each)
- Uses **min-cut algorithms** to minimize nets crossing between blocks

**Why Minimize Cuts?**

A "cut" is a net that crosses between two blocks. Minimizing cuts is important because:

1. **Easier Routing:** Fewer inter-block connections make routing simpler
2. **Better Timing:** Nets crossing blocks experience additional delay
   - Must route through one block → top level → another block
   - Increased delays can cause timing violations
3. **Reduced Pin Count:** Fewer cuts = fewer pins on block boundaries
   - Lower pin count makes block-level physical design easier
   - Simplifies block interface

**Example:**
```
Block B1 ←→ (4 cuts) ←→ Block B2
```
- 4 nets cross between B1 and B2
- Each cut requires a pin on both blocks
- Minimizing to 2 cuts would reduce pin count and improve routability

### 1.3 Budgeting and Block Implementation

- Push timing (SDC) and physical/DFT constraints into blocks
- Implement blocks individually
- Assemble with abstract models (ETM/ILM focusing on interface paths)

---

## 2. Floorplanning Basics

### 2.1 Placement of Large Objects (Macros)

During floorplanning, we place **large objects** (also called **macros**):
- **Blocks** from partitioning
- **RAM, ROM**
- **Analog components**
- **Large clock buffers**

**Why Separate from Standard Cells?**
- **Scale difference:** Tens/hundreds of macros vs. millions of standard cells
- **Manual intervention possible:** Can visually inspect and adjust macro placement
- **High impact on QoR:** Macro placement significantly affects final chip performance
- **Standard cells** are placed later during the **Placement Stage**

### 2.2 Initial Macro Placement Guidance

#### **Connectivity-Based Placement**
Use **fly lines** to visualize connectivity between objects:
- Fly lines show the **number of nets** between two objects
- Width/weight of line indicates connection strength

**Example:**
```
      [I1]━━━━4━━━━[B4]
       ║           ║
       5           8
       ║           ║
      [I2]━━16━━━[B1]━━━52━━━[B2]━━━4━━━[B5]
       ║           ║           ║
       3           12          6
       ║           ║           ║
      [I3]         [B3]        [I4]
```

**Placement Heuristics:**
1. **Strong connections → Place closer**
   - B1 ↔ B2 have 52 nets (maximum) → Place adjacent
   - B2 ↔ B5 have 4 nets → Can be further apart

2. **IO proximity**
   - B1 has 16 nets to I2 → Place B1 near I2
   - B1 has only 5 nets to I3 → Can be further from I3

3. **Iterative refinement**
   - Start with connectivity-based initial placement
   - Perform **rough/predictive routing** to identify congestion
   - Adjust macro positions to alleviate congestion hotspots

### 2.3 Floorplanning Guidelines

Since there's no deterministic algorithm for optimal macro placement, designers rely on **guidelines**:

#### **Guideline 1: Allot Contiguous Regions for Standard Cells**

**❌ Bad - Fragmented Regions:**
```
┌─────────────────────────┐
│ [A]  std   [B]   std   │  ← Non-contiguous
│      cells       cells  │     standard cell
│ [C]   std  [D]   std   │     regions
│       cells      cells  │
│ [E]  std   [F]   std   │
│      cells       cells  │
│ [G]   std  [H]         │
└─────────────────────────┘
```

**✓ Good - Contiguous Region:**
```
┌─────────────────────────┐
│ [A]  [B]  [C]  [D]     │
│                         │  ← Single continuous
│ [E]  [F]  [G]  [H]     │     region for
│                         │     standard cells
│    Standard Cell Area   │
│                         │
└─────────────────────────┘
```

**Why?**
- Standard cell area is same in both cases
- **Analytical placement algorithms** work better with continuous regions
- Fragmented regions cause placement tool performance degradation
- Better optimization results with contiguous space

#### **Guideline 2: Avoid Narrow Channels Between Macros**

**❌ Bad - Narrow Channels:**
```
┌─────────────────────────┐
│     ← narrow gap →      │
│ ┌────┐  ┌────┐  ┌────┐ │
│ │ A  │  │ B  │  │ C  │ │  ← Narrow channels
│ └────┘  └────┘  └────┘ │     between macros
│   ↑       ↑       ↑    │
│ narrow  narrow  narrow  │
└─────────────────────────┘
```

**Problems with Narrow Channels:**

1. **Routing Congestion**
   - Fewer routing tracks available
   - Limited space for wires
   - High probability of routing failures

2. **Optimization Difficulties**
   - **Upsizing blocked:** No room to increase cell size for timing fixes
   - **Buffer insertion limited:** Cannot add buffers for signal integrity
   - Timing violations hard to fix

3. **Placement Issues**
   - Placement tool may fill narrow channels
   - Cells get stuck without room for optimization

**✓ Better Solutions:**

**Option 1: Shift macros to eliminate channels**
```
┌─────────────────────────┐
│ ┌────┐┌────┐┌────┐     │
│ │ A  ││ B  ││ C  │     │  ← Macros pushed together
│ └────┘└────┘└────┘     │
│                         │
│   Wide standard cell    │  ← Wide area for
│   region               │     standard cells
└─────────────────────────┘
```

**Option 2: Change aspect ratio of flexible macros**
- If macro B is a **flexible macro**, change its shape
- Make it taller/narrower to eliminate the channel
- Only works for soft/flexible macros, not hard macros

### 2.4 Macro Types

#### **Hard Macros**
- **Fixed** aspect ratio and area
- Often from external vendors
- Cannot modify dimensions
- Examples: Licensed IP blocks, pre-designed memories

#### **Flexible (Soft) Macros**
- **Variable** aspect ratio
- Can change shape during floorplanning
- Shapes: Rectangular, Rectilinear (I, L, U shapes)
- Examples: Blocks you design yourself, synthesizable memories

### 2.5 Die Size and Utilization

- Core area from cell + macro + halo; target 60–80% utilization (leave 20–40% for routing)
- Smaller die improves yield and cost; package constraints also matter

### 2.2 IO Cells and Power Pads

- IO types: input, output, bidirectional; functions: drive, level shift, ESD
- Place IOs with heuristics: 
  - Group jointly-driven inputs
  - Spread power-hungry IOs
  - Keep sensitive signals away from noisy IOs
  - Use fly lines to determine which IOs should be near which blocks
- Separate IO vs core supplies; size power pads per current draw

### 2.3 Rows and Standard Cell Regions

- Define standard cell rows for later placement
- Ensure **contiguous regions** for standard cells (not fragmented)
- Macro placement and halos determine available space for rows

---

## 3. Practical Tips and Best Practices

### Planning Phase
- **Maximum flexibility at the start:** Make critical decisions during chip planning when you have the most options
- **Wrong decisions propagate:** Mistakes made early will impact the entire design flow
- Avoid over/under-partitioning; re-budgeting is expensive
- Reserve top-level timing budget for inter-block routing

### Partitioning
- Use **functional partitioning** as the primary method for logical designs
- Apply **min-cut algorithms** to reduce inter-block communication
- Target 1-2 million gates per block for manageable complexity
- Balance block sizes for parallel implementation

### Floorplanning
- Keep utilization **60-80%** (leave 20-40% for routing)
- Never use 100% utilization—no room for routing or optimization
- **Allot contiguous regions** for standard cells (not fragmented)
- **Avoid narrow channels** between macros (< 5-10 cell rows)
- Use **fly lines** to guide initial macro placement
- Perform **rough routing** to identify and fix congestion early
- Place strongly connected blocks adjacent to each other
- Position blocks near relevant IO pads based on connectivity

### Macro Placement
- Hard macros: Fixed shape, cannot modify
- Flexible macros: Can adjust aspect ratio to improve floorplan
- Leave adequate spacing (halos) around macros for routing and optimization
- Manual intervention is valuable—visual inspection helps catch issues

---

## 4. Key Takeaways

1. **Hierarchical flow** reduces complexity and improves QoR for large designs
2. **Chip planning is critical:** Maximum flexibility at design start; decisions here impact entire flow
3. **Partitioning strategies:**
   - Functional partitioning for logical designs
   - Min-cut algorithms to reduce inter-block nets
   - Target manageable block sizes (1-2M gates)
4. **Floorplanning guidelines:**
   - Use fly lines to guide macro placement
   - Allot contiguous regions for standard cells
   - Avoid narrow channels between macros
   - Keep 60-80% utilization for routing headroom
5. **Macro types matter:**
   - Hard macros: Fixed shape from vendors
   - Flexible macros: Adjustable aspect ratio
6. Smart IO and die planning prevents routing and SI headaches
7. Abstract timing models (ETM/ILM) simplify top-level closure
8. **"A journey of a thousand miles begins with a single step"** - Good planning enables successful implementation

---

## Tools

- Partitioning: hMetis, Innovus/ICC2 hierarchical flows
- Floorplan: Innovus `floorPlan`, ICC2 `initialize_floorplan`, OpenROAD

---

## Common Pitfalls

### During Partitioning
- **Over-partitioning:** Too many small blocks → excessive inter-block communication
- **Under-partitioning:** Blocks too large → hard to optimize and close timing
- Ignoring DFT constraints during budgeting

### During Floorplanning
- Random IO placement causing hotspots and crosstalk
- 100% utilization—no room for routing or optimization
- **Fragmented standard cell regions** → poor placement quality
- **Narrow channels between macros** → routing congestion, cannot upsize cells or insert buffers
- Ignoring connectivity when placing macros → long inter-block routes
- Not using fly lines to guide placement decisions
- Placing hard macros without considering routing channels
- Forgetting to leave halos around macros

### During Power Planning
- Insufficient power stripe width → IR drop violations
- Not accounting for peak current requirements
- Poor power grid topology → voltage droop

---

## Further Reading

- [[16-Placement]]: Standard cell placement
- [[17-Clock-Tree-Synthesis]]: Skew/latency targets, buffering
