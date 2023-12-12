fly_command:
  type: command
  name: fly
  debug: false
  description: Toggles flight to yourself or another player
  usage: /fly (player)
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
    - if <context.args.size> > 1:
      - inject command_syntax_error

    - if <context.args.is_empty>:
      - define player <player>
    - else:
      - define player_name <context.args.first>
      - inject command_player_verification

    - adjust <[player]> can_fly:<[player].can_fly.not>
    - if <[player]> != <player>:
      - if <[player].can_fly>:
        - narrate "<&e><[player_name]><&a>'s flight enabled"
        - narrate "<&a>Flight enabled" targets:<[player]>
      - else:
        - narrate "<&e><[player_name]><&a>'s flight disabled"
        - narrate "<&a>Flight disabled" targets:<[player]>
    - else:
      - if <player.can_fly>:
        - narrate "<&a>Flight enabled"
      - else:
        - narrate "<&a>Flight disabled"
