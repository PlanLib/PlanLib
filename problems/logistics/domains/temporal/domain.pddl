(define (domain logistics-temporal)
  (:requirements :durative-actions :typing)
  (:types
    place physobj city - object
    airport location - place
    package vehicle - physobj
    truck airplane - vehicle)
  (:predicates
    (in-city ?l - place ?c - city)
    (at ?x - physobj ?l - place)
    (in ?pkg - package ?v - vehicle))

  (:durative-action load-truck
    :parameters (?pkg - package ?truck - truck ?loc - location)
    :duration (= ?duration 1)
    :condition (and (at start (at ?truck ?loc))
                    (at start (at ?pkg ?loc)))
    :effect (and (at start (not (at ?pkg ?loc)))
                 (at end (in ?pkg ?truck))))

  (:durative-action unload-truck
    :parameters (?pkg - package ?truck - truck ?loc - location)
    :duration (= ?duration 1)
    :condition (and (at start (at ?truck ?loc))
                    (at start (in ?pkg ?truck)))
    :effect (and (at start (not (in ?pkg ?truck)))
                 (at end (at ?pkg ?loc))))

  (:durative-action drive-truck
    :parameters (?truck - truck ?from - location ?to - location ?city - city)
    :duration (= ?duration 3)
    :condition (and (at start (at ?truck ?from))
                    (at start (in-city ?from ?city))
                    (at start (in-city ?to ?city)))
    :effect (and (at start (not (at ?truck ?from)))
                 (at end (at ?truck ?to))))

  (:durative-action load-airplane
    :parameters (?pkg - package ?airplane - airplane ?airport - airport)
    :duration (= ?duration 1)
    :condition (and (at start (at ?airplane ?airport))
                    (at start (at ?pkg ?airport)))
    :effect (and (at start (not (at ?pkg ?airport)))
                 (at end (in ?pkg ?airplane))))

  (:durative-action unload-airplane
    :parameters (?pkg - package ?airplane - airplane ?airport - airport)
    :duration (= ?duration 1)
    :condition (and (at start (at ?airplane ?airport))
                    (at start (in ?pkg ?airplane)))
    :effect (and (at start (not (in ?pkg ?airplane)))
                 (at end (at ?pkg ?airport))))

  (:durative-action fly-airplane
    :parameters (?airplane - airplane ?from - airport ?to - airport)
    :duration (= ?duration 5)
    :condition (at start (at ?airplane ?from))
    :effect (and (at start (not (at ?airplane ?from)))
                 (at end (at ?airplane ?to)))))
