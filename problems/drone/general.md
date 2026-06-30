---
id: prob013
slug: drone
title: Drone
subtitle: "A battery-powered UAV navigates a 3-D integer grid to visit a set of target locations, returning to the origin to recharge as needed. A benchmark for numeric and bounded-integer planning."
proposers: ["Enrico Scala"]
origin: "Numeric planning research (Enrico Scala)"
origin_year: 2018
last_updated: "2026-06-30"
category: Classical
tags: [Classical, Fully Observable, Deterministic, Single Agent, Typed PDDL, Resource Management]
languages: [PDDL 2.1, PDDL-XTS]
ipc_editions: []
complexity_summary: {existence: PSPACE-complete, optimal: PSPACE-complete}
---

## Description

A UAV starts at the origin (0, 0, 0) of a 3-D integer grid. A set of target locations is given, each described by exact (x, y, z) coordinates. Each movement step (±1 along any axis) and each visit action costs one unit of battery. The battery has a fixed maximum charge; when it runs low the drone must return to the origin to recharge fully. The goal is to visit all targets and return home.

The planner must decide on the order of visits and when to return for recharges, balancing tour length against battery capacity. Short round-trips to nearby targets may be more efficient than one long tour that exceeds battery range.

## History

The Drone domain was developed by Enrico Scala as a test-bed for numeric planning research. It demonstrates a key challenge in numeric planning: managing a resource (battery) that is depleted by every action, with a non-monotone recharge action. The domain has been used in research on numeric planning heuristics. The PDDL-XTS formulation replaces the seven static boundary fluents and the battery-level-full constant with bounded integer types, yielding a more compact representation with no spurious numeric state.

## Variants

- [Numeric Formulation (PDDL 2.1)](#domain-numeric)
- [Extended Data Structures (PDDL-XTS)](#domain-extended-data-structures)

The base PDDL 2.1 formulation stores grid bounds as numeric fluents (min_x, max_x, etc.) which are static throughout planning. The PDDL-XTS formulation replaces these with type bounds on bounded integers, eliminating 7 static functions and making bounds a type-level invariant rather than a precondition check.

## Complexity

| Problem | Qualifier | Result | Class |
|---|---|---|---|
| Plan existence | with sufficient battery | PSPACE-complete | hard |
| Optimal visit order | TSP-like with recharges | PSPACE-complete | hard |
| Satisficing plan | greedy nearest-neighbour with recharge | P | easy |
