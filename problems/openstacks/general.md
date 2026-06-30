---
id: prob015
slug: openstacks
title: Openstacks
subtitle: "Orders for sets of products must be shipped in a sequence that never exceeds a limited number of simultaneously open stacks. A manufacturing-scheduling benchmark from IPC 2006–2011."
proposers: ["IPC 2006 Organizers"]
origin: "IPC 2006 (5th International Planning Competition)"
origin_year: 2006
last_updated: "2026-06-30"
category: Classical
tags: [Classical, Fully Observable, Deterministic, Single Agent, Typed PDDL, Action Costs]
languages: [PDDL 2.1]
ipc_editions: [IPC 2006, IPC 2008, IPC 2011]
complexity_summary: {existence: P, optimal: NP-hard}
---

## Description

A factory receives a set of orders, each requiring one or more products. Products are manufactured one at a time. An order can only be shipped once all products it includes have been made. While an order is active (started but not yet shipped) it occupies one stack. The factory initially has zero available stacks; each stack must be explicitly opened at a cost of one unit. The objective is to minimise the total number of stack openings.

The planner must find a sequencing of make, start-order, and ship-order actions that minimises total stack-opening cost. The challenge is that each product may appear in multiple orders, so the sequencing of product manufacturing determines which orders can be opened and closed simultaneously.

## History

Openstacks was introduced at IPC 2006 as a domain blending scheduling and classical planning. It models the open-stacks minimisation problem (OSP), a combinatorial optimisation problem from manufacturing scheduling that is NP-hard. The domain is notable for using ADL universal quantification (forall in preconditions) to express the condition "all orders that include product p have been started". It reappeared at IPC 2008 and IPC 2011 and is widely used to evaluate planners on problems where goal serialisation matters.

## Variants

- [Base Formulation — ADL + Action Costs (IPC 2006)](#domain-base)
- STRIPS encoding (propositionalised forall via order–product pairs)

The canonical formulation uses ADL. A STRIPS encoding exists that propositionalises the universal precondition into per-pair waiting predicates, at the cost of a larger grounded instance.

## Complexity

| Problem | Qualifier | Result | Class |
|---|---|---|---|
| Plan existence | any sequencing that ships all orders | P | easy |
| Optimal stack cost | open-stacks minimisation | NP-hard | hard |
| Satisficing plan | make all products in arbitrary order | P | easy |
