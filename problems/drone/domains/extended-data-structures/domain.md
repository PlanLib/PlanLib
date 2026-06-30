---
title: "Extended Data Structures (PDDL-XTS)"
language: PDDL-XTS
source: ScalaXTS
viewpoint_group: xts
viewpoint_title: "XTS: Bounded Coordinates and Battery"
notes: "PDDL-XTS reformulation of the Drone domain. The four numeric types (coord-x, coord-y, coord-z, battery) are declared as bounded integers with type-level bounds. This eliminates all seven static fluents from the base formulation: min_x/max_x/min_y/max_y/min_z/max_z become implicit bounds of their respective types, and battery-level-full becomes the literal 21 in the recharge effect. Movement preconditions use type-bound inequalities (<, >) instead of arithmetic comparisons against static fluents. The state space is identical but more compact: no numeric variable ever holds a value outside its type bound."
instances_description: "Instance p3 corresponds to a 1×8×1 grid (y ranging 0–8) with 4 target locations."
generator_note: "Adapted by the PDDL-XTS project from the base Drone domain."
---

## State Space

A state records: the bounded-integer position (x: 0–1, y: 0–8, z: 0–1) and battery-level (0–21). All bounds are type-level invariants; no numeric value can leave its declared range. The recharge effect assigns the literal maximum (21) rather than reading a static fluent.

## Types

| name | parent | meaning |
|---|---|---|
| location | object | a target location object |
| coord-x | (number 0 1) | x-coordinate, bounded in [0,1] |
| coord-y | (number 0 8) | y-coordinate, bounded in [0,8] |
| coord-z | (number 0 1) | z-coordinate, bounded in [0,1] |
| battery | (number 0 21) | battery charge level, bounded in [0,21] |

## Predicates

| name | desc |
|---|---|
| visited(?l - location) | target location ?l has been visited |

## Functions

| name | type | desc |
|---|---|---|
| x | coord-x | current x-coordinate |
| y | coord-y | current y-coordinate |
| z | coord-z | current z-coordinate |
| battery-level | battery | current battery charge |
| xl(?l - location) | coord-x | x-coordinate of location ?l (static) |
| yl(?l - location) | coord-y | y-coordinate of location ?l (static) |
| zl(?l - location) | coord-z | z-coordinate of location ?l (static) |

## Actions

#### increase_x() — Move +x
```
preconditions: battery-level ≥ 1 ∧ x < 1   (upper bound is the type max, not a fluent)
add effects:   x += 1, battery-level −= 1
```

#### decrease_x() — Move −x
```
preconditions: battery-level ≥ 1 ∧ x > 0   (lower bound is the type min)
add effects:   x −= 1, battery-level −= 1
```

#### increase_y() / decrease_y() — Move along y (bounds 0–8)
```
preconditions: battery-level ≥ 1 ∧ y < 8  (or > 0)
add effects:   y ±= 1, battery-level −= 1
```

#### increase_z() / decrease_z() — Move along z (bounds 0–1)
```
preconditions: battery-level ≥ 1 ∧ z < 1  (or > 0)
add effects:   z ±= 1, battery-level −= 1
```

#### visit(?l - location) — Visit a target location
```
preconditions: battery-level ≥ 1 ∧ xl(l) = x ∧ yl(l) = y ∧ zl(l) = z
add effects:   visited(l), battery-level −= 1
```

#### recharge() — Recharge at origin
```
preconditions: x = 0 ∧ y = 0 ∧ z = 0
add effects:   battery-level := 21    (literal, no fluent needed)
```

## Goal

All target locations satisfy `visited`, and drone is at origin.

## Instances

| name | n | k* | status | source | file |
|---|---|---|---|---|---|
| p3 | 4 | - | satisficing | ScalaXTS | instances/p3.pddl |
