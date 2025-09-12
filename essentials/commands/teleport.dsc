teleport_command:
  type: command
  name: teleport
  debug: false
  usage: /teleport (player) / X Y Z (world)
  description: Teleports you to another destination
  tab completions:
    1: <server.players.exclude[<player>].parse[name].include[<server.worlds.parse[name]>]>
    2: <server.players.exclude[<player>].parse[name].include[<server.worlds.parse[name]>]>
    4: <server.worlds.parse[name]>
    5: <server.worlds.parse[name]>
  script:
    - choose <context.args.size>:
      # /teleport player
      # /teleport world
      - case 1:
        - if <context.args.first> in <server.worlds.parse[name]>:
          - define world_name <context.args.first>
          - define location <world[<[world_name]>].spawn_location>
          - flag <player> behr.essentials.teleport.last_teleport.location:<player.location>
          - flag <player> behr.essentials.teleport.last_teleport.world_name:<player.location.world.name>
          - teleport <player> <[location]>
          - narrate "<&a>Teleported you to <&e><[world_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)"

        - else:
          - define player_name <context.args.first>
          - if <player.has_flag[behr.essentials.permission.offline_teleporting]>:
            - define player <server.match_offline_player[<[player_name]>].if_null[null]>
          - else:
            - define player <server.match_player[<[player_name]>].if_null[null]>
          - if <[player]> == <player>:
            - narrate "<&e>Nothing interesting happens"
            - stop

          - if <[player]> == null:
            - define message.hover "<&a>Click to insert<&co><n><&6>/<&e><context.alias.proc[command_usage].proc[command_syntax_format]><n><&c>You typed<&co> <underline>/<context.alias> <context.raw_args>"
            - if <server.match_offline_player[<[player_name]>].exists>:
              - define message.text "<&e><[player_name]> <&c>is not online"
            - else:
              - define message.text "<&e><[player_name]> <&c>is not a valid player or world name"
            - narrate <[message.text].on_hover[<[message.hover]>].on_click[/<context.alias> ].type[suggest_command]>
            - stop

          - define location <[player].location>
          - flag <player> behr.essentials.teleport.last_teleport.location:<player.location>
          - flag <player> behr.essentials.teleport.last_teleport.world_name:<player.location.world.name>
          - teleport <player> <[location].find_spawnable_blocks_within[3].last.if_null[<[location]>]>
          - narrate "<&a>Teleported you to <&e><[player_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)"

      # /teleport player world
      # /teleport player_one player_two
      - case 2:
        - define player_one_name <context.args.first>
        - if <player.has_flag[behr.essentials.permission.offline_teleporting]>:
          - define player_one <server.match_offline_player[<[player_one_name]>].if_null[null]>
        - else:
          - define player_one <server.match_player[<[player_one_name]>].if_null[null]>
        - if <[player_one]> == null:
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
          - flag <[player_one]> behr.essentials.teleport.last_teleport.location:<[player_one].location>
          - flag <[player_one]> behr.essentials.teleport.last_teleport.world_name:<[player_one].location.world.name>
          - teleport <[player_one]> <[location]>
          - narrate "<&a>Teleported you to <&e><[world_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)" targets:<[player_one]>
          - if <[player_one]> != <player>:
            - narrate "<&a>Teleported <&e><[player_one_name]> <&a>to <&e><[world_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)" targets:<[player_one]>

        - else:
          - define player_two_name <context.args.last>
          - if <player.has_flag[behr.essentials.permission.offline_teleporting]>:
            - define player_two <server.match_offline_player[<[player_two_name]>].if_null[null]>
          - else:
            - define player_two <server.match_player[<[player_two_name]>].if_null[null]>
          - if <[player_one]> == <[player_two]>:
            - narrate "<&e>Nothing interesting happens"
            - stop

          - if <[player_two]> == null:
            - define message.hover "<&a>Click to insert<&co><n><&6>/<&e><context.alias.proc[command_usage].proc[command_syntax_format]><n><&c>You typed<&co> <underline>/<context.alias> <context.raw_args>"
            - if <server.match_offline_player[<[player_two_name]>].exists>:
              - define message.text "<&e><[player_two_name]> <&c>is not online"
            - else:
              - define message.text "<&e><[player_two_name]> <&c>is not a valid player or world name"
            - narrate <[message.text].on_hover[<[message.hover]>].on_click[/<context.alias> ].type[suggest_command]>
            - stop

          - define location <[player_two].location>
          - flag <[player_one]> behr.essentials.teleport.last_teleport.location:<[player_one].location>
          - flag <[player_one]> behr.essentials.teleport.last_teleport.world_name:<[player_one].location.world.name>
          - teleport <[player_one]> <[location].find_spawnable_blocks_within[3].last.if_null[<[location]>]>
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
        - flag <player> behr.essentials.teleport.last_teleport.location:<player.location>
        - flag <player> behr.essentials.teleport.last_teleport.world_name:<player.location.world.name>
        - teleport <player> <[location]>
        - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
        - narrate "<&a>Teleported you to <&e><[world_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)"

      # /teleport player x y z
      # /teleport x y z world
      - case 4:
        - if !<context.args.first.is_decimal>:
          - define player_name <context.args.first>
          - if <player.has_flag[behr.essentials.permission.offline_teleporting]>:
            - define player <server.match_offline_player[<[player_name]>].if_null[null]>
          - else:
            - define player <server.match_player[<[player_name]>].if_null[null]>
          - if <[player]> == null:
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
          - flag <[player]> behr.essentials.teleport.last_teleport.location:<[player].location>
          - flag <[player]> behr.essentials.teleport.last_teleport.world_name:<[player].location.world.name>
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
          - if !<[world_name]> in <server.worlds.parse[name]>:
            - define reason "<[world_name]> is an invalid world"
            - inject command_error

          - define location <location[<[x]>,<[y]>,<[z]>,<[world_name]>]>
          - flag <player> behr.essentials.teleport.last_teleport.location:<player.location>
          - flag <player> behr.essentials.teleport.last_teleport.world_name:<player.location.world.name>
          - teleport <player> <[location]>
          - narrate "<&a>Teleported you to <&e><[world_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)"

      # /teleport player x y z world
      - case 5:
        - if !<context.args.first.is_decimal>:
          - define player_name <context.args.first>
          - if <player.has_flag[behr.essentials.permission.offline_teleporting]>:
            - define player <server.match_offline_player[<[player_name]>].if_null[null]>
          - else:
            - define player <server.match_player[<[player_name]>].if_null[null]>
          - if <[player]> == null:
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
          - if !<[world_name]> in <server.worlds.parse[name]>:
            - define reason "<[world_name]> is an invalid world"
            - inject command_error

          - define location <location[<[x]>,<[y]>,<[z]>,<[world_name]>]>
          - flag <[player]> behr.essentials.teleport.last_teleport.location:<[player].location>
          - flag <[player]> behr.essentials.teleport.last_teleport.world_name:<[player].location.world.name>
          - teleport <[player]> <[location]>
          - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
          - if <[player]> != <player>:
            - narrate "<&a>Teleported <&e><[player_name]> <&a>to <&e><[world_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)"
          - narrate "<&a>Teleported you to <&e><[world_name]> <&6>(<&e><[location].round.simple.replace_text[,].with[<&6>,<&e> ]><&6>)" targets:<[player]>

      - case 0:
        - inventory open destination:teleport_menu
      - default:
        - inject command_syntax_error

teleport_menu:
  type: inventory
  debug: false
  inventory: chest
  title: <script.parsed_key[data.title].unseparated>
  data:
    title:
      - <proc[bbackground].context[36|e003]>
      - <&color[<proc[prgb]>]>
      - <proc[sp].context[32]>
      - <element[Commands].color[<proc[argb]>].font[minecraft_8.5]>
  size: 36
  gui: true
  definitions:
    x: air
  procedural items:
    - define items <list>
    - define items <[items].include_single[<item[profile_button].with[skull_skin=<player.skull_skin>;display=<&color[<proc[argb]>]>Profile]>]>
    - define items <[items].include_single[<item[color_menu_button].with[display=<&color[<proc[argb]>]>Color Settings]>]>
    - define items <[items].include[<item[b_commands_settings_button].with[display=<&color[<proc[argb]>]>B Command Settings].repeat_as_list[4]>]>
    - determine <[items]>
  slots:
    - [] [] [] [] [] [] [] [] []
    - [settings_commands_playsound] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []

#dont_rotate:
#  type: world
#  events:
#    on player right clicks item_frame:
#      - narrate cancelled
#      - determine cancelled
