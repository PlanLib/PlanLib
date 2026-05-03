; ──────────────────────────────────────────────────────────
; Domain:   Gripper — Typed STRIPS (IPC 1998 ADL round)
; Language: PDDL 2.1 (:typing)
;
; Typed version of the Gripper domain. Semantics are identical
; to the untyped base domain; the three unary type predicates
; (room, ball, gripper) are replaced by PDDL type annotations.
;
; Reference: McDermott et al., PDDL 1.2, 1998
; ──────────────────────────────────────────────────────────

(define (domain gripper-typed)
  (:requirements :strips :typing)

  (:types room ball gripper - object)

  (:predicates
    (at-robby ?r - room)
    (at      ?b - ball    ?r - room)
    (free    ?g - gripper)
    (carry   ?b - ball    ?g - gripper)
  )

  ; Move the robot from room ?from to room ?to.
  (:action move
    :parameters (?from - room ?to - room)
    :precondition (at-robby ?from)
    :effect (and
      (at-robby ?to)
      (not (at-robby ?from))
    )
  )

  ; Pick up ball ?b in room ?r using gripper ?g.
  (:action pick
    :parameters (?b - ball ?r - room ?g - gripper)
    :precondition (and (at ?b ?r) (at-robby ?r) (free ?g))
    :effect (and
      (carry ?b ?g)
      (not (at ?b ?r))
      (not (free ?g))
    )
  )

  ; Drop ball ?b in room ?r from gripper ?g.
  (:action drop
    :parameters (?b - ball ?r - room ?g - gripper)
    :precondition (and (carry ?b ?g) (at-robby ?r))
    :effect (and
      (at ?b ?r)
      (free ?g)
      (not (carry ?b ?g))
    )
  )
)
