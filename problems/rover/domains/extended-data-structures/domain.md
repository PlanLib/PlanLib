---
title: "Extended Type Structures (PDDL-XTS)"
language: PDDL-XTS
source: Isaac26
viewpoint_group: xts
viewpoint_title: "XTS: Bounded Energy and Set Fluents"
notes: "PDDL-XTS reformulation of the numeric IPC 2002 domain. Two changes: (1) energy per rover becomes a bounded-integer type (number 0 100), making the numeric state finite and eliminating unbounded reachability. (2) The four binary per-rover tracking predicates — have_soil_analysis(?r,?w), have_rock_analysis(?r,?w), communicated_soil_data(?w), communicated_rock_data(?w) — are replaced by set fluents: (soil-analyzed ?r)-wayptset, (rock-analyzed ?r)-wayptset, (communicated-soil)-wayptset, (communicated-rock)-wayptset. Sampling adds the waypoint to a rover's set; communication checks membership and adds to the global relayed set. have_image and communicated_image_data are kept as predicates because they pair two non-rover arguments."
instances_description: "Same parameterisation as the numeric domain. Energy initial values must fit in [0, 100]."
generator_note: "Instances from examples/PDDL-XTS/rover/instances/."
---

## State Space

The state space is the same as the numeric formulation but with two structural improvements: the energy variable is explicitly bounded as an integer in [0, 100], and per-rover waypoint tracking is lifted from O(r × w) ground atoms to a pair of set fluents per rover. The number of reachable states is finite and substantially smaller than the general numeric case.

## Types

| name | parent |
|---|---|
| rover | object |
| waypoint | object |
| store | object |
| camera | object |
| mode | object |
| lander | object |
| objective | object |
| energy-val | (number 0 100) |
| wayptset | (set waypoint) |

## Predicates

| name | desc |
|---|---|
| in(?x - rover, ?y - waypoint) | rover ?x is at waypoint ?y |
| at_lander(?x - lander, ?y - waypoint) | lander ?x is at waypoint ?y (static) |
| can_traverse(?r - rover, ?x - waypoint, ?y - waypoint) | rover may move from ?x to ?y (static) |
| equipped_for_soil_analysis(?r - rover) | rover has soil-analysis gear (static) |
| equipped_for_rock_analysis(?r - rover) | rover has rock-analysis gear (static) |
| equipped_for_imaging(?r - rover) | rover has imaging camera (static) |
| empty(?s - store) | store ?s holds no sample |
| full(?s - store) | store ?s holds a sample |
| calibrated(?c - camera, ?r - rover) | camera ?c on rover ?r is calibrated |
| supports(?c - camera, ?m - mode) | camera ?c supports imaging mode ?m (static) |
| available(?r - rover) | rover ?r channel is idle |
| visible(?w - waypoint, ?p - waypoint) | line-of-sight between waypoints (static) |
| have_image(?r - rover, ?o - objective, ?m - mode) | image of objective ?o in mode ?m acquired by rover ?r |
| communicated_image_data(?o - objective, ?m - mode) | image data for (?o, ?m) relayed to lander |
| at_soil_sample(?w - waypoint) | uncollected soil sample present at ?w |
| at_rock_sample(?w - waypoint) | uncollected rock sample present at ?w |
| visible_from(?o - objective, ?w - waypoint) | objective ?o is visible from waypoint ?w (static) |
| store_of(?s - store, ?r - rover) | store ?s belongs to rover ?r (static) |
| calibration_target(?i - camera, ?o - objective) | camera ?i calibrates against objective ?o (static) |
| on_board(?i - camera, ?r - rover) | camera ?i mounted on rover ?r (static) |
| channel_free(?l - lander) | lander communication channel is free |
| in_sun(?w - waypoint) | waypoint ?w receives sunlight (static) |

## Actions

#### navigate(?x - rover, ?y - waypoint, ?z - waypoint) — Move rover; costs 8 energy
```
preconditions: can_traverse(x,y,z) ∧ available(x) ∧ in(x,y) ∧ visible(y,z) ∧ energy(x) ≥ 8
add effects:   in(x,z)
del effects:   in(x,y)
numeric:       energy(x) -= 8
```

#### recharge(?x - rover, ?w - waypoint) — Recharge at sunlit waypoint; restores 20 energy
```
preconditions: in(x,w) ∧ in_sun(w) ∧ energy(x) ≤ 80
numeric:       energy(x) += 20, recharges += 1
```

#### sample_soil(?x - rover, ?s - store, ?p - waypoint) — Collect soil; adds ?p to soil-analyzed set
```
preconditions: in(x,p) ∧ energy(x) ≥ 3 ∧ at_soil_sample(p) ∧ equipped_for_soil_analysis(x) ∧ store_of(s,x) ∧ empty(s)
add effects:   full(s); ?p ∈ soil-analyzed(x) (set add)
del effects:   empty(s), at_soil_sample(p)
numeric:       energy(x) -= 3
```

#### sample_rock(?x - rover, ?s - store, ?p - waypoint) — Collect rock; adds ?p to rock-analyzed set
```
preconditions: in(x,p) ∧ energy(x) ≥ 5 ∧ at_rock_sample(p) ∧ equipped_for_rock_analysis(x) ∧ store_of(s,x) ∧ empty(s)
add effects:   full(s); ?p ∈ rock-analyzed(x) (set add)
del effects:   empty(s), at_rock_sample(p)
numeric:       energy(x) -= 5
```

#### communicate_soil_data(?r, ?l, ?p, ?x, ?y) — Relay soil; checks member of soil-analyzed(r)
```
preconditions: in(r,x) ∧ at_lander(l,y) ∧ member(p, soil-analyzed(r)) ∧ visible(x,y) ∧ available(r) ∧ channel_free(l) ∧ energy(r) ≥ 4
add effects:   ?p ∈ communicated-soil (set add), available(r)
numeric:       energy(r) -= 4
```

#### communicate_rock_data(?r, ?l, ?p, ?x, ?y) — Relay rock; checks member of rock-analyzed(r)
```
preconditions: in(r,x) ∧ at_lander(l,y) ∧ member(p, rock-analyzed(r)) ∧ visible(x,y) ∧ available(r) ∧ channel_free(l) ∧ energy(r) ≥ 4
add effects:   ?p ∈ communicated-rock (set add), available(r)
numeric:       energy(r) -= 4
```

## Goal

Set membership goals: required waypoints must appear in communicated-soil and communicated-rock; required image pairs must satisfy communicated_image_data predicates.

## Instances

| name | n | k* | status | source | file |
|---|---|---|---|---|---|
| p14 | 4 | - | unknown | Isaac26 | instances/p14.pddl |
