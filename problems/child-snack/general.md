---
id: prob012
slug: child-snack
title: Child Snack
subtitle: "Sandwiches are assembled in a kitchen and distributed on trays to children waiting at tables, respecting individual gluten-allergy constraints. A resource-distribution benchmark from IPC 2014."
proposers: ["Raquel Fuentetaja", "Tomás de la Rosa"]
origin: "IPC 2014 (8th International Planning Competition)"
origin_year: 2013
last_updated: "2026-06-30"
category: Classical
tags: [Classical, Fully Observable, Deterministic, Single Agent, Typed PDDL, STRIPS]
languages: [PDDL 2.1]
ipc_editions: [IPC 2014]
complexity_summary: {existence: P, optimal: unknown}
---

## Description

A kitchen constant is defined as the preparation area. Bread portions and content portions are available at the kitchen. Some children are allergic to gluten; others are not. Sandwiches must be assembled from one bread portion and one content portion. If a child is allergic to gluten, their sandwich must be made from gluten-free bread and gluten-free content.

A tray starts at the kitchen. Sandwiches are loaded onto the tray, the tray is moved to the table where children are waiting, and each sandwich is served to one child. A sandwich can only be served to the correct allergy-class child. The tray can move freely between the kitchen and any table.

## History

Child Snack was introduced at IPC 2014 by Raquel Fuentetaja and Tomás de la Rosa as a satisficing planning benchmark. Its significance lies in the conditional structure: the gluten constraint creates two classes of objects (allergic/non-allergic, gluten-free/regular ingredients) that interact, requiring planners to match resources to consumers under a type-consistency constraint. Despite its small ground instance size, the domain scales by increasing the number of children, tables, and available portions, creating problems with combinatorial matching structure.

## Variants

- [Base Formulation — STRIPS (IPC 2014)](#domain-base)
- Child Snack with action costs (penalising tray moves)

The IPC 2014 formulation is purely satisficing (no cost metric). Research extensions add tray-move costs or multiple trays.

## Complexity

| Problem | Qualifier | Result | Class |
|---|---|---|---|
| Plan existence | matching bread+content to children | P | easy |
| Optimal plan | minimise tray moves | NP-hard | hard |
| Satisficing plan | greedy per-child sandwich assignment | P | easy |
