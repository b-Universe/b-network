player_join_handler:
  type: world
  debug: false
  events:
    on player joins:
      - determine cancelled if:<player.has_flag[behr.essentials.ratelimit.join_announcement]>
      - flag player behr.essentials.ratelimit.join_announcement expire:10s

      - define time <util.time_now>
      - definemap player_data:
          name: <player.name>
          uuid: <player.uuid>
      - if <player.has_flag[behr.essentials.profile.first_joined]>:
        # ██ [ check for a namechange
        - if !<player.flag[behr.essentials.profile.data.names_owned].contains[<player.name>]>:
          - flag player behr.essentials.profile.data.names_owned.<player.name>:<util.time_now>

        # ██ [ base defintions                ] ██:
        - define text "<&b><player.name> joined b"

      - else:
        # ██ [ default profile flags and data ] ██:
        - flag player behr.essentials.profile.first_joined:<util.time_now>
        - flag player behr.essentials.profile.stats.construction.level:1
        - flag player behr.essentials.profile.stats.construction.experience:1
        - flag player behr.essentials.profile.data.names_owned.<player.name>:<util.time_now>
        - flag player behr.essentials.settings.playsounds

        # ██ [ base defintions                ] ██:
        - define text "<&c>🎊<&6>🎊<&e>🎉 <&b><player.name> joined b for the first time! <&e>🎉<&6>🎊<&c>🎊"

        # ██ [ welcome the new players        ] ██:
        - define first_joined true

        # ██ [ announce the player join       ] ██:
      - playsound <server.online_players> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3
      - determine <[text]> passively
      - inject discord_join_message

discord_join_message:
  type: task
  debug: false
  definitions: text|player_data
  script:
      - define text <[text].strip_color>

      - definemap embed:
          color: <color[0,254,255].rgb_integer>
          description: <[text]>
      - if <[first_joined].is_truthy>:
        - define embed.image.url <[player_data.uuid].proc[player_profiles].context[armor/body|<[time]>]>
        - define embed.title "A new player!"
        - define embed.description "🎉🎊🎊🎊🎊🎉<n>Everyone welcome<n>**<[player_data.name]>** to b!"

      - definemap payload:
          username: <[player_data.name]>
          avatar_url: <[player_data.uuid].proc[player_profiles].context[armor/bust|<[time]>]>
          embeds: <list_single[<[embed]>]>
          allowed_mentions:
            parse: <list>

      - definemap data:
          webhook_name: discord_chat_relay
          #webhook_name: discord_testing
          payload: <[payload]>

      - run discord_webhook_message defmap:<[data]>
