chat_formatting:
  type: world
  debug: false
  events:
    on player chats:
      - announce to_console "<&6><&lb><&e>Event<&6><&co> <&a>player chats<&6><&rb> <&b>| <&6><&lt><&e>context<&6>.<&e>message<&6><&gt> <&b>| <&a><context.message>"
      - determine passively cancelled
      - narrate <context.message.proc[player_chat_format]> targets:<server.online_players> from:<player.uuid>

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
    - define nameplate "<[name].on_hover[<[name_hover].separated_by[<n>]>].on_click[<[name_click]>].type[SUGGEST_COMMAND].with_insertion[<&at><player.name> ]>"

    # % ██ [ Check for Discord connection ] ██
    - if <player.has_flag[behr.essentials.discord.connected]>:
      - define name_hover "<[name_hover].include_single[<&color[#F3FFAD]>Discord<&color[#26FFC9]><&co> <&color[#C1F2F7]><player.flag[behr.essentials.discord.username]>]>"

    - define text_hover "<&color[#F3FFAD]>Timestamp<&color[#26FFC9]><&co> <&color[#C1F2F7]><util.time_now.format[E, MMM d, y h:mm a].replace[,].with[<&color[#26FFC9]>,<&color[#C1F2F7]>]>"
    - define message <[message].proc[chat_color_format].on_hover[<[text_hover]>].with_insertion[<[message]>]>

    - determine "<[nameplate]><&color[#C1F2F7]><&co> <[message]>"

chat_color_format:
  type: procedure
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
