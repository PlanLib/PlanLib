---
title: "Numeric Formulation (IPC 2002)"
language: PDDL 2.1
source: Long03
viewpoint_group: numeric
viewpoint_title: "Numeric: Energy-Bounded Navigation"
notes: "IPC 2002 formulation. Energy is a numeric fluent tracked per rover; every action deducts a fixed cost. Navigation requires ≥ 8 energy; soil/rock sampling 3 and 5 respectively; calibration 2; image capture 1; communication 4–6 depending on data type. A recharge action (only at in_sun waypoints, energy ≤ 80) restores 20 units. Stores are boolean buffers: a rover carries at most one sample at a time."
instances_description: "Instances parameterised by number of rovers (r), waypoints (w), cameras, modes, objectives, and observation goals. Rover energy budgets are set in the initial state."
generator_note: "IPC 2002 instances: https://github.com/potassco/pddl-instances/tree/master/ipc-2002/domains/rover-strips-typed"
---

## State Space

A state records: rover locations (`in`), lander location (`at_lander`), store fullness per rover (`empty`/`full`), camera calibration status (`calibrated`), acquired analyses (`have_soil_analysis`, `have_rock_analysis`), acquired images (`have_image`), communicated results (`communicated_soil_data`, `communicated_rock_data`, `communicated_image_data`), remaining energy per rover (numeric), and which waypoints still have unsampled material (`at_soil_sample`, `at_rock_sample`). The combination of exponential combinatorics (which goals have been achieved) with bounded numeric resources makes the state space large but finite.

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

## Predicates

| name | desc |
|---|---|
| in(?x - rover, ?y - waypoint) | rover ?x is at waypoint ?y |
| at_lander(?x - lander, ?y - waypoint) | lander ?x is fixed at waypoint ?y (static) |
| can_traverse(?r - rover, ?x - waypoint, ?y - waypoint) | rover ?r may move from ?x to ?y (static) |
| equipped_for_soil_analysis(?r - rover) | rover ?r can sample soil (static) |
| equipped_for_rock_analysis(?r - rover) | rover ?r can sample rock (static) |
| equipped_for_imaging(?r - rover) | rover ?r has an imaging camera (static) |
| empty(?s - store) | store ?s holds no sample |
| full(?s - store) | store ?s holds a sample |
| have_rock_analysis(?r - rover, ?w - waypoint) | rover ?r has collected rock from waypoint ?w |
| have_soil_analysis(?r - rover, ?w - waypoint) | rover ?r has collected soil from waypoint ?w |
| calibrated(?c - camera, ?r - rover) | camera ?c on rover ?r is calibrated |
| supports(?c - camera, ?m - mode) | camera ?c supports imaging mode ?m (static) |
| available(?r - rover) | rover ?r is not currently communicating |
| visible(?w - waypoint, ?p - waypoint) | waypoint ?w has line-of-sight to ?p (static, for comms) |
| have_image(?r - rover, ?o - objective, ?m - mode) | rover ?r has image of objective ?o in mode ?m |
| communicated_soil_data(?w - waypoint) | soil data from waypoint ?w has been relayed to lander |
| communicated_rock_data(?w - waypoint) | rock data from waypoint ?w has been relayed to lander |
| communicated_image_data(?o - objective, ?m - mode) | image of ?o in mode ?m has been relayed to lander |
| at_soil_sample(?w - waypoint) | waypoint ?w still has an uncollected soil sample |
| at_rock_sample(?w - waypoint) | waypoint ?w still has an uncollected rock sample |
| visible_from(?o - objective, ?w - waypoint) | objective ?o is visible from waypoint ?w (static) |
| store_of(?s - store, ?r - rover) | store ?s belongs to rover ?r (static) |
| calibration_target(?i - camera, ?o - objective) | camera ?i uses objective ?o for calibration (static) |
| on_board(?i - camera, ?r - rover) | camera ?i is mounted on rover ?r (static) |
| channel_free(?l - lander) | lander ?l's communication channel is idle |
| in_sun(?w - waypoint) | waypoint ?w receives sunlight (static, for recharge) |

## Actions

#### navigate(?x - rover, ?y - waypoint, ?z - waypoint) — Move rover along a traversable edge
```
preconditions: can_traverse(x,y,z) ∧ available(x) ∧ in(x,y) ∧ visible(y,z) ∧ energy(x) ≥ 8
add effects:   in(x,z)
del effects:   in(x,y)
numeric:       energy(x) -= 8
```

#### recharge(?x - rover, ?w - waypoint) — Recharge at a sunlit waypoint
```
preconditions: in(x,w) ∧ in_sun(w) ∧ energy(x) ≤ 80
numeric:       energy(x) += 20, recharges += 1
```

#### sample_soil(?x - rover, ?s - store, ?p - waypoint) — Collect a soil sample
```
preconditions: in(x,p) ∧ energy(x) ≥ 3 ∧ at_soil_sample(p) ∧ equipped_for_soil_analysis(x) ∧ store_of(s,x) ∧ empty(s)
add effects:   full(s), have_soil_analysis(x,p)
del effects:   empty(s), at_soil_sample(p)
numeric:       energy(x) -= 3
```

#### sample_rock(?x - rover, ?s - store, ?p - waypoint) — Collect a rock sample
```
preconditions: in(x,p) ∧ energy(x) ≥ 5 ∧ at_rock_sample(p) ∧ equipped_for_rock_analysis(x) ∧ store_of(s,x) ∧ empty(s)
add effects:   full(s), have_rock_analysis(x,p)
del effects:   empty(s), at_rock_sample(p)
numeric:       energy(x) -= 5
```

#### drop(?x - rover, ?y - store) — Empty the sample store
```
preconditions: store_of(y,x) ∧ full(y)
add effects:   empty(y)
del effects:   full(y)
```

#### calibrate(?r - rover, ?i - camera, ?t - objective, ?w - waypoint) — Calibrate camera at its target
```
preconditions: equipped_for_imaging(r) ∧ energy(r) ≥ 2 ∧ calibration_target(i,t) ∧ in(r,w) ∧ visible_from(t,w) ∧ on_board(i,r)
add effects:   calibrated(i,r)
numeric:       energy(r) -= 2
```

#### take_image(?r - rover, ?p - waypoint, ?o - objective, ?i - camera, ?m - mode) — Capture an image
```
preconditions: calibrated(i,r) ∧ on_board(i,r) ∧ equipped_for_imaging(r) ∧ supports(i,m) ∧ visible_from(o,p) ∧ in(r,p) ∧ energy(r) ≥ 1
add effects:   have_image(r,o,m)
del effects:   calibrated(i,r)
numeric:       energy(r) -= 1
```

#### communicate_soil_data(?r, ?l, ?p, ?x, ?y) — Relay soil analysis to lander
```
preconditions: in(r,x) ∧ at_lander(l,y) ∧ have_soil_analysis(r,p) ∧ visible(x,y) ∧ available(r) ∧ channel_free(l) ∧ energy(r) ≥ 4
add effects:   communicated_soil_data(p), available(r)
numeric:       energy(r) -= 4
```

#### communicate_rock_data(?r, ?l, ?p, ?x, ?y) — Relay rock analysis to lander
```
preconditions: in(r,x) ∧ at_lander(l,y) ∧ have_rock_analysis(r,p) ∧ visible(x,y) ∧ available(r) ∧ channel_free(l) ∧ energy(r) ≥ 4
add effects:   communicated_rock_data(p), available(r)
numeric:       energy(r) -= 4
```

#### communicate_image_data(?r, ?l, ?o, ?m, ?x, ?y) — Relay image data to lander
```
preconditions: in(r,x) ∧ at_lander(l,y) ∧ have_image(r,o,m) ∧ visible(x,y) ∧ available(r) ∧ channel_free(l) ∧ energy(r) ≥ 6
add effects:   communicated_image_data(o,m), available(r)
numeric:       energy(r) -= 6
```

## Goal

A conjunction of `communicated_soil_data`, `communicated_rock_data`, and `communicated_image_data` facts: all specified scientific results must be relayed to the lander.

## Instances

| name | n | k* | status | source | file |
|---|---|---|---|---|---|
| instance-01 | 2 | - | unknown | Long03 | instances/instance-01.pddl |
