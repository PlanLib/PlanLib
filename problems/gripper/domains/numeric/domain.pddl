(define (domain gripper-numeric)
  (:requirements :numeric-fluents :typing)
  (:types room gripper)
  (:predicates
    (at-robby ?r - room))
  (:functions
    (balls-in ?r - room)
    (carried ?g - gripper))

  (:action move
    :parameters (?from - room ?to - room)
    :precondition (at-robby ?from)
    :effect (and (at-robby ?to)
                 (not (at-robby ?from))))

  (:action pick
    :parameters (?r - room ?g - gripper)
    :precondition (and (at-robby ?r)
                       (> (balls-in ?r) 0)
                       (= (carried ?g) 0))
    :effect (and (decrease (balls-in ?r) 1)
                 (increase (carried ?g) 1)))

  (:action drop
    :parameters (?r - room ?g - gripper)
    :precondition (and (at-robby ?r)
                       (= (carried ?g) 1))
    :effect (and (increase (balls-in ?r) 1)
                 (decrease (carried ?g) 1))))
