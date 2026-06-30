---
title: "Base Formulation — ADL + Action Costs (IPC 2006)"
language: PDDL 2.1
source: IPC06Archive
viewpoint_group: adl-costs
viewpoint_title: "ADL + Action Costs"
notes: "IPC 2006 sequential-optimal formulation. Uses ADL universal quantification in preconditions to express 'all orders for product p have started' and 'all products in order o have been made'. Stack count is propositionalised via a count type with next-count successor predicates (similar to capacity-predecessor in Transport). Opening a new stack is the only action with cost; all other actions are free."
instances_description: "Instances parameterised by number of orders (n) and products (m). The number of products per order and maximum stacks varies."
generator_note: "IPC 2006 instances: https://github.com/potassco/pddl-instances/tree/master/ipc-2006/domains/openstacks-sequential-optimal-adl"
---

## State Space

A state records: the status of each order (waiting / started / shipped), whether each product has been made, and the current number of available stacks (stacks-avail). The challenge lies in ordering the make-product and ship-order actions to minimise total stack openings.

## Types

| name | parent |
|---|---|
| order | object |
| product | object |
| count | object |

## Predicates

| name | desc |
|---|---|
| includes(?o - order, ?p - product) | order ?o requires product ?p (static) |
| waiting(?o - order) | order ?o has not yet been started |
| started(?o - order) | order ?o is open (occupying a stack) |
| shipped(?o - order) | order ?o has been completed and shipped |
| made(?p - product) | product ?p has been manufactured |
| stacks-avail(?s - count) | ?s is the current number of available stacks |
| next-count(?s - count, ?ns - count) | ?ns is one more than ?s (static) |

## Functions

| name | desc |
|---|---|
| total-cost | accumulated number of new-stack openings |

## Actions

#### make-product(?p - product) — Manufacture a product
```
preconditions: ¬made(p) ∧ ∀o: includes(o,p) → started(o)
add effects:   made(p)
del effects:   –
cost:          0
```

#### start-order(?o - order, ?avail - count, ?new-avail - count) — Open an order (consume one stack)
```
preconditions: waiting(o) ∧ stacks-avail(avail) ∧ next-count(new-avail, avail)
add effects:   started(o), stacks-avail(new-avail)
del effects:   waiting(o), stacks-avail(avail)
cost:          0
```

#### ship-order(?o - order, ?avail - count, ?new-avail - count) — Ship a completed order (free one stack)
```
preconditions: started(o) ∧ (∀p: includes(o,p) → made(p)) ∧ stacks-avail(avail) ∧ next-count(avail, new-avail)
add effects:   shipped(o), stacks-avail(new-avail)
del effects:   started(o), stacks-avail(avail)
cost:          0
```

#### open-new-stack(?open - count, ?new-open - count) — Expand available stacks by one
```
preconditions: stacks-avail(open) ∧ next-count(open, new-open)
add effects:   stacks-avail(new-open)
del effects:   stacks-avail(open)
cost:          1
```

## Goal

All orders satisfy `shipped`.

## Instances

| name | n | k* | status | source | file |
|---|---|---|---|---|---|
| instance-01 | 2 | - | optimal | IPC06Archive | instances/instance-01.pddl |
