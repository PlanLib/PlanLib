---
title: Temporal Formulation (IPC 2006)
language: PDDL 2.1
source: Fox06
viewpoint_title: "Temporal: Durative Actions"
notes: "IPC 2006 temporal extension. Slewing takes variable time given by slew_time(?s,?d1,?d2) (a numeric function set in the problem). Switch-on takes 2 time units; switch-off 1; calibration 5; image acquisition 7. The invariant (over all) conditions ensure the satellite stays pointing during calibration and image-taking. Multiple satellites can slew and observe in parallel. The objective is to minimise total makespan."
instances_description: "Same structure as the base domain; additionally requires slew_time functions in the initial state. Makespan depends on how much parallel satellite activity can be scheduled."
generator_note: "IPC 2006 temporal instances: https://github.com/potassco/pddl-instances/tree/master/ipc-2006/domains/satellite-time-numeric-automatic"
---

## State Space

Same predicates as the base domain; actions now occupy continuous time intervals. The critical constraint is that calibrate and take_image require the satellite to hold its pointing direction throughout their duration (over all condition). Scheduling these activities without interruption — while avoiding conflicts on shared resources (the power bus) — makes this a genuine temporal planning problem. Multiple satellites can operate in parallel.

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
| power_avail(?s - satellite) | satellite ?s has free power capacity |
| power_on(?i - instrument) | instrument ?i is powered on |
| calibrated(?i - instrument) | instrument ?i is calibrated since last power-on |
| calibration_target(?i - instrument, ?d - direction) | calibration direction for ?i (static) |
| have_image(?d - direction, ?m - mode) | image of ?d in mode ?m acquired |

## Actions

#### turn_to(?s - satellite, ?d_new - direction, ?d_prev - direction) — Slew satellite; duration = slew_time(s,d_new,d_prev)
```
at start:  pointing(s,d_prev)
at start del: pointing(s,d_prev)
at end add:   pointing(s,d_new)
```

#### switch_on(?i - instrument, ?s - satellite) — Power on; duration 2
```
at start: on_board(i,s) ∧ power_avail(s)
at start del: power_avail(s), calibrated(i)
at end add:   power_on(i)
```

#### switch_off(?i - instrument, ?s - satellite) — Power off; duration 1
```
at start: on_board(i,s) ∧ power_on(i)
at start del: power_on(i)
at end add:   power_avail(s)
```

#### calibrate(?s - satellite, ?i - instrument, ?d - direction) — Calibrate; duration 5
```
at start:    on_board(i,s) ∧ calibration_target(i,d) ∧ power_on(i)
over all:    pointing(s,d) ∧ power_on(i)
at end add:  calibrated(i)
```

#### take_image(?s - satellite, ?d - direction, ?i - instrument, ?m - mode) — Capture image; duration 7
```
at start:   calibrated(i) ∧ on_board(i,s) ∧ supports(i,m) ∧ power_on(i)
over all:   pointing(s,d) ∧ power_on(i) ∧ calibrated(i)
at end add: have_image(d,m)
```

## Goal

The same set of have_image(d,m) goals as the base domain. The metric is minimize makespan.

## Instances

| name | n | k* | status | source | file | description |
|---|---|---|---|---|---|---|
| instance-01-temporal | 3 | 16 | proven optimal | Fox06 | instances/instance-01-temporal.pddl | 1 satellite, 1 instrument, 2 directions, 1 mode; slew_time=3; single observation |
