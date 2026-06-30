(define (domain satellite-numeric)
  (:requirements :numeric-fluents :typing)
  (:types satellite direction instrument mode - object)
  (:predicates
    (on_board ?i - instrument ?s - satellite)
    (supports ?i - instrument ?m - mode)
    (pointing ?s - satellite ?d - direction)
    (power_avail ?s - satellite)
    (power_on ?i - instrument)
    (calibrated ?i - instrument)
    (calibration_target ?i - instrument ?d - direction)
    (have_image ?d - direction ?m - mode))
  (:functions
    (fuel ?s - satellite)
    (fuel-use ?s - satellite ?d1 - direction ?d2 - direction)
    (data ?i - instrument ?m - mode)
    (data-stored)
    (data-capacity ?s - satellite))

  (:action turn_to
    :parameters (?s - satellite ?d_new - direction ?d_prev - direction)
    :precondition (and (pointing ?s ?d_prev)
                       (>= (fuel ?s) (fuel-use ?s ?d_new ?d_prev)))
    :effect (and (pointing ?s ?d_new)
                 (not (pointing ?s ?d_prev))
                 (decrease (fuel ?s) (fuel-use ?s ?d_new ?d_prev))))

  (:action switch_on
    :parameters (?i - instrument ?s - satellite)
    :precondition (and (on_board ?i ?s) (power_avail ?s))
    :effect (and (power_on ?i)
                 (not (calibrated ?i))
                 (not (power_avail ?s))))

  (:action switch_off
    :parameters (?i - instrument ?s - satellite)
    :precondition (and (on_board ?i ?s) (power_on ?i))
    :effect (and (not (power_on ?i))
                 (power_avail ?s)))

  (:action calibrate
    :parameters (?s - satellite ?i - instrument ?d - direction)
    :precondition (and (on_board ?i ?s)
                       (calibration_target ?i ?d)
                       (pointing ?s ?d)
                       (power_on ?i))
    :effect (calibrated ?i))

  (:action take_image
    :parameters (?s - satellite ?d - direction ?i - instrument ?m - mode)
    :precondition (and (calibrated ?i)
                       (on_board ?i ?s)
                       (supports ?i ?m)
                       (power_on ?i)
                       (pointing ?s ?d)
                       (<= (+ (data-stored) (data ?i ?m)) (data-capacity ?s)))
    :effect (and (have_image ?d ?m)
                 (increase (data-stored) (data ?i ?m)))))
