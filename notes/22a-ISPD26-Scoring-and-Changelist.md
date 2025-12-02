# ISPD26 Scoring and Changelist

Summarizes scoring formulas and exact output requirements (Verilog/DEF/changelist) for submissions.

## Scoring components (subject to contest weights)

- PPA score: S_PPA = w_tns*ΔTNS + w_dpower*Δdpower + w_lpower*Δlpower
- ERC penalty: P_ERC = w_slew*ΔSlew + w_cap*ΔCap + w_fanout*ΔFanout (normalized vs baseline)
- Runtime: R = w_tool*R_tool + w_flow*R_flow
- Displacement penalty: P_dis based on average Manhattan displacement
- Overflow penalties: P_overflow = w_max*P_max + w_total*P_total
- Final score: S_final = C_HC * (S_PPA − P_ERC − R − P_dis − P_overflow), where C_HC=1 if all hard constraints pass; else 0.

## Hard constraints

- Placement legality via checkPlacement
- Logical equivalence (LEC)
- No floorplan perturbation; stitch into provided PDN floorplan

## Changelist format

- Sizing:
  - size_cell <x, y>
  - New variant must exist in .lib/.lef and be function-equivalent
  - <x, y> is location of resized instance
- Buffering:
  - insert_repeater <x, y>
  - Cell must exist in library
  - DEF updated to place at <x, y>
  - Include driver pin name and list of load pin names

## Consistency requirements

- Net names preserved; new nets/instances follow OpenROAD naming (Resizer::makeUniqueNetName/InstName)
- .v, .def, and .changelist must match exactly

## Consistency example (illustrative)

- Changelist:
  - insert_repeater 1200 340 (driver: U123/A, loads: U200/B U201/B)
- Verilog:
  - New instance RPT_0001 of BUFX2; net N1 split into N1_DRV→RPT_0001 and RPT_0001→{U200/U201}
- DEF:
  - COMPONENT RPT_0001 PLACED (1200 340) N; NETS updated with segments to new pins; names match changelist.

## Submission

- Build on provided Docker/Singularity; run.sh must produce <design>.def, <design>.v, <design>.changelist in <output_dir>.
 - Determinism & runtime: fix random seeds; cap iterations; report tool and flow runtimes to match scoring metrics.
