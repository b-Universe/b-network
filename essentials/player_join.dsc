player_join_handler:
  type: world
  debug: false
  events:
    on player joins:
      # ██ [ let everyone know they joined, if they aren't constantly joining ] ██:
      - determine cancelled if:<player.has_flag[behr.essentials.ratelimit.join_announcement]>
      - flag player behr.essentials.ratelimit.join_announcement expire:10s

        # ██ [ base defintions                ] ██:
      - define time <util.time_now>
      - definemap player_data:
          name: <player.name>
          uuid: <player.uuid>

      - if <player.has_flag[behr.essentials.profile.first_joined]>:
        - define action join
        # ██ [ check for a namechange         ] ██:
        - if !<player.flag[behr.essentials.profile.data.names_owned].contains[<player.name>]>:
          - flag player behr.essentials.profile.data.names_owned.<player.name>:<util.time_now>

        # ██ [ base defintions                ] ██:
        - define text "<&b><player.name> joined b"

      - else:
        - define action first_join
        # ██ [ default profile flags and data ] ██:
        - flag player behr.essentials.profile.first_joined:<util.time_now>
        - flag player behr.essentials.profile.stats.construction.level:1
        - flag player behr.essentials.profile.stats.construction.experience:0
        - flag player behr.essentials.profile.data.names_owned.<player.name>:<util.time_now>
        - flag player behr.essentials.settings.playsounds

        # ██ [ base defintions                ] ██:
        - define text "<&c>🎊<&6>🎊<&e>🎉 <&b><player.name> joined b for the first time! <&e>🎉<&6>🎊<&c>🎊"

      # ██ [ announce the player join         ] ██:
      - playsound <server.online_players> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3
      - determine <[text]> passively
      - inject discord_door_message
