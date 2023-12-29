portal_handler:
  type: world
  debug: false
  events:
    on player teleports cause:END_GATEWAY:
      - if <player.location.is_within[biome_mine_nether_portal]>:
        - determine passively cancelled
        - define x_start <list[-2000|2000].random>
        - define z_start <list[-2000|2000].random>
        - define start_offfset <location[0,400,0,home_nether].with_x[<[x_start]>].with_z[<[z_start]>]>
        - determine <[start_offfset].random_offset[1000,0,1000]> passively
        - cast slow_falling duration:1m
        - wait 1s
        - waituntil <player.is_on_ground> || !<player.is_truthy> rate:1s
        - cast slow_falling remove
        #- teleport 293.5,226,403.5,home_nether

      - else if <player.location.is_within[biome_mine_random_teleporter]>:
        - define x_start <list[-2000|2000].random>
        - define z_start <list[-2000|2000].random>
        - define start_offfset <location[0,400,0,home_the_end].with_x[<[x_start]>].with_z[<[z_start]>]>
        - determine <[start_offfset].random_offset[1000,0,1000]> passively
        - cast slow_falling duration:1m
        - wait 1s
        - waituntil <player.is_on_ground> || !<player.is_truthy> rate:1s
        - cast slow_falling remove

      - else if <player.location.is_within[biome_mine_random_teleporter_green]>:
        - determine passively cancelled
        - define x_start <list[-2000|2000].random>
        - define z_start <list[-2000|2000].random>
        - define start_offfset <location[0,400,0,home].with_x[<[x_start]>].with_z[<[z_start]>]>
        - teleport <[start_offfset].random_offset[1000,0,1000]>
        - cast slow_falling duration:1m
        - wait 1s
        - waituntil <player.is_on_ground> || !<player.is_truthy> rate:1s
        - cast slow_falling remove
