portal_handler:
  type: world
  debug: false
  events:
    on player teleports cause:end_gateway in:*_random_teleporter_green:
        - determine passively cancelled
        - define x_start <list[-5000|5000].random>
        - define z_start <list[-5000|5000].random>
        - define start_offfset <location[0,400,0,home].with_x[<[x_start]>].with_z[<[z_start]>]>
        - teleport <[start_offfset].random_offset[1000,0,1000]>
        - cast slow_falling duration:2m
        - wait 1s
        - waituntil <player.is_on_ground> || !<player.is_truthy> rate:1s
        - cast slow_falling remove

    on player teleports cause:end_gateway in:*_nether_portal:
        - determine passively cancelled
        - define x_start <list[-2000|2000].random>
        - define z_start <list[-2000|2000].random>
        - define start_offfset <location[0,400,0,home_nether].with_x[<[x_start]>].with_z[<[z_start]>]>
        - teleport <[start_offfset].random_offset[1000,0,1000]>
        - cast slow_falling duration:2m
        - wait 1s
        - waituntil <player.is_on_ground> || !<player.is_truthy> rate:1s
        - cast slow_falling remove

    on player teleports cause:end_gateway in:*_random_teleporter:
        - determine passively cancelled
        - define x_start <list[-2000|2000].random>
        - define z_start <list[-2000|2000].random>
        - define start_offfset <location[0,400,0,home_the_end].with_x[<[x_start]>].with_z[<[z_start]>]>
        - teleport <[start_offfset].random_offset[1000,0,1000]>
        - cast slow_falling duration:2m
        - wait 1s
        - waituntil <player.is_on_ground> || !<player.is_truthy> rate:1s
        - cast slow_falling remove
