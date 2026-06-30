; Satellite Numeric — instance-01-numeric
; 1 satellite (sat0), 1 instrument (inst0), 2 directions (groundstation0, star1), 1 mode (image1).
; sat0 starts pointing at groundstation0; inst0 calibrates facing groundstation0.
; Goal: have_image(star1, image1). Fuel=50, fuel-use=20 per slew, data=15, data-capacity=30.
; Optimal plan (k*=4): switch_on, calibrate, turn_to(star1), take_image.
(define (problem sat-numeric-01)
  (:domain satellite-numeric)
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
    (= (fuel sat0) 50)
    (= (fuel-use sat0 groundstation0 star1) 20)
    (= (fuel-use sat0 star1 groundstation0) 20)
    (= (data inst0 image1) 15)
    (= (data-stored) 0)
    (= (data-capacity sat0) 30))
  (:goal (have_image star1 image1)))
