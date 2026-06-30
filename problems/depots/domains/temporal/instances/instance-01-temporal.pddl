; Temporal Depots — instance-01-temporal
; 1 crate, 1 pallet, 1 depot, 1 distributor, 1 truck, 1 hoist.
; Crate at depot0 on pallet0; goal: crate0 on pallet1 at distributor0.
; Optimal makespan: lift(1) + load(1) + drive(2) + unload(1) + drop(1) = 5 (sequential, no parallelism possible).
(define (problem depots-temporal-01)
  (:domain depots-temporal)
  (:objects
    depot0 - depot
    dist0 - distributor
    truck0 - truck
    hoist0 - hoist
    crate0 - crate
    pallet0 pallet1 - pallet)
  (:init
    (at hoist0 depot0)
    (available hoist0)
    (at truck0 depot0)
    (at crate0 depot0)
    (on crate0 pallet0)
    (clear crate0)
    (at pallet0 depot0)
    (at pallet1 dist0)
    (clear pallet1))
  (:goal (on crate0 pallet1))
  (:metric minimize (total-time)))
