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
        - narrate "<&a>Your fly speed is <&e><player.fly_speed.mul[10].round_to[2]>"
        - stop

      - case 1:
        - define speed <context.args.first>
        - if !<[speed].is_decimal>:
          - define player <server.match_offline_player[<[speed]>].if_null[invalid]>
          - if <[player]> != invalid:
            - narrate "<&e><[player].name><&a>'s fly speed is <&e><[player].fly_speed.mul[10].round_to[2]>"
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
        - narrate "<&a>You sent <&e><[player_name]><&a>'s flying at <[speed_name]><&a>!"
      - narrate targets:<[player]> "<&a>Now flying at <[speed_name]><&a>!"

    - else:
      - if <[speed]> > 10:
        - define reason "Fly speed must be below 10"
        - inject command_error

      - else if <[speed]> < 0:
        - define reason "Fly speed can't be negative"
        - inject command_error

      - else if <[speed]> == <[player].fly_speed.mul[10]>:
        - if <[player]> != <player>:
          - narrate <element[<&e>Nothing interesting happens].on_hover[<&e><[player_name]><&a>'s fly speed is already <&e><[speed]>]>
        - else:
          - narrate <element[<&e>Nothing interesting happens].on_hover[<&a>Your fly speed is already <&e><[speed]>]>
        - stop

      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
      - adjust <[player]> fly_speed:<[speed].div[10]>
      - if <[player]> != <player>:
        - narrate "<&e><[player_name]><&a>'s fly speed set to <&e><[speed]>"
      - narrate targets:<[player]> "<&a>Fly speed set to <&e><[speed]>"
