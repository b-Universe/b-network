chat_formatting:
  type: world
  events:
    on player chats:
      - determine passively cancelled
      - run player_chat def.text:<context.message>

color_test:
  type: procedure
  definitions: text
  script:
    - if <[text].contains_text[&]>:
      - define new_text <list>
      - foreach <[text].split[&]> as:string:
        - if <[loop_index]> != 1:
          # @ hex coloring via &# prefix, eg &#FFFFFFwhite
          - if <[string].starts_with[#]> && && <[string].length> > 6 && <[string].substring[2,7].matches_character_set[ABCDEFabcdef0123456789]>:
            - if <color[#<[string].substring[2,7]>].is_truthy>:
              - define new_text <[new_text].include_single[<[string].substring[7,999].color[#<[string].substring[2,7]>].no_reset>]>
            - else:
              - define new_text <[new_text].include_single[<&ns>&<[string]>]>

          - else:
            - define tag <[string].char_at[1]>
            - choose <[string].char_at[1]>:
          # @ standard &color-tags
              - case 0 1 2 3 4 5 6 7 8 9 a b c d e:
                - define new_text <[new_text].include_single[<[string].color[<[tag]>].no_reset>]>

          # @ standard &format-tags
              - case l m n o:
                - if <[new_text].last.from_secret_colors.ends_with[rainbow].if_null[false]>:
                  - define new_text <[new_text].remove[last].include_single[<element[<[new_text].last><[string].color[<[tag]>].no_reset><[string].substring[2,999]>].hex_rainbow><element[rainbow].to_secret_colors>]>
                - else:
                  - define new_text <[new_text].include_single[<[new_text].last.last_color><[string].color[<[tag]>]>]>

          # @ return to my own white color-tag
              - case r f:
                - define new_text <[new_text].include_single[<[string].substring[2,999].color[#C1F2F7]>]>

          # @ custom &z rainbow color-tag
              - case z:
                - define new_text <[new_text].include_single[<[string].after[z].hex_rainbow><element[rainbow].to_secret_colors>]>

          # @ custom &k comic sans color-tag
              - case k:
                - if <[new_text].last.from_secret_colors.ends_with[rainbow].if_null[false]>:
                  - define new_text <[new_text].include_single[<&font[utility:comic_sans]><[string].substring[2,999].hex_rainbow><element[rainbow].to_secret_colors>]>
                - else:
                  - define new_text <[new_text].include_single[<[string].substring[2,999].font[utility:comic_sans]>]>

          # @ default text
              - default:
                - define new_text <[new_text].include_single[<[new_text].last.last_color.if_null[<empty>]><[string]>]>

        - else:
          # @ include remaining text
          - define new_text <[new_text].include_single[<[string]>]>

      - determine <[new_text].unseparated>

    # @ no formatting
    - else:
      - determine <[text]>

player_chat:
  type: task
  definitions: text|player
  script:
    - define player <player> if:!<[player].exists>
    - define nameplate <&color[#F3FFAD]><[player].name>

    - define hover "<&color[#F3FFAD]>Timestamp<&color[#26FFC9]><&co> <&color[#C1F2F7]><util.time_now.format[E, MMM d, y h:mm a].replace[,].with[<&color[#26FFC9]>,<&color[#C1F2F7]>]>"
    - if <[text].contains_text[&]>:
      - define new_text <list>
      - foreach <[text].split[&]> as:string:
        - if <[loop_index]> != 1:

          # @ rainbowfy &z colortags
          - if <[string].starts_with[z]>:
            - define new_text <[new_text].include_single[<[string].after[z].hex_rainbow><element[rainbow].to_secret_colors>]>

          # @ <reset> and <white> tags are now actually <&color[#C1F2F7]> because im evil mwahahaha
          - else if <[string].starts_with[r]> || <[string].starts_with[f]>:
            - define new_text <[new_text].include_single[<&color[#C1F2F7]><[string].substring[2,999]>]>

          # @ replace &c with comics sans MWAAHAHAHAHA
          - else if <[string].starts_with[k]>:
            - if <[new_text].last.from_secret_colors.ends_with[rainbow].if_null[false]>:
              - define new_text <[new_text].include_single[<[string].substring[2,999].hex_rainbow.font[utility:comic_sans]>]>
            - else:
              - define new_text <[new_text].include_single[<[string].substring[2,999].font[utility:comic_sans]>]>

          # @ parse all other colortags normally, if theyre valid
          - else:
            - define new_text <[new_text].include_single[<[new_text].last.last_color.if_null[<empty>]><element[&<[string].char_at[1]>].parse_color><[string].substring[2,999]>]>

        - else:
          - define new_text <[new_text].include_single[<[string]>]>

      - define text <[new_text].unseparated>
    - else:
      - define text <[text]>

    - define message <[text].on_hover[<[hover]>]>

    - announce "<[nameplate]><&color[#26FFC9]><&co> <&color[#C1F2F7]><[message]>"
