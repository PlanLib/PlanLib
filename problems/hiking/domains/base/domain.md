---
title: "Base Formulation — STRIPS + Equality (IPC 2014)"
language: PDDL 2.1
source: IPC14Archive
viewpoint_group: strips
viewpoint_title: "STRIPS + Equality"
notes: "IPC 2014 sequential satisficing formulation. Places are connected by a static next relation (linear chain). Tents can be up or down; only a down (folded) tent can be driven in a car. A couple walks together as a single action when both members and a pitched tent are co-located with the adjacent place. The domain requires equality to prevent driving a person as their own passenger."
instances_description: "Instances parameterised by number of couples, number of cars, and number of places. The minimal instance uses 1 couple, 2 cars, 1 tent, and 3 places."
generator_note: "IPC 2014 instances: https://github.com/potassco/pddl-instances/tree/master/ipc-2014/domains/hiking-sequential-satisficing"
---

## State Space

A state records: the location of each tent (`at_tent`), person (`at_person`), and car (`at_car`), the up/down status of each tent (`up`, `down`), and the progress of each couple (`walked ?couple ?place`). The `walked` fluent tracks the furthest place each couple has reached together.

## Types

| name | parent |
|---|---|
| car | object |
| tent | object |
| person | object |
| couple | object |
| place | object |

## Predicates

| name | desc |
|---|---|
| at_tent(?x - tent, ?p - place) | tent ?x is at place ?p |
| at_person(?x - person, ?p - place) | person ?x is at place ?p |
| at_car(?x - car, ?p - place) | car ?x is at place ?p |
| partners(?c - couple, ?p1 - person, ?p2 - person) | ?p1 and ?p2 are the two members of couple ?c (static) |
| up(?t - tent) | tent ?t is pitched |
| down(?t - tent) | tent ?t is folded |
| walked(?c - couple, ?p - place) | couple ?c has walked together as far as place ?p |
| next(?p1 - place, ?p2 - place) | place ?p2 immediately follows place ?p1 on the trail (static) |

## Actions

#### put_down(?person - person, ?place - place, ?tent - tent) — Fold a pitched tent
```
preconditions: at_person(person,place) ∧ at_tent(tent,place) ∧ up(tent)
add effects:   down(tent)
del effects:   up(tent)
cost:          0
```

#### put_up(?person - person, ?place - place, ?tent - tent) — Pitch a folded tent
```
preconditions: at_person(person,place) ∧ at_tent(tent,place) ∧ down(tent)
add effects:   up(tent)
del effects:   down(tent)
cost:          0
```

#### drive(?driver - person, ?from - place, ?to - place, ?car - car) — Drive alone
```
preconditions: at_person(driver,from) ∧ at_car(car,from)
add effects:   at_person(driver,to), at_car(car,to)
del effects:   at_person(driver,from), at_car(car,from)
cost:          0
```

#### drive_passenger(?driver, ?from, ?to, ?car, ?passenger - person) — Drive with a passenger
```
preconditions: at_person(driver,from) ∧ at_car(car,from) ∧ at_person(passenger,from) ∧ driver ≠ passenger
add effects:   at_person(driver,to), at_car(car,to), at_person(passenger,to)
del effects:   at_person(driver,from), at_car(car,from), at_person(passenger,from)
cost:          0
```

#### drive_tent(?driver, ?from, ?to, ?car, ?tent - tent) — Drive with a folded tent
```
preconditions: at_person(driver,from) ∧ at_car(car,from) ∧ at_tent(tent,from) ∧ down(tent)
add effects:   at_person(driver,to), at_car(car,to), at_tent(tent,to)
del effects:   at_person(driver,from), at_car(car,from), at_tent(tent,from)
cost:          0
```

#### drive_tent_passenger(?driver, ?from, ?to, ?car, ?tent, ?passenger - person) — Drive with tent and passenger
```
preconditions: at_person(driver,from) ∧ at_car(car,from) ∧ at_tent(tent,from) ∧ down(tent) ∧ at_person(passenger,from) ∧ driver ≠ passenger
add effects:   at_person(driver,to), at_car(car,to), at_tent(tent,to), at_person(passenger,to)
del effects:   at_person(driver,from), at_car(car,from), at_tent(tent,from), at_person(passenger,from)
cost:          0
```

#### walk_together(?tent, ?dest, ?p1, ?prev, ?p2 - person, ?couple - couple) — Both members walk to next place
```
preconditions: at_tent(tent,dest) ∧ up(tent) ∧ at_person(p1,prev) ∧ next(prev,dest) ∧ at_person(p2,prev) ∧ p1 ≠ p2 ∧ walked(couple,prev) ∧ partners(couple,p1,p2)
add effects:   at_person(p1,dest), at_person(p2,dest), walked(couple,dest)
del effects:   at_person(p1,prev), at_person(p2,prev), walked(couple,prev)
cost:          0
```

## Goal

Each couple ?c has `walked(?c, final_place)` for the last place on the trail.

## Instances

| name | n | k* | status | source | file |
|---|---|---|---|---|---|
| instance-01 | 3 | - | satisficing | IPC14Archive | instances/instance-01.pddl |
