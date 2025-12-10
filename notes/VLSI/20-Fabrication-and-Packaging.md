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

## 5. Test and Packaging

### 5.1 Wafer Probe Testing

- **Purpose:** Identify good dies before packaging
- **Process:** Test each die on wafer
- **Outcome:** Mark good/bad dies
- **Next step:** Slice wafer, discard bad dies

### 5.2 Packaging

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

## 6. Final Test, Burn-in, Binning

### 6.1 Final Test

- **Timing:** Post-package testing
- **Purpose:** Catch assembly-related issues
- **Checks:** Functionality, performance, defects introduced during packaging

### 6.2 Burn-in

- **Process:** Subject chips to high voltage and temperature
- **Purpose:** Expose latent defects
- **Benefit:** Improve long-term reliability
- **Mechanism:** Accelerate failure of weak chips

### 6.3 Binning

- **Process:** Categorize chips by performance
- **Criteria:** Speed, power consumption, functionality
- **Purpose:** Market segmentation and pricing
- **Example:** Same design → multiple SKUs based on tested performance

---

## 7. Key Takeaways

1. **RET is essential:** OPC and multi-patterning critical for sub-wavelength lithography
2. **Mask fabrication is complex:** Data prep, writing, QA, and protection all critical
3. **Wafer fab has two phases:** FEOL (devices) and BEOL (interconnects)
4. **Packaging matters:** Not just protection—affects electrical, thermal, and mechanical performance
5. **Testing at multiple stages:** Wafer probe, final test, and burn-in ensure quality
6. **Binning enables flexibility:** Same design supports multiple market segments

---

## Tools

- **OPC engines:** Calibre nmOPC, Proteus OPC
- **Mask writers:** Laser and e-beam mask writing systems
- **Inspection systems:** Mask defect inspection
- **Test equipment:** Wafer probers, final test systems

---

## Common Pitfalls

- **Skipping OPC:** Results in distorted wafer features and yield loss
- **Poor thermal design:** Inadequate heat dissipation in package leads to overheating
- **Inadequate pin planning:** Creates signal integrity issues
- **Insufficient test coverage:** Defects escape to customers
- **Ignoring manufacturability:** Layout patterns that are difficult to fabricate

---

## Further Reading

- [[14-Physical-Design-Basics]]: Interconnect and BEOL context
- [[19-Physical-Verification-and-Signoff]]: Pre-fab verification steps
