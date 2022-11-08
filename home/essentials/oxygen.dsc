oxygen_command:
  type: command
  name: oxygen
  debug: false
  description: Replinishes or deflates a player<&sq>s oxygen, or your own
  usage: /oxygen (player) <&lt>0-20<&gt>
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>\
  permission: behr.essentials.oxygen
  script:
    - if <context.args.is_empty>:
      - oxygen <player.max_oxygen.sub[<player.oxygen.in_ticks>]> mode:add
      - narrate "<&[green]>Your oxygen was replenished"
      - stop

    - else if <context.args.size> > 2:
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

    - if <[oxygen]> > 20:
      - define reason "Oxygen must be set below 20"
      - inject command_error

    - else if <[oxygen]> < 0:
      - define reason "Oxygen must be at or above 0"
      - inject command_error

    - if <[oxygen].contains[.]>:
      - define reason "Oxygen cannot be a decimal"
      - inject command_error

    - if <[player].oxygen.in_ticks> > <[oxygen].mul[20]>:
      - oxygen <[player].oxygen.in_ticks.sub[<[oxygen].mul[20]>]> mode:remove player:<[player]>
      - if <[player]> != <player>:
        - narrate "<&[green]><[player].name><&sq>s oxygen was deflated"
      - narrate "<&[red]>Your oxygen was deflated" targets:<[player]>

    - else:
      - oxygen <[oxygen].mul[20].sub[<[player].oxygen.in_ticks>]> mode:add player:<[player]>
      - if <[player]> != <player>:
        - narrate "<&[yellow]><[player].name><&[green]><&sq>s oxygen was replenished"
      - narrate "<&[red]>Your oxygen was replenished" targets:<[player]>
