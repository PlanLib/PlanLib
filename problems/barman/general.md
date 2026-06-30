---
id: prob006
slug: barman
title: Barman
subtitle: "A two-handed robot bartender mixes cocktails: it grasps shot glasses and a shaker, fills shots from dispensers, pours ingredients into the shaker in the right order, shakes, and serves. A benchmark for sequential manipulation planning with ordering constraints."
proposers: ["Sergio Jiménez", "Anders Jonsson", "IPC 2014 Organizers"]
origin: "IPC 2014 (8th International Planning Competition)"
origin_year: 2014
last_updated: "2026-06-30"
category: Classical
tags: [Classical, Fully Observable, Deterministic, Single Agent, Typed PDDL, Manipulation, Action Costs]
languages: [PDDL 2.1]
ipc_editions: [IPC 2014]
complexity_summary: {existence: P, optimal: NP-hard}
---

## Description

A robotic bartender has two hands and access to a set of shot glasses, a cocktail shaker, and ingredient dispensers. Each cocktail requires exactly two ingredients to be combined in the shaker and shaken together. The bartender must: grasp and fill shot glasses from the appropriate dispenser; pour the filled shots into the shaker in the correct combination; shake; and pour the result into clean shot glasses for serving.

Cleaning and filling constraints interact: a shot glass must be clean before it can be filled with a new ingredient (unless it already holds that same ingredient); the shaker must be empty and clean to start a new cocktail or must already be unshaked for a second ingredient pour. The total cost objective minimises the number of actions, with fills costing 10 and all other actions costing 1.

## History

Barman was introduced at IPC 2014 as a benchmark for sequential optimal planning under complex procedural constraints. Its appeal lies in the tight interleaving of container management (clean/fill/empty cycles) with cocktail logic (ingredient ordering, shaking). Planners must discover that optimal solutions often reuse containers across multiple cocktails, requiring nontrivial ordering of cleaning and filling steps.

## Variants

- [Base Formulation — STRIPS + action costs (IPC 2014)](#domain-base)
- Barman-multidimensional (additional ingredient types and larger cocktail menus)

The IPC 2014 domain is the canonical formulation. Extended variants with more than two ingredients per cocktail or multiple shakers have appeared in subsequent research but are not standard benchmarks.

## Complexity

| Problem | Qualifier | Result | Class |
|---|---|---|---|
| Plan existence | propositional STRIPS | P | easy |
| Optimal plan length | minimum action cost | NP-hard | hard |
| Satisficing plan | sequential per-cocktail scheduling | P | easy |
