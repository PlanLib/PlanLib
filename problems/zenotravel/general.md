---
id: prob011
slug: zenotravel
title: Zenotravel
subtitle: "Aircraft transport passengers between cities at two speed levels, consuming fuel at different rates. An IPC 2002 benchmark combining location-based routing with numeric resource management."
proposers: ["IPC 2002 Organizers"]
origin: "IPC 2002 (3rd International Planning Competition)"
origin_year: 2002
last_updated: "2026-06-30"
category: Classical
tags: [Classical, Fully Observable, Deterministic, Single Agent, Typed PDDL, Resource Management, Transportation]
languages: [PDDL 2.1]
ipc_editions: [IPC 2002]
complexity_summary: {existence: PSPACE-complete, optimal: PSPACE-complete}
---

## Description

A fleet of aircraft and a set of passengers occupy cities connected by a fully-connected route network. Each aircraft has a fuel tank, a passenger capacity limit (zoom-limit), and per-aircraft slow-burn and fast-burn coefficients. Passengers board and disembark at the aircraft's current city. An aircraft can fly between any two cities in one of two modes: slow (higher fuel efficiency, no capacity restriction) or fast (lower efficiency but valid only when the passenger load does not exceed zoom-limit). A refuel action instantly tops up a tank to full capacity.

The goal specifies target city locations for each person. The planner must schedule boarding, flight, and disembarkation actions while respecting fuel constraints (flights require ≥ distance × burn-rate fuel) and the zoom capacity limit on fast flights.

## History

Zenotravel was introduced at IPC 2002 as one of the five numeric domains testing PDDL 2.1 numeric fluents. The name is whimsical — "Zeno" alludes to Zeno's paradox and the challenge of achieving a goal through a sequence of increasingly refined steps. The domain deliberately mixes routing (which city?) with resource scheduling (slow or fast?) and load management (how many passengers on board?), making it harder for planners that rely on relaxed planning graphs or delete-relaxation heuristics.

## Variants

- [Base Formulation (IPC 2002)](#domain-base)
- Temporal Zenotravel (durative flights with timed fuel consumption)

The standard IPC 2002 domain is purely numeric (no temporal features). A temporal extension exists where flight durations depend on distance and speed, requiring planners to schedule concurrent boarding and flight operations.

## Complexity

| Problem | Qualifier | Result | Class |
|---|---|---|---|
| Plan existence | classical routing | PSPACE-complete | hard |
| Optimal plan length | fuel-constrained routing | PSPACE-complete | hard |
| Satisficing plan | greedy per-person routing | P | easy |
