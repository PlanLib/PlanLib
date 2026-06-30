; Satellite Temporal — instance-01-temporal
; 1 satellite (sat0), 1 instrument (inst0), 2 directions, 1 mode.
; sat0 points at groundstation0 initially; goal: have_image(star1, image1).
; Optimal makespan: switch_on(2) + calibrate(5) [parallel with turn_to(3)] + take_image(7) = 2+5+7=14?
; Sequential lower bound: switch_on(2) || turn_to(3) then calibrate(5) then take_image(7) = max(2,3)+5+7=16.
(define (problem sat-temporal-01)
  (:domain satellite-temporal)
  (:objects
    sat0 - satellite
    inst0 - instrument
    groundstation0 star1 - direction
    image1 - mode)
  (:init
    (on_board inst0 sat0)
    (supports inst0 image1)
    (calibration_target inst0 groundstation0)
    (pointing sat0 groundstation0)
    (power_avail sat0)
    (= (slew_time sat0 groundstation0 star1) 3)
    (= (slew_time sat0 star1 groundstation0) 3))
  (:goal (have_image star1 image1))
  (:metric minimize (total-time)))
