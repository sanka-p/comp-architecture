## IC Physical Structure

Integrated circuits are monolithic silicon chips containing several electronic components. The vertical structure is composed of:

**Bottom layer (substrate):**
- Devices: Transistors, diodes formed using diffusion and ion implantation
- Created through selective doping of silicon substrate

**Upper layers (interconnect):**
- Multiple metal layers (M1, M2, M3, ...) for routing signals due to
	- Limited planar area requires vertical stacking
	- Enables crossing connections without electrical shorts
	- Each layer dedicated to preferred routing direction (alternating horizontal/vertical)
- Vias connect between metal layers vertically
- Dielectric insulation prevents shorts

**Benefits of transistor scaling:**
- ↑ Speed (shorter channels, lower capacitance)
- ↓ Energy per operation (lower voltage, smaller devices)
- ↓ Cost per transistor (more transistors per die)
- ↑ Design complexity (managing billions of devices)

![IC Cross Section](ic-cross-section.jpg "IC Cross Section")

---
## IC Manufacturing Process

### Photolithography Pipeline

**Steps:**
1. **Coat:** Apply photoresist (light-sensitive polymer) to wafer
2. **Expose:** Shine light through mask onto photoresist
   - Mask = transparent glass plate with opaque chromium patterns
   - Defines geometry for one layer
3. **Develop:** Chemical removes exposed (or unexposed) resist
4. **Etch:** Remove exposed film (metal, oxide) not protected by resist
5. **Strip:** Remove remaining photoresist
6. **Repeat:** For each layer (devices, contacts, metals, vias)

> **Note:** Modern processes use 20-40 mask layers; each requires a separate photolithography cycle.

### Manufacturing Hierarchy

**From silicon to chip:**

```
Silicon Ingot (cylindrical, pure silicon)
    ↓ (slice)
Wafers (circular, typically 300mm diameter)
    ↓ (pattern, etch, deposit — many layers)
Dies (rectangular regions on wafer, single IC unit)
    ↓ (test, separate)
Good Dies (functional after testing)
    ↓ (bond, encapsulate)
Chips (packaged, market-ready products)
```


**Yield**: Percentage of functional dies per wafer
$$\text{Yield} = \frac{\text{Good Dies}}{\text{Total Dies on Wafer}} \times 100\%$$
Yield depends on:
- Defect density (fab cleanliness, process control)
- Die area (larger dies → more defects → lower yield)
- Design rule adherence (PDK compliance)

---

## Design vs Fabrication

### Distinct Roles

**Design:**
- Chooses circuit parameters (transistor sizes, connectivity)
- Creates layout (geometric patterns for each layer)
- Generates masks (one per layer)
- Tools: EDA software (synthesis, simulation, verification)

**Fabrication:**
- Replicates physical chips from masks
- Operates in cleanrooms with expensive equipment
- Process defined by foundry
- Capital-intensive ($10B+ for advanced fabs)

> **Critical insight:** Design and fabrication are separate specializations requiring coordination through standardized interfaces (PDK, GDSII files).

### Industry Business Models

| Model | Description | Examples | Characteristics |
|-------|-------------|----------|-----------------|
| **Fabless** | Design only; outsource manufacturing | Qualcomm, NVIDIA, AMD | Low capex, design focus |
| **Foundry** | Manufacturing only; no design | TSMC, UMC, GlobalFoundries | Serve multiple customers |
| **IDM** (Integrated Device Manufacturer) | Both design and fab | Intel, Samsung | High capex, vertical integration |

**Why fabless-foundry model dominates:**
- Foundries achieve economies of scale (serve many customers)
- Design companies avoid $10B+ fab investment
- Specialization improves efficiency

### Process Design Kit (PDK)

**Definition:** Package from foundry to designers ensuring manufacturable, high-yield layouts.

**PDK contents:**
- **Device models:** SPICE models for transistors, capacitors, resistors
- **Design rules:** Min width, spacing, enclosure constraints
- **Standard cell libraries:** Pre-characterized gates (AND, OR, FF, etc.)
- **Technology files:** Layer definitions, metal stack info
- **Extraction rules:** Parasitic R/C calculation

**Purpose:**
- Align design with fabrication capabilities
- Enable yield prediction
- Provide characterized components (libraries)

---

## IC Types and Design Styles

### IC Classification by Application

**ASIC (Application-Specific IC):**
- Designed for specific function (e.g., crypto accelerator)
- Low programmability
- Lower volume, higher per-unit effort

**General-Purpose ICs:**
- CPUs, GPUs, memories, FPGAs
- High programmability/reusability
- Higher volume, amortized design cost

### Design Styles Spectrum

Arranged by customization level (highest effort → lowest effort):

#### 1. Full-Custom Design
- **Level:** Transistor/layout level
- **Effort:** Highest (manual layout)
- **PPA:** Best (optimized for specific circuit)
- **Use case:** Analog, memory cells, critical datapaths

#### 2. Standard-Cell Design
- **Level:** Gate level using pre-designed cells
- **Effort:** Moderate (automated P&R)
- **PPA:** Strong (characterized libraries)
- **Flow:** Synthesis → Place & Route → Verification
- **Use case:** Most digital ASICs, SoCs

**Standard-cell characteristics:**
- Fixed height cells (form rows)
- Variable width (different gate strengths)
- Macros for complex blocks (multipliers, RAM)
![Standard Cell Rows](standard-cell-rows.PNG "Standard Cell Rows")
#### 3. Gate-Array Design
- **Level:** Pre-fabricated transistor arrays
- **Customization:** Only top metal layers
- **Effort:** Lower than standard-cell
- **PPA:** Limited (unused devices waste area)
- **Use case:** Legacy; mostly obsolete

#### 4. FPGA (Field-Programmable Gate Array)
- **Level:** Hardware fixed; program interconnects
- **Effort:** Lowest (vendor tools, no masks)
- **PPA:** Worst (overhead from programmability)
- **Advantage:** Fast iteration, easy bug fixes, low NRE
- **Use case:** Prototyping, low-volume, rapid deployment


### Economic Break-Even Analysis

**Cost components:**

**Fixed costs (one-time):**
- Design effort (engineering time)
- EDA tool licenses
- Hardware for verification
- Masks (per layer; $1M-5M for advanced nodes)

**Variable costs (per unit):**
- Wafer fabrication
- Die area
- Yield loss
- Testing, packaging

$$\text{Total Cost} = \text{Fixed} + (\text{Variable} \times \text{Units})$$

|               | ASIC                                            | FPGA                                          |
| ------------- | ----------------------------------------------- | --------------------------------------------- |
| Fixed Cost    | High: designing cost, tools, mask               | Low: tools for programming                    |
| Variable Cost | Low: cost of die (small die size, higher yield) | High: cost of die (large die size, low yield) |

**Decision rule:**
- **Low volume (<10K units):** FPGA cheaper (low NRE)
- **High volume (>100K units):** ASIC cheaper (amortize fixed costs)

![Crossover Point](asic-fpga-crossover.png "Crossover Point")

---

## Figures of Merit (QoR - Quality of Result)

### PPA Trade-offs

**PPA = Performance, Power, Area**

**Performance:**
- Maximum clock frequency (fmax)
- Latency, throughput
- Delay through critical paths

**Power:**
- Dynamic power (switching)
- Static power (leakage)
- Total power budget

**Area:**
- Die size (mm²)
- Gate count
- Utilization

> **Trade-off reality:** Improving one metric often worsens others. Example: Increasing frequency (performance) may require larger transistors (area) and higher voltage (power).

**Goal:** Find **acceptable** balance, not mathematical optimum. Quote PPA consistently across comparisons.

### Additional Success Criteria

Beyond PPA, consider:

**Testability (DFT):**
- Scan coverage
- ATPG fault coverage
- Built-in self-test (BIST)

**Reliability:**
- Aging margins (NBTI, HCI)
- Soft error tolerance
- Operating temperature range

**Schedule:**
- Time-to-market
- Design closure schedule
- Risk of re-spins

---

## VLSI Design Flow Overview

TODO: VLSI Flow Diagram

### Abstraction Management

**Key principle:** Use high abstraction early for broad exploration; add detail later for accuracy.

| Abstraction Level    | Speed    | Accuracy | Typical Stage   |
| -------------------- | -------- | -------- | --------------- |
| Behavioral/Algorithm | Fast     | Low      | System design   |
| RTL                  | Moderate | Moderate | Logic design    |
| Gate-level netlist   | Slow     | High     | Post-synthesis  |
| Layout (GDSII)       | Slowest  | Highest  | Physical design |

**Trade-off:**
- High abstraction → Fast iteration, broad exploration, coarse QoR estimates
- Low abstraction → Accurate QoR, fewer options, slower turnaround

---

## System-Level Design

### Evaluation of "Idea"
- Market requirement
- Financial viability
- Technical feasibility

### Preparing specifications
- Features (functionality)
- PPA
- TTM (Time to Market)

### Hardware/Software Partitioning

**Goal:** Exploit hardware speed/efficiency and software flexibility.

|                  | HW   | SW   |
| ---------------- | ---- | ---- |
| Performance      | High | Low  |
| Cost             | High | Low  |
| Risk due to bug  | High | Low  |
| Customization    | Low  | High |
| Development Time | High | Low  |

**Approach:**
1. Start with all functions in software
2. Set performance target **P**
3. **Profile** to identify bottlenecks (hot spots)
4. Iteratively move top N functions to hardware
5. Re-evaluate performance
6. Stop when P met or no improvement

**Example: Video Compression**
- Software: Frame buffering, control, I/O
- Hardware: DCT (Discrete Cosine Transform) acceleration
- **Why?** DCT is compute-intensive, data-parallel → benefits from HW

**Considerations:**
- Communication overhead (HW ↔ SW)
- Data dependencies
- Implementation complexity

> **Pitfall:** Moving too many functions to HW increases cost/complexity without meeting targets if communication latency dominates.

### Early Verification Without Hardware

**Challenge:** How to verify HW/SW integration before HW exists?

**Solutions:**
1. **Co-simulation:** Use timing models for HW; run SW
2. **FPGA prototyping:** Quick HW implementation for performance testing
3. **HLS-based estimates:** Generate approximate HW from high-level code

---

## RTL Creation Approaches

Functional specification opens up and implementation gap when it being converted to RTL. The implementation gap can be filled using following methods:

### Manual Coding

### IP Assembly

**Concept:** Integrate pre-designed Intellectual Property (IP) blocks.

**Content:**
- Hardware blocks
- Software
- Verification IPs (VIPs)

**Benefits:**
- ↑ Productivity (reuse vs re-create)
- ↓ Cost (amortize IP development)
- ↑ Features (leverage proven blocks)

**Integration challenges:**
- **Configuration consistency:** Bus widths, protocols, clocking
- **Interconnect:** Ad-hoc buses → structured NoC (Network-on-Chip)
- **Verification:** Exponential config space

### Metadata and Generators

**Problem:** Managing complex SoC configurations manually is error-prone.

**Solution:** Use metadata to describe IPs, buses, registers → generate RTL and verification environment.

**Standards/formats:**
- **IP-XACT:** XML-based IP description (IEEE 1685)
- **SystemRDL:** Register description language
- **Custom:** Spreadsheets, JSON, YAML

**Generated artifacts:**
- SoC-level RTL (interconnect, glue logic)
- Verification testbenches
- Software drivers (register access)
- Documentation

### Behaviour Synthesis / High-Level Synthesis (HLS)


