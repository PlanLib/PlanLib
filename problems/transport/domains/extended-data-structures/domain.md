---
title: "Extended Data Structures (PDDL-XTS)"
language: PDDL-XTS
source: Isaac26
viewpoint_group: xts
viewpoint_title: "XTS: Set Fluents and Bounded Capacity"
notes: "PDDL-XTS reformulation replacing propositional package-location predicates with per-location and per-vehicle set fluents. (at ?p ?l) → member(?p, loc-pkgs(?l)); (in ?p ?v) → member(?p, veh-pkgs(?v)). pick-up performs a cross-set transfer: remove ?p from loc-pkgs(?l), add to veh-pkgs(?v). drop is the reverse. Vehicle position is an object fluent (vat ?v). Road connectivity is a per-location locset fluent. Capacity is a bounded integer in [0,4]."
instances_description: "Same parameterisation as the base domain. Capacity bound of 4 is hard-coded in the type; larger benchmarks need a wider bound type."
generator_note: "Instances from examples/PDDL-XTS/diffViewpoints/transport/."
---

## State Space

The state space has the same reachable states as the base domain but is represented more compactly: package locations are encoded in sets indexed by location/vehicle rather than as O(p × l + p × v) ground atoms. The partition invariant (each package in exactly one set) is maintained by the cross-set transfer pattern.

## Types

| name | parent |
|---|---|
| location | object |
| vehicle | object |
| package | object |
| locset | (set location) |
| pkgset | (set package) |
| cap | (number 0 4) |

## Actions

#### drive(?v - vehicle, ?l1 - location, ?l2 - location) — Drive along a road stored in roads(?l1)
```
preconditions: vat(v) = l1 ∧ member(l2, roads(l1))
effects:       vat(v) := l2  (object fluent assign)
```

#### pick-up(?v - vehicle, ?l - location, ?p - package) — Cross-set transfer: location → vehicle
```
preconditions: vat(v) = l ∧ member(p, loc-pkgs(l)) ∧ capacity(v) > 0
effects:       remove(p, loc-pkgs(l)), add(p, veh-pkgs(v))
numeric:       capacity(v) -= 1
```

#### drop(?v - vehicle, ?l - location, ?p - package) — Cross-set transfer: vehicle → location
```
preconditions: vat(v) = l ∧ member(p, veh-pkgs(v))
effects:       remove(p, veh-pkgs(v)), add(p, loc-pkgs(l))
numeric:       capacity(v) += 1
```

## Goal

Set membership goals: required packages must be members of loc-pkgs(?destination) for their target location.

## Instances

| name | n | k* | status | source | file |
|---|---|---|---|---|---|
| pfile01 | 3 | - | unknown | Isaac26 | instances/pfile01.pddl |
| pfile02 | 5 | - | unknown | Isaac26 | instances/pfile02.pddl |
