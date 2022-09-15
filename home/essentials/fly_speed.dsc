fly_speed_command:
  type: command
  debug: false
  name: fly_speed
  usage: /fly_speed (player) <&lt>speed<&gt>
  description: Changes yours or another player<&dq>s fly speed
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
    - if <context.args.is_empty>:
      - narrate "<&[green]>Your fly speed is <&[yellow]><player.fly_speed.mul[10].round_to[2]>"
      - stop

    - else if <context.args.size> > 2:
      - inject command_syntax_error

    - else if <context.args.size> == 2:
      - define player_name <context.args.first>
      - inject player_verification

      - define speed <context.args.last>

    - else if <context.args.size> == 1:
      - if <server.match_player[<context.args.first>].if_null[null].is_truthy>:
        - narrate "<&[yellow]><server.match_player[<context.args.first>].name><&[green]>'s fly speed is <&[yellow]><player.fly_speed.mul[10].round_to[2]>"
        - stop
      - else:
        - define player <player>
        - define speed <context.args.first>

    - if !<[speed].is_decimal>:
      - choose <[speed]>:
        - case lightspeed:
          - define speed 6
          - define speed_name <&b>Lightspeed

        - case ludicrous:
          - define speed 8
          - define speed_name "<&b><italic><bold>Ludicrous speed"

        - case plaid:
          - define speed 10
          - define speed_name "<element[Plaid speed].rainbow[ca]>"

        - default:
          - inject command_syntax_error

      - adjust <[player]> fly_speed:<[speed]>
      - if <[player]> != <player>:
        - narrate "<&[green]>You sent <&[yellow]><[player_name]><&[green]>'s flying at <[speed_name]><&a>!"
      - narrate targets:<[player]> "<&[green]>Now flying at <[speed_name]><&a>!"

    - else:
      - if <[speed]> > 10:
        - define reason "Fly speed must be below 10"
        - inject command_error

      - else if <[speed]> < 0:
        - define reason "Fly speed can't be negative"
        - inject command_error

      - else if <[speed]> == <[player].fly_speed.mul[10]>:
        - if <[player]> != <player>:
          - narrate "<element[<&[yellow]>Nothing interesting happens].on_hover[<&[yellow]><[player_name]><&[green]>'s fly speed is already <&[yellow]><[speed]>]>"
        - else:
          - narrate "<element[<&[yellow]>Nothing interesting happens].on_hover[<&[green]>Your fly speed is already <&[yellow]><[speed]>]>"
        - stop

      - adjust <[player]> fly_speed:<[speed].div[10]>
      - if <[player]> != <player>:
        - narrate "<&[yellow]><[player_name]><&[green]>'s fly speed set to <&[yellow]><[speed]>"
      - narrate targets:<[player]> "<&[green]>Fly speed set to <&[yellow]><[speed]>"
