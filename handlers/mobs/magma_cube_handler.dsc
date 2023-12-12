magma_cube_handler:
  type: world
  debug: false
  events:
    after magma_cube spawns chance:1 server_flagged:!behr.essentials.magma_death:
      - adjust <context.entity> size:7

    after magma_cube spawns chance:10 server_flagged:!behr.essentials.magma_death:
      - adjust <context.entity> size:5

    on magma_cube dies:
      - stop if:<list[drowning|dragon_breath|kill|void].contains[<context.cause>]>
      - define location <context.entity.location>
      - flag server behr.essentials.magma_death expire:1t
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
            - spawn magma_cube[size=<util.random.int[1].to[5].div[5].round_down>;velocity=<location[0,1,0].random_offset[1,0,1]>] <[location]>
            - wait 1t
