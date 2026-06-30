---
id: prob010
slug: transport
title: Transport
subtitle: "Vehicles with limited capacity drive along a road network to pick up and deliver packages to specified destinations, minimising total travel and handling cost. A core benchmark from IPC 2008–2014."
proposers: ["Štěpán Šimáček", "IPC 2008 Organizers"]
origin: "IPC 2008 (6th International Planning Competition)"
origin_year: 2008
last_updated: "2026-06-30"
category: Classical
tags: [Classical, Fully Observable, Deterministic, Single Agent, Typed PDDL, Transportation, Action Costs]
languages: [PDDL 2.1, PDDL-XTS]
ipc_editions: [IPC 2008, IPC 2011, IPC 2014]
complexity_summary: {existence: P, optimal: NP-hard}
---

## Description

A directed road network connects a set of locations. Vehicles sit at locations and each has a fixed integer carrying capacity measured in package slots. Packages start at various locations and must be delivered to designated destinations. A vehicle can drive along any road in one step (at a cost equal to the road length), pick up a package at its current location (costing 1, consuming one capacity slot), or drop a package at its current location (costing 1, freeing one slot). The objective is to deliver all packages while minimising total action cost.

Capacity is encoded propositionally via a `capacity-predecessor` chain: each vehicle starts at some capacity level, and pick-up/drop transitions along the chain. This avoids explicit numeric arithmetic while still modelling integral capacity constraints.

## History

Transport was introduced at IPC 2008 as a cost-optimal benchmark replacing the older Logistics domain for the optimisation track. Unlike Logistics (which has no action costs), Transport requires planners to minimise a weighted combination of travel distance and loading/unloading steps. It reappeared at IPC 2011 and IPC 2014, becoming one of the most used domains in the optimal planning literature for testing cost-based heuristics (LM-cut, h^max, landmark heuristics).

## Variants

- [Base Formulation — STRIPS + action costs](#domain-base)
- [Extended Data Structures (PDDL-XTS)](#domain-extended-data-structures)
- Temporal Transport (durative drive and load actions)

The base domain encodes capacity propositionally via predecessor chains. The PDDL-XTS variant replaces per-package location predicates with per-location and per-vehicle set fluents and uses a bounded-integer capacity, giving a more compact and semantically transparent formulation.

## Complexity

| Problem | Qualifier | Result | Class |
|---|---|---|---|
| Plan existence | single vehicle, no capacity | P | easy |
| Optimal plan length | multiple vehicles, capacity-constrained | NP-hard | hard |
| Satisficing plan | greedy per-package routing | P | easy |
