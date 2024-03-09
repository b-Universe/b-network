respawn_handler:
  type: world
  debug: false
  events:
    on player death:
      - define drops <context.drops>
      - define drops <[drops].filter[advanced_matches[!*_space_suit_*]]>
      - determine <[drops]>

    on player respawns elsewhere:
      #- determine passively <server.flag[behr.essentials.spawn_location]>

      #- give respira_space_package if:!<player.has_flag[package_ratelimit]>
      - flag player package_ratelimit expire:1h

      - if <server.has_flag[behr.essentials.uniques.<player.uuid>.space_suit]>:
        - if !<player.has_flag[behr.essentials.ratelimit.unique_space_suit_reward]>:
          - flag <player> behr.essentials.ratelimit.unique_space_suit_reward expire:7d
          - narrate "<&3>The Galactic Federation of B has gifted this unique space suit for your contribution here at B. We thank you for your support."
        - define equipment_map <server.flag[behr.essentials.uniques.<player.uuid>.space_suit]>

      - else:
        - definemap equipment_map:
            helmet: respira_space_suit_helmet_WC1
            chest: elytra
            legs: respira_space_suit_boots

      - equip head:<[equipment_map.helmet]> chest:<[equipment_map.chest]> boots:<[equipment_map.legs]>

#/ex flag server behr.essentials.uniques.389c52d3-4af2-4c74-8119-c78da351412f.space_suit:<map[helmet=titanium_ice_space_suit_helmet;chest=titanium_ice_space_suit_top;legs=titanium_ice_space_suit_bottom]>
#389c52d3-4af2-4c74-8119-c78da351412f:
#  helmet: titanium_ice_space_suit_helmet
#  chest: titanium_ice_space_suit_top
#  legs: titanium_ice_space_suit_bottom

  