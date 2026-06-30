---
id: prob008
slug: rover
title: Rover
subtitle: "A team of planetary rovers must navigate a waypoint graph, collect soil and rock samples, take calibrated images, and relay all results to a fixed lander. A flagship resource-management benchmark from IPC 2002."
proposers: ["Maria Fox", "Derek Long", "John Bresina"]
origin: "IPC 2002 (3rd International Planning Competition)"
origin_year: 2002
last_updated: "2026-06-30"
category: Classical
tags: [Classical, Fully Observable, Deterministic, Single Agent, Typed PDDL, Resource Management]
languages: [PDDL 2.1, PDDL-XTS]
ipc_editions: [IPC 2002, IPC 2004, IPC 2006]
complexity_summary: {existence: PSPACE-complete, optimal: PSPACE-complete}
---

## Description

One or more planetary rovers operate on a terrain modelled as a directed waypoint graph. Each rover carries specialised equipment: soil-analysis gear, rock-analysis gear, imaging cameras, and an on-board sample store. Waypoints may hold soil or rock samples; objectives (scientific targets) are photographable from designated waypoints. A fixed lander sits at a known waypoint and can receive radio transmissions.

To complete a mission the planner must: navigate rovers across traversable edges while tracking energy consumption; collect soil and rock samples (using the on-board store as a buffer); calibrate cameras against designated objectives; capture images in required modes; and communicate all acquired data back to the lander before the energy budget is exhausted. Each navigation, sampling, calibration, and communication step deducts a fixed energy cost; a recharge action (only available at sunlit waypoints) partially restores energy.

## History

The Rover domain was motivated by NASA's Mars Exploration Rover (MER) missions and the planned Mars Science Laboratory (MSL) mission. It was designed by Maria Fox and Derek Long for IPC 2002, where it challenged planners with coupled resource constraints (energy) and multi-step sensing sequences (navigate → calibrate → take_image → communicate). Rover returned at IPC 2004 with a pure numeric extension separating energy management from the classical structure, and at IPC 2006 in a temporal version with durative navigation and observation actions.

## Variants

- [Numeric Formulation (IPC 2002)](#domain-numeric)
- [Extended Data Structures (PDDL-XTS)](#domain-extended-data-structures)
- Temporal Rover (durative actions, IPC 2006)

The base IPC 2002 domain already uses PDDL 2.1 numeric fluents for energy. The PDDL-XTS variant replaces the four binary per-rover tracking predicates with set fluents and bounds the energy variable as a bounded integer, eliminating one source of infinite numeric state.

## Complexity

| Problem | Qualifier | Result | Class |
|---|---|---|---|
| Plan existence | propositional abstraction | PSPACE-complete | hard |
| Optimal plan length | energy-bounded traversal | PSPACE-complete | hard |
| Satisficing plan | sequential per-goal scheduling | P | easy |
