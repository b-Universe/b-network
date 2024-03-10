fly_speed_command:
  type: command
  debug: false
  name: fly_speed
  usage: /fly_speed (player) <&lt>speed<&gt>
  description: Changes yours or another player<&dq>s fly speed
  tab completions:
    1: <server.players.exclude[<player>].parse[name]>
  script:
    - choose <context.args.size>:
      - case 0:
        - narrate "<&[green]>Your fly speed is <&[yellow]><player.fly_speed.mul[10].round_to[2]>"
        - stop

      - case 1:
        - define speed <context.args.first>
        - if !<[speed].is_decimal>:
          - define player <server.match_offline_player[<[speed]>].if_null[invalid]>
          - if <[player]> != invalid:
            - narrate "<&[yellow]><[player].name><&[green]>'s fly speed is <&[yellow]><[player].fly_speed.mul[10].round_to[2]>"
            - stop

          - else:
            - define reason "Fly speed must be a number"
            - inject command_error

        - else:
          - define player <player>

      - case 2:
        - define player_name <context.args.first>
        - inject command_player_verification

        - define speed <context.args.last>

      - default:
        - inject command_syntax_error

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
          - define speed_name <element[Plaid speed].rainbow[ca]>

        - default:
          - inject command_syntax_error

      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
      - adjust <[player]> fly_speed:<[speed]>
      - if <[player]> != <player>:
        - narrate "<&[green]>You sent <&[yellow]><[player_name]><&[green]>'s flying at <[speed_name]><&[green]>!"
      - narrate targets:<[player]> "<&[green]>Now flying at <[speed_name]><&[green]>!"

    - else:
      - if <[speed]> > 10:
        - define reason "Fly speed must be below 10"
        - inject command_error

      - else if <[speed]> < 0:
        - define reason "Fly speed can't be negative"
        - inject command_error

      - else if <[speed]> == <[player].fly_speed.mul[10]>:
        - if <[player]> != <player>:
          - narrate <element[<&[yellow]>Nothing interesting happens].on_hover[<&[yellow]><[player_name]><&[green]>'s fly speed is already <&[yellow]><[speed]>]>
        - else:
          - narrate <element[<&[yellow]>Nothing interesting happens].on_hover[<&[green]>Your fly speed is already <&[yellow]><[speed]>]>
        - stop

      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
      - adjust <[player]> fly_speed:<[speed].div[10]>
      - if <[player]> != <player>:
        - narrate "<&[yellow]><[player_name]><&[green]>'s fly speed set to <&[yellow]><[speed]>"
      - narrate targets:<[player]> "<&[green]>Fly speed set to <&[yellow]><[speed]>"
