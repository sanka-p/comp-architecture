# Lec10 — Tutorial: Introduction to TCL

## Overview
- TCL (Tool Command Language) is a scripting language for EDA tool automation, customization, and integration.
- Supports variables, control flow, procedures, file I/O, and system command execution.

## Core concepts
- Variables: `set varName value`; access with `$varName`.
- Lists: `{elem1 elem2 …}`; iterate with `foreach`, modify with `lset`.
- Control flow: `if`, `foreach`, `while`, `continue`, `break` (similar to C/Python).
- Square brackets `[]`: evaluate first; enables command substitution (e.g., `[expr {…}]`).
- Procedures: `proc name {args} { body }`; `return` exits.
- File I/O: `open`, `close`, `read`, `puts`.
- System commands: `exec` runs shell commands (e.g., `exec ls`).
- Expression evaluation: `expr {…}` for math/logic.

## Methods/flows
- Iterate over list, modify elements conditionally, print results.
- Open file, read/write, close channel.
- Define reusable procedures for common tasks.
- Execute system commands to integrate with shell environment.

## Constraints/assumptions
- TCL files saved as `.tcl`; run with `tclsh script.tcl`.
- `[]` always evaluated first; use `{}` to defer evaluation.

## Examples
- Ex1: `foreach` loop negates even elements in list; uses `lset`, `expr`.
- Ex2: Open file in `w+` (write/truncate/create), write "test", reopen in `r`, read, print.
- Ex3: Procedure `printSumProduct` computes and prints sum/product; `return` prevents subsequent lines.
- Ex4: `exec ls` and `exec pwd` to run Unix commands from TCL.

## Tools/commands
- `tclsh`: TCL shell interpreter.
- Commands: `set`, `foreach`, `lset`, `if`, `incr`, `puts`, `expr`, `proc`, `return`, `open`, `close`, `read`, `exec`.
- TCL manual for full reference.

## Common pitfalls
- Forgetting `$` when accessing variable value.
- Misunderstanding `[]` vs `{}` evaluation order.
- Not closing file channels → resource leaks.
- Confusing `puts` without channel (stdout) vs with channel (file).

## Key takeaways
- TCL automates EDA tasks: batch processing, constraint generation, report parsing.
- `set`/`$` for variables; `[]` for command substitution; `{}` for grouping.
- `foreach` + `lset` for list manipulation; `expr` for arithmetic/logic.
- `proc` for reusable code; `open`/`read`/`puts`/`close` for files.
- `exec` bridges TCL and shell; enables integration with Unix tools.
- Master TCL to script synthesis, placement, STA, DRC flows efficiently.

[Figure: TCL scripting workflow (summary)]
- Shows EDA tool → TCL script → automate tasks (constraints, reports, batch runs).

Cross‑links: See Lec05: Unix commands; See Lec22: Scripting synthesis flows; See Lec28: STA scripting; See Lec40: Physical design automation.
