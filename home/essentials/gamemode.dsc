gamemode_command:
  type: command
  name: gamemode
  debug: false
  description: Adjusts another user or your gamemode
  usage: /gamemode (player) <&lt>adventure|creative|spectator|survival<&gt>
  permission: behr.essentials.gamemode
  tab completions:
    1: <server.online_players.parse[name].exclude[<player.name>].include[<list[adventure|creative|spectator|survival].exclude[<player.gamemode>]>]>
    2: <list[adventure|creative|spectator|survival].exclude[<server.match_player[<context.args.first>].gamemode.if_null[invalid]>]>
  aliases:
    - gma
    - gmc
    - gms
    - gmsp
  script:
  # % ██ [ check if using too many arguments      ] ██
    - if <context.args.size> > 2:
      - define reason "Too many arguments"
      - inject command_error

  # % ██ [ check if not using arguments at all    ] ██
    - if <context.args.is_empty>:

  # % ██ [ check if using a shorthand alias       ] ██
      - define alias_map <map[gma=adventure;gmc=creative;gms=survival;gmsp=spectator]>
      - define gamemode <[alias_map].get[<context.alias>]>
      - if !<context.alias.advanced_matches[<[alias_map].keys>]>:
        - narrate "<&[red]>Invalid gamemode, you want any of <list[adventure|creative|spectator|survival].exclude[<player.gamemode>].parse[to_titlecase].separated_by[/]>"
        - stop

  # % ██ [ check if already in the gamemode       ] ██
      - if <player.gamemode.advanced_matches[<[gamemode]>]>:
        - narrate "<&[green]>You're already in <&[yellow]><[gamemode].to_titlecase>"
        - stop

  # % ██ [ change the gamemode, tell the player   ] ██
      - adjust <player> gamemode:<[gamemode]>
      - narrate "<&[green]>Set gamemode to <&[yellow]><[gamemode].to_titlecase>"
      - stop

  # % ██ [ check if using another player          ] ██
    - else if <context.args.size> == 2:
      - define player_name <context.args.first>

  # % ██ [ check if the player is truthy          ] ██
      - inject offline_player_verification
    - else:
      - define player <player>

  # % ██ [ check if using a valid gamemode         ] ██
    - define gamemode <context.args.last>
    - if !<[gamemode].advanced_matches[adventure|creative|spectator|survival]>:
      - narrate "<&[red]>Invalid gamemode, you want any of <&[yellow]><list[adventure|creative|spectator|survival].exclude[<[player].gamemode>].parse[to_titlecase].separated_by[/]>"
      - stop

  # % ██ [ check if already in the gamemode        ] ██
    - if <[player].gamemode> == <[gamemode]>:
      - if <[player]> != <player>:
        - narrate "<&[red]><[player_name]> is already in <&[yellow]><[gamemode].to_titlecase>"
      - else:
        - narrate "<&[green]>You're already in <&[yellow]><[gamemode].to_titlecase>"
      - stop

  # % ██ [ change the gamemode, tell the player(s) ] ██
    - adjust <[player]> gamemode:<[gamemode]>
    - if <[player]> != <player>:
      - narrate "<&[green]><player.name> set your gamemode to <&[yellow]><[gamemode].to_titlecase>"
    - narrate "<&[green]>Set gamemode to <&[yellow]><[gamemode].to_titlecase>"
