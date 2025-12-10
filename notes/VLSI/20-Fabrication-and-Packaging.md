# Fabrication and Packaging

> **Chapter Overview:** From verified layout to physical chips: mask fabrication with resolution enhancement techniques, wafer fabrication (FEOL/BEOL), wafer test, packaging, final test, burn-in, and binning.

**Prerequisites:** [[14-Physical-Design-Basics]]  
**Related Topics:** [[19-Physical-Verification-and-Signoff]]

---

## Overview: From Layout to Chip (Lec09)

After completing the design flow (idea → RTL → GDS), the layout must be fabricated into physical chips. Understanding fabrication helps designers:
- Appreciate fabrication challenges
- Make design decisions that improve manufacturability
- Solve fabrication problems during design phase

**Key concept:** Photolithography is the fundamental task in IC fabrication, requiring masks to transfer patterns onto silicon.

---

## 1. Mask Fabrication (Lec09)

### 1.1 What is a Mask?

**Definition:** A mask is a replica of patterns on a given layer of the layout, created on glass or fused silica substrate, used to transfer patterns during photolithography.

**Purpose:** Transfer layout patterns onto silicon wafer through photolithography process.

### 1.2 Mask Fabrication Steps

#### Step 1: Data Preparation

**Fracturing:**
- Convert complex polygon shapes from layout into simpler shapes
- Break down polygons → rectangles and trapezoids
- Enables easier comprehension by mask writing tools

**Resolution Enhancement Techniques (RET):**
- Augment mask data to enhance photolithography resolution
- Techniques include:
  - Optical Proximity Correction (OPC)
  - Multi-patterning (double-patterning, etc.)

#### Step 2: Mask Writing

**Starting material (Blank):**
- Glass or quartz substrate
- Chromium layer coating
- Photoresist layer on top

**Writing process:**
1. Expose photoresist to laser or electron beam in desired pattern
2. Exposed regions change properties
3. Develop: Remove exposed photoresist regions
4. Etch: Remove chromium where photoresist was removed
5. Strip: Remove remaining photoresist
6. Result: Pattern transferred to chromium layer

#### Step 3: Quality Assurance

**Inspection:**
- Scan mask surface
- Compare with reference image
- Identify defects

**Repair:**
- Use laser to repair defects beyond tolerance limits
- Ensure defect-free pattern

#### Step 4: Protection

- Apply pellicle (protective cover) over mask
- Prevents contamination during use
- Mask ready for photolithography

---

## 2. Resolution Enhancement Techniques (RET) (Lec09)

### 2.1 The Sub-Wavelength Challenge

**Problem:**
- Photolithography wavelength: 193 nm (typical)
- Modern feature sizes: Much smaller than 193 nm
- When feature size < wavelength → diffraction effects cause distortion
- Direct mask replication produces distorted features on silicon

**Solution:** Pre-compensate mask features so post-distortion result matches desired pattern.

### 2.2 Optical Proximity Correction (OPC)

**Concept:** Add controlled distortion to mask features so final silicon patterns match design intent.

#### Common Distortions Without OPC

- **Corner rounding:** Sharp corners become rounded
- **Line-end pullback:** Line ends recede from intended position

#### OPC Techniques

**Added features:**
- **Hammerheads:** Extended features at line ends
- **Serifs:** Corner extensions
- **Mouse bites:** Indentations

**Result:** Pre-distorted mask + diffraction effects → desired pattern on silicon

**Example:**
```
Desired: L-shaped feature
Without OPC: Rounded corners, shortened line ends
With OPC: Add serifs and hammerheads to mask
After lithography: Correct L-shape on silicon
```
![[Pasted image 20251211033704.png]]
### 2.3 Multi-Patterning (Double/Multiple Patterning)

**Problem:** Closely spaced features cannot be printed simultaneously due to resolution limits.

**Solution:** Split features across multiple masks and exposures.

#### Process

1. **Color assignment:** Assign features to different masks (colors)
2. **Spacing requirement:** Features on same mask must have sufficient spacing
3. **Multiple exposures:** Each mask exposed separately
4. **Final pattern:** Combination of all exposures creates desired layout

#### Advantages

- Enables printing of closely spaced features
- Overcomes single-exposure resolution limits
- Essential for advanced technology nodes

#### Challenges

- **Increased complexity:** Multiple masks required
- **Alignment:** Precise alignment between exposures critical
- **Cost:** More masks and exposures increase fabrication cost
- **Design constraints:** Layout must be "colorable" (assignable to masks)

---

## 3. Masks and RET Summary

**Key RET techniques:**
- Fracture polygons → rectangles/trapezoids
- Add OPC features (serifs, hammerheads, mouse bites) to mitigate diffraction
- Multi-patterning: split closely spaced features across masks/exposures
- Color assignment for multi-patterning

**Mask writing process:**
- Laser/e-beam on resist → develop → etch chromium → strip resist
- Quality assurance + pellicle protection

---

## 4. Wafer Fabrication

**Front-End-Of-Line (FEOL):** Device fabrication
- Photolithography
- Oxidation
- Diffusion
- Ion implantation
- Etching
- Creates transistors and other devices

**Back-End-Of-Line (BEOL):** Interconnect fabrication
- Dual-damascene process for metal stack
- Multiple metal layers
- Vias connecting layers

**Process characteristics:**
- Hundreds of sequential steps
- Layer-by-layer fabrication
- Precise process control required

---

## 5. Manufacturing Defects and Yield (Lec08)

### 5.1 What are Manufacturing Defects?

**Definition:** Physical imperfections in a fabricated chip that are permanent in nature.

**Key distinction:**
- **Defects:** Physical imperfections (shorts, opens, conducting particles)
- **Faults:** Logical models of defects used for testing (e.g., stuck-at-0, stuck-at-1)

**What testing detects:**
- Problematic defects modeled as faults
- **NOT** detected: Distortions from optical effects (diffraction during photolithography)
- **NOT** detected: Inconsequential flaws (e.g., tiny dust particles with no observable impact)

### 5.2 Sources of Manufacturing Defects

Despite sophisticated clean room environments with controlled:
- Particulate impurities
- Static electricity
- Vibrations

**Defects originate from:**
1. **Statistical deviations:** Material properties and chemical concentrations vary
2. **Finite tolerances:** Process parameters (e.g., furnace temperature: 800°C ± 1°C)
3. **Airborne particles:** Cannot be completely eliminated
4. **Undesired chemicals:** Trace contaminants
5. **Mask feature deviations:** Variations in mask patterns

### 5.3 Types of Manufacturing Defects

#### Large Area Defects
- **Causes:** Wafer mishandling, mask misalignment
- **Detectability:** Simpler to eliminate
- **Status:** Easily eliminated in mature processes

#### Spot Defects (Small Area Defects)
- **Nature:** Random, inevitable
- **Behavior:** Increase with die area
- **Importance:** Primary concern for testing

### 5.4 Common Defect Manifestations

**Short circuits:**
- Conducting particle bridges two lines
- Example: Particle between signal line C and ground → C stuck-at-0

**Open circuits:**
- Non-conducting particle breaks electrical path
- Example: Particle on wire → signal path broken

**Parameter changes:**
- Circuit parameters altered
- Delay increases/decreases
- Timing violations result

### 5.5 Yield: Definition and Importance

**Yield formula:**
```
Yield = (Number of good dies / Total dies) × 100%
```

**Example:**
- 400 dies manufactured, 300 good, 100 defective
- Yield = (300/400) × 100% = 75%

**Yield dependencies:**

1. **Process maturity:**
   - Mature process: >90% yield
   - New process: <50% yield

2. **Die area:**
   - Larger area → higher defect probability → lower yield
   - Critical design tradeoff

3. **Defect density (d):**
   - Average defects per unit area
   - Function of process technology and maturity

4. **Clustering (α):**
   - How defects distribute across wafer
   - Clustered defects → higher yield (multiple defects on same die don't reduce yield further)
   - Distributed defects → lower yield (each defect kills separate die)

### 5.6 Yield Model

**Popular yield model (accounting for clustering):**

```
Y = (1 + Ad/α)^(-α) × 100%
```

Where:
- A = die area
- d = defect density
- α = clustering parameter

**Clustering impact:**
- Low α: defects highly clustered → high yield
- High α: defects distributed → low yield
- **Fortunately:** Real fabrication shows clustered defect distribution

**Example: Clustering effect**
- 34 dies, 10 defects distributed → Yield = 71%
- 34 dies, 10 defects clustered → Yield = 76%

**Using the model:**
- Obtain d and α from historical data via curve fitting
- Estimate yield for new chip using die area
- Critical for profitability analysis before starting design venture

### 5.7 Economic Impact of Yield

**Cost relationship:**
- Low yield → fewer good dies per wafer
- Higher effective cost per chip
- Reduced profitability
- Essential to estimate yield before project start

---

## 6. Test and Packaging

### 6.1 Verification vs. Testing

**Verification (during design):**
- Ensures design correctness
- Catches design errors
- Performed: RTL to GDS flow
- Goal: Layout meets specification

**Testing (after fabrication):**
- Ensures manufacturing quality
- Catches fabrication defects
- Performed: Post-fabrication
- Goal: Fabricated chip matches layout

**Why testing matters during design:**
- Must add Design-for-Test (DFT) features
- Enables easy defect detection and diagnosis
- Improves test quality and coverage

### 6.2 Wafer Probe Testing

**Purpose:** Identify good dies before expensive packaging step

**Equipment:** Automatic Test Equipment (ATE)
- Test head
- Probe cards
- Probe needles

**Process:**
1. Probe needles contact die pads on wafer
2. Apply test vectors (test patterns) to die
3. Observe output response through probe needles
4. Compare actual vs. expected response
5. Pass/fail decision for each die
6. Mark good/bad dies

**Outcome:**
- Good dies proceed to packaging
- Bad dies discarded
- Wafer sliced after testing

### 6.3 Test Pattern Generation

**Goal:** Differentiate good circuits from faulty ones

**Method:**
- Design test patterns based on circuit functionality
- For each fault model, create patterns where:
  - Good circuit produces one response
  - Faulty circuit produces different response
- Observing difference indicates presence of fault

### 6.4 Test Quality Metrics

#### Fault Coverage

**Definition:**
```
Fault Coverage = (Faults detectable by test patterns / All possible faults) × 100%
```

**Target:** >99% (ideally 100%)

**Impact:**
- 100% coverage: No defective chip escapes testing
- <100% coverage: Some defective chips pass as good

**Trade-off:**
- Higher coverage requires more test patterns
- More test time → higher cost
- Must balance quality vs. cost

#### Defect Level (DL)

**Definition:** Ratio of bad chips among those passing test

**Measurement:** Parts Per Million (PPM)

**Formula:**
```
DL = (Bad chips passing test / Total chips passing test) × 1,000,000
```

**Example calculation:**
- 100 chips manufactured
- 90% yield → 90 good, 10 bad
- 50% fault coverage → 5 bad caught, 5 bad escape
- Chips shipped: 90 + 5 = 95
- Defect level: (5/95) × 1,000,000 = 52,632 PPM

**Commercial target:** <500 PPM defect level

**Dependencies:**
- Increases with lower fault coverage
- Increases with lower yield
- Effective testing critical for customer satisfaction

### 6.5 Design for Test (DFT)

**Why DFT during design phase:**

1. **Insert test structures:**
   - Scan chains
   - Built-in self-test (BIST)
   - Test access mechanisms
   - Facilitate easy testing of internal nodes

2. **Generate test patterns:**
   - Automatic Test Pattern Generation (ATPG)
   - High fault coverage patterns
   - Minimize test time

3. **Compute expected responses:**
   - Golden reference for comparison
   - Fault simulation results

**DFT tasks:**
- Performed during RTL to GDS flow
- Targeted for manufacturing test
- Trade-off: area/power overhead vs. testability

### 6.6 Packaging

**Functions:**
- Encapsulate die for protection
- Provide I/O connections
- Manage thermal dissipation

**Package types:**
- DIP (Dual In-line Package)
- BGA (Ball Grid Array)
- Others (QFP, LGA, etc.)

**Design impact:**
- Affects signal integrity
- Influences thermal behavior
- Determines mechanical constraints

---

## 7. Final Test, Burn-in, Binning

### 7.1 Final Test

- **Timing:** Post-package testing
- **Purpose:** Catch assembly-related issues
- **Checks:** Functionality, performance, defects introduced during packaging
- **Method:** Similar to wafer probe but on packaged parts
- **Goal:** Ensure package assembly didn't introduce defects

### 7.2 Burn-in

- **Process:** Subject chips to high voltage and temperature
- **Purpose:** Expose latent defects
- **Benefit:** Improve long-term reliability
- **Mechanism:** Accelerate failure of weak chips
- **Typical conditions:** Elevated temperature (e.g., 125°C), elevated voltage
- **Duration:** Hours to days depending on application criticality

### 7.3 Binning

- **Process:** Categorize chips by performance
- **Criteria:** Speed, power consumption, functionality
- **Purpose:** Market segmentation and pricing
- **Example:** Same design → multiple SKUs based on tested performance
- **Benefit:** Maximize revenue from single design
  - High-speed parts → premium pricing
  - Lower-speed parts → budget market

### 7.4 Diagnosis and Failure Analysis

**When defects found:**
- Diagnose root cause
- Identify fault location
- Analyze failure mechanism

**Corrective actions:**
- Process adjustments
- Design modifications if systematic issue
- Prevent similar defects in future fabrication

**Goal:** Continuous improvement of yield and quality

---

## 8. Key Takeaways

1. **RET is essential:** OPC and multi-patterning critical for sub-wavelength lithography
2. **Mask fabrication is complex:** Data prep, writing, QA, and protection all critical
3. **Wafer fab has two phases:** FEOL (devices) and BEOL (interconnects)
4. **Defects are inevitable:** Statistical variations, particles, and tolerances cause defects
5. **Yield economics matter:** Die area, defect density, and clustering determine profitability
6. **Testing ≠ Verification:** Verification checks design correctness; testing checks manufacturing quality
7. **DFT enables testing:** Must design for testability during RTL to GDS flow
8. **Test quality metrics:** Fault coverage (>99%) and defect level (<500 PPM) measure effectiveness
9. **Packaging matters:** Not just protection—affects electrical, thermal, and mechanical performance
10. **Multi-stage testing:** Wafer probe → package → final test → burn-in ensures quality
11. **Binning enables flexibility:** Same design supports multiple market segments

---

## Tools

- **OPC engines:** Calibre nmOPC, Proteus OPC
- **Mask writers:** Laser and e-beam mask writing systems
- **Inspection systems:** Mask defect inspection
- **Test equipment:** Automatic Test Equipment (ATE), wafer probers, final test systems
- **ATPG tools:** Automatic Test Pattern Generation for DFT
- **Fault simulators:** Compute fault coverage metrics

---

## Common Pitfalls

- **Skipping OPC:** Results in distorted wafer features and yield loss
- **Ignoring yield during design:** Large die area → low yield → unprofitable
- **Insufficient DFT:** Difficult/impossible to test manufactured chips
- **Low fault coverage:** Defective chips escape to customers (high defect level)
- **Poor thermal design:** Inadequate heat dissipation in package leads to overheating
- **Inadequate pin planning:** Creates signal integrity issues
- **Insufficient test coverage:** Defects escape to customers
- **Ignoring manufacturability:** Layout patterns that are difficult to fabricate
- **Neglecting clustering effects:** Yield estimates inaccurate without considering defect distribution

---

## Further Reading

- [[13-Design-for-Test]]: DFT techniques and scan design
- [[14-Physical-Design-Basics]]: Interconnect and BEOL context
- [[19-Physical-Verification-and-Signoff]]: Pre-fab verification steps
