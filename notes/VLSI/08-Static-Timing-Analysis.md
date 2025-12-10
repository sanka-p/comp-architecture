## Fundamentals

![Timing](ff-timing.png "Timing")


Types of delays in a FF:
- Propagation delay - Delay from clock edge to valid output change
- Setup time - Time the data needs to be stable **before** the clock edge
- Hold time - Time the data needs to be stable **after** the clock edge

Sequentially adjacent flip-flops: Output of one flip-flop is fed as an input to the other flip-flop through a combinational path


Critical Path: The combinational path that has the largest delay in the circuit

**Maximum frequency:**
$$f_{max} < \frac{1}{d_{max}}$$

Where $d_{max}$ is the critical path delay in the design.

## Goals

- Ensure the circuit is in a valid state at each clock cycle 
	- (no zero/double clocking)
- Verify the design is capable of operating at the desired clock frequency from the constraints file
- Check setup (late) and hold (early) constraints for every FF pair

> **Note:** Analysis based on worst-case scenario and takes a pessimistic view wherever possible. Hence it is done without test vector and simulation (therefore static). If the timing analysis passes for the worst-case then all other test vectors should pass the analysis as well.

---

Invalid Circuit States
- Zero Clocking
	- Late data arrival at a flip flop (data arrives after clock edge)
	- Ensured using setup analysis or late analysis
-  Double Clocking
	- Data gets captured by two flip flops by the same clock edge
	- Clock edge to the second flip flop is late
	- New data captured by the first flop flop arrives at the second before the clock signal
	- Ensured using hold analysis or early analysis

> **Note:** The circuit can contain many FFs and data propagates sequentially through a pipeline before reaching the output. Therefore each pair of launch and capture FFs are examined separately

Setup Check
- Ensures the data sent by launch FF in a given clock cycle is captured reliably by the capture FF in the next clock cycle
- Ensures the setup requirement of the FF is also met
Arrival time of data at the D-pin of launch FF:
$$t_{arrival} =  T_{launch} + T_{clk->ql} + T_{data}$$
Required time for data to settle at D-pin of capture FF:
$$t_{req,set} = T_{period} + T_{capture} - T_{setup-c}$$
To avoid zero clocking and setup-time constraints of flip-flops:
$$t_{req,set} > t_{arrival}$$
After simplification
$$T_{period} > (T_{launch} - T_{capture}) + T_{clk->ql} + T_{data} + T_{setup-c}$$
A setup violation can occur if:
- Clock period is decreased
- Delay of capture clock path is decreased
- Delay of launch clock path is increased
- Delay of data path is increased


Let $\delta_{LC} = T_{launch} - T_{capture}$ (clock skew)
Then,
$$T_{period} > \delta_{LC} + T_{clk->ql} + T_{data} + T_{setup-c}$$
To get the worst case scenario
$$T_{period} > \delta_{LC} + T_{clk->ql}^{max} + T_{data} + T_{setup-c}$$

Hold Check
- From one active edge of the clock in the launch flip-flop to the same clock edge at the capture flip-flop (independent of clock period)
- Ensures that the hold requirement of the flip-flop is also met

Arrival time of data at the D-pin of capture FF:
$$t_{arrival} =  T_{launch} + T_{clk->ql} + T_{data}$$
Data to arrive at the capture FF D-pin after the required time:
$$t_{req,hold} = T_{capture} + T_{hold-c}$$
To avoid double clocking and hold-time constraints of flip-flops:
$$t_{arrival} > t_{req,hold}$$
After simplification
$$(T_{launch} - T_{capture}) + T_{clk->ql} + T_{data} >  T_{hold-c}$$
A hold violation can occur if:
- Delay of capture clock path is increased
- Delay of launch clock path is decreased
- Delay of data path is decreased


Let $\delta_{LC} = T_{launch} - T_{capture}$ (clock skew)
Then,
$$\delta_{LC} + T_{clk->ql} + T_{data} >  T_{hold-c}$$
To get the worst case scenario
$$\delta_{LC} + T_{clk->ql} + T_{data}^{min} >  T_{hold-c}$$

> **Note:** Hold violations are fixed after physical synthesis since it strongly depends on clock skew


In STA we are interested in the data path as well as the clock path

Data Path:
- Timing start points
	- Input ports
	- Clock pins of a FF
- Timing end points
	- D-pin of a FF
	- Output ports

Clock Path:
- Starts at clock source (specified in constraints)
- Passes through the combinational circuit elements (buffers, inverters, gating logic)
- Ends at a clock pin of a FF

> **Note:** Setup and hold checks are performed at the timing endpoints

---

Timing Graph G=(V, E)

- Vertices: pins/ports
- Edges: timing arcs
	- cell arcs from .lib - timing arc between two pins of the same cell
	- net arcs from netlist - timing arc between two pins of different cells that are connected directly by a net
![Timing](timing-graph.png "Timing")

**Special Vertices:**
- **Source vertices**: Vertices with no incoming edges (timing start points - input ports, clock pins of FFs)
- **Sink vertices**: Vertices with no outgoing edges (timing end points - D pins of FFs, output ports)

**Edge Annotations:**
- Each edge E(i,j) has annotated delay D(i,j)
- Delays computed by delay calculator and stored on edges
- Vertices store timing information: arrival time, required time, slack

### 3.2 Delay Calculator

The circuit is decomposed into separate stages. A **stage** consists of:
- **Driving cell**: The cell that generates the signal
- **Interconnect**: Net connecting driver to receivers
- **Driven pins**: Input pins of receiving cells (modeled as capacitive loads)

Large circuits are decomposed into multiple stages for efficient delay calculation.

**Delay Calculation Requirements:**
1. **Driver Model** (from .lib file):
   - NLDM (Non-Linear Delay Model)
   - CCS (Composite Current Source)
   - ECSM (Effective Current Source Model)

2. **Interconnect Model**:
   - Zero capacitance (early stages)
   - Lumped capacitance
   - Elmore delay model
   - AWE (Asymptotic Waveform Evaluation)
   - Extracted from layout using parasitic extraction tools → SPEF file (Standard Parasitic Exchange Format)

3. **Receiver Model**:
   - Simple lumped capacitor
   - Advanced receiver models

4. **Input Waveform**:
   - Input transition/slew required for delay calculation
   - Delay calculation proceeds in topological order (fanout direction)
   - Input waveforms at input ports specified by constraints or assumed

**Delay Calculator Output:**
- Edge delay D(i,j)
- Output slew/transition time S(i,j)

### 3.3 Arrival Time Computation

**Definition:** Arrival time is the time at which a signal settles at a given vertex.

**Single Incoming Edge:**
$$A(j) = A(i) + D(ij)$$

**Multiple Incoming Edges:**
When multiple paths converge at a vertex, the signal can toggle multiple times before settling. To avoid tracking all arrival times (memory intensive), we compute bounds:

$$A(j,min) = \min(A(i,min) + D(ij))$$
$$A(j,max) = \max(A(i,max) + D(ij))$$

**Computation Method:**
- **Forward traversal** of timing graph (from input ports to output ports)
- Arrival time at input ports: specified by constraints or assumed to be 0
- A vertex is processed only when arrival times at all input vertices are known
- Can be computed in **one traversal** of vertices and edges (very efficient)

**Example Calculation:**
Given three input vertices to vertex v_j:
- Vertex 1: A_min=100, A_max=150, edge delay=10
- Vertex 2: A_min=80, A_max=120, edge delay=10  
- Vertex 3: A_min=150, A_max=200, edge delay=10

Results at v_j:
- A_min(j) = min(100+10, 80+10, 150+10) = min(110, 90, 160) = **90**
- A_max(j) = max(150+10, 120+10, 200+10) = max(160, 130, 210) = **210**

**Additional Considerations:**
- Rise and fall delays may differ → compute 4 arrival times per vertex:
  - A_max(rise), A_max(fall), A_min(rise), A_min(fall)
- Slew must be propagated and stored at each vertex for downstream delay calculations

### 3.4 Required Time Computation

**Definition:** 
- **Setup Analysis (Late)**: Required time is the maximum time by which signal should arrive to avoid setup violation
- **Hold Analysis (Early)**: Required time is the minimum time after which signal should arrive to avoid hold violation

**Computation Formulas:**
For a vertex v_i with output vertices v_j:

$$R(i,setup) = \min(R(j,setup) - D(ij))$$
$$R(i,hold) = \max(R(j,hold) - D(ij))$$

**Computation Method:**
- **Backward traversal** of timing graph (from output ports to input ports)
- Required time at timing endpoints: specified/inferred from constraints (SDC file, clock period)
- A vertex is processed only when required times at all output vertices are known
- Can be computed in **one traversal** (reuses delay annotations from arrival time computation)

**Example Calculation:**
Given three output vertices from vertex v_i:
- Vertex 1: R_hold=10, R_setup=150, edge delay=10
- Vertex 2: R_hold=15, R_setup=120, edge delay=10
- Vertex 3: R_hold=20, R_setup=180, edge delay=10

Results at v_i:
- R_hold(i) = max(10-10, 15-10, 20-10) = max(0, 5, 10) = **10**
- R_setup(i) = min(150-10, 120-10, 180-10) = min(140, 110, 170) = **110**

**Why min/max operations?**
These operations ensure the most pessimistic (safest) timing requirements are met. If the minimum required time for setup is satisfied, all other paths automatically meet their requirements.

### 3.5 Slack Computation

**Setup Slack (Late Analysis):**
$$\text{Slack}_{setup} = RT_{setup} - AT_{max}$$

- Slack > 0: Setup constraint satisfied
- Slack < 0: **Setup violation** exists
- Slack represents margin by which arrival time can increase without causing violation

**Hold Slack (Early Analysis):**
$$\text{Slack}_{hold} = AT_{min} - RT_{hold}$$

- Slack > 0: Hold constraint satisfied  
- Slack < 0: **Hold violation** exists
- Slack represents margin by which arrival time can decrease without causing violation
![[slack-computation.png]]
---

## 4. Slew Propagation and Variations

### 4.1 Slew Propagation Fundamentals

**What is Slew?**
Slew quantifies how steeply or gently a signal transitions:
- **Steep transition** → Small slew
- **Gentle transition** → Large slew

**Why Propagate Slew?**
- Delay calculation for each stage requires knowledge of input slew
- Input slew at design ports specified by constraints
- Internal node slews must be computed and propagated through the circuit

**Challenge:**
Different combinational paths through a cell can produce different output slews. For example, a 3-input NAND gate has 3 timing arcs (A→Z, B→Z, C→Z), each potentially producing different output slews (e.g., 10ps, 15ps, 8ps).

Storing all possible slews would lead to exponential memory growth as signals propagate through multiple stages.

### 4.2 Monotonicity Property

**Key Property of CMOS Logic Gates:**
Delay and output slew are **monotonically non-decreasing functions** of input slew.

$$\text{If } S_{in,1} < S_{in,2} \text{ then } D_1 \leq D_2 \text{ and } S_{out,1} \leq S_{out,2}$$

**Implication:**
- Only need to store **minimum** and **maximum** slew bounds at each vertex
- Bounds on input slew → Bounds on delay and output slew
- Enables efficient computation while maintaining safety

### 4.3 Slew Propagation Formulas

For vertex $v_j$ with incoming vertices $v_i$ (i = 1 to n):

**Arrival Time Bounds:**
$$A_{j,min} = \min_i[A_{i,min} + D_{ij,min}]$$
$$A_{j,max} = \max_i[A_{i,max} + D_{ij,max}]$$

**Slew Bounds:**
$$S_{j,min} = \min_i[OS_{ij,min}]$$
$$S_{j,max} = \max_i[OS_{ij,max}]$$

Where:
- $D_{ij,min}$: Delay for edge (i,j) with minimum input slew $S_{i,min}$
- $D_{ij,max}$: Delay for edge (i,j) with maximum input slew $S_{i,max}$
- $OS_{ij,min}$: Output slew for edge (i,j) with input slew $S_{i,min}$
- $OS_{ij,max}$: Output slew for edge (i,j) with input slew $S_{i,max}$

**Edge Annotations:**
Each edge now stores:
- Two delay values (for min and max input slew)
- Two output slew values (for min and max input slew)

### 4.4 Graph-Based Analysis (GBA)

**Method:**
- Store only min/max slew bounds at each vertex
- Propagate arrival time using worst-case slew for delay calculation
- **Arrival time and slew may come from different paths**

**Example:**
Given vertices A and C feeding vertex Y:
- Vertex A: $A_{max}=100$, $S_{max}=20$ → Edge delay=50, output slew=10
- Vertex C: $A_{max}=20$, $S_{max}=40$ → Edge delay=80, output slew=30

At vertex Y:
- $A_{max}(Y) = \max(100+50, 20+80) = \max(150, 100) = 150$ (from path A→Y)
- $S_{max}(Y) = \max(10, 30) = 30$ (from path C→Y)

**Characteristics:**
- ✅ **Very efficient** - Only 2 slew values per vertex per transition type
- ✅ **Always safe** - Conservative/pessimistic analysis
- ❌ **May be pessimistic** - Arrival and slew from different paths simultaneously
- ❌ **Can report false violations**

### 4.5 Path-Based Analysis (PBA)

**Method:**
- Propagate arrival time and slew **along the same path**
- Compute delays for each complete path separately
- Take worst case across all paths

**Example (same circuit as GBA):**

Path 1 (A→Y→X):
- At Y: $A=150$, $S=10$ (both from path A→Y)
- At X: Using $S=10$ → delay=30, output slew=10
- Result: $A_{max}(X) = 150 + 30 = 180$, $S_{max}(X) = 10$

Path 2 (C→Y→X):
- At Y: $A=100$, $S=30$ (both from path C→Y)  
- At X: Using $S=30$ → delay=100, output slew=20
- Result: $A_{max}(X) = 100 + 100 = 200$, $S_{max}(X) = 20$

**Final Result:** $A_{max}(X) = \max(180, 200) = 200$

**Comparison:**
- GBA result: 250 (pessimistic)
- PBA result: 200 (accurate)
- **PBA removes 50ps of pessimism**

**Characteristics:**
- ✅ **More accurate** - Eliminates false violations
- ✅ **Tighter bounds** - Less pessimism
- ❌ **Computationally expensive** - Must analyze many paths
- **Usage:** Apply PBA only to paths failing GBA to remove false violations

### 4.6 Accounting for Variations

**Sources of Variation:**
- **Process (P)**: Fabrication variations (line thickness, transistor dimensions)
- **Voltage (V)**: Supply voltage fluctuations
- **Temperature (T)**: Operating temperature variations

**PVT variations** affect:
- Transistor characteristics
- Interconnect properties
- Delay and timing parameters

**Impact:** Timing constraints that pass nominally may fail after fabrication due to variations.

### 4.7 Techniques to Handle Variations

#### 4.7.1 Safety Margins
**Method:** Add timing margin to constraints

Example: If required time = 1000ps, apply margin of 100ps
- New constraint: Arrival time < 900ps instead of < 1000ps

**Usage:**
- Early design stages (logic synthesis) when layout unknown
- Large uncertainty → larger margins
- Reduce margins as design progresses
- Most margins eliminated in later stages

#### 4.7.2 Multimode Multi-Corner (MMMC) Analysis

**Purpose:** Account for **global variations** (affect all devices similarly)

**Three Dimensions of Scenarios:**

1. **PVT Corners** (Technology Libraries):
   - slow.lib (worst-case delay)
   - fast.lib (best-case delay)
   - typical.lib (nominal delay)

2. **Modes** (Constraint Files/SDC):
   - func.sdc (functional mode)
   - test.sdc (test mode)
   - sleep.sdc (low power mode)
   - turbo.sdc (high performance mode)
   - Differ in: clock frequencies, control signals, operating conditions

3. **RC Corners** (Parasitic Files/SPEF):
   - C_worst.spef (maximum capacitance)
   - C_best.spef (minimum capacitance)
   - RC_max.spef (maximum RC)
   - RC_min.spef (minimum RC)

**Example Scenario Calculation:**
- 3 PVT corners × 4 modes × 4 RC corners = **48 scenarios**

**MMMC Benefits:**
- Analyze all scenarios **simultaneously** (not sequentially)
- Avoid analyzing **dominated scenarios** (if one scenario is always worse)
- Enable **parallel processing**
- Much more efficient than 48 separate STA runs

**Effectiveness:** Best for global variations where all devices shift together

#### 4.7.3 On-Chip Variation (OCV) Derating

**Purpose:** Account for **local variations** (random device-to-device differences)

**Method:** Apply derating factors to nominal delays
$$D_{effective} = D_{nominal} \times \text{Derate Factor}$$

**Derating Factor Specifications:**
Can vary by:
- **Path type**: Early paths vs. Late paths
- **Path category**: Data paths vs. Clock paths
- **Delay type**: Gate delay vs. Interconnect delay

**Example Derating Factors:**
- Late paths: 1.1 (increase delay by 10%)
- Early paths: 0.9 (decrease delay by 10%)

**Setup Analysis Application:**
- **Data path** (late): Multiply by 1.1 (pessimistic - harder to meet)
- **Launch clock** (late): Multiply by 1.1
- **Capture clock** (early): Multiply by 0.9 (pessimistic - reduces required time)

**Hold Analysis Application:**
- **Data path** (early): Multiply by 0.9 (pessimistic - harder to meet)
- **Launch clock** (early): Multiply by 0.9  
- **Capture clock** (late): Multiply by 1.1 (pessimistic - increases required time)

**Example:**
Given: Late derate = 1.1, Early derate = 0.9

Setup analysis:
- AND gate on data path (nominal 100ps) → 110ps effective delay
- Inverter on capture clock (nominal 100ps) → 90ps effective delay
- Makes timing harder to meet (pessimistic/safe)

Hold analysis:
- Buffer on data path (nominal 100ps) → 90ps effective delay
- Inverter on capture clock (nominal 100ps) → 110ps effective delay
- Makes timing harder to meet (pessimistic/safe)

---

## 5. OpenSTA Tutorial Highlights (Lec31)

Inputs:
- Constraints (SDC)

Commands:

Observations:
- Arrival = input delay + path delay
- Required = period − output delay − uncertainty
- Slack decreases with higher input transition or output load
