friend_command:
  type: command
  name: friend
  debug: false
  description: Adds or removes a player to or from your friends list
  usage: /friend <&lt>player<&gt> (remove)
  permission: behr.essentials.friend
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
    2: remove
  script:
  # % ██ [ check if typing nothing                ] ██
    - if <context.args.is_empty>:
      - if <player.has_flag[behr.essentials.friends]>:
        - narrate "<&[green]>You have <&[yellow]><player.flag[behr.essentials.friends].size> <&[green]>friends<&co><n><player.flag[behr.essentials.friends].parse_tag[<&e>- <&[green]><[parse_value].name>].separated_by[<n>]>"
      - else:
        - narrate "<&[green]>You have no friends"
      - stop

  # % ██ [ check if typing too many arguments     ] ██
    - else if <context.args.size> > 2:
      - inject command_syntax_error

  # % ██ [ check the player being used            ] ██
    - else if !<context.args.is_empty>:
      - define player_name <context.args.first>
      - inject offline_player_verification

  # % ██ [ check if removing from friends list    ] ██
    - if <context.args.size> == 2:
      - if !<list[remove|delete|defriend].contains[<context.args.last]>>:
        - inject command_syntax_error

  # % ██ [ check if removing someone not a friend ] ██
      - else if !<player.flag[behr.essentials.friends].contains[<[player]>]>:
        - narrate "<&[yellow]><[player_name]> <&[red]>isn<&sq>t on your friends list"

  # % ██ [ remove a friend from friends list      ] ██
      - else:
        - flag <player> behr.essentials.friends.<[player]>:!
        - narrate "<&[green]>Removed <&[yellow]><[player_name]> <&[green]>from your friends list"

  # % ██ [ check if player is already a friend    ] ██
    - else:
      - if <player.flag[behr.essentials.friends].contains[<[player]>]>:
        - narrate "<&[yellow]><[player_name]> <&[red]>is already on your friends list"

  # % ██ [ add a new friend to friends list       ] ██
      - else:
        - flag player behr.essentials.friends.<[player]>:<util.time_now>
        - narrate "<&[yellow]>Added<[player_name]> <&g[green]>to your friends list"
        - if <[player].flag[behr.essentials.friends].contains[<player>]>:
          - narrate "<&[green]>You're already on their friends list"
