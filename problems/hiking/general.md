---
id: prob014
slug: hiking
title: Hiking
subtitle: "Couples drive tents and equipment between waypoints and walk together to the next camp. A STRIPS benchmark from IPC 2014 testing coordinated transport with a strict sequential walking dependency."
proposers: ["University of Huddersfield (GIPO)"]
origin: "IPC 2014 (8th International Planning Competition)"
origin_year: 2014
last_updated: "2026-06-30"
category: Classical
tags: [Classical, Fully Observable, Deterministic, Single Agent, STRIPS, Typed PDDL]
languages: [PDDL 2.1]
ipc_editions: [IPC 2014]
complexity_summary: {existence: PSPACE-complete, optimal: PSPACE-complete}
---

## Description

A hiking trip is modelled as a sequence of places connected in a linear chain (next relation). Each couple must walk from their current place to the next, but can only do so if a tent is already pitched at the destination.

Cars can be driven between any two places (not just adjacent ones) by one person, optionally carrying a passenger or a folded-down tent. Before driving a tent it must be put down (folded); after arriving it must be put up (pitched) again. The couple walks together as a single action when both members are at the same place and the tent is up at the immediately next place.

The planner must coordinate: who drives the support vehicle forward to set up camp, who stays behind to walk, and in what order to shuttle equipment so that every couple reaches the final destination.

## History

The Hiking domain was originally generated using GIPO (a knowledge-engineering tool) at the University of Huddersfield, copyright 2001, and appeared as a benchmark at IPC 2014. Its appeal is deceptive simplicity: the walk_together action has an asymmetric dependency on tent position and order, which makes relaxed-plan heuristics behave poorly when the tent needs to be transported non-adjacently ahead of the walkers. It exercises goal-ordering and serialisation reasoning that standard FF-style relaxations miss.

## Variants

- [Base Formulation — STRIPS + Equality (IPC 2014)](#domain-base)

The IPC 2014 formulation is the canonical version. Temporal extensions with durative drive and walk actions exist in the research literature.

## Complexity

| Problem | Qualifier | Result | Class |
|---|---|---|---|
| Plan existence | propositional STRIPS | PSPACE-complete | hard |
| Optimal plan length | k couples, m places | PSPACE-complete | hard |
| Satisficing plan | sequential shuttle strategy | P | easy |
