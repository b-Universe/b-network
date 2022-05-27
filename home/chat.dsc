chat_formatting:
  type: world
  events:
    on player chats:
      - determine passively cancelled
      - run player_chat def.text:<context.message>

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
