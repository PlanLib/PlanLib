;; transport pfile02: 2 vehicles, 3 locations (hub+2 cities), 2 packages.
;;
;; Mirrors the existing translation problem (transport-xts-3nodes) but with
;; package sets instead of boolean pat/pin predicates.
;;
;; Topology: loc3 (hub) ↔ loc1, loc3 ↔ loc2 (loc1 and loc2 only connect via loc3).
;; truck1 at loc3, capacity 4.   truck2 at loc1, capacity 3.
;; pkg1 and pkg2 both start at loc3.
;; Goal: both packages delivered to loc2.
;;
;; Shortest plan sketch:
;;   pick-up(truck1, loc3, pkg1)
;;   pick-up(truck1, loc3, pkg2)
;;   drive(truck1, loc3, loc2)
;;   drop(truck1, loc2, pkg1)
;;   drop(truck1, loc2, pkg2)   (5 steps)

(define (problem transport-set-medium)
    (:domain transport-set-xts)
    (:objects
        loc1 loc2 loc3 - location
        truck1 truck2  - vehicle
        pkg1 pkg2      - package
    )
    (:init
        (= (roads loc3) (set.mk (loc1 loc2)))
        (= (roads loc1) (set.mk (loc3)))
        (= (roads loc2) (set.mk (loc3)))
        (= (vat truck1)      loc3)
        (= (vat truck2)      loc1)
        (= (capacity truck1) 4)
        (= (capacity truck2) 3)
        (= (loc-pkgs loc3)   (set.mk (pkg1 pkg2)))
        (= (loc-pkgs loc1)   (set.mk ()))
        (= (loc-pkgs loc2)   (set.mk ()))
        (= (veh-pkgs truck1) (set.mk ()))
        (= (veh-pkgs truck2) (set.mk ())))
    (:goal (and (member pkg1 (loc-pkgs loc2))
                (member pkg2 (loc-pkgs loc2)))))
