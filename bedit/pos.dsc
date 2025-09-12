bedit_pos_command:
  type: command
  debug: false
  enabled: true
  name: bpos1
  usage: /bpos1 / /bpos2 (move (<&ns>)/direction (<&ns>)/clear)
  aliases:
    - bpos2
  description: Sets your selection position
  tab completions:
    1: move|forward|forward_flat|backward|backward_flat|left|right|north|northeast|east|southeast|south|southwest|west|cursor_on|up|above|down|below
    # <context.location.if_null[<player.cursor_on[100].if_null[<player.location.forward[20]>].round>]>
  sub_script:
    syntax_error:
      - define reason "Available directions are <[directions].keys.comma_separated> and miscellaneous directions are <[miscellaneous_directions].keys.comma_separated>"
      - inject command_error

    check_for_selection:
      - foreach left|right:
        - if <player.has_flag[behr.essentials.bedit.selection.<[value]>]>:
          - define origin_location <player.flag[behr.essentials.bedit.selection.<[position]>.location]>
          - foreach stop

        - else if <[position]> == <[value]>:
          - define origin_location <player.location>
          - foreach stop

        - else if <[args].first> == move:
          - define reason "No <[value]> position active"
          - inject command_error

  script:
    - define args <context.args>

    - if <context.alias> == bpos1:
      - define position left
    - else:
      - define position right
    - define directions <script[bedit_directions].data_key[directions]>
    - define miscellaneous_directions <script[bedit_directions].data_key[miscellaneous_directions]>

    - choose <[args].size>:
      # /pos1 / /pos2
      - case 0:
        - define location <player.location.round_down.with_yaw[0].with_pitch[0]>

      - case 1:
        - choose <[args].first>:
          - case move:
            - define location <[origin_location].forward[1]>

          - case forward backward left right forward_flat backward_flat up down above below cursor_on:
            - inject bedit_pos_command.sub_script.check_for_selection
            - define distance 1
            - define location <[miscellaneous_directions].get[<[args].first>].parsed>

          - case north northeast east southeast south southwest west northwest:
            - inject bedit_pos_command.sub_script.check_for_selection
            - define offset <script[bedit_directions].data_key[directions].get[<[args].first>].as[location]>
            - define location <[origin_location].add[<[offset]>]>

          - case clear:
            - run bedit_clear_selections def:selection
            - stop

          - default:
            - inject bedit_pos_command.sub_script.syntax_error

      - case 2:
        - inject bedit_pos_command.sub_script.check_for_selection

        - define direction <[args].first>
        - define distance <[args].last>
        - if !<[distance].is_decimal>:
          - if <[direction]> == move:
            - choose <[distance]>:
              - case forward backward left right forward_flat backward_flat up down above below:
                - define location <[miscellaneous_directions].get[<[args].first>].parsed>

              - case north northeast east southeast south southwest west northwest:
                - define offset <[directions].get[<[args].first>].as[location].mul[<[distance]>]>
                - define location <[origin_location].add[<[offset]>]>

              - default:
                - inject bedit_pos_command.sub_script.syntax_error

          - else:
            - define reason "Distance has to be a number"
            - inject command_error

        - else:
          - if <[direction]> !in <[directions]>:
            - if <[direction]> !in <[miscellaneous_directions]>:
              - if <[direction]> == move:
                - define location <[origin_location].forward[<[distance]>].round_down.with_yaw[0].with_pitch[0]>

              - else:
                - inject bedit_pos_command.sub_script.syntax_error

            - else:
              - define location <script[bedit_directions].parsed_key[miscellaneous_directions.<[direction]>]>

          - else:
            - define offset <[directions].get[<[direction]>].as[location].mul[<[distance]>]>
            - define location <[origin_location].add[<[offset]>]>

      - case 3:
        - if <[args].first> != move:
          - inject command_syntax_error

        - inject bedit_pos_command.sub_script.check_for_selection

        - define distance <[args].last>
        - if !<[distance].is_decimal>:
          - define reason "Distance has to be a number"
          - inject command_error

        - define direction <[args].get[2]>

        - if <[direction]> in <[directions]>:
          - define offset <[directions].get[<[direction]>].as[location].mul[<[distance]>]>
          - define location <[origin_location].add[<[offset]>]>

        - else if <[distance]> in <[miscellaneous_directions]>:
          - define location <[miscellaneous_directions].get[<[direction]>].parsed>

        - else:
          - inject bedit_pos_command.sub_script.syntax_error

      - default:
        - inject bedit_pos_command.sub_script.syntax_error

    - define color <[location].map_color>
    - inject bedit_set_position
