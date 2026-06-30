---
title: Temporal Formulation
language: PDDL 2.1
viewpoint_title: "Temporal / Makespan"
notes: "Durative-action formulation where driving and flying take non-zero time. Load and unload operations each take 1 time unit; driving between locations takes 3 units; flying between airports takes 5 units. Multiple vehicles can move in parallel, making scheduling decisions non-trivial. The objective is to minimise total makespan."
instances_description: "Instances are identical in structure to the STRIPS variants. Optimal makespan depends on vehicle parallelism and package routing."
---

## State Space

States record the same information as the STRIPS formulation — package and vehicle locations — but now each action occupies a time interval. The temporal state includes active durative actions and their end-times. Parallelism across vehicles turns this into a scheduling problem: two trucks in different cities can drive simultaneously, reducing the total makespan below the sequential plan length.

## Types

| name | parent |
|---|---|
| place | object |
| physobj | object |
| city | object |
| airport | place |
| location | place |
| package | physobj |
| vehicle | physobj |
| truck | vehicle |
| airplane | vehicle |

## Predicates

| name | desc |
|---|---|
| in-city(?l - place, ?c - city) | place l is in city c (static) |
| at(?x - physobj, ?l - place) | object x is at place l |
| in(?pkg - package, ?v - vehicle) | package pkg is inside vehicle v |

## Actions

#### load-truck(?pkg - package, ?truck - truck, ?loc - location) — load package; duration 1
```
at start: at(truck,loc) ∧ at(pkg,loc)
at start del: at(pkg,loc)
at end add:   in(pkg,truck)
```

#### unload-truck(?pkg - package, ?truck - truck, ?loc - location) — unload package; duration 1
```
at start: at(truck,loc) ∧ in(pkg,truck)
at start del: in(pkg,truck)
at end add:   at(pkg,loc)
```

#### drive-truck(?truck - truck, ?from - location, ?to - location, ?city - city) — drive; duration 3
```
at start: at(truck,from) ∧ in-city(from,city) ∧ in-city(to,city)
at start del: at(truck,from)
at end add:   at(truck,to)
```

#### load-airplane(?pkg - package, ?airplane - airplane, ?airport - airport) — load; duration 1
```
at start: at(airplane,airport) ∧ at(pkg,airport)
at start del: at(pkg,airport)
at end add:   in(pkg,airplane)
```

#### unload-airplane(?pkg - package, ?airplane - airplane, ?airport - airport) — unload; duration 1
```
at start: at(airplane,airport) ∧ in(pkg,airplane)
at start del: in(pkg,airplane)
at end add:   at(pkg,airport)
```

#### fly-airplane(?airplane - airplane, ?from - airport, ?to - airport) — fly; duration 5
```
at start: at(airplane,from)
at start del: at(airplane,from)
at end add:   at(airplane,to)
```

## Goal

Same as the STRIPS formulation: a conjunction of at(pkg, loc) literals. The metric is minimize makespan.

## Instances

| name | n | k* | status | source | file |
|---|---|---|---|---|---|
| instance-01-temporal | 1 | 9 | proven optimal | | instances/instance-01-temporal.pddl |
