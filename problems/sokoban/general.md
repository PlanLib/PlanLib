---
id: prob009
slug: sokoban
title: Sokoban
subtitle: "A warehouse keeper pushes stones to goal positions on a grid; stones can only be pushed (never pulled) and must not be cornered. The classic puzzle benchmark for optimal planning."
proposers: ["Hiroyuki Imabayashi"]
origin: "Thinking Rabbit Inc., 1982"
origin_year: 1982
last_updated: "2026-06-30"
category: Classical
tags: [Classical, Fully Observable, Deterministic, Single Agent, STRIPS, Action Costs, Puzzle]
languages: [PDDL 2.1]
ipc_editions: [IPC 2008, IPC 2011]
complexity_summary: {existence: PSPACE-complete, optimal: PSPACE-complete}
---

## Description

A player (warehouse keeper) occupies a grid; some cells contain stones that must be pushed to marked goal cells. The player can move freely to adjacent empty cells. To push a stone, the player must be directly behind it relative to the target direction, and the cell on the far side of the stone must be clear. Stones can be pushed but never pulled, so reversing a bad push may require an elaborate sequence of manoeuvres or may be entirely impossible (deadlocks).

The planning domain models the grid explicitly as a set of location objects with directional move predicates. Cells are either goal locations, non-goal locations, or blocked. The action cost of each push is 1, and the goal minimises total push count.

## History

Sokoban was designed by Hiroyuki Imabayashi and published by Thinking Rabbit in 1982. It became one of the first video-game puzzles studied rigorously in computational complexity theory: Culberson (1997) proved that determining solvability is PSPACE-complete. The domain was introduced to IPC at the 2008 competition as a cost-optimal STRIPS benchmark, and it has since been used extensively to evaluate the quality of pattern databases and domain-specific heuristics designed to detect deadlocks.

## Variants

- [Base Formulation — STRIPS + action costs (IPC 2008)](#domain-base)
- Sokoban with deadlock detection preprocessing

The IPC formulation splits pushes into push-to-goal and push-to-nongoal actions to avoid recomputing the at-goal status of stones during search. No numeric fluents are needed; the model is pure propositional STRIPS with action costs.

## Complexity

| Problem | Qualifier | Result | Class |
|---|---|---|---|
| Plan existence | general grid, multiple stones | PSPACE-complete | hard |
| Optimal plan length | minimum pushes | PSPACE-complete | hard |
| Satisficing plan | deadlock avoidance needed | hard | hard |
