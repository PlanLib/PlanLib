---
title: Temporal Formulation
language: PDDL 2.1
source: IPC02DepotsArchive
viewpoint_title: "Temporal / Makespan"
notes: "Durative-action version from IPC 2002. Hoist lift and drop take 1 time unit; load and unload take 1 unit; truck drive takes 2 units. Multiple hoists at different places can operate in parallel. The objective is to minimise total makespan."
instances_description: "Same parameterisation as the STRIPS variant: number of depots, distributors, trucks, hoists, crates, and pallets. Makespan depends on how much hoist and truck work can be parallelised."
generator_note: "Official IPC 2002 temporal instances: https://github.com/potassco/pddl-instances/tree/master/ipc-2002/domains/depots-time-automatic"
---

## State Space

The state space is identical to the STRIPS formulation in terms of reachable configurations — same objects, same predicates, same goal conditions — but actions now consume time intervals. Hoists at distinct places can operate concurrently, and a truck can drive while hoists are loading at another place. This makes Temporal Depots a genuine parallel scheduling problem rather than a sequential one.

## Types

| name | parent |
|---|---|
| place | object |
| locatable | object |
| depot | place |
| distributor | place |
| hoist | locatable |
| truck | locatable |
| surface | locatable |
| pallet | surface |
| crate | surface |

## Predicates

| name | desc |
|---|---|
| at(?x - locatable, ?p - place) | locatable x is at place p |
| on(?c - crate, ?s - surface) | crate c rests on surface s |
| in(?c - crate, ?t - truck) | crate c is inside truck t |
| lifting(?h - hoist, ?c - crate) | hoist h is holding crate c |
| available(?h - hoist) | hoist h is not lifting anything |
| clear(?s - surface) | no crate rests on surface s |

## Actions

#### lift(?h - hoist, ?c - crate, ?s - surface, ?p - place) — hoist picks up a crate; duration 1
```
at start: at(h,p) ∧ available(h) ∧ at(c,p) ∧ on(c,s) ∧ clear(c)
at start del: available(h), at(c,p), on(c,s), clear(c)
at end add:   lifting(h,c), clear(s)
```

#### drop(?h - hoist, ?c - crate, ?s - surface, ?p - place) — hoist places a crate; duration 1
```
at start: at(h,p) ∧ lifting(h,c) ∧ at(s,p) ∧ clear(s)
at start del: lifting(h,c), clear(s)
at end add:   available(h), at(c,p), on(c,s), clear(c)
```

#### load(?h - hoist, ?c - crate, ?t - truck, ?p - place) — hoist loads crate into truck; duration 1
```
at start: at(h,p) ∧ at(t,p) ∧ lifting(h,c)
at start del: lifting(h,c)
at end add:   in(c,t), available(h)
```

#### unload(?h - hoist, ?c - crate, ?t - truck, ?p - place) — hoist unloads crate from truck; duration 1
```
at start: at(h,p) ∧ at(t,p) ∧ available(h) ∧ in(c,t)
at start del: in(c,t), available(h)
at end add:   lifting(h,c)
```

#### drive(?t - truck, ?from - place, ?to - place) — truck drives between places; duration 2
```
at start: at(t,from)
at start del: at(t,from)
at end add:   at(t,to)
```

## Goal

A conjunction of on(c, s) literals specifying the desired crate stacking configuration at destination places. The metric is minimize makespan.

## Instances

| name | n | k* | status | source | file |
|---|---|---|---|---|---|
| instance-01-temporal | 1 | 5 | proven optimal | | instances/instance-01-temporal.pddl |
