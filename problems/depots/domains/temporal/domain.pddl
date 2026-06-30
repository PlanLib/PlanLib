(define (domain depots-temporal)
  (:requirements :durative-actions :typing)
  (:types
    place locatable - object
    depot distributor - place
    hoist truck - locatable
    surface - locatable
    pallet crate - surface)
  (:predicates
    (at ?x - locatable ?p - place)
    (on ?c - crate ?s - surface)
    (in ?c - crate ?t - truck)
    (lifting ?h - hoist ?c - crate)
    (available ?h - hoist)
    (clear ?s - surface))

  (:durative-action lift
    :parameters (?h - hoist ?c - crate ?s - surface ?p - place)
    :duration (= ?duration 1)
    :condition (and (at start (at ?h ?p))
                    (at start (available ?h))
                    (at start (at ?c ?p))
                    (at start (on ?c ?s))
                    (at start (clear ?c)))
    :effect (and (at start (not (available ?h)))
                 (at start (not (at ?c ?p)))
                 (at start (not (on ?c ?s)))
                 (at start (not (clear ?c)))
                 (at end (lifting ?h ?c))
                 (at end (clear ?s))))

  (:durative-action drop
    :parameters (?h - hoist ?c - crate ?s - surface ?p - place)
    :duration (= ?duration 1)
    :condition (and (at start (at ?h ?p))
                    (at start (lifting ?h ?c))
                    (at start (at ?s ?p))
                    (at start (clear ?s)))
    :effect (and (at start (not (lifting ?h ?c)))
                 (at start (not (clear ?s)))
                 (at end (available ?h))
                 (at end (at ?c ?p))
                 (at end (on ?c ?s))
                 (at end (clear ?c))))

  (:durative-action load
    :parameters (?h - hoist ?c - crate ?t - truck ?p - place)
    :duration (= ?duration 1)
    :condition (and (at start (at ?h ?p))
                    (at start (at ?t ?p))
                    (at start (lifting ?h ?c)))
    :effect (and (at start (not (lifting ?h ?c)))
                 (at end (in ?c ?t))
                 (at end (available ?h))))

  (:durative-action unload
    :parameters (?h - hoist ?c - crate ?t - truck ?p - place)
    :duration (= ?duration 1)
    :condition (and (at start (at ?h ?p))
                    (at start (at ?t ?p))
                    (at start (available ?h))
                    (at start (in ?c ?t)))
    :effect (and (at start (not (in ?c ?t)))
                 (at start (not (available ?h)))
                 (at end (lifting ?h ?c))))

  (:durative-action drive
    :parameters (?t - truck ?from - place ?to - place)
    :duration (= ?duration 2)
    :condition (at start (at ?t ?from))
    :effect (and (at start (not (at ?t ?from)))
                 (at end (at ?t ?to)))))
