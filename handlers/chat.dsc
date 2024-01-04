chat_handler:
  type: world
  debug: false
  sub_events:
    instant_mute:
      - define reason "Blatantly not using common sense (Slurs, in this case)"
      - definemap embed_data:
          color: <color[0,254,255]>
          author_name: <[player_data.name]>
          author_icon_url: <[player_data.uuid].proc[player_profiles].context[armor/bust|<[time]>]>

      - define embed <discord_embed.with[color].as[<color[0,254,255]>]>
      - define description <list_single[<&lt>:b_timeout:1067859276967727175<&gt> `<[player_data.name]>` was muted.]>
      - define description <[description].include_single[**Reason**<&co> <[reason].replace_text[<n>].with[<n><&gt> ]>]> if:<[reason].is_truthy>
      - define embed <[embed].with[description].as[<[description].separated_by[<n><&gt> ]>]>

      - flag player behr.essentials.muted
      - flag server champagne.relay_ratelimit
      - ~discordmessage id:b channel:1100806492988379306 <[embed]>
      - flag server champagne.relay_ratelimit:!
      - narrate "<red>You were instantly muted for not using common sense."
      - define embed <[embed].with[description].as[<[message.text]>].with[author_name].as[<[player_data.name]>].with[author_icon_url].as[<[player_data.uuid].proc[player_profiles].context[armor/bust|<[time]>]>]>
      - ~discordmessage id:b channel:901618453356630054 "Hey <&lt>@194619362223718400<&gt>, I muted `<[player_data.name]>` because they weren<&sq> using common sense.<n>Here's their original message<&co>" embed:<[embed]>
      - stop

  events:
    on player chats bukkit_priority:lowest:
      - determine cancelled passively
      - if <player.has_flag[behr.essentials.muted]>:
        - narrate <element[<&7><player.name><&co> <context.message>].on_hover[<red>You<&sq>re muted, and nobody can hear you.]>
        - stop

      - define message.text <context.message>
      - definemap player_data:
          uuid: <player.uuid>
          name: <player.name>
      - define time <util.time_now>
      - if <[message.text].contains_any_text[nigger|n1qqer|n1gger|niggger|niqqer|kill yourself faggot|tranny|troon]>:
        - inject chat_handler.sub_events.instant_mute

      # ██ [ construct webhook message  ] ██:
      - definemap payload:
          username: <[player_data.name]>
          avatar_url: <[player_data.uuid].proc[player_profiles].context[armor/bust|<[time]>]>
          content: <[message.text].parse_color.strip_color.replace_text[@champagne].with[<&lt>@905309299524382811<&gt>]>
          allowed_mentions:
            parse: <list>
          tts: true

      # ██ [ construct webhook data     ] ██:
      - definemap data:
          webhook_name: discord_chat_relay
          payload: <[payload]>
      - define data.webhook_name discord_testing if:<server.has_flag[behr.developmental.debug_mode]>

      # ██ [ send discord relay message ] ██:
      - narrate "<&color[#C1F2F7]><[player_data.name]><reset><&co> <[message.text].proc[player_chat_format]>" targets:<server.online_players>
      - run discord_webhook_message defmap:<[data]>

    after discord message received channel:1100806492988379306:
    #after discord message received channel:901618453746712665:
      - define message <context.new_message>
      - stop if:<[message].author.id.equals[1102238494631415850].if_null[true]>
      - stop if:<server.has_flag[champagne.relay_ratelimit]>
      - stop if:!<[message].text.is_truthy>
      - definemap message:
          text: <context.new_message.text.proc[chat_replacements].replace_text[&k].parse_color>
          author:
            name: <context.new_message.author.name>
            nickname: <context.new_message.author.nickname[<discord_group[b,901618453356630046]>].if_null[null]>
      - if <[message.author.nickname].is_truthy>:
        - define hover <list_single[<&color[#F3FFAD]>Real name<&color[#26FFC9]><&co> <&color[#C1F2F7]><[message.author.name]>]>
        - define hover <[hover].include_single[<&color[#F3FFAD]>Timestamp<&color[#26FFC9]><&co> <&color[#C1F2F7]><util.time_now.format[E, MMM d, y h:mm a].replace[,].with[<&color[#26FFC9]>,<&color[#C1F2F7]>].replace[<&co>].with[<&color[#26FFC9]><&co><&color[#C1F2F7]>]>]>
        - define message.nameplate <&color[#c0e9f7]><[message.author.nickname].on_hover[<[hover].separated_by[<n>]>]>
      - else:
        - define hover <list_single[<&color[#F3FFAD]>Timestamp<&color[#26FFC9]><&co> <&color[#C1F2F7]><util.time_now.format[E, MMM d, y h:mm a].replace[,].with[<&color[#26FFC9]>,<&color[#C1F2F7]>].replace[<&co>].with[<&color[#26FFC9]><&co><&color[#C1F2F7]>]>]>
        - define message.nameplate <&color[#c0e9f7]><[message.author.name]>

      - narrate "<[message.nameplate]><reset><&co> <[message.text]>" targets:<server.online_players>

player_chat_format:
  type: procedure
  debug: false
  definitions: text
  script:
    # % ██ [ Format message                ] ██:
    - define message.hover <list>

    # % ██ [ Apply timestamp               ] ██:
    - define message.hover <[message.hover].include_single[<&color[#F3FFAD]>Timestamp<&color[#26FFC9]><&co> <&color[#C1F2F7]><util.time_now.format[E, MMM d, y h:mm a].replace[,].with[<&color[#26FFC9]>,<&color[#C1F2F7]>].replace[<&co>].with[<&color[#26FFC9]><&co><&color[#C1F2F7]>]>]>
    - define message.text <[text].proc[parse_chat_format].on_hover[<[message.hover].separated_by[<n>]>].with_insertion[<[text]>]>

    - determine <[message.text].on_hover[<[message.hover]>]>

parse_chat_format:
  type: procedure
  debug: false
  definitions: text
  script:
    - if !<[text].contains_text[&]>:
      - determine <[text]>
    - else:
      - determine <[text].parse_color>

chat_replacements:
  type: procedure
  debug: false
  definitions: text
  #data:
  #  emojis:
  script:
    #- foreach <script.parsed_key[data.emojis]> key:old_emoji as:new_emoji:
    #  - define text <[text].replace_text[]>
    - define text <[text].replace_text[<&lt><&co>kekw_dog<&co>847143006023974933<&gt>].with[<&co>kekw_dog<&co>]>
    - define text <[text].replace_text[<&lt><&co>SCgrin<&co>812319264521584689<&gt>].with[<&lt><&co>SCgrin<&gt>]>
    - define text <[text].replace_text[<&lt>a<&co>clappy<&co>1020740651047997461<&gt>].with[<&lt><&co>clappy<&gt>]>
    - define text <[text].replace_text[<&lt>a<&co>kek<&co>1080770892965085204<&gt>].with[<&lt><&co>kek<&gt>]>
    - define text <[text].replace_text[<&lt>@905309299524382811<&gt>].with[@Champagne]>
    - determine <[text]>
