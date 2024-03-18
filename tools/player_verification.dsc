command_online_player_verification:
  type: task
  debug: false
  definitions: player_name
  script:
    - define player <server.match_player[<[player_name]>].if_null[null]>
    - if !<[player].is_truthy>:
      - define message.hover "<&[green]>Click to insert<&co><n><&6>/<&[yellow]><context.alias.proc[command_usage].proc[command_syntax_format]><n><&[red]>You typed<&co> <underline>/<context.alias> <context.raw_args>"
      - if <server.match_offline_player[<[player_name]>].exists>:
        - define message.text "<&[yellow]><[player_name]> <&[red]>is not online"
      - else:
        - define message.text "<&[yellow]><[player_name]> <&[red]>is not a valid player"
      - narrate <[message.text].on_hover[<[message.hover]>].on_click[/<context.alias> ].type[suggest_command]>
      - stop

command_player_verification:
  type: task
  debug: false
  definitions: player_name
  script:
    - define player <server.match_offline_player[<[player_name]>].if_null[null]>
    - if <[player].name.length> != <[player_name].length>:
      - definemap message:
          hover: <&[green]>Click to insert<&co><n><&6>/<&[yellow]><context.alias.proc[command_usage].proc[command_syntax_format]><n><&[red]>You typed<&co> <underline>/<context.alias> <context.raw_args>
          text: <&[yellow]><[player_name]> <&[red]>is not a valid player or may be too short of input
      - narrate <[message.text].on_hover[<[message.hover]>].on_click[/<context.alias> ].type[suggest_command]>
      - stop

    - if <[player]> == null:
      - definemap message:
          hover: <&[green]>Click to insert<&co><n><&6>/<&[yellow]><context.alias.proc[command_usage].proc[command_syntax_format]><n><&[red]>You typed<&co> <underline>/<context.alias> <context.raw_args>
          text: <&[yellow]><[player_name]> <&[red]>is not a valid player
      - narrate <[message.text].on_hover[<[message.hover]>].on_click[/<context.alias> ].type[suggest_command]>
      - stop
