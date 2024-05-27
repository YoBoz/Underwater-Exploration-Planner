(define (problem surveying)
  (:domain underwater_exploration_domian)

  ; Mission 1 - Performing sub sea survery
  
  (:objects
    sub1 - sub
    sub2 - sub
    pilot1 - pilot
    pilot2 - pilot
    scientist1 - scientist
    scientist2 - scientist
    engineer1 - engineer
    engineer2 - engineer
    land1 - land
    loc1 - deep-water
    loc2 - shallow-water
    loc3 - shallow-water
    loc4 - deep-water
    loc5 - shallow-water
    loc6 - deep-water
    kit1 - structure-kit
    kit2 - structure-kit
    kit3 - energy-cable-kit
    kit4 - energy-cable-kit
  )

  (:init
    (marine-protected-area loc4)
    (has-kraken loc5)
    (command-center-at loc1)
    (at sub1 loc1)
    (at sub2 loc1)
    (at pilot1 loc1)
    (at pilot2 loc1)
    (at scientist1 loc1)
    (at scientist2 loc1)
    (at engineer1 loc1)
    (at engineer2 loc1)
    (at kit1 loc1)
    (at kit2 loc1)
    (at kit3 loc1)
    (at kit4 loc1)
    (adjacent loc3 land1)
    (deep-water loc1)
    (deep-water loc2)
    (shallow-water loc3)
    (deep-water loc4)
    (shallow-water loc5)
    (deep-water loc6)
    (adjacent loc1 loc2)
    (adjacent loc2 loc1)
    (adjacent loc2 loc3)
    (adjacent loc3 loc2)
    (adjacent loc3 loc4)
    (adjacent loc4 loc3)
    (adjacent loc4 loc5)
    (adjacent loc5 loc4)
    (adjacent loc5 loc6)
    (adjacent loc6 loc5)
    
  )

  (:goal(and
      (energy-shield-on sub1)
      (subsea-survey loc2)
      (subsea-survey loc3)
      (at sub1 loc1)
    (at sub2 loc1)
    (at pilot1 loc1)
    (at pilot2 loc1)
    (at scientist1 loc1)
    (at scientist2 loc1)
    (at engineer1 loc1)
    (at engineer2 loc1)
    )
  )
)