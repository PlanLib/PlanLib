---
title: "Base Formulation — STRIPS + Action Costs (IPC 2011)"
language: PDDL 2.1
source: IPC11Archive
viewpoint_group: strips-costs
viewpoint_title: "STRIPS + Action Costs"
notes: "IPC 2011 sequential-optimal formulation. Machines are typed: highspeed-saw and saw for cutting, grinder for smoothing, planer for resetting surface, glazer, immersion-varnisher, and spray-varnisher for finishing. Board sizes use a boardsize-successor chain (analogous to capacity-predecessor). Machine-specific per-part cost functions encode different finishing costs. Surface, treatment, and colour are tracked as ternary fluents on each woodobj."
instances_description: "Instances parameterised by number of machines per type, number of boards, parts, and target finishing specification. Randomly generated via IPC 2011 generator."
generator_note: "IPC 2011 instances: https://github.com/potassco/pddl-instances/tree/master/ipc-2011/domains/woodworking-sequential-optimal"
---

## State Space

A state records: for each woodobj (board or part), its wood type (`wood`), surface condition (`surface-condition`), colour (`colour`), and treatment (`treatment`); for each part, whether it is `unused` and whether it is `available`; the highspeed-saw load state (`in-highspeed-saw`, `empty`). Boards lose size as parts are cut from them via the `boardsize-successor` chain.

## Types

| name | parent |
|---|---|
| acolour | object |
| awood | object |
| woodobj | object |
| machine | object |
| surface | object |
| treatmentstatus | object |
| aboardsize | object |
| apartsize | object |
| board | woodobj |
| part | woodobj |
| highspeed-saw | machine |
| glazer | machine |
| grinder | machine |
| immersion-varnisher | machine |
| planer | machine |
| saw | machine |
| spray-varnisher | machine |

## Constants

| name | type | meaning |
|---|---|---|
| verysmooth, smooth, rough | surface | surface roughness levels |
| varnished, glazed, untreated, colourfragments | treatmentstatus | finishing states |
| natural | acolour | uncoloured / raw |
| small, medium, large | apartsize | cut-part size classes |

## Predicates

| name | desc |
|---|---|
| unused(?p - part) | part ?p has not yet been cut from a board |
| available(?obj - woodobj) | board or part ?obj is ready for operations |
| surface-condition(?obj - woodobj, ?s - surface) | ?obj has surface roughness ?s |
| treatment(?p - part, ?t - treatmentstatus) | part ?p has finishing state ?t |
| colour(?p - part, ?c - acolour) | part ?p has colour ?c |
| wood(?obj - woodobj, ?w - awood) | ?obj is made of wood type ?w |
| boardsize(?b - board, ?s - aboardsize) | remaining size of board ?b is ?s |
| goalsize(?p - part, ?s - apartsize) | target size of part ?p is ?s (static) |
| boardsize-successor(?s1 - aboardsize, ?s2 - aboardsize) | ?s2 is one size larger than ?s1 (static) |
| in-highspeed-saw(?b - board, ?m - highspeed-saw) | board ?b is loaded in highspeed-saw ?m |
| empty(?m - highspeed-saw) | highspeed-saw ?m has no board loaded |
| has-colour(?m - machine, ?c - acolour) | machine ?m can apply colour ?c (static) |
| contains-part(?b - board, ?p - part) | part ?p has been cut from board ?b |
| grind-treatment-change(?old ?new - treatmentstatus) | grinding transitions treatment from ?old to ?new (static) |
| is-smooth(?s - surface) | surface condition ?s counts as smooth for varnishing (static) |

## Functions

| name | type | desc |
|---|---|---|
| total-cost | number | accumulated manufacturing cost |
| spray-varnish-cost(?p - part) | number | cost to spray-varnish part ?p |
| glaze-cost(?p - part) | number | cost to glaze part ?p |
| grind-cost(?p - part) | number | cost to grind part ?p |
| plane-cost(?p - part) | number | cost to plane part ?p |

## Actions

#### load-highspeed-saw(?b - board, ?m - highspeed-saw) — Load board into highspeed saw
```
preconditions: empty(m) ∧ available(b)
add effects:   in-highspeed-saw(b,m)
del effects:   available(b), empty(m)
cost:          30
```

#### unload-highspeed-saw(?b - board, ?m - highspeed-saw) — Unload board from highspeed saw
```
preconditions: in-highspeed-saw(b,m)
add effects:   available(b), empty(m)
del effects:   in-highspeed-saw(b,m)
cost:          10
```

#### cut-board-small/medium/large(?b, ?p, ?m, ...) — Cut a part from a loaded board
```
preconditions: unused(p) ∧ goalsize(p,size) ∧ in-highspeed-saw(b,m) ∧ wood(b,w) ∧ surface-condition(b,s) ∧ boardsize chain
add effects:   available(p), wood(p,w), surface-condition(p,s), colour(p,natural), treatment(p,untreated)
del effects:   unused(p), boardsize(b,size_before) → boardsize(b,size_after)
cost:          10
```

#### do-saw-small/medium/large(?b, ?p, ?m, ...) — Cut a part using a manual saw
```
preconditions: unused(p) ∧ goalsize(p,size) ∧ available(b) ∧ wood+surface+boardsize chain
add effects:   available(p), wood(p,w), surface-condition(p,s), colour(p,natural), treatment(p,untreated)
del effects:   unused(p), updates boardsize
cost:          30
```

#### do-plane(?p, ?m - planer, ...) — Plane a part (resets to smooth, removes colour and treatment)
```
preconditions: available(p) ∧ surface-condition(p,s) ∧ treatment(p,t) ∧ colour(p,c)
add effects:   surface-condition(p,smooth), treatment(p,untreated), colour(p,natural)
del effects:   surface-condition(p,s), treatment(p,t), colour(p,c)
cost:          plane-cost(p)
```

#### do-grind(?p, ?m - grinder, ...) — Grind a part (makes very-smooth, strips colour and changes treatment)
```
preconditions: available(p) ∧ surface-condition(p,s) ∧ is-smooth(s) ∧ colour(p,c) ∧ treatment(p,t) ∧ grind-treatment-change(t,new-t)
add effects:   surface-condition(p,verysmooth), treatment(p,new-t), colour(p,natural)
del effects:   surface-condition(p,s), treatment(p,t), colour(p,c)
cost:          grind-cost(p)
```

#### do-immersion-varnish(?p, ?m, ?colour, ?surface) — Varnish by immersion (adds colour, requires smooth)
```
preconditions: available(p) ∧ has-colour(m,colour) ∧ surface-condition(p,s) ∧ is-smooth(s) ∧ treatment(p,untreated)
add effects:   treatment(p,varnished), colour(p,colour)
del effects:   treatment(p,untreated), colour(p,natural)
cost:          10
```

#### do-spray-varnish(?p, ?m - spray-varnisher, ...) — Spray varnish (variable cost, requires smooth)
```
preconditions: available(p) ∧ has-colour(m,colour) ∧ surface-condition(p,s) ∧ is-smooth(s) ∧ treatment(p,untreated)
add effects:   treatment(p,varnished), colour(p,colour)
del effects:   treatment(p,untreated), colour(p,natural)
cost:          spray-varnish-cost(p)
```

#### do-glaze(?p, ?m - glazer, ?colour) — Glaze a part (no smooth requirement)
```
preconditions: available(p) ∧ has-colour(m,colour) ∧ treatment(p,untreated)
add effects:   treatment(p,glazed), colour(p,colour)
del effects:   treatment(p,untreated), colour(p,natural)
cost:          glaze-cost(p)
```

## Goal

For each target part: `available(p)`, `colour(p,target_colour)`, `wood(p,target_wood)`, `treatment(p,target_treatment)`.

## Instances

| name | n | k* | status | source | file |
|---|---|---|---|---|---|
| instance-01 | 1 | - | optimal | IPC11Archive | instances/instance-01.pddl |
