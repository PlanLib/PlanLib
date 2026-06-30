---
title: PDDL Domain (typed STRIPS)
language: PDDL 2.1
source: McDermott98
viewpoint_group: strips
notes: "Typed formulation with explicit room, ball, and gripper type declarations. Semantics identical to the untyped base; typing replaces unary category predicates and enables type-based grounding pruning."
---

## State Space

Identical to the untyped formulation: a state specifies the room containing the robot, the room of each ball, and which ball each gripper carries. Type declarations eliminate the unary category predicates and reduce the number of valid groundings at no semantic cost.

## Types

| name | parent |
|---|---|
| room | object |
| ball | object |
| gripper | object |

## Objects

Objects of types `room` (two rooms), `ball` (n balls), and `gripper` (two grippers: left, right).

## Predicates

| name | desc |
|---|---|
| at-robby(?r - room) | the robot is in room r |
| at(?b - ball, ?r - room) | ball b is in room r |
| free(?g - gripper) | gripper g holds nothing |
| carry(?b - ball, ?g - gripper) | gripper g is carrying ball b |

## Actions

#### move(?from - room, ?to - room) — move the robot between rooms
```
preconditions: at-robby(?from)
add effects:   at-robby(?to)
del effects:   at-robby(?from)
```

#### pick(?b - ball, ?r - room, ?g - gripper) — pick up a ball with a free gripper
```
preconditions: at(?b, ?r) ∧ at-robby(?r) ∧ free(?g)
add effects:   carry(?b, ?g)
del effects:   at(?b, ?r), free(?g)
```

#### drop(?b - ball, ?r - room, ?g - gripper) — drop a carried ball in the current room
```
preconditions: carry(?b, ?g) ∧ at-robby(?r)
add effects:   at(?b, ?r), free(?g)
del effects:   carry(?b, ?g)
```

## Goal

All n balls at the destination room. Gripper positions are unconstrained.

## Instances

| name | n | k* | status | source | file |
|---|---|---|---|---|---|
| instance-01 | 2 | 5 | proven optimal | | |
| instance-02 | 4 | 9 | proven optimal | | |
| instance-03 | 6 | 13 | proven optimal | | |
| instance-04-odd | 3 | 9 | proven optimal | | |
