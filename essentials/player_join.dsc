player_join_handler:
  type: world
  debug: false
  events:
    on player joins flagged:!behr.essentials.profile.first_joined:
      # ██ [ default profile flags and data ] ██:
      - flag player behr.essentials.profile.first_joined:<util.time_now>
      - flag player behr.essentials.profile.stats.construction.level:1
      - flag player behr.essentials.profile.stats.construction.experience:1
      - flag player behr.essentials.profile.data.names_owned.<player.name>:<util.time_now>
      - flag player behr.essentials.settings.playsounds

      # ██ [ default profile flags and data ] ██:

      # ██ [ welcome the new players        ] ██:
      - playsound <server.online_players> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3
      - determine "<&e>🎊🎊 <&b><player.name> joined b for the first time! <&e>🎊🎊"

    on player joins flagged:behr.essentials.profile.first_joined:
      # ██ [ check for a namechange
      - if !<player.flag[behr.essentials.profile.data.names_owned].contains[<player.name>]>:
        - flag player behr.essentials.profile.data.names_owned.<player.name>:<util.time_now>

      # ██ [ welcome the player back        ] ██:
      - determine cancelled if:<player.has_flag[behr.essentials.ratelimit.join_announcement]>
      - flag player behr.essentials.ratelimit.join_announcement expire:10s
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3
      - determine "<&b><player.name> joined b"
