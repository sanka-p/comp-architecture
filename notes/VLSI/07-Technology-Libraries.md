# Technology Libraries

> **Chapter Overview:** Technology libraries provide the models tools need to estimate delay, slew, power, and constraints for standard cells. This chapter explains Liberty (.lib) timing models (NLDM/CCS), setup/hold characterization, PVT corners, and how libraries are used in synthesis and STA.

**Prerequisites:** [[04-Logic-Synthesis]]  
**Related Topics:** [[08-Static-Timing-Analysis]], [[10-Technology-Mapping]]

---

## 1. Library Types and Roles

### 1.1 Technology Library (Liberty .lib)

**Content:**
- Functionality (Boolean logic of pins)
- Timing (cell delay, output slew tables)
- Power (dynamic/leakage)
- Area
- Constraints (setup/hold for sequential cells)

**Format:** ASCII, human-readable; widely used across tools.

### 1.2 Physical Library (LEF)

**Content:**
- Abstract layout: pin locations, cell width/height
- Technology data: layer stack, resistance/capacitance per square

**Usage:** Physical design (placement, routing). Timing uses .lib; geometry uses LEF.

### 1.3 Why Libraries Matter

- Raise abstraction: work at cell level, not transistors
- Distribute cost over many chips (1 library → many designs)
- Enable fast analysis vs SPICE (100–1000× faster)

---

## 2. Characterization and Models

### 2.1 Characterization Flow

1. Design cell (layout, transistor sizing)  
2. SPICE simulate across stimuli, PVT corners (PDK models)  
3. Extract delay/slew/power vs conditions  
4. Build abstract tables → write Liberty `.lib`

### 2.2 PVT Corners

- Process: slow/typical/fast
- Voltage: min/typ/max
- Temperature: e.g., -40°C, 25°C, 125°C
- Separate .lib per corner; STA checks MMMC scenarios.

### 2.3 Timing Arcs

- Delay arcs: input pin → output pin
- Constraint arcs: D pin → CLK pin (setup/hold)

### 2.4 Slew and Delay Definitions

- Slew (transition time): LTP→UTP (e.g., 10→90%)
- Delay (propagation): input threshold → output threshold (e.g., 50%→50%)
- Thresholds defined in .lib header: IRTP/IFTP, ORTP/OFTP

### 2.5 NLDM vs CCS

**NLDM (Non-Linear Delay Model):**
- 2D tables: delay/slew = f(input slew, output load C)
- Separate rise/fall tables
- Interpolate between table points

**CCS/ECS (Current Source Models):**
- More accurate at advanced nodes (accounts for RC, Miller coupling)
- Preferred at 7nm/5nm; NLDM sufficient at older nodes

### 2.6 Setup/Hold Modeling

- Setup: minimum time data must be stable before clock edge
- Hold: minimum time data must be stable after clock edge
- 2D tables: constraint = f(data slew, clock slew)

---

## 3. Practical Use in Tools

### 3.1 Synthesis

- Chooses gates and drive strengths using .lib timing/area
- Technology mapping to library cells (see [[10-Technology-Mapping]])

### 3.2 Static Timing Analysis (STA)

- Computes delays from .lib tables (NLDM/CCS)
- Uses PVT-specific .lib per scenario
- Propagates slew and arrival times through timing graph

### 3.3 OpenSTA Experiments (Lec36)

- Input transition increases → delay increases (table rows)
- Output load increases → delay increases (table columns)
- Input delay adds to arrival; output delay subtracts from required
- Clock uncertainty subtracts from required (pessimistic margin)

---

## 4. Key Takeaways

1. Liberty .lib models are the backbone for timing/power analysis.
2. NLDM uses 2D lookup tables; CCS/ECS improve accuracy at advanced nodes.
3. Setup/hold constraints depend on both data and clock slews.
4. PVT corners → multiple .lib files; STA runs MMMC scenarios.
5. LEF gives geometry; .lib gives timing—both needed for full flow.

---

## Tools

- Characterization: Liberate, SiliconSmart
- SPICE: HSPICE, Spectre, Ngspice
- STA: OpenSTA (open-source), PrimeTime, Tempus

---

## Common Pitfalls

- Confusing slew with delay
- Using wrong thresholds (read .lib header)
- Assuming NLDM accuracy at advanced nodes (use CCS)
- Ignoring that setup/hold depend on both data and clock slew

---

## Further Reading

- [[08-Static-Timing-Analysis]]: How STA consumes .lib tables
- [[10-Technology-Mapping]]: Mapping RTL to library cells
- [[21-EDA-Tools-and-Tutorials]]: OpenSTA usage and scripts
