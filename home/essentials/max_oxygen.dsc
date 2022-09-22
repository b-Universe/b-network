max_oxygen_command:
  type: command
  name: max_oxygen
  debug: false
  description: Changes another player or your maximum oxygen capacity in seconds
  usage: /max_oxygen (player) <&lt><&ns>/default<&gt>
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name].include[default]>
    2: default
  script:
    - if <context.args.is_empty> || <context.args.size> > 2:
      - inject command_syntax_error

    - else if <context.args.size> == 2:
      - define player_name <context.args.first>
      - inject player_verification
      - define oxygen <context.args.last>

    - else if <context.args.size> == 1:
      - define player <player>
      - define oxygen <context.args.first>

    - if !<[oxygen].is_integer>:
      - define reason "Oxygen must be a number"
      - inject command_error

    - else if <[oxygen]> > 2000:
      - define reason "Oxygen must be set below 2000"
      - inject command_error

    - else if <[oxygen]> < 0:
      - define reason "Oxygen must be at or above 0"
      - inject command_error

    - else if <[oxygen].contains[.]>:
      - define reason "Oxygen cannot be a decimal"
      - inject command_error

    - if <[player].max_oxygen.in_seconds> > <[oxygen]>:
      - oxygen <[oxygen].mul[20]> type:maximum player:<[player]>
      - oxygen <[oxygen].mul[20]> mode:set player:<[player]>
      - if <[player]> != <player>:
        - narrate "<&[green]><[player_name]><&sq>s maximum oxygen was deflated"
      - narrate "<&[red]>Your oxygen deflates and is now lower capacity" targets:<[player]>

    - else:
      - oxygen <[oxygen].mul[20]> mode:maximum player:<[player]>
      - oxygen <[oxygen].mul[20]> mode:set player:<[player]>
      - if <[player]> != <player>:
        - narrate "<&[yellow]><[player_name]><&[green]><&sq>s maximum oxygen was inflated"
      - narrate "<&[red]>Your oxygen replenishes and is now higher capacity" targets:<[player]>
