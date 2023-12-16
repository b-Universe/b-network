slime_handler:
  type: world
  debug: false
  events:
    after slime spawns chance:10 server_flagged:!behr.essentials.slime_death:
      - stop if:<list[command|custom|default|egg|mount|slime_split|spawner|spawner_egg].contains[<context.reason>]>
      - if <util.random_chance[10]>:
        - adjust <context.entity> size:7
      - else:
        - adjust <context.entity> size:5

    on entity_flagged:behr.essentials.fall_protection damaged by fall:
      - determine cancelled

    on slime dies:
      - stop if:<list[drowning|dragon_breath|kill|void].contains[<context.cause>]>
      - define location <context.entity.location>
      - flag server behr.essentials.slime_death expire:30t
      - if <context.entity.size> == 7:
        - repeat 30:
          - spawn slime[size=<util.random.int[1].to[5].div[5].round_down>;velocity=<location[0,1,0].random_offset[1,0,1]>] <[location]> save:slime
          - flag <entry[slime].spawned_entity> behr.essentials.fall_protection expire:5s
          - wait 1t
