---
title: Numeric Fluent Formulation
language: PDDL 2.1
viewpoint_title: "Numeric Fluents"
notes: "Replaces per-ball at/carry predicates with numeric counters. (balls-in ?r) tracks how many balls are in room r; (carried ?g) is 1 when gripper g holds a ball, 0 when free. Ball identity is lost — individual balls cannot be distinguished — but for the standard goal (get all balls to the destination) counting suffices. The state is O(|rooms| + |grippers|) numeric values instead of O(n × |rooms|) propositions."
instances_description: "Parameterised by n (number of balls). Initial state sets (balls-in rooma)=n. Goal: (= (balls-in roomb) n)."
generator_note: "Instances are fully determined by n. Optimal plan length is the same as the STRIPS formulation: 2n+1 for even n."
---

## State Space

A state is a pair of numeric vectors: how many balls are in each room and how many balls each gripper holds (0 or 1). The dynamic state has 4 numeric values — balls-in(rooma), balls-in(roomb), carried(left), carried(right) — regardless of n. The state space has only O(n²) reachable states (the count in rooma can be 0..n, independent of gripper load), compared with O(2ⁿ × n) in the propositional encoding. However, individual ball identity is abstract: no plan can target a specific ball.

## Types

| name | parent |
|---|---|
| room | object |
| gripper | object |

No `ball` type — balls are represented implicitly by the counter.

## Predicates

| name | desc |
|---|---|
| at-robby(?r - room) | the robot is in room r |

## Actions

#### move(?from - room, ?to - room) — move the robot between rooms
```
preconditions: at-robby(?from)
add effects:   at-robby(?to)
del effects:   at-robby(?from)
```

#### pick(?r - room, ?g - gripper) — pick up a ball (decrement room count)
```
preconditions: at-robby(?r) ∧ balls-in(?r) > 0 ∧ carried(?g) = 0
numeric effects: balls-in(?r) -= 1 ; carried(?g) := 1
```

#### drop(?r - room, ?g - gripper) — drop a held ball (increment room count)
```
preconditions: at-robby(?r) ∧ carried(?g) = 1
numeric effects: balls-in(?r) += 1 ; carried(?g) := 0
```

## Goal

`(= (balls-in roomb) n)` — all n balls must be in the destination room.

## Instances

| name | n | k* | status | source | file | description |
|---|---|---|---|---|---|---|
| n4 | 4 | 11 | proven optimal | | instances/instance-n4.pddl | 4 balls in rooma; goal all in roomb |
