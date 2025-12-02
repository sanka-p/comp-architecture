# Lec05 — Tutorial: Unix Commands (WSL setup)

## Overview
- Quick setup of Unix environment on Windows using WSL.
- Essential shell commands for navigation, file management, processes, disk usage.

## Core concepts
- WSL install: run as Administrator; prompts for username/password; Ubuntu image.
- Filesystem and navigation: pwd, ls, cd; directory creation with mkdir.
- File ops: mv (move/rename), cp (copy), touch (create), rm (remove), cat (view contents).
- Command discovery: which (executable path), man (manual pages).
- Privileged ops: sudo for admin tasks (e.g., apt‑get update).
- Disk usage: du (per folder), df (filesystem free space), -h for human‑readable.
- Processes: ps (list), top (live view).
- Jobs: jobs (list), bg (background), fg (foreground), Ctrl+Z to suspend; job specifiers like %1.
- History: history lists prior commands; whoami shows current user.

## Methods/flows
- WSL install: wsl -install → reboot → set user → use Ubuntu terminal.
- Update packages: sudo apt-get update.
- Typical workflow: navigate with cd/ls; create dirs/files; manage processes; inspect disk.

## Constraints/assumptions
- Requires Administrator PowerShell to install WSL.
- Sudo prompts for the WSL user’s password.

## Examples
- Move a file into a new directory: mkdir tutorial1; mv unix_commands tutorial1.
- Create and remove a file: touch d.txt; rm d.txt.

## Tools/commands
- PowerShell: wsl -install.
- Ubuntu/WSL: pwd, ls, cd, mkdir, mv, cp, touch, rm, cat, which, man, sudo, apt‑get, du, df, ps, top, jobs, bg, fg, history, whoami.

## Common pitfalls
- Forgetting sudo for admin tasks → permission denied.
- Misusing rm on directories without -r.
- Losing foreground control of jobs; use fg to reattach.

## Key takeaways
- WSL provides a convenient Unix environment on Windows.
- Master core shell commands for daily VLSI workflows and automation.
- Use man/which to discover and understand commands.
- Monitor processes and disk to avoid resource issues during EDA runs.

[Figure: WSL setup (summary)]
- Shows Windows → WSL → Ubuntu terminal flow; admin install then user login.

Cross‑links: See Lec10: Scripting for automation; See Lec32: Verification flows (running sims); See Lec40: Physical design runs (disk/process).
