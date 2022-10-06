chat_formatting:
  type: world
  debug: true
  events:
    on player chats:
      - determine cancelled passively
      - define message <context.message.proc[player_chat_format]>
      #- define message "<player.name><&co> <context.message.on_hover[hover text]>"
      - flag server behr.essentials.chat.channel.player_chat.<util.time_now.epoch_millis>:<[message]>
      - narrate player_chat/<[message]> targets:<server.online_players> from:<player.uuid>

    on player receives message:
      # ! DRAFT !
      - define message <context.message>
      - define message_channel <context.message.before[/]>
      - define raw_message <[message].after[<[message_channel]>/]>

      #- define player_channel <player.flag[behr.essentials.chat.channel].if_null[all]>

      - define history <list>
      - foreach <server.flag[behr.essentials.chat.channel].if_null[<list>]> key:channel as:content:
        - if !<player.has_flag[behr.essentials.settings.chat.channel.<[channel]>.messages.disabled]>:
          - define history <[history].include[<[content]>]>
      - if !<[history].parse[values.first.strip_color].contains_single[<[raw_message].strip_color>]>:
        - flag server behr.essentials.chat.channel.system.<util.time_now.epoch_millis>:->:system/<[message]>
        - define history <[history].include_single[<map.with[system].as[<[raw_message]>]>]>

#      - if ! <[history].contains[<[message]>]>:
#        - if !<player.has_flag[behr.essentials.settings.chat.systen.disabled]>:

      - determine message:<n.repeat[10]><[history].sort_by_value[highest].parse[values].separated_by[<&r><n>]>
      #- determine message:<[history].separated_by[<&r><n>]>

player_chat_format:
  type: procedure
  debug: false
  definitions: message
  script:
    # % ██ [ Format nameplate ] ██
    - define name_click "/msg <player.name> "
    - define name_hover <list>
    - if <player.has_flag[behr.essentials.nickname]>:
      - define name <player.flag[behr.essentials.nickname]>
      - define name_hover "<[name_hover].include_single[<&color[#F3FFAD]>Real Name<&color[#26FFC9]><&co> <&color[#C1F2F7]><player.name>]>"
    - else:
      - define name <player.name>

    - define name_hover "<[name_hover].include_single[<&color[#F3FFAD]>Click to message].include_single[<&color[#F3FFAD]>Shift-Click to mention]>"
    - define nameplate "<[name].on_hover[<[name_hover].separated_by[<n>]>].on_click[<[name_click]>].type[SUGGEST_COMMAND].with_insertion[@<player.name> ]>"

    # % ██ [ Check for Discord connection ] ██
    - if <player.has_flag[behr.essentials.discord.connected]>:
      - define name_hover "<[name_hover].include_single[<&color[#F3FFAD]>Discord<&color[#26FFC9]><&co> <&color[#C1F2F7]><player.flag[behr.essentials.discord.username]>]>"

    - define text_hover "<&color[#F3FFAD]>Timestamp<&color[#26FFC9]><&co> <&color[#C1F2F7]><util.time_now.format[E, MMM d, y h:mm a].replace[,].with[<&color[#26FFC9]>,<&color[#C1F2F7]>]>"
    - define message <[message].proc[chat_color_format].on_hover[<[text_hover]>].with_insertion[<[message]>]>

    - determine "<[nameplate]><&color[#C1F2F7]><&co> <[message]>"

chat_color_format:
  type: procedure
  debug: false
  definitions: text
  script:
    - if <[text].contains_text[&]>:
      - if <[text].starts_with[&]>:
        - if <color[<[text].char_at[2]>].is_truthy>:
          - define new_text <list_single[<&color[<[text].char_at[2]>]><[text].split[&].first.substring[3,999]>]>
        - else:
          - define new_text <list_single[<[text].split[&].first>]>
      - else:
        - define new_text <list_single[<[text].split[&].first>]>

      - foreach <[text].split[&].remove[first]> as:string:
        # @ hex coloring via &# prefix, eg &#FFFFFFwhite
        - if <[string].starts_with[<&ns>]> && <[string].length> > 8 && <[string].substring[2,7].matches_character_set[ABCDEFabcdef0123456789]>:
          - if <color[<[string].substring[1,7]>].is_truthy>:
            - define new_text <[new_text].include_single[<[string].substring[8,999].color[<[new_text].last.last_color.if_null[#C1F2F7]>].color[<[string].substring[1,7]>]>]>
          - else:
            - define new_text <[new_text].include_single[<[string].substring[8,999].color[<[new_text].last.last_color.if_null[#C1F2F7]>]>]>

        - else:
          - define tag <[string].char_at[1]>
          - choose <[tag]>:

        # @ standard &color-tags
            - case 0 1 2 3 4 5 6 7 8 9 a b c d e:
              - define last_format <[new_text].unseparated.last_color.if_null[<empty>]>

              - define new_text <[new_text].include_single[<&color[<[tag]>]>]>
              - foreach <bold>|<italic>|<strikethrough>|<underline> as:format:
                - if <[last_format].contains_text[<[format]>]>:
                  - define new_text <[new_text].include_single[<[format]>]>
              - define new_text <[new_text].include_single[<[string].substring[2,999]>]>

        # @ standard &format-tags
            - case l m n o:
              - if <[new_text].last.from_secret_colors.ends_with[rainbow].if_null[false]>:
                - define new_text <[new_text].remove[last].include_single[<element[<[new_text].last><&color[<[tag]>]><[string].substring[2,999]>].hex_rainbow><element[rainbow].to_secret_colors>]>
              - else:
                - define new_text <[new_text].include_single[<&color[<[tag]>]><[string].substring[2,999]>]>

        # @ return to my own white color-tag
            - case r f:
              - define new_text <[new_text].include_single[<reset><&color[#C1F2F7]><[string].substring[2,999]>]>

        # @ custom &z rainbow color-tag
            - case z:
              - define new_text <[new_text].include_single[<[string].after[z].hex_rainbow><element[rainbow].to_secret_colors>]>

        # @ custom &k comic sans color-tag
            - case k:
              - if <[new_text].last.from_secret_colors.ends_with[rainbow].if_null[false]>:
                - define new_text <[new_text].remove[last].include_single[<element[<&font[utility:comic_sans]><[new_text].last><&color[<[tag]>]><[string].substring[2,999]>].hex_rainbow><element[rainbow].to_secret_colors>]>
              - else:
                - define new_text <[new_text].include_single[<&font[utility:comic_sans]><[string].substring[2,999]>]>

        # @ default text
            - default:
              - define new_text <[new_text].include_single[<[new_text].last.last_color.if_null[<empty>]><[string]>]>

      - determine <[new_text].unseparated>

    # @ no formatting
    - else:
      - determine <[text]>

#- narrate <context.message.proc[player_chat_format]> targets:<server.online_players> from:<player.uuid>
