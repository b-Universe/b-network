command_error:
  type: task
  debug: false
  definitions: reason
  script:
    - define text <[reason].color_gradient[from=#aa0000;to=#ee0000;style=rgb]>
    - define hover "<list_single[<&[red]>You typed<&co> <&[yellow]><underline>/<context.alias> <context.raw_args>]>"
    - define hover "<[hover].include_single[<&[green]>Click to insert<&co>]>"
    - define hover <[hover].include_single[<context.alias.proc[command_usage].proc[command_syntax_format]>]>
    - narrate <[text].on_hover[<[hover].separated_by[<n>]>].on_click[/<context.alias>].type[suggest_command]>
    - stop

command_syntax_error:
  type: task
  debug: false
  script:
    - define text "<element[Command syntax<&co>].color_gradient[from=#aa0000;to=#ee0000;style=rgb]> <context.alias.proc[command_usage].proc[command_syntax_format]>"
    - define hover "<list_single[<&[red]>You typed<&co> <&[yellow]><underline>/<context.alias> <context.raw_args>]>"
    - define hover "<[hover].include_single[<&[green]>Click to insert<&co>]>"
    - define hover <[hover].include_single[<context.alias.proc[command_usage].proc[command_syntax_format]>]>
    - narrate "<[text].on_hover[<[hover].separated_by[<n>]>].on_click[/<context.alias> ].type[suggest_command]>"
    - stop

command_usage:
  type: procedure
  definitions: alias
  script:
    - if <script[<[alias]>_command].exists>:
      - determine <script[<[alias]>_command].parsed_key[usage]>
    - else:
      - determine <util.scripts.filter[data_key[aliases].contains_text[<[alias]>]].first.parsed_key[usage].if_null[invalid]>

command_syntax_format:
  type: procedure
  debug: false
  definitions: text
  script:
    - define text <[text].color_gradient[from=#e6e600;to=#ffff1a;style=rgb]>
    - foreach (|)|<&lb>|<&rb>|<&gt>|<&lt>|/|-|<&ns> as:symbol:
      - define text <[text].replace_text[<[symbol]>].with[<&color[#ffb84d]><[symbol]>]>
    - determine <[text]>

offline_player_verification:
  type: task
  definitions: player_name
  script:
    - if !<server.match_offline_player[<[player_name]>].if_null[null].is_truthy>:
      - define text "<&[yellow]><[player_name]> <&[red]>does not match a valid player"
      - define hover "<&[red]>You entered<&co> <&[yellow]><underline>/<context.alias> <context.raw_args>"
      - narrate <[text].on_hover[<[hover]>]>
      - stop
    - else:
      - define player <server.match_offline_player[<[player]>]>

player_verification:
  type: task
  definitions: player_name
  script:
    - if !<server.match_player[<[player_name]>].if_null[null].is_truthy>:
      - if !<server.match_offline_player[<[player_name]>].if_null[null].is_truthy>:
        - define text "<&[yellow]><[player_name]> <&[red]>does not match a valid player"
      - else:
        - define text "<&[yellow]><[player_name]> <&[red]>is not or did not match a valid player"
      - define hover "<&[red]>You entered<&co> <&[yellow]><underline>/<context.alias> <context.raw_args>"
      - narrate <[text].on_hover[<[hover]>]>
      - stop
    - else:
      - define player <server.match_offline_player[<[player]>]>
