player_join_discord_task:
  type: task
  definitions: player
  script:
    - stop if:<player.has_flag[behr.essentials.ratelimit.discord_join_announcement]>
    - flag player behr.essentials.ratelimit.discord_join_announcement expire:10m

    # ██ [ base defintions      ] ██:
    - define embed.color <color[0,254,255].rgb_integer>
    - define time <util.time_now>

    - if <player.has_flag[behr.essentials.profile.first_joined]>:
      - define text "<&b><player.name> joined b"
      # ██ [ check for a namechange     ] ██:
      - if !<player.has_flag[behr.essentials.profile.data.names_owned.<player.name>]>:
        - flag player behr.essentials.profile.data.names_owned.<player.name>:<[time]>
      - define embed.image.url <[player].proc[player_profiles].context[armor/body|<[time]>]>

    - else:
      - define text "<&c>🎊<&6>🎊<&e>🎉 <&b><player.name> joined B for the first time! <&e>🎉<&6>🎊<&c>🎊"
      - define embed.title "A new player!"
      - define text "🎉🎊🎊🎊🎊🎉<n>Everyone welcome<n>**<[player].name>** to b!"

      - flag player behr.essentials.profile.first_joined:<[time]>
      - foreach construction|magic|technology as:stat:
        - if !<player.has_flag[behr.essentials.profile.stats.<[stat]>]>:
          - flag <player> behr.essentials.profile.stats.<[stat]>.experience:0
          - flag <player> behr.essentials.profile.stats.<[stat]>.level:1

    - define embed.description <[text].strip_color>

    # ██ [ construct webhook message  ] ██:
    - definemap payload:
        username: <[player_data.name]>
        avatar_url: <[player_data.uuid].proc[player_profiles].context[armor/bust|<[time]>]>
        embeds: <list_single[<[embed]>]>
        allowed_mentions:
        parse: <list>

    # ██ [ construct webhook data   ] ██:
    - definemap data:
        webhook_name: discord_chat_relay
        payload: <[payload]>

    # ██ [ send discord relay message ] ██:
    - run discord_webhook_message defmap:<[data]>