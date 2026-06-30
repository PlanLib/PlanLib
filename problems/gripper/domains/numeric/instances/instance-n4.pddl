(define (problem gripper-numeric-n4)
  (:domain gripper-numeric)
  (:objects
    rooma roomb - room
    left right - gripper)
  (:init
    (at-robby rooma)
    (= (balls-in rooma) 4)
    (= (balls-in roomb) 0)
    (= (carried left) 0)
    (= (carried right) 0))
  (:goal
    (= (balls-in roomb) 4)))
