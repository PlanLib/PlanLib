;; PDDL-XTS diffViewpoint: transport — package locations as mutable partition sets.
;;
;; Source: PDDL-XTS/translations/transport-sequential-optimal-strips/
;;
;; VIEWPOINT: replace (pat ?p ?l) and (pin ?p ?v) boolean predicates with
;; per-location and per-vehicle set fluents tracking package positions.
;;
;;   Original                      This viewpoint
;;   --------                      ---------------
;;   (pat ?p ?l) boolean           (member ?p (loc-pkgs ?l)) set test
;;   (pin ?p ?v) boolean           (member ?p (veh-pkgs ?v)) set test
;;   pick: (not (pat ?p ?l)),      pick: remove ?p from loc-pkgs ?l,
;;         (pin ?p ?v)                   add ?p to veh-pkgs ?v
;;   drop: (not (pin ?p ?v)),      drop: remove ?p from veh-pkgs ?v,
;;         (pat ?p ?l)                   add ?p to loc-pkgs ?l
;;   goal: (pat pkg1 dest) ∧ …    goal: (member pkg1 (loc-pkgs dest)) ∧ …
;;
;; The source translation already uses sets for road connectivity ((roads ?l)).
;; Adding package sets makes this domain the richest set example in the benchmark:
;; two dynamic set types (loc-pkgs, veh-pkgs) plus one static set type (roads).
;;
;; PARTITION PROPERTY: each package appears in exactly one set at any time
;; (either (loc-pkgs ?l) for some location ?l, or (veh-pkgs ?v) for some vehicle ?v).
;; pick-up and drop maintain this invariant by pairing a remove with an add on
;; two DIFFERENT set fluents — a cross-set transfer that is allowed.

(define (domain transport-set-xts)
    (:requirements :typing :sets :bounded-integers :object-fluents)

    (:types
        location vehicle package - object
        locset - (set location)
        pkgset - (set package)
        cap    - (number 0 4)
    )

    (:functions
        (roads    ?l - location) - locset
        (vat      ?v - vehicle)  - location
        (capacity ?v - vehicle)  - cap
        (loc-pkgs ?l - location) - pkgset
        (veh-pkgs ?v - vehicle)  - pkgset
    )

    ;; Drive vehicle from ?l1 to adjacent ?l2.
    (:action drive
        :parameters (?v - vehicle ?l1 ?l2 - location)
        :precondition (and (= (vat ?v) ?l1) (member ?l2 (roads ?l1)))
        :effect (assign (vat ?v) ?l2)
    )

    ;; Pick up package ?p at location ?l into vehicle ?v.
    ;; Cross-set transfer: remove from loc-pkgs ?l, add to veh-pkgs ?v.
    (:action pick-up
        :parameters (?v - vehicle ?l - location ?p - package)
        :precondition (and (= (vat ?v) ?l)
                           (member ?p (loc-pkgs ?l))
                           (> (capacity ?v) 0))
        :effect (and (remove ?p (loc-pkgs ?l))
                     (add    ?p (veh-pkgs ?v))
                     (decrease (capacity ?v) 1))
    )

    ;; Drop package ?p from vehicle ?v at current location ?l.
    ;; Cross-set transfer: remove from veh-pkgs ?v, add to loc-pkgs ?l.
    (:action drop
        :parameters (?v - vehicle ?l - location ?p - package)
        :precondition (and (= (vat ?v) ?l)
                           (member ?p (veh-pkgs ?v)))
        :effect (and (remove ?p (veh-pkgs ?v))
                     (add    ?p (loc-pkgs ?l))
                     (increase (capacity ?v) 1))
    )
)
