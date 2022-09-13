fly_command:
  type: command
  name: fly
  debug: false
  description: Grants flight to yourself or another player
  usage: /fly (player)
  permission: behr.essentials.fly
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
    - if <context.args.size> > 1:
      - inject command_syntax_error

    - if <context.args.is_empty>:
      - define player <player>
    - else:
      - define player_name <context.args.first>
      - inject player_verification

    - adjust <[player]> can_fly:<[player].can_fly.not>
    - if <[player]> != <player>:
      - if <[player].can_fly>:
        - narrate "<&[yellow]><[player_name]><&[green]>'s flight enabled"
        - narrate "<&[green]>Flight enabled" targets:<[player]>
      - else:
        - narrate "<&[yellow]><[player_name]><&[green]>'s flight disabled"
        - narrate "<&[green]>Flight disabled" targets:<[player]>
    - else:
      - if <player.can_fly>:
        - narrate "<&[green]>Flight enabled"
      - else:
        - narrate "<&[green]>Flight disabled"
