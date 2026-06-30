;; transport pfile01: 1 vehicle, 2 locations, 1 package.
;;
;; Locations: loc1 (start+package), loc2 (destination).
;; Roads: loc1 ↔ loc2 (bidirectional).
;; Vehicle: truck1 at loc1, capacity 2.
;; Package: pkg1 at loc1. Goal: pkg1 at loc2.
;;
;; Plan (3 steps):
;;   pick-up(truck1, loc1, pkg1)     ;; loc-pkgs(loc1): {pkg1}→{}, veh-pkgs(truck1): {}→{pkg1}
;;   drive(truck1, loc1, loc2)
;;   drop(truck1, loc2, pkg1)        ;; veh-pkgs(truck1): {pkg1}→{}, loc-pkgs(loc2): {}→{pkg1}

(define (problem transport-set-small)
    (:domain transport-set-xts)
    (:objects
        loc1 loc2 - location
        truck1    - vehicle
        pkg1      - package
    )
    (:init
        (= (roads loc1) (set.mk (loc2)))
        (= (roads loc2) (set.mk (loc1)))
        (= (vat truck1)      loc1)
        (= (capacity truck1) 2)
        (= (loc-pkgs loc1)   (set.mk (pkg1)))
        (= (loc-pkgs loc2)   (set.mk ()))
        (= (veh-pkgs truck1) (set.mk ())))
    (:goal (member pkg1 (loc-pkgs loc2))))
