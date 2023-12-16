discord_webhook_message:
  type: task
  debug: false
  definitions: webhook_name|payload
  data:
    webhooks:
      discord_chat_relay: <secret[discord_chat_webhook]>
      discord_testing: <secret[discord_test_webhook]>
  script:
    # ██ [ reference pre-defined webhooks ] ██:
    - if <script.data_key[data.webhooks].contains[<[webhook_name]>]>:
      - define webhook_url <script.parsed_key[data.webhooks.<[webhook_name]>]>

    # ██ [ reference undefined webhook    ] ██:
    - else if <[webhook_name].is_integer>:
      - stop
    # ██ [ invalid usage                  ] ██:
    - else:
      - stop

    # ██ [ normalize embeds consistency   ] ██:
    - if <[payload].contains[embeds]>:
      - foreach <[payload.embeds]> as:embed:
        - define embed.color <color[0,254,255].rgb_integer> if:!<[embed].contains[color]>
        - define payload.embeds <[payload.embeds].set_single[<[embed]>].at[<[loop_index]>]>
    - define payload.allowed_mentions.parse <list> if:!<[payload].contains[allowed_mentions]>

    - definemap headers:
        Authorization: <secret[bbot]>
        Content-Type: application/json
        User-Agent: b

    - ~webget <[webhook_url]> headers:<[headers]> data:<[payload].to_json> save:response
    - inject web_debug.webget_response if:<server.has_flag[behr.developmental.debug_mode]>
