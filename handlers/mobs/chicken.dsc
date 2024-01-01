chicken_handler:
  type: world
  debug: false
  events:
    on egg despawns:
      - define location <context.location>
      - repeat <context.item.quantity.div[2].round_up>:
        - repeat next if:!<util.random_chance[12.5]>
        - spawn chicken[age=baby;velocity=<location[0,1,0].random_offset[0.5,0,0.5]>] <[location]>
        - playsound sound:ENTITY_CHICKEN_EGG <[location]> pitch:<util.random.decimal[0.7].to[1.3]>
        - playeffect at:<[location].above[0.5]> effect:cloud quantity:25
        - wait 1t
