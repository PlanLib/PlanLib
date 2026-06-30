---
title: "Base Formulation — STRIPS + action costs (IPC 2008)"
language: PDDL 2.1
source: IPC08Archive
viewpoint_group: strips-costs
viewpoint_title: "STRIPS + Action Costs"
notes: "IPC 2008 sequential-optimal formulation. The grid is represented as a set of location objects connected by directional MOVE-DIR static predicates. Pushes are split into push-to-goal and push-to-nongoal to allow the goal condition to use the at-goal fluent rather than enumerating cell identities. Move actions (player movement without pushing) have no cost; pushes cost 1 each."
instances_description: "Instances parameterised by grid layout, number of stones (p), and number of goal positions. Encoded from standard Sokoban puzzle sets."
generator_note: "IPC 2008 instances: https://github.com/potassco/pddl-instances/tree/master/ipc-2008/domains/sokoban-sequential-optimal"
---

## State Space

A state records: the location of the player (`at ?p ?l`) and the location of each stone (`at ?s ?l`), plus the derived at-goal status of each stone. The set of clear locations is maintained as a complement. The branching factor is at most 4 (one push/move per direction); the challenge lies in irreversible pushes that create deadlocks.

## Types

| name | parent |
|---|---|
| thing | object |
| location | object |
| direction | object |
| player | thing |
| stone | thing |

## Predicates

| name | desc |
|---|---|
| clear(?l - location) | location ?l holds no thing |
| at(?t - thing, ?l - location) | player or stone ?t is at location ?l |
| at-goal(?s - stone) | stone ?s is at a goal location |
| IS-GOAL(?l - location) | location ?l is a goal cell (static) |
| IS-NONGOAL(?l - location) | location ?l is not a goal cell (static) |
| MOVE-DIR(?from - location, ?to - location, ?dir - direction) | moving in direction ?dir takes you from ?from to ?to (static) |

## Actions

#### move(?p - player, ?from - location, ?to - location, ?dir - direction) — Move player to an empty cell
```
preconditions: at(p,from) ∧ clear(to) ∧ MOVE-DIR(from,to,dir)
add effects:   at(p,to), clear(from)
del effects:   at(p,from), clear(to)
cost:          0
```

#### push-to-nongoal(?p, ?s, ?ppos, ?from, ?to, ?dir) — Push stone to a non-goal cell
```
preconditions: at(p,ppos) ∧ at(s,from) ∧ clear(to) ∧ MOVE-DIR(ppos,from,dir) ∧ MOVE-DIR(from,to,dir) ∧ IS-NONGOAL(to)
add effects:   at(p,from), at(s,to), clear(ppos)
del effects:   at(p,ppos), at(s,from), clear(to), at-goal(s)
cost:          1
```

#### push-to-goal(?p, ?s, ?ppos, ?from, ?to, ?dir) — Push stone to a goal cell
```
preconditions: at(p,ppos) ∧ at(s,from) ∧ clear(to) ∧ MOVE-DIR(ppos,from,dir) ∧ MOVE-DIR(from,to,dir) ∧ IS-GOAL(to)
add effects:   at(p,from), at(s,to), clear(ppos), at-goal(s)
del effects:   at(p,ppos), at(s,from), clear(to)
cost:          1
```

## Goal

All stones satisfy `at-goal`: every stone is at some goal location.

## Instances

| name | n | k* | status | source | file |
|---|---|---|---|---|---|
| instance-01 | 3 | - | unknown | IPC08Archive | instances/instance-01.pddl |
