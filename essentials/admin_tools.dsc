
prevent_aggro_handler:
  type: world
  debug: false
  events:
    on monster|slime|magma_cube|shulker|phantom targets player flagged:behr.essentials.aggro_disabled:
      - determine cancelled

aggro_command:
  type: command
  debug: false
  name: aggro
  usage: /aggro (player)
  description: Toggles mob aggro for you or another player
  aliases:
    - /aggro
  tab complete:
    - if <player.has_flag[behr.essentials.aggro_disabled]>:
      - actionbar "<&[yellow]>Aggro is currently <&[red]>disabled"
    - else:
      - actionbar "<&[yellow]>Aggro is currently <&[green]>enabled"
    - if <context.args.size> < 2 && <context.args.last.if_null[]> != <empty>
    - determine <server.players.exclude[<player>].parse[name].filter[starts_with[<context.args.first.if_null[]>]]>
  script:
  # % ██ [ check if typing arguments                ] ██:
    - if <context.args.size> > 1:
      - inject command_syntax_error

    - if <context.args.is_empty>:
      - define player <player>
    - else:
      - define player_name <context.args.first>
      - inject command_player_verification

  # % ██ [ change the server's debug mode           ] ██:
    - if <[player].has_flag[behr.essentials.aggro_disabled]>:
      - flag <[player]> behr.essentials.aggro_disabled:!
      - if <[player]> != <player>:
        - narrate "<&[green]>Mob aggro enabled for <[player_name]>"
      - narrate "<&[green]>Mob aggro enabled" targets:<[player]>

    - else:
      - flag <[player]> behr.essentials.aggro_disabled
      - if <[player]> != <player>:
        - narrate "<&[green]>Mob aggro disabled for <[player_name]>"
      - narrate "<&[green]>Mob aggro disabled" targets:<[player]>
