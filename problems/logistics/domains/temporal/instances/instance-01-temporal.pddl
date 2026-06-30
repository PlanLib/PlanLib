; Temporal Logistics — instance-01-temporal
; 1 package, 1 truck, 1 airplane, 2 cities, 1 location per city, 2 airports.
; Package at loc-1-1 (city1), must reach loc-2-1 (city2).
; Optimal makespan: load(1) + drive(3) + unload(1) + fly(5) + load(1) + unload(1) = ... (with parallelism: 9)
(define (problem log-temporal-01)
  (:domain logistics-temporal)
  (:objects
    city1 city2 - city
    loc-1-1 loc-2-1 - location
    apt-1 apt-2 - airport
    pkg1 - package
    truck1 - truck
    plane1 - airplane)
  (:init
    (at truck1 loc-1-1)
    (at plane1 apt-1)
    (at pkg1 loc-1-1)
    (in-city loc-1-1 city1)
    (in-city apt-1 city1)
    (in-city loc-2-1 city2)
    (in-city apt-2 city2))
  (:goal (at pkg1 loc-2-1))
  (:metric minimize (total-time)))
