---
id: prob016
slug: woodworking
title: Woodworking
subtitle: "Parts must be cut from raw boards and finished through sequences of grinding, planing, and varnishing on specialised machines. A process-planning benchmark from IPC 2011."
proposers: ["IPC 2011 Organizers"]
origin: "IPC 2011 (7th International Planning Competition)"
origin_year: 2011
last_updated: "2026-06-30"
category: Classical
tags: [Classical, Fully Observable, Deterministic, Single Agent, Typed PDDL, Action Costs]
languages: [PDDL 2.1]
ipc_editions: [IPC 2011]
complexity_summary: {existence: P, optimal: NP-hard}
---

## Description

A woodworking factory has a set of machines: high-speed saws and saws (for cutting), grinders, planers, immersion varnishers, spray varnishers, and glazers. Raw boards of known wood type, size, and surface condition are available. Each board can be cut into small, medium, or large parts. Parts must be finished to meet goal specifications for wood type, colour, and treatment.

The finishing pipeline is constrained: varnishing (immersion or spray) requires a smooth or very-smooth surface and the part to be untreated; glazing requires only untreated but no smoothness constraint, and sets treatment to glazed; grinding requires a smooth surface, sets treatment to verysmooth, and resets colour to natural; planing resets surface to smooth, treatment to untreated, and colour to natural. Each action has an associated cost (load-highspeed-saw: 30, do-saw: 30, cut-board: 10, unload-highspeed-saw: 10, immersion-varnish: 10, plane/grind/spray-varnish/glaze: per-part variable). The objective minimises total manufacturing cost.

## History

Woodworking was introduced at IPC 2011 as a process-planning benchmark requiring planners to reason about multi-step transformation pipelines. Its complexity arises from the large number of machine types, the per-part cost functions, and the need to select efficient machine sequences (e.g., immersion varnish has a fixed cost of 10 while spray varnish has a per-part variable cost, so the cheapest finishing path depends on instance parameters). The domain is rich in constants (surface types, treatment states, colours, sizes) and uses typed constants to keep the domain compact.

## Variants

- [Base Formulation — STRIPS + Action Costs (IPC 2011)](#domain-base)

The IPC 2011 formulation is the standard benchmark. Research extensions include temporal versions with machine occupation times and stochastic versions with uncertain surface outcomes.

## Complexity

| Problem | Qualifier | Result | Class |
|---|---|---|---|
| Plan existence | feasible finishing sequence exists | P | easy |
| Optimal cost | machine selection + sequencing | NP-hard | hard |
| Satisficing plan | per-part greedy machine selection | P | easy |
