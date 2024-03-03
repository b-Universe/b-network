player_death_announcer:
  type: world
  debug: true
  events:
    on player dies:
      # ██ [ base defintions            ] ██:
      - define embed.color <color[0,254,255].rgb_integer>
      - define embed.description <context.message.strip_color>
      - define time <util.time_now>
      - define player.name <player.name>
      - define player.uuid <player.uuid>

      # ██ [ construct webhook message  ] ██:
      - definemap payload:
          username: <[player.name]>
          avatar_url: https://minotar.net/armor/bust/<[player.uuid].replace_text[-]>/100.png?date=<[time].format[MM-dd]>
          embeds: <list_single[<[embed]>]>
          allowed_mentions:
            parse: <list>

      - define webhook_url <secret[discord_chat_webhook]>
      - define webhook_url <secret[discord_test_webhook]> if:<server.has_flag[behr.developmental.debug_mode]>

      - definemap headers:
          Authorization: <secret[bbot]>
          Content-Type: application/json
          User-Agent: b

      - ~webget <[webhook_url]> headers:<[headers]> data:<[payload].to_json> save:response
      - inject web_debug.webget_response if:<server.has_flag[behr.developmental.debug_mode]>