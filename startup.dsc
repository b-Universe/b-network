# ex run "server_start_handler.events.after server start"
server_start_handler:
  type: world
  debug: false
  data:
    webhooks:
      discord_chat_relay: <secret[discord_chat_webhook]>
      discord_testing: <secret[discord_test_webhook]>
  events:
    after server start:
      - adjust system redirect_logging:true

      - wait 5s

      # ██ [ construct webhook data     ] ██:
      - if <server.has_flag[behr.developmental.debug_mode]>:
        - define webhook_url <script.parsed_key[data.webhooks.discord_testing]>
        - define channel <discord_channel[b,901618453746712665]>
      - else:
        - define webhook_url <script.parsed_key[data.webhooks.discord_chat_relay]>
        - define channel <discord_channel[b,1100806492988379306]>

      - definemap headers:
          Authorization: <secret[bbot]>
          Content-Type: application/json
          User-Agent: b

      # ██ [ construct webhook message  ] ██:
      - define embed.color <color[0,254,255].rgb_integer>
      - define embed.description "Server has come online!"
      - define time <util.time_now>
      - definemap payload:
          username: B
          avatar_url: https://api.behr.dev/images/bicon.png
          #avatar_url: https://cdn.discordapp.com/attachments/901618453746712665/1205575260900954152/DALL_E_2023-05-27_03.27.11_-_shiny_golden_metallic_badge_icon__spherically_embedded_in_middle_with_golden_b_with_golden_planet_for_background_slightly_visible__high_quality__golde-removebg-preview.png?ex=65d8de74&is=65c66974&hm=c49ef5d68f2bb22ac53f1e4e0f85ad4c0e62a94afb71438a8f4f46ff76215033&
          embeds: <list_single[<[embed]>]>
          allowed_mentions:
            parse: <list>

      - if <server.has_flag[behr.essentials.last_startup_notification]>:
        - adjust <server.flag[behr.essentials.last_startup_notification]> delete
        - flag server behr.essentials.last_startup_notification:!

      - ~webget <[webhook_url]> headers:<[headers]> data:<[payload].to_json> save:response
      - inject web_debug.webget_response if:<server.has_flag[behr.developmental.debug_mode]>
      - flag server behr.essentials.startup_notification expire:55s
      - waituntil <[channel].last_message.author.id> == 970396053914394694 max:60s
      - stop if:<server.has_flag[behr.essentials.startup_notification]>
      - flag server behr.essentials.last_startup_notification:<[channel].last_message>
