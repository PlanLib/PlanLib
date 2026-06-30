---
title: "Base Formulation (IPC 2002)"
language: PDDL 2.1
source: Long03
viewpoint_group: numeric
viewpoint_title: "Numeric: Fuel and Speed"
notes: "IPC 2002 numeric formulation. Fuel is consumed as distance × burn-rate (slow-burn or fast-burn). Refuelling resets fuel to capacity (assign effect). The onboard counter tracks passenger load; fly-fast is only applicable when onboard ≤ zoom-limit. No type hierarchy beyond locatable/aircraft/person; city is a separate type."
instances_description: "Instances parameterised by number of aircraft, cities, and passengers. Fuel capacities and burn rates vary per aircraft; distances vary per city pair."
generator_note: "IPC 2002 instances: https://github.com/potassco/pddl-instances/tree/master/ipc-2002/domains/zenotravel-strips-typed"
---

## State Space

A state records the location of each aircraft and each person (`located`), which passengers are aboard which aircraft (`in`), the remaining fuel per aircraft (numeric), and the current passenger count per aircraft (`onboard`, numeric). The numeric dimensions are bounded by capacity constraints (fuel by capacity, onboard by zoom-limit), so the state space is finite but very large: locations × passenger assignments × fuel levels.

## Types

| name | parent |
|---|---|
| locatable | object |
| aircraft | locatable |
| person | locatable |
| city | object |

## Predicates

| name | desc |
|---|---|
| located(?x - locatable, ?c - city) | person or aircraft ?x is in city ?c |
| in(?p - person, ?a - aircraft) | person ?p is aboard aircraft ?a |

## Actions

#### board(?p - person, ?a - aircraft, ?c - city) — Board a person onto an aircraft
```
preconditions: located(p,c) ∧ located(a,c)
add effects:   in(p,a)
del effects:   located(p,c)
numeric:       onboard(a) += 1
```

#### debark(?p - person, ?a - aircraft, ?c - city) — Disembark a person from an aircraft
```
preconditions: in(p,a) ∧ located(a,c)
add effects:   located(p,c)
del effects:   in(p,a)
numeric:       onboard(a) -= 1
```

#### fly-slow(?a - aircraft, ?c1 - city, ?c2 - city) — Fly economy; higher fuel efficiency
```
preconditions: located(a,c1) ∧ fuel(a) ≥ distance(c1,c2) × slow-burn(a)
add effects:   located(a,c2)
del effects:   located(a,c1)
numeric:       fuel(a) -= distance(c1,c2) × slow-burn(a)
               total-fuel-used += distance(c1,c2) × slow-burn(a)
```

#### fly-fast(?a - aircraft, ?c1 - city, ?c2 - city) — Fly fast; restricted to low passenger loads
```
preconditions: located(a,c1) ∧ fuel(a) ≥ distance(c1,c2) × fast-burn(a) ∧ onboard(a) ≤ zoom-limit(a)
add effects:   located(a,c2)
del effects:   located(a,c1)
numeric:       fuel(a) -= distance(c1,c2) × fast-burn(a)
               total-fuel-used += distance(c1,c2) × fast-burn(a)
```

#### refuel(?a - aircraft) — Top up fuel to full capacity
```
preconditions: capacity(a) > fuel(a)
numeric:       fuel(a) := capacity(a)  (assign)
```

## Goal

All persons are `located` at their designated destination cities.

## Instances

| name | n | k* | status | source | file |
|---|---|---|---|---|---|
| instance-01 | 3 | - | unknown | Long03 | instances/instance-01.pddl |
