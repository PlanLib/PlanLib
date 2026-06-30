---
title: "Numeric Formulation (PDDL 2.1)"
language: PDDL 2.1
source: ScalaNumeric
viewpoint_group: numeric
viewpoint_title: "Numeric: Unbounded Coordinates"
notes: "Base PDDL 2.1 formulation by Enrico Scala. Grid bounds are stored as static numeric fluents (min_x, max_x, min_y, max_y, min_z, max_z) and battery-level-full is also a static numeric constant. Movement preconditions compare current coordinates against the dynamic bounds using arithmetic. Recharge assigns battery-level to battery-level-full. The seven static fluents add redundant numeric state that never changes; the XTS formulation eliminates them."
instances_description: "Instances parameterised by grid dimensions and target location set. Instance names encode the grid size (e.g. 1×8×1)."
generator_note: "Domain by Enrico Scala. Instances from PDDL-XTS examples collection."
---

## State Space

A state records: the current 3-D position (x, y, z as numeric fluents) and the battery-level. The static fluents (min_x, max_x, etc., battery-level-full) never change. Each move step costs 1 battery unit; a visit action also costs 1 battery unit. Recharge is only possible at the origin (0,0,0) and refills to battery-level-full.

## Types

| name | parent |
|---|---|
| location | object |

## Predicates

| name | desc |
|---|---|
| visited(?l - location) | target location ?l has been visited |

## Functions

| name | desc |
|---|---|
| x | current x-coordinate of the drone |
| y | current y-coordinate of the drone |
| z | current z-coordinate of the drone |
| xl(?l - location) | x-coordinate of target location ?l (static) |
| yl(?l - location) | y-coordinate of target location ?l (static) |
| zl(?l - location) | z-coordinate of target location ?l (static) |
| battery-level | current battery charge |
| battery-level-full | maximum battery charge (static) |
| min_x, max_x | x-axis bounds (static) |
| min_y, max_y | y-axis bounds (static) |
| min_z, max_z | z-axis bounds (static) |

## Actions

#### increase_x() — Move one step in +x direction
```
preconditions: battery-level ≥ 1 ∧ x ≤ max_x − 1
add effects:   x := x + 1, battery-level := battery-level − 1
cost:          1 (via battery)
```

#### decrease_x() — Move one step in −x direction
```
preconditions: battery-level ≥ 1 ∧ x ≥ min_x + 1
add effects:   x := x − 1, battery-level := battery-level − 1
cost:          1 (via battery)
```

#### increase_y() / decrease_y() — Move along y-axis
```
preconditions: battery-level ≥ 1 ∧ within y bounds
add effects:   y ±= 1, battery-level −= 1
```

#### increase_z() / decrease_z() — Move along z-axis
```
preconditions: battery-level ≥ 1 ∧ within z bounds
add effects:   z ±= 1, battery-level −= 1
```

#### visit(?l - location) — Visit a target location
```
preconditions: battery-level ≥ 1 ∧ xl(l) = x ∧ yl(l) = y ∧ zl(l) = z
add effects:   visited(l), battery-level −= 1
```

#### recharge() — Recharge battery at the origin
```
preconditions: x = 0 ∧ y = 0 ∧ z = 0
add effects:   battery-level := battery-level-full
```

## Goal

All target locations satisfy `visited`, and the drone has returned to origin (x=0, y=0, z=0).

## Instances

| name | n | k* | status | source | file |
|---|---|---|---|---|---|
| instance-01 | 2 | - | satisficing | ScalaNumeric | instances/instance-01.pddl |
