command_online_player_verification:
  type: task
  debug: false
  definitions: player_name
  script:
    - define player <server.match_player[<[player_name]>].if_null[null]>
    - if !<[player].is_truthy>:
      - define message.hover "<&a>Click to insert<&co><n><&6>/<&e><context.alias.proc[command_usage].proc[command_syntax_format]><n><&c>You typed<&co> <underline>/<context.alias> <context.raw_args>"
      - if <server.match_offline_player[<[player_name]>].exists>:
        - define message.text "<&e><[player_name]> <&c>is not online"
      - else:
        - define message.text "<&e><[player_name]> <&c>is not a valid player"
      - narrate <[message.text].on_hover[<[message.hover]>].on_click[/<context.alias> ].type[suggest_command]>
      - stop

command_player_verification:
  type: task
  debug: false
  definitions: player_name
  script:
    - define player <server.match_offline_player[<[player_name]>].if_null[null]>
    - if !<[player].is_truthy>:
      - definemap message:
          hover: <&a>Click to insert<&co><n><&6>/<&e><context.alias.proc[command_usage].proc[command_syntax_format]><n><&c>You typed<&co> <underline>/<context.alias> <context.raw_args>
          text: <&e><[player_name]> <&c>is not a valid player
      - narrate <[message.text].on_hover[<[message.hover]>].on_click[/<context.alias> ].type[suggest_command]>
      - stop
