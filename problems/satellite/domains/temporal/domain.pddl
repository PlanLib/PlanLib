(define (domain satellite-temporal)
  (:requirements :durative-actions :numeric-fluents :typing)
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
    (slew_time ?s - satellite ?d1 - direction ?d2 - direction))

  (:durative-action turn_to
    :parameters (?s - satellite ?d_new - direction ?d_prev - direction)
    :duration (= ?duration (slew_time ?s ?d_new ?d_prev))
    :condition (at start (pointing ?s ?d_prev))
    :effect (and (at start (not (pointing ?s ?d_prev)))
                 (at end (pointing ?s ?d_new))))

  (:durative-action switch_on
    :parameters (?i - instrument ?s - satellite)
    :duration (= ?duration 2)
    :condition (and (at start (on_board ?i ?s))
                    (at start (power_avail ?s)))
    :effect (and (at start (not (power_avail ?s)))
                 (at start (not (calibrated ?i)))
                 (at end (power_on ?i))))

  (:durative-action switch_off
    :parameters (?i - instrument ?s - satellite)
    :duration (= ?duration 1)
    :condition (and (at start (on_board ?i ?s))
                    (at start (power_on ?i)))
    :effect (and (at start (not (power_on ?i)))
                 (at end (power_avail ?s))))

  (:durative-action calibrate
    :parameters (?s - satellite ?i - instrument ?d - direction)
    :duration (= ?duration 5)
    :condition (and (at start (on_board ?i ?s))
                    (at start (calibration_target ?i ?d))
                    (over all (pointing ?s ?d))
                    (over all (power_on ?i)))
    :effect (at end (calibrated ?i)))

  (:durative-action take_image
    :parameters (?s - satellite ?d - direction ?i - instrument ?m - mode)
    :duration (= ?duration 7)
    :condition (and (at start (calibrated ?i))
                    (at start (on_board ?i ?s))
                    (at start (supports ?i ?m))
                    (at start (power_on ?i))
                    (over all (pointing ?s ?d))
                    (over all (power_on ?i))
                    (over all (calibrated ?i)))
    :effect (at end (have_image ?d ?m))))
