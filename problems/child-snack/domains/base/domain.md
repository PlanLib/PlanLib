---
title: "Base Formulation — STRIPS (IPC 2014)"
language: PDDL 2.1
source: IPC14Archive
viewpoint_group: strips
viewpoint_title: "STRIPS + Equality"
notes: "IPC 2014 sequential satisficing formulation by Fuentetaja and de la Rosa. The kitchen is a constant of type place. Sandwiches are typed objects that start as notexist placeholders; making a sandwich consumes bread and content from the kitchen and instantiates the sandwich. No action costs are defined; this is a satisficing benchmark. A tray can hold multiple sandwiches (ontray is a set of sandwich–tray pairs)."
instances_description: "Instances parameterised by number of children (some allergic), number of bread/content portions, number of sandwiches, and number of tables."
generator_note: "IPC 2014 instances: https://github.com/potassco/pddl-instances/tree/master/ipc-2014/domains/child-snack-sequential-satisficing"
---

## State Space

A state records: which bread/content portions are at the kitchen, which sandwiches exist (notexist tracks un-instantiated slots), which sandwiches are on which trays, which trays are at which places, which children have been served, and which sandwiches are gluten-free. Tray movement enables batch delivery: load multiple sandwiches, move tray to table, serve each child.

## Types

| name | parent |
|---|---|
| child | object |
| bread-portion | object |
| content-portion | object |
| sandwich | object |
| tray | object |
| place | object |

## Constants

| name | type | meaning |
|---|---|---|
| kitchen | place | the fixed preparation area |

## Predicates

| name | desc |
|---|---|
| at_kitchen_bread(?b - bread-portion) | bread portion ?b is in the kitchen |
| at_kitchen_content(?c - content-portion) | content portion ?c is in the kitchen |
| at_kitchen_sandwich(?s - sandwich) | sandwich ?s has been made and is in the kitchen |
| no_gluten_bread(?b - bread-portion) | bread portion ?b is gluten-free (static) |
| no_gluten_content(?c - content-portion) | content portion ?c is gluten-free (static) |
| ontray(?s - sandwich, ?t - tray) | sandwich ?s is on tray ?t |
| no_gluten_sandwich(?s - sandwich) | sandwich ?s was made with gluten-free ingredients |
| allergic_gluten(?c - child) | child ?c requires a gluten-free sandwich (static) |
| not_allergic_gluten(?c - child) | child ?c can eat any sandwich (static) |
| served(?c - child) | child ?c has received a sandwich |
| waiting(?c - child, ?p - place) | child ?c is waiting at place ?p (static) |
| at(?t - tray, ?p - place) | tray ?t is at place ?p |
| notexist(?s - sandwich) | sandwich ?s has not yet been assembled |

## Actions

#### make_sandwich_no_gluten(?s, ?b - bread-portion, ?c - content-portion) — Assemble a gluten-free sandwich
```
preconditions: at_kitchen_bread(b) ∧ at_kitchen_content(c) ∧ no_gluten_bread(b) ∧ no_gluten_content(c) ∧ notexist(s)
add effects:   at_kitchen_sandwich(s), no_gluten_sandwich(s)
del effects:   at_kitchen_bread(b), at_kitchen_content(c), notexist(s)
cost:          0
```

#### make_sandwich(?s, ?b - bread-portion, ?c - content-portion) — Assemble a regular sandwich
```
preconditions: at_kitchen_bread(b) ∧ at_kitchen_content(c) ∧ notexist(s)
add effects:   at_kitchen_sandwich(s)
del effects:   at_kitchen_bread(b), at_kitchen_content(c), notexist(s)
cost:          0
```

#### put_on_tray(?s - sandwich, ?t - tray) — Load sandwich onto tray at kitchen
```
preconditions: at_kitchen_sandwich(s) ∧ at(t, kitchen)
add effects:   ontray(s, t)
del effects:   at_kitchen_sandwich(s)
cost:          0
```

#### move_tray(?t - tray, ?from - place, ?to - place) — Move tray between places
```
preconditions: at(t, from)
add effects:   at(t, to)
del effects:   at(t, from)
cost:          0
```

#### serve_sandwich_no_gluten(?s, ?c - child, ?t - tray, ?p - place) — Serve gluten-free sandwich to allergic child
```
preconditions: allergic_gluten(c) ∧ ontray(s,t) ∧ waiting(c,p) ∧ no_gluten_sandwich(s) ∧ at(t,p)
add effects:   served(c)
del effects:   ontray(s,t)
cost:          0
```

#### serve_sandwich(?s, ?c - child, ?t - tray, ?p - place) — Serve any sandwich to non-allergic child
```
preconditions: not_allergic_gluten(c) ∧ waiting(c,p) ∧ ontray(s,t) ∧ at(t,p)
add effects:   served(c)
del effects:   ontray(s,t)
cost:          0
```

## Goal

All children satisfy `served`.

## Instances

| name | n | k* | status | source | file |
|---|---|---|---|---|---|
| instance-01 | 2 | - | satisficing | IPC14Archive | instances/instance-01.pddl |
