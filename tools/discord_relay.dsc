discord_door_message:
  type: task
  debug: false
  definitions: text|player_data|action|time
  script:
      # ██ [ base defintions            ] ██:
      - define embed.color <color[0,254,255].rgb_integer>

      - choose <[action]>:
        - case first_join:
          - define embed.image.url <[player_data.uuid].proc[player_profiles].context[armor/body|<[time]>]>
          - define embed.title "A new player!"
          - define text "🎉🎊🎊🎊🎊🎉<n>Everyone welcome<n>**<[player_data.name]>** to b!"

        - case join leave:
          - define text <[text].strip_color>

      - define embed.description <[text]>

      # ██ [ construct webhook message  ] ██:
      - definemap payload:
          username: <[player_data.name]>
          avatar_url: <[player_data.uuid].proc[player_profiles].context[armor/bust|<[time]>]>
          embeds: <list_single[<[embed]>]>
          allowed_mentions:
            parse: <list>

      # ██ [ construct webhook data     ] ██:
      - definemap data:
          webhook_name: discord_chat_relay
          payload: <[payload]>

      # ██ [ send discord relay message ] ██:
      - run discord_webhook_message defmap:<[data]> if:!<server.has_flag[behr.developmental.debug_mode]>

player_death_announcer:
  type: world
  debug: true
  events:
    on player dies:
      # ██ [ base defintions            ] ██:
      - define embed.color <color[0,254,255].rgb_integer>
      - define embed.description <context.message.strip_color>
      - define time <util.time_now>
      - definemap player_data:
          name: <player.name>
          uuid: <player.uuid>

      # ██ [ construct webhook message  ] ██:
      - definemap payload:
          username: <[player_data.name]>
          avatar_url: <[player_data.uuid].proc[player_profiles].context[armor/bust|<[time]>]>
          embeds: <list_single[<[embed]>]>
          allowed_mentions:
            parse: <list>

      # ██ [ construct webhook data     ] ██:
      - definemap data:
          webhook_name: discord_chat_relay
          payload: <[payload]>

      # ██ [ send discord relay message ] ██:
      - run discord_webhook_message defmap:<[data]> if:!<server.has_flag[behr.developmental.debug_mode]>
