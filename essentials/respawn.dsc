respawn_handler:
  type: world
  debug: false
  events:
    on player death:
      - define drops <context.drops>
      - define suits <script[space_suits].data_key[respira]>
      - define drops <[drops].filter[advanced_matches[!<[suits]>]]>
      - determine <[drops]>

    on player respawns elsewhere:
      - determine passively <server.flag[behr.essentials.spawn_location]>

      - give respira_space_package if:!<player.has_flag[package_ratelimit]>
      - flag player package_ratelimit expire:1h

      - flag <player> space_suit_ratelimit expire:1t
      - equip head:respira_space_suit_helmet_WC1 chest:respira_space_suit_top legs:respira_space_suit_bottom boots:respira_space_suit_boots
