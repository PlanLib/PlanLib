---
title: "Base Formulation — STRIPS + action costs (IPC 2008)"
language: PDDL 2.1
source: IPC08Archive
viewpoint_group: strips-costs
viewpoint_title: "STRIPS + Action Costs"
notes: "IPC 2008 sequential-optimal formulation. Capacity is encoded propositionally via a capacity-predecessor chain: capacity(?v, ?s1) means the vehicle currently has ?s1 free slots; pick-up transitions to the predecessor of ?s1, drop transitions to the successor. Road lengths are numeric functions; the metric minimises total-cost (sum of road-length per drive plus 1 per pick-up/drop)."
instances_description: "Instances parameterised by number of vehicles (v), locations (l), packages (p), and road density. Capacity levels range from 1 to 4 in standard benchmarks."
generator_note: "IPC 2008–2014 instances: https://github.com/potassco/pddl-instances/tree/master/ipc-2008/domains/transport-sequential-optimal"
---

## State Space

A state records the location of each vehicle (`at(?v,?l)`), the location of each package (either `at(?p,?l)` at a location or `in(?p,?v)` in a vehicle), and the current capacity token of each vehicle (`capacity(?v,?s)`). The `road-length` function is static. The state space is finite; its size is dominated by the exponential number of package placements and vehicle locations.

## Types

| name | parent |
|---|---|
| location | object |
| target | object |
| locatable | object |
| vehicle | locatable |
| package | locatable |
| capacity-number | object |

## Predicates

| name | desc |
|---|---|
| road(?l1 - location, ?l2 - location) | a road connects ?l1 to ?l2 (static) |
| at(?x - locatable, ?v - location) | vehicle or package ?x is at location ?v |
| in(?x - package, ?v - vehicle) | package ?x is loaded in vehicle ?v |
| capacity(?v - vehicle, ?s1 - capacity-number) | vehicle ?v currently has free-slot level ?s1 |
| capacity-predecessor(?s1 ?s2 - capacity-number) | ?s1 is one slot fewer than ?s2 (static chain) |

## Actions

#### drive(?v - vehicle, ?l1 - location, ?l2 - location) — Drive vehicle along a road
```
preconditions: at(v,l1) ∧ road(l1,l2)
add effects:   at(v,l2)
del effects:   at(v,l1)
cost:          road-length(l1,l2)
```

#### pick-up(?v - vehicle, ?l - location, ?p - package, ?s1 - capacity-number, ?s2 - capacity-number) — Load package; decrements capacity token
```
preconditions: at(v,l) ∧ at(p,l) ∧ capacity-predecessor(s1,s2) ∧ capacity(v,s2)
add effects:   in(p,v), capacity(v,s1)
del effects:   at(p,l), capacity(v,s2)
cost:          1
```

#### drop(?v - vehicle, ?l - location, ?p - package, ?s1 - capacity-number, ?s2 - capacity-number) — Unload package; increments capacity token
```
preconditions: at(v,l) ∧ in(p,v) ∧ capacity-predecessor(s1,s2) ∧ capacity(v,s1)
add effects:   at(p,l), capacity(v,s2)
del effects:   in(p,v), capacity(v,s1)
cost:          1
```

## Goal

All packages `at` their designated destination locations.

## Instances

| name | n | k* | status | source | file |
|---|---|---|---|---|---|
| instance-01 | 4 | - | unknown | IPC08Archive | instances/instance-01.pddl |
