arrow_deflecting_handler:
  type: world
  debug: false
  enabled: false
  events:
    on player clicks block with:*sword:
      - define location <player.eye_location.forward_flat>
      - foreach <[location].find_entities[arrow].within[1.25]> as:arrow:
        - adjust <[arrow]> velocity:<location[0,0,0].with_pose[<player>].forward[2]>
        - playeffect effect:SWEEP_ATTACK at:<[arrow].location> quantity:3 offset:0.1
        - animate animation:arm_swing for:<player>
      - adjust <player> no_damage_duration:1t
