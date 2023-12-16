magma_cube_handler:
  type: world
  debug: false
  events:
    after magma_cube spawns chance:10 server_flagged:!behr.essentials.magma_death:
      - stop if:<list[command|custom|default|egg|mount|slime_split|spawner|spawner_egg].contains[<context.reason>]>
      - if <util.random_chance[10]>:
        - adjust <context.entity> size:7
      - else:
        - adjust <context.entity> size:5

    on entity_flagged:behr.essentials.fall_protection damaged by fall:
      - determine cancelled

    on magma_cube dies:
      - stop if:<list[drowning|dragon_breath|kill|void].contains[<context.cause>]>
      - define location <context.entity.location>
      - flag server behr.essentials.magma_death expire:30t
      - choose <context.entity.size>:
        - case 2:
          - explode <[location]>
        - case 3:
          - explode <[location]> fire
        - case 5:
          - explode <[location]> fire power:3
        - case 7:
          - explode <[location]> fire breakblocks power:5
          - repeat 30:
            - spawn magma_cube[size=<util.random.int[1].to[5].div[5].round_down>;velocity=<location[0,1,0].random_offset[1,0,1]>] <[location]> save:magma_cube
            - flag <entry[magma_cube].spawned_entity> behr.essentials.fall_protection expire:5s
            - wait 1t
