---
title: "Base Formulation — STRIPS + action costs (IPC 2014)"
language: PDDL 2.1
source: IPC14Archive
viewpoint_group: strips-costs
viewpoint_title: "STRIPS + Action Costs"
notes: "IPC 2014 sequential-optimal formulation. Shaker fill level is tracked via a next(?l1,?l2) chain: each pour increments the level from ?l to next(?l). The shaker starts at the empty level and can hold at most two ingredients before shaking. Fills cost 10; all other actions cost 1. Shot glasses track which ingredient they last held (used predicate) to allow refill without clean if same ingredient."
instances_description: "Instances parameterised by number of cocktails to prepare and number of shot glasses available. Each cocktail specifies two required ingredients."
generator_note: "IPC 2014 instances: https://github.com/potassco/pddl-instances/tree/master/ipc-2014/domains/barman-sequential-optimal"
---

## State Space

A state records: where each container is (on table or held in which hand), which hand holds what, the contents of each container, the cleanliness/used status of each container, and the shaker's level and shaked/unshaked status. The state space is finite and propositional; its size is dominated by the exponential number of content assignments across all containers.

## Types

| name | parent |
|---|---|
| hand | object |
| level | object |
| beverage | object |
| ingredient | beverage |
| cocktail | beverage |
| dispenser | object |
| container | object |
| shot | container |
| shaker | container |

## Predicates

| name | desc |
|---|---|
| ontable(?c - container) | container ?c is on the table |
| holding(?h - hand, ?c - container) | hand ?h is holding container ?c |
| handempty(?h - hand) | hand ?h holds nothing |
| empty(?c - container) | container ?c holds no beverage |
| contains(?c - container, ?b - beverage) | container ?c holds beverage ?b |
| clean(?c - container) | container ?c has been cleaned (can be filled with any ingredient) |
| used(?c - container, ?b - beverage) | container ?c last held ingredient ?b (can be refilled with same) |
| dispenses(?d - dispenser, ?i - ingredient) | dispenser ?d provides ingredient ?i (static) |
| shaker-empty-level(?s - shaker, ?l - level) | level ?l is the empty level for shaker ?s (static) |
| shaker-level(?s - shaker, ?l - level) | shaker ?s is currently at fill level ?l |
| next(?l1 - level, ?l2 - level) | ?l2 is one step above ?l1 in the level chain (static) |
| unshaked(?s - shaker) | shaker ?s has been poured into but not yet shaken |
| shaked(?s - shaker) | shaker ?s has been shaken and is ready to serve |
| cocktail-part1(?c - cocktail, ?i - ingredient) | first required ingredient of cocktail ?c (static) |
| cocktail-part2(?c - cocktail, ?i - ingredient) | second required ingredient of cocktail ?c (static) |

## Actions

#### grasp(?h - hand, ?c - container) — Pick up container from table
```
preconditions: ontable(c) ∧ handempty(h)
add effects:   holding(h,c)
del effects:   ontable(c), handempty(h)
cost:          1
```

#### leave(?h - hand, ?c - container) — Put container on table
```
preconditions: holding(h,c)
add effects:   ontable(c), handempty(h)
del effects:   holding(h,c)
cost:          1
```

#### fill-shot(?s - shot, ?i - ingredient, ?h1 ?h2 - hand, ?d - dispenser) — Fill a clean shot glass from a dispenser
```
preconditions: holding(h1,s) ∧ handempty(h2) ∧ dispenses(d,i) ∧ empty(s) ∧ clean(s)
add effects:   contains(s,i), used(s,i)
del effects:   empty(s), clean(s)
cost:          10
```

#### refill-shot(?s - shot, ?i - ingredient, ?h1 ?h2 - hand, ?d - dispenser) — Refill a shot glass with the same ingredient
```
preconditions: holding(h1,s) ∧ handempty(h2) ∧ dispenses(d,i) ∧ empty(s) ∧ used(s,i)
add effects:   contains(s,i)
del effects:   empty(s)
cost:          10
```

#### empty-shot(?h - hand, ?p - shot, ?b - beverage) — Empty a shot glass
```
preconditions: holding(h,p) ∧ contains(p,b)
add effects:   empty(p)
del effects:   contains(p,b)
cost:          1
```

#### clean-shot(?s - shot, ?b - beverage, ?h1 ?h2 - hand) — Clean an empty, used shot glass
```
preconditions: holding(h1,s) ∧ handempty(h2) ∧ empty(s) ∧ used(s,b)
add effects:   clean(s)
del effects:   used(s,b)
cost:          1
```

#### pour-shot-to-clean-shaker(?s - shot, ?i - ingredient, ?d - shaker, ?h1 - hand, ?l ?l1 - level) — Pour first ingredient into empty clean shaker
```
preconditions: holding(h1,s) ∧ contains(s,i) ∧ empty(d) ∧ clean(d) ∧ shaker-level(d,l) ∧ next(l,l1)
add effects:   contains(d,i), unshaked(d), shaker-level(d,l1)
del effects:   contains(s,i), empty(s), empty(d), clean(d), shaker-level(d,l)
cost:          1
```

#### pour-shot-to-used-shaker(?s - shot, ?i - ingredient, ?d - shaker, ?h1 - hand, ?l ?l1 - level) — Pour second ingredient into unshaked shaker
```
preconditions: holding(h1,s) ∧ contains(s,i) ∧ unshaked(d) ∧ shaker-level(d,l) ∧ next(l,l1)
add effects:   contains(d,i), shaker-level(d,l1)
del effects:   contains(s,i), empty(s), shaker-level(d,l)
cost:          1
```

#### shake(?b - cocktail, ?d1 ?d2 - ingredient, ?s - shaker, ?h1 ?h2 - hand) — Shake cocktail from its two ingredients
```
preconditions: holding(h1,s) ∧ handempty(h2) ∧ contains(s,d1) ∧ contains(s,d2) ∧ cocktail-part1(b,d1) ∧ cocktail-part2(b,d2) ∧ unshaked(s)
add effects:   shaked(s), contains(s,b)
del effects:   unshaked(s), contains(s,d1), contains(s,d2)
cost:          1
```

#### empty-shaker(?h - hand, ?s - shaker, ?b - cocktail, ?l ?l1 - level) — Empty the shaker after serving
```
preconditions: holding(h,s) ∧ contains(s,b) ∧ shaked(s) ∧ shaker-level(s,l) ∧ shaker-empty-level(s,l1)
add effects:   empty(s), shaker-level(s,l1)
del effects:   shaked(s), shaker-level(s,l), contains(s,b)
cost:          1
```

#### clean-shaker(?h1 ?h2 - hand, ?s - shaker) — Clean an empty shaker
```
preconditions: holding(h1,s) ∧ handempty(h2) ∧ empty(s)
add effects:   clean(s)
cost:          1
```

#### pour-shaker-to-shot(?b - beverage, ?d - shot, ?h - hand, ?s - shaker, ?l ?l1 - level) — Pour a serving from the shaked shaker into a clean shot glass
```
preconditions: holding(h,s) ∧ shaked(s) ∧ empty(d) ∧ clean(d) ∧ contains(s,b) ∧ shaker-level(s,l) ∧ next(l1,l)
add effects:   contains(d,b), shaker-level(s,l1)
del effects:   clean(d), empty(d), shaker-level(s,l)
cost:          1
```

## Goal

All required cocktails are contained in designated shot glasses: `contains(glass_i, cocktail_j)` for each requested serving.

## Instances

| name | n | k* | status | source | file |
|---|---|---|---|---|---|
| instance-01 | 2 | - | unknown | IPC14Archive | instances/instance-01.pddl |
