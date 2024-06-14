new_enchantments:
  type: world
  debug: false
  events:
    after player shoots bow:
      - stop if:!<player.item_in_hand.enchantment_map.contains[flame]>
      - define level <player.item_in_hand.enchantment_map.get[flame]>
      - wait 2t

      - define location <context.projectile.location.above[0.1]> if:<context.projectile.is_truthy>
      - while <context.projectile.is_truthy> && !<context.projectile.is_on_ground>:
        - define location <context.projectile.location.above[0.1]>
        - playeffect effect:flame at:<[location]> visibility:100 quantity:<[level].mul[3]> offset:0.1
        - playeffect effect:lava at:<[location]> visibility:100 quantity:<[level].mul[2]> offset:0.1
        - wait 1t
      - playeffect effect:lava at:<[location]> visibility:100 quantity:<[level].mul[20]> offset:0.<[level]>

      - if <[level]> == 4:
        - explode <[location]> power:1 source:<player>
        - playeffect effect:explosion_large at:<[location].above> quantity:10 offset:1 targets:<server.online_players.exclude[<[location].find_players_within[15]>]>

      - else if <[level]> == 5:
        - playeffect effect:explosion_large at:<[location].above> quantity:10 offset:1 targets:<[location].find_players_within[15]>
        - if !<player.has_flag[behr.essentials.combat.cooldown.large_flame_explosion]>:
          - flag <player> behr.essentials.combat.cooldown.large_flame_explosion expire:6s
          - explode <[location]> power:3 source:<player>
          - playeffect effect:explosion_huge at:<[location]> quantity:1 visibility:112 targets:<server.online_players.exclude[<[location].find_players_within[15]>]>
        - else:
          - explode <[location]> power:2 source:<player>
          - playeffect effect:explosion_huge at:<[location]> quantity:1 visibility:112 targets:<server.online_players.exclude[<[location].find_players_within[15]>]>

    #on player prepares anvil craft bow|crossbow:
    #on player prepares anvil craft enchanted_book:
