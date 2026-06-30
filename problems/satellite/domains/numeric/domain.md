---
title: Numeric Formulation (IPC 2004)
language: PDDL 2.1
source: Fox03
viewpoint_title: "Numeric: Fuel and Data"
notes: "IPC 2004 extension of the base domain. Adds numeric functions: fuel(?s) tracks remaining propellant on each satellite; fuel-use(?s,?d1,?d2) is the cost to slew from d1 to d2; data(?i,?m) is the data volume of one image in mode m; data-stored accumulates total stored data; data-capacity(?s) is the satellite's on-board storage limit. Slewing now depletes fuel and fails if the tank is empty; taking an image fails if the storage is full."
instances_description: "Parameterised as the base domain (satellites, instruments, directions, modes) with additional initial values for fuel, fuel-use, data, and data-capacity fluents."
generator_note: "IPC 2004 numeric instances: https://github.com/potassco/pddl-instances/tree/master/ipc-2004/domains/satellite-numeric-automatic"
---

## State Space

The state space extends the base domain with numeric dimensions: the fuel remaining on each satellite (continuous or integer) and the total data stored (monotonically increasing). Fuel depletion introduces resource reachability constraints absent in the base domain — some observation sequences become infeasible because the satellite runs out of propellant. The data-capacity bound limits how many images can be acquired per satellite, creating a bin-packing dimension.

## Types

| name | parent |
|---|---|
| satellite | object |
| direction | object |
| instrument | object |
| mode | object |

## Predicates

| name | desc |
|---|---|
| on_board(?i - instrument, ?s - satellite) | instrument ?i is on satellite ?s (static) |
| supports(?i - instrument, ?m - mode) | instrument ?i supports mode ?m (static) |
| pointing(?s - satellite, ?d - direction) | satellite ?s is pointing at direction ?d |
| power_avail(?s - satellite) | satellite ?s has free power (no instrument on) |
| power_on(?i - instrument) | instrument ?i is currently powered |
| calibrated(?i - instrument) | instrument ?i is calibrated since last power-on |
| calibration_target(?i - instrument, ?d - direction) | calibration direction for instrument ?i (static) |
| have_image(?d - direction, ?m - mode) | image of ?d in mode ?m has been acquired |

## Actions

#### turn_to(?s - satellite, ?d_new - direction, ?d_prev - direction) — Slew satellite; consumes fuel
```
preconditions: pointing(s,d_prev) ∧ fuel(s) ≥ fuel-use(s,d_new,d_prev)
add effects:   pointing(s,d_new)
del effects:   pointing(s,d_prev)
numeric:       fuel(s) -= fuel-use(s,d_new,d_prev)
```

#### switch_on(?i - instrument, ?s - satellite) — Power on instrument
```
preconditions: on_board(i,s) ∧ power_avail(s)
add effects:   power_on(i)
del effects:   calibrated(i), power_avail(s)
```

#### switch_off(?i - instrument, ?s - satellite) — Power off instrument
```
preconditions: on_board(i,s) ∧ power_on(i)
add effects:   power_avail(s)
del effects:   power_on(i)
```

#### calibrate(?s - satellite, ?i - instrument, ?d - direction) — Calibrate instrument
```
preconditions: on_board(i,s) ∧ calibration_target(i,d) ∧ pointing(s,d) ∧ power_on(i)
add effects:   calibrated(i)
```

#### take_image(?s - satellite, ?d - direction, ?i - instrument, ?m - mode) — Capture image; stores data
```
preconditions: calibrated(i) ∧ on_board(i,s) ∧ supports(i,m) ∧ power_on(i) ∧ pointing(s,d)
               ∧ data-stored + data(i,m) ≤ data-capacity(s)
add effects:   have_image(d,m)
numeric:       data-stored += data(i,m)
```

## Goal

A set of have_image(d,m) goals plus optionally a metric on fuel consumed or data stored.

## Instances

| name | n | k* | status | source | file | description |
|---|---|---|---|---|---|---|
| instance-01-numeric | 3 | 4 | proven optimal | Fox03 | instances/instance-01-numeric.pddl | 1 satellite, 1 instrument, 2 directions, 1 mode; fuel=50, fuel-use=20, data=15, data-capacity=30 |
