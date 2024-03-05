player_leave_handler:
  type: world
  debug: false
  events:
    on player quits:
      # ██ [ let everyone know they left, if they aren't constantly leaving ] ██:
      - determine cancelled if:<player.has_flag[behr.essentials.ratelimit.leave_announcement]>
      - flag player behr.essentials.ratelimit.leave_announcement expire:10s

        # ██ [ base defintions            ] ██:
      - define time <util.time_now>
      - define player.name <player.name>
      - define player.uuid <player.uuid>

      # ██ [ announce the player leave    ] ██:
      - determine "<&b><player.name> left b" passively
      - run player_quit_discord_announcement_task def:<[time]>

player_quit_discord_announcement_task:
  type: task
  definitions: time
  script:
    - stop if:<player.has_flag[behr.essentials.ratelimit.discord_leave_announcement]>
    - flag player behr.essentials.ratelimit.discord_leave_announcement expire:10m

    # ██ [ base defintions            ] ██:
    - define embed.color <color[0,254,255].rgb_integer>
    - define player.name <player.name>
    - define player.uuid <player.uuid>
    - define embed.description "<[player.name]> left B"

    # ██ [ construct webhook message  ] ██:
    - definemap payload:
        username: <[player.name]>
        avatar_url: https://minotar.net/armor/bust/<[player.uuid].replace_text[-]>/100.png?date=<[time].format[MM-dd]>
        embeds: <list_single[<[embed]>]>
        allowed_mentions:
          parse: <list>

    - define webhook_url <secret[discord_chat_webhook]>
    - define webhook_url <secret[discord_test_webhook]> if:<server.has_flag[behr.developmental.debug_mode]>

    # ██ [ construct webhook data     ] ██:
    - definemap headers:
        Authorization: <secret[bbot]>
        Content-Type: application/json
        User-Agent: b

    # ██ [ send discord relay message                                       ] ██:
    - ~webget <[webhook_url]> headers:<[headers]> data:<[payload].to_json> save:response
    - inject web_debug.webget_response if:<server.has_flag[behr.developmental.debug_mode]>
