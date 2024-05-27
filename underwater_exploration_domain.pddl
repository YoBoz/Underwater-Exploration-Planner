; Domain file for Part 3 of F29AI CW1 
; Underwater Exploration

(define (domain underwater_exploration_domian)

  ; Requirements
  (:requirements :strips :typing :negative-preconditions :disjunctive-preconditions :equality)

  ; Following are the diffrent types used diffrent locations, personnels, sub, base, structures
  (:types
    location personnel sub kit base structures - object
    engineer scientist pilot - personnel
    structure-kit energy-cable-kit - kit
    land shallow-water deep-water marine-protected-area - location
    tidal-power-generator energy-cable - structures
    underwater-research-base - base
  )

  ; Following are the predicates used
  (:predicates
    (at ?obj - object ?loc - location) ; Object ?obj is at location ?loc
    (on-board ?sub - sub ?per - personnel) ; Submarine ?sub has personnel ?per on board
    (carrying ?sub - sub ?kit - kit) ; Submarine ?sub is carrying kit ?kit
    (research-scan ?loc - location) ; Research scan has been performed at location ?loc
    (subsea-survey ?loc - location) ; Subsea survey has been performed at location ?loc
    (shallow-water ?loc - location) ; Location ?loc is shallow water
    (deep-water ?loc - location) ; Location ?loc is deep water
    (marine-protected-area ?loc - location) ; Location ?loc is a marine protected area
    (transferred ?loc - location) ; Research results have been transferred at location ?loc
    (analyzed ?loc - location) ; Research results have been analyzed at location ?loc
    (command-center-at ?loc - location) ; Command center is at location ?loc
    (tidal-power-generator-at ?loc - location) ; Tidal power generator is at location ?loc
    (energy-cable-at ?loc - location) ; Energy cable is at location ?loc
    (underwater-research-base-at ?loc - location) ; Underwater research base is at location ?loc
    (adjacent ?obj1 - object ?obj2 - object) ; Objects ?obj1 and ?obj2 are adjacent
    (energy-shield-on ?sub - sub) ; Energy shield is on submarine ?sub
    (sonar-array-on ?baseloc - location) ; Sonar array is on at underwater research base at location ?baseloc
    (has-kraken ?loc - location) ; Location ?loc has a kraken
    (destroyed-by-kraken ?sub - sub) ; Submarine ?sub is destroyed by a kraken
  )

  ; Below are actions
  ; Following is the action to move submarine
  (:action move-sub
    :parameters (?sub - sub ?from ?to - location ?pilot - pilot)
    :precondition (and
      (at ?sub ?from)
      (on-board ?sub ?pilot)
      (not (= ?from ?to))
      (adjacent ?from ?to)
      (or
        (and (shallow-water ?from) (shallow-water ?to))
        (and (deep-water ?from) (deep-water ?to))
        (and (shallow-water ?from) (deep-water ?to))
        (and (deep-water ?from) (shallow-water ?to))
      )
      (forall
        (?other-pilot - pilot)
        (or
          (not (on-board ?sub ?other-pilot))
          (and (= ?other-pilot ?pilot))
        )
      )
    )
    :effect (and
      (not (at ?sub ?from))
      (at ?sub ?to)
    )
  )

  ; Following is the action for personnel to board the submarine
  (:action board-sub
    :parameters (?per - personnel ?sub - sub ?loc - location)
    :precondition (and
      (at ?sub ?loc)
      (at ?per ?loc)
      (or
        (underwater-research-base-at ?loc)
        (command-center-at ?loc))
      (not (on-board ?sub ?per))
      (forall (?other-per - personnel)
              (or (not (on-board ?sub ?other-per))
                  (and (not (= ?per ?other-per)))))
    )
    :effect (and
      (on-board ?sub ?per)
      (not (at ?per ?loc))
    )
  )

  ; Following is the action for personnel to leave the submarine
  (:action leave-sub
    :parameters (?per - personnel ?sub - sub ?loc - location)
    :precondition (and
      (on-board ?sub ?per)
      (at ?sub ?loc)
      (or
        (underwater-research-base-at ?loc)
        (command-center-at ?loc))
    )
    :effect (and
      (at ?per ?loc)
      (not (on-board ?sub ?per)))
  )

  ; Following is the action to perform a sub sea survey
  (:action perform-subsea-survey
    :parameters (?sub - sub ?loc - location ?pilot - pilot ?scientist - scientist)
    :precondition (and
      (at ?sub ?loc)
      (or (shallow-water ?loc)
        (deep-water ?loc))
      (on-board ?sub ?pilot)
      (on-board ?sub ?scientist)
      (not (subsea-survey ?loc))
    )
    :effect (subsea-survey ?loc)
  )

  ; Following is the action to perform a research scan
  (:action perform-research-scan
    :parameters (?sub - sub ?loc - location ?pilot - pilot ?scientist - scientist)
    :precondition (and
      (at ?sub ?loc)
      (or (shallow-water ?loc) (deep-water ?loc))
      (on-board ?sub ?pilot)
      (on-board ?sub ?scientist)
      (not (research-scan ?loc))
    )
    :effect (research-scan ?loc)
  )

  ; Following is the action to load a kit in the submarine
  (:action load-kit
    :parameters (?sub - sub ?kit - kit ?engineer - engineer ?loc - location)
    :precondition (and
      (at ?sub ?loc)
      (at ?kit ?loc)
      (command-center-at ?loc)
      (at ?engineer ?loc)
      (not (carrying ?sub ?kit))
    )
    :effect (and
      (carrying ?sub ?kit)
      (not (at ?kit ?loc)))
  )

  ; Following is the action to unload a kit from the submarine
  (:action unload-kit
    :parameters (?sub - sub ?kit - kit ?engineer - engineer ?loc - location)
    :precondition (and
      (at ?sub ?loc)
      (at ?kit ?loc)
      (command-center-at ?loc)
      (at ?engineer ?loc)
      (carrying ?sub ?kit)
    )
    :effect (and
      (not (carrying ?sub ?kit))
      (at ?kit ?loc))
  )

  ; Following is the action to transfer research scank results
  (:action transfer-research-results
    :parameters (?sub - sub ?scanloc ?baseloc - location)
    :precondition (and
      (underwater-research-base-at ?baseloc)
      (at ?sub ?baseloc)
      (research-scan ?scanloc)
      (not (transferred ?scanloc))
    )
    :effect (and
      (transferred ?scanloc)
      (not (research-scan ?scanloc))
    )
  )

  ; Following is the action to analyze search results
  (:action analyze-research-results
    :parameters ( ?scientist - scientist ?scanloc ?baseloc - location)
    :precondition (and
      (underwater-research-base-at ?baseloc)
      (at ?scientist ?baseloc)
      (transferred ?scanloc)
    )
    :effect (analyzed ?scanloc)
  )

  ; Following is the action to construct a tidal power generator
  (:action construct-tidal-power-generator
    :parameters (?sub - sub ?loc - location ?engineer - engineer ?pilot - pilot ?kit - structure-kit ?land1 - land)
    :precondition (and
      (at ?sub ?loc)
      (shallow-water ?loc)
      (subsea-survey ?loc)
      (carrying ?sub ?kit)
      (on-board ?sub ?pilot)
      (on-board ?sub ?engineer)
      (adjacent ?loc ?land1)
      (not (marine-protected-area ?loc))
      (not (tidal-power-generator-at ?loc))
    )
    :effect (and
      (tidal-power-generator-at ?loc)
      (not (carrying ?sub ?kit))
    )
  )

  ; Following is the action to install a energy cable
  (:action install-energy-cable
    :parameters (?sub - sub ?loc - location ?engineer - engineer ?pilot - pilot ?kit - energy-cable-kit ?strc - structures)
    :precondition (and
      (at ?sub ?loc)
      (subsea-survey ?loc)
      (carrying ?sub ?kit)
      (on-board ?sub ?pilot)
      (on-board ?sub ?engineer)
      (adjacent ?loc ?strc)
      (or
        (shallow-water ?loc)
        (deep-water ?loc))
      (not (marine-protected-area ?loc))
      (not (energy-cable-at ?loc))
    )
    :effect (energy-cable-at ?loc)
  )

  ; Following is the action to construct a underwater research base
  (:action construct-underwater-research-base
    :parameters (?sub1 ?sub2 - sub ?loc - location ?engineer1 ?engineer2 - engineer ?pilot1 ?pilot2 - pilot ?kit1 ?kit2 - structure-kit)
    :precondition (and
      (deep-water ?loc)
      (at ?sub1 ?loc)
      (at ?sub2 ?loc)
      (not (= ?sub1 ?sub2))
      (subsea-survey ?loc)
      (carrying ?sub1 ?kit1)
      (carrying ?sub2 ?kit2)
      (on-board ?sub1 ?pilot1)
      (on-board ?sub1 ?engineer1)
      (on-board ?sub2 ?pilot2)
      (on-board ?sub2 ?engineer2)
      (energy-cable-at ?loc)
      (not (marine-protected-area ?loc))
      (not (underwater-research-base-at ?loc))
    )
    :effect (and
      (underwater-research-base-at ?loc)
      (not (carrying ?sub1 ?kit1))
      (not (carrying ?sub2 ?kit2))
    )
  )

  ; Following is the action to turn on energy sheild
  (:action turn-on-energy-shield
    :parameters (?sub - sub ?loc - location ?pilot - pilot)
    :precondition (and
      (on-board ?sub ?pilot)
      (not (energy-shield-on ?sub))
    )
    :effect (energy-shield-on ?sub)
  )

  ; Following is the action to turn off energy sheild
  (:action turn-off-energy-shield
    :parameters (?sub - sub ?pilot - pilot)
    :precondition (and
      (energy-shield-on ?sub)
      (on-board ?sub ?pilot))
    :effect (not (energy-shield-on ?sub))
  )

  ; Following is the action to turn on sonnar array
  (:action turn-on-sonar-array
    :parameters (?baseloc1 ?baseloc2 - location ?engineer1 ?engineer2 - engineer)
    :precondition (and
      (not (= ?baseloc1 ?baseloc2))
      (underwater-research-base-at ?baseloc1)
      (underwater-research-base-at ?baseloc2)
      (at ?engineer1 ?baseloc1)
      (at ?engineer2 ?baseloc2))
    :effect (sonar-array-on ?baseloc1)
  )

  ; Following is the action to turn off sonar array
  (:action turn-off-sonar-array
    :parameters (?baseloc - location ?engineer - engineer)
    :precondition (and
      (underwater-research-base-at ?baseloc)
      (sonar-array-on ?baseloc)
      (at ?engineer ?baseloc))
    :effect (not (sonar-array-on ?baseloc))
  )

  ; Following is the action which destroys submarine if both energy sheild and sonnar array is off
  (:action kraken-interaction-destroyed
    :parameters (?sub - sub ?loc - location ?baseloc - location)
    :precondition (and
      (at ?sub ?loc)
      (has-kraken ?loc)
      (or (not (sonar-array-on ?baseloc)) (not(energy-shield-on ?sub)))
    )
    :effect (destroyed-by-kraken ?sub)
  )

)