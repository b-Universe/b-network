teleport_command:
  type: command
  name: teleport
  debug: false
  usage: /teleport (player) / X Y Z (world)
  description: Teleports you to another destination
  script:
    - choose <context.args.size>:
      # /teleport (player)
      # /teleport (world)
      - case 1:
        - if <context.args.first> in <server.worlds.parse[name]>:
          - define world_name <context.args.first>
          - define location <world[<[world_name]>].spawn_location>
          - teleport <player> <[location]>
          - narrate "<&a>Teleported you to <&e><[world_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)"

        - else:
          - define player_name <context.args.first>
          - define player <server.match_player[<[player_name]>].if_null[null]>
          - if <[player]> == <player>:
            - narrate "<&e>Nothing interesting happens"
            - stop

          - if !<[player].is_truthy>:
            - define message.hover "<&a>Click to insert<&co><n><&6>/<&e><context.alias.proc[command_usage].proc[command_syntax_format]><n><&c>You typed<&co> <underline>/<context.alias> <context.raw_args>"
            - if <server.match_offline_player[<[player_name]>].exists>:
              - define message.text "<&e><[player_name]> <&c>is not online"
            - else:
              - define message.text "<&e><[player_name]> <&c>is not a valid player or world name"
            - narrate <[message.text].on_hover[<[message.hover]>].on_click[/<context.alias> ].type[suggest_command]>
            - stop

          - define location <[player].location>
          - teleport <player> <[location]>
          - narrate "<&a>Teleported you to <&e><[player_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)"

      # /teleport (player one) (player two/world)
      - case 2:
        - define player_one_name <context.args.first>
        - define player_one <server.match_player[<[player_one_name]>].if_null[null]>
        - if !<[player_one].is_truthy>:
          - define message.hover "<&a>Click to insert<&co><n><&6>/<&e><context.alias.proc[command_usage].proc[command_syntax_format]><n><&c>You typed<&co> <underline>/<context.alias> <context.raw_args>"
          - if <server.match_offline_player[<[player_one_name]>].exists>:
            - define message.text "<&e><[player_one_name]> <&c>is not online"
          - else:
            - define message.text "<&e><[player_one_name]> <&c>is not a valid player"
          - narrate <[message.text].on_hover[<[message.hover]>].on_click[/<context.alias> ].type[suggest_command]>
          - stop

        - if <context.args.last> in <server.worlds.parse[name]>:
          - define world_name <context.args.first>
          - define location <world[<[world_name]>].spawn_location>
          - teleport <[player_one]> <[location]>
          - narrate "<&a>Teleported you to <&e><[world_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)" targets:<[player_one]>
          - if <[player_one]> != <player>:
            - narrate "<&a>Teleported <&e><[player_one_name]> <&a>to <&e><[world_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)" targets:<[player_one]>

        - else:
          - define player_two_name <context.args.last>
          - define player_two <server.match_player[<[player_two_name]>].if_null[null]>
          - if <[player_one]> == <[player_two]>:
            - narrate "<&e>Nothing interesting happens"
            - stop

          - if !<[player_two].is_truthy>:
            - define message.hover "<&a>Click to insert<&co><n><&6>/<&e><context.alias.proc[command_usage].proc[command_syntax_format]><n><&c>You typed<&co> <underline>/<context.alias> <context.raw_args>"
            - if <server.match_offline_player[<[player_two_name]>].exists>:
              - define message.text "<&e><[player_two_name]> <&c>is not online"
            - else:
              - define message.text "<&e><[player_two_name]> <&c>is not a valid player or world name"
            - narrate <[message.text].on_hover[<[message.hover]>].on_click[/<context.alias> ].type[suggest_command]>
            - stop

          - define location <[player_two].location>
          - teleport <[player_one]> <[location]>
          - narrate "<&a>Teleported you to <&e><[player_two_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)" targets:<[player_one]>
          - if <[player_one]> != <player>:
            - narrate "<&a>Teleported <&e><[player_one_name]> <&a>to <&e><[player_two_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)"

      # /teleport x y z
      - case 3:
        - define x <context.args.first>
        - if !<[x].is_decimal>:
          - define reason "<[x]> is an invalid coordinate"
          - inject command_error

        - define y <context.args.get[2]>
        - if !<[y].is_decimal>:
          - define reason "<[y]> is an invalid coordinate"
          - inject command_error

        - define z <context.args.last>
        - if !<[z].is_decimal>:
          - define reason "<[z]> is an invalid coordinate"
          - inject command_error

        - define world_name <player.world.name>
        - define location <location[<[x]>,<[y]>,<[z]>,<[world_name]>]>
        - teleport <player> <[location]>
        - narrate "<&a>Teleported you to <&e><[world_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)"

      # /teleport player x y z
      # /teleport x y z world
      - case 4:
        - if !<context.args.first.is_decimal>:
          - define player_name <context.args.first>
          - define player <server.match_player[<[player_name]>].if_null[null]>
          - if !<[player].is_truthy>:
            - define message.hover "<&a>Click to insert<&co><n><&6>/<&e><context.alias.proc[command_usage].proc[command_syntax_format]><n><&c>You typed<&co> <underline>/<context.alias> <context.raw_args>"
            - if <server.match_offline_player[<[player_name]>].exists>:
              - define message.text "<&e><[player_name]> <&c>is not online"
            - else:
              - define message.text "<&e><[player_name]> <&c>is not a valid player or coordinate"
            - narrate <[message.text].on_hover[<[message.hover]>].on_click[/<context.alias> ].type[suggest_command]>
            - stop

          - define x <context.args.get[2]>
          - if !<[x].is_decimal>:
            - define reason "<[x]> is an invalid coordinate"
            - inject command_error

          - define y <context.args.get[3]>
          - if !<[y].is_decimal>:
            - define reason "<[y]> is an invalid coordinate"
            - inject command_error

          - define z <context.args.last>
          - if !<[z].is_decimal>:
            - define reason "<[z]> is an invalid coordinate"
            - inject command_error

          - define world_name <[player].world.name>
          - define location <location[<[x]>,<[y]>,<[z]>,<[world_name]>]>
          - teleport <[player]> <[location]>
          - if <[player]> != <player>:
            - narrate "<&a>Teleported <&e><[player_name]> <&a>to <&e><[world_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)"
          - narrate "<&a>Teleported you to <&e><[world_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)" targets:<[player]>

        - else:
          - define x <context.args.first>
          - if !<[x].is_decimal>:
            - define reason "<[x]> is an invalid coordinate"
            - inject command_error

          - define y <context.args.get[2]>
          - if !<[y].is_decimal>:
            - define reason "<[y]> is an invalid coordinate"
            - inject command_error

          - define z <context.args.get[3]>
          - if !<[z].is_decimal>:
            - define reason "<[z]> is an invalid coordinate"
            - inject command_error

          - define world_name <context.args.last>
          - if !<[world_name]> in <server.worlds.parse[name]>::
            - define reason "<[world_name]> is an invalid world"
            - inject command_error

          - define location <location[<[x]>,<[y]>,<[z]>,<[world_name]>]>
          - teleport <player> <[location]>
          - narrate "<&a>Teleported you to <&e><[world_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)"

      # /teleport player x y z world
      - case 5:
        - if !<context.args.first.is_decimal>:
          - define player_name <context.args.first>
          - define player <server.match_player[<[player_name]>].if_null[null]>
          - if !<[player].is_truthy>:
            - define message.hover "<&a>Click to insert<&co><n><&6>/<&e><context.alias.proc[command_usage].proc[command_syntax_format]><n><&c>You typed<&co> <underline>/<context.alias> <context.raw_args>"
            - if <server.match_offline_player[<[player_name]>].exists>:
              - define message.text "<&e><[player_name]> <&c>is not online"
            - else:
              - define message.text "<&e><[player_name]> <&c>is not a valid player or coordinate"
            - narrate <[message.text].on_hover[<[message.hover]>].on_click[/<context.alias> ].type[suggest_command]>
            - stop

          - define x <context.args.get[2]>
          - if !<[x].is_decimal>:
            - define reason "<[x]> is an invalid coordinate"
            - inject command_error

          - define y <context.args.get[3]>
          - if !<[y].is_decimal>:
            - define reason "<[y]> is an invalid coordinate"
            - inject command_error

          - define z <context.args.get[4]>
          - if !<[z].is_decimal>:
            - define reason "<[z]> is an invalid coordinate"
            - inject command_error

          - define world_name <context.args.last>
          - if !<[world_name]> in <server.worlds.parse[name]>::
            - define reason "<[world_name]> is an invalid world"
            - inject command_error

          - define location <location[<[x]>,<[y]>,<[z]>,<[world_name]>]>
          - teleport <[player]> <[location]>
          - if <[player]> != <player>:
            - narrate "<&a>Teleported <&e><[player_name]> <&a>to <&e><[world_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)"
          - narrate "<&a>Teleported you to <&e><[world_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)" targets:<[player]>

      - default:
        - inject command_syntax_error
