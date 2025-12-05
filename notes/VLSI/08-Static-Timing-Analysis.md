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
### 3.2 Stage Model

- Driver cell + interconnect + receivers
- Delay calculator uses .lib tables (NLDM/CCS), SPEF RC, input slew → outputs edge delay and output slew

### 3.3 Arrival and Required Times

- Arrival (forward): A_j = max(A_i + D_ij)
- Required (backward): R_i = min(R_j - D_ij) for setup; max for hold

---

## 4. Slew Propagation and Variations (Lec30)

- Monotonicity: ↑ input slew → ↑ delay, ↑ output slew

#### GBA (Graph-Based Analysis)
- Fast, safe; pessimistic (arrival and slew may come from different paths)
#### PBA (Path-Based Analysis)
- Propagate arrival and slew along same path
- Accurate, expensive; use on failing GBA paths to remove false violations

- OCV: On-chip variation derating (local variations)
  - Setup (late): data/clock-launch derate > 1, clock-capture derate < 1
  - Hold (early): data/clock-launch derate < 1, clock-capture derate > 1
---

## 5. OpenSTA Tutorial Highlights (Lec31)

Inputs:
- Constraints (SDC)

Commands:

Observations:
- Arrival = input delay + path delay
- Required = period − output delay − uncertainty
- Slack decreases with higher input transition or output load
