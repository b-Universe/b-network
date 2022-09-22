ping_command:
  type: command
  name: ping
  debug: false
  description: Shows yours, or another player's ping
  usage: /ping (player)
  permission: behr.essentials.ping
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
  # % ██ [ check if player is typing too much    ] ██
    - if <context.args.size> > 1:
      - inject command_syntax_error

  # % ██ [ check if typing another player or not ] ██
    - if <context.args.is_empty>:
      - narrate "<&[green]>Your ping is <player.ping>"

    - else:
      - define player_name <context.args.first>
      - inject player_verification
      - narrate "<&[yellow]><[player_name]><&[green]><&sq>s ping is <[player].ping>"
