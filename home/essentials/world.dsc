world_command:
  type: command
  name: world
  debug: false
  description:  manages worlds or teleports youself or another player to the specified world
  usage: /world (create/destroy/help/list/list_unloaded/load/unload/teleport (player)) <&lt>worldname<&gt>
  permission: behr.essentials.world
  tag_data:
    valid_folders: <server.list_files[../../].exclude[<script[worldfilelist].data_key[blacklist]>].filter_tag[<server.list_files[../../<[filter_value]>].contains[level.dat].if_null[<empty>]>]>
  tab complete:
    - define commands <list[create|destroy|list|list_unloaded|load|unload|teleport].include[<server.worlds.parse[name]>]>
    - define loaded_worlds <server.worlds.parse[name]>
    - if <context.args.is_empty>:
      - determine <[commands]>

    - define arg_count <context.args.size>
    - if "<context.raw_args.ends_with[ ]>":
      - define arg_count:++

    - if <[arg_count]> == 1:
      - determine <[commands].filter[starts_with[<context.args.first>]]>

    - else if <[arg_count]> == 2 && <context.args.first.advanced_matches_text[destroy|unload]>:
      - determine <[loaded_worlds].filter[starts_with[<context.args.get[2].if_null[<empty>]>]]>

    - else if <[arg_count]> == 2 && <context.args.first> == load:
      - define valid_folders <script.parsed_key[tag_data.valid_folders].exclude[<[loaded_worlds]>]>
      - determine <[valid_folders].filter[starts_with[<context.args.get[2].if_null[<empty>]>]]>

    - else if <[arg_count]> == 2 && <context.args.first> == teleport:
      - determine <[loaded_worlds].include[<server.online_players.parse[name].exclude[<player.name>]>].filter[starts_with[<context.args.get[2].if_null[<empty>]>]]>

    - else if <[arg_count]> == 3 && <context.args.first> == teleport && <server.match_player[<context.args.get[2]>].is_truthy>:
      - determine <[loaded_worlds].filter[starts_with[<context.args.get[3].if_null[<empty>]>]]>

  script:
    # % ██ [  check args ] ██
    - if <context.args.is_empty> || <context.args.size> > 3:
      - inject command_syntax

    - define loaded_worlds <server.worlds.parse[name]>
    - define world_name <context.args.last>
    - choose <context.args.size>:
      # | /world help
      # | /world list
      # | /world list_unloaded
      # | /world <world_name>
      - case 1:
        - choose <[world_name]>:
          - case help:
            - narrate "<&6>/<&e>world help <&b>| <&a>Shows you this helpful list"
            - narrate "<&6>/<&e>world create <&6><&lt><&e>world_name<&6><&gt> <&b>| <&a>Creates a world"
            - narrate "<&6>/<&e>world destroy <&6><&lt><&e>world_name<&6><&gt> <&b>| <&a>Permanently deletes a world"
            - narrate "<&6>/<&e>world list <&b>| <&a>Lists the loaded worlds"
            - narrate "<&6>/<&e>world list_unloaded <&b>| <&a>Lists the unloaded worlds"
            - narrate "<&6>/<&e>world load <&6><&lt><&e>world_name<&6><&gt> <&b>| <&a>Loads a world"
            - narrate "<&6>/<&e>world unload <&6><&lt><&e>world_name<&6><&gt> <&b>| <&a>Unloads a world"
            - narrate "<&6>/<&e>world teleport <&6>(<&e>player_name<&6>) <&lt>world_name<&6><&gt><&b>| <&a>Teleports you or a player to a world"

          - case list:
            - foreach <[loaded_worlds]> as:world_name:
              - define hover "<proc[colorize].context[Click to teleport to world:|green]> <&e><[world_name]>"
              - define text <&e><[world_name]>
              - define command "world teleport <[world_name]>"
              - define world_list:->:<proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>

            - narrate "<proc[colorize].context[Loaded worlds (<[loaded_worlds].size>):|green]> <&e><[world_list].separated_by[<&f>, <&e>]>"

          - case list_unloaded:
            - define valid_folders <script.parsed_key[tag_data.valid_folders].exclude[<[loaded_worlds]>]>
            - define unloaded_worlds <[valid_folders].exclude[<[loaded_worlds]>]>
            - foreach <[unloaded_worlds]> as:world_name:
              - define hover "<proc[colorize].context[Click to load:|green]> <&e><[world_name]>"
              - define text <&e><[world_name]>
              - define command "world load <[world_name]>"
              - define world_list:->:<proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>

              - narrate "<proc[colorize].context[Unloaded worlds (<[unloaded_worlds].size>):|green]> <&e><[world_list].separated_by[<&f>, <&e>]>"

          - default:
            - if !<server.worlds.parse[name].contains[<[world_name]>]>:
              - define valid_folders <script.parsed_key[tag_data.valid_folders].exclude[<[loaded_worlds]>]>

              - if <[valid_folders].contains[<[world_name]>]>:
                - narrate format:colorize_red "This world is not loaded."
                - inject world_command.load_world
                - stop

              - define reason "Invalid world name"
              - inject command_error

            - flag player behr.essentials.teleport.back.location:<player.location>
            - flag player behr.essentials.teleport.back.name:<player.world.name>
            - define location <world[<context.args.first>].spawn_location>
            - narrate format:colorize_green "Teleported you to <[location].simple>"
            - teleport <[location]>

      # @ possibilities:
      # | /world create <world_name>
      # | /world destroy <world_name>
      # | /world load <world_name>
      # | /world unload <world_name>
      # | /world teleport <world_name>
      - case 2:
        - choose <context.args.first>:
          - case create:
            # % ██ [  Check if world already exists ] ██
            - define valid_folders <script.parsed_key[tag_data.valid_folders].exclude[<[loaded_worlds]>]>

            - if <[loaded_worlds].contains[<[world_name]>]>:
              - narrate "<&c>World already exists and is loaded"
              - stop

            - if <[valid_folders].contains[<[world_name]>]>:
              - narrate format:colorize_red "This world already exists."
              - inject world_command.load_world
              - stop

            - else if !<[world].matches_character_set[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_]>:
              - narrate "world names should be alphanumerical."
              - stop

            - inject world_command.create_world

          - case destroy:
            # % ██ [  Check if world is loaded ] ██
            - if !<[loaded_worlds].contains[<[world_name]>]>:
              - define reason "That world is unloaded or does not exist."
              - inject command_error

            # % ██ [  Check if they're serious ] ██
            - if !<player.has_flag[behrry.essentials.world.prompt.destroy.0]>:
              - flag player behrry.essentials.world.prompt.destroy.0 duration:10s
              - define hover "<proc[colorize].context[Click to destroy:|red]><&nl><&e><[world_name]>"
              - define text <&a>[<&2><&l><&chr[2714]><&r><&a>]
              - define command "world destroy <[world_name]>"
              - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
              - narrate "<&b>| <[accept]> <&b>| <proc[colorize].context[Destroy world?:|green]> <&e><[world_name]>"
              - stop

            # % ██ [  Check if they're really serious ] ██
            - if !<player.has_flag[behrry.essentials.world.prompt.destroy.1]>:
              - flag player behrry.essentials.world.prompt.destroy.1 duration:10s
              - define hover "<proc[colorize].context[Click to destroy:|red]><&nl><&e><[world_name]>"
              - define text <&a>[<&2><&l><&chr[2714]><&r><&a>]
              - define command "world destroy <[world_name]>"
              - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
              - narrate "<&b>| <[accept]> <&b>| <proc[colorize].context[Really really destroy world?:|green]> <&e><[world_name]>"
              - stop

            - flag player behrry.essentials.world.prompt.destroy:!
            - narrate format:colorize_green "destroying world..."
            - adjust <world[<[world_name]>]> destroy
            - wait 1s
            - narrate "<&c>world destroyed<&4>: <&6>[<&e><[world_name]><&6>]"

          - case load:
            # % ██ [  Check if world is already loaded ] ██
            - if <[loaded_worlds].contains[<[world_name]>]>:
              - define reason "That world is already loaded."
              - inject command_error

            - define valid_folders <script.parsed_key[tag_data.valid_folders]>

            # % ██ [  Check if world file exists ] ██
            - if !<[valid_folders].contains[<[world_name]>]>:
              - narrate "<&c>World doesn't exist. Create instead?"
              - inject world_command.create_world
              - stop

            - inject world_command.load_world
            - stop

          - case unload:
            # % ██ [  Check if world is loaded ] ██
            - if !<[loaded_worlds].contains[<[world_name]>]>:
              - define reason "That world is unloaded or does not exist."
              - inject command_error

            - if !<player.has_flag[behrry.essentials.world.prompt.unload]>:
              - flag player behrry.essentials.world.prompt.unload duration:10s
              - define hover "<proc[colorize].context[Click to unload:|green]><&nl><&e><[world_name]>"
              - define text <&a>[<&2><&l><&chr[2714]><&r><&a>]
              - define command "world unload <[world_name]>"
              - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
              - narrate "<&b>| <[accept]> <&b>| <proc[colorize].context[Unload world?:|green]> <[world_name]>"
              - stop

            - flag player behrry.essentials.world.prompt.unload:!
            - narrate format:colorize_green "unloading world..."
            - adjust <world[<[world_name]>]> unload
            - wait 1s
            - narrate "<&c>world unloaded<&4>: <&6>[<&e><[world_name]><&6>]"

          - case teleport:
            # % ██ [  Check if world is loaded ] ██
            - if !<[loaded_worlds].contains[<context.args.last>]>:
              - define reason "That world is unloaded or does not exist."
              - inject command_error

            - flag player behr.essentials.teleport.back.location:<player.location>
            - flag player behr.essentials.teleport.back.name:<player.world.name>
            - define location <world[<[world_name]>].spawn_location>
            - narrate format:colorize_green "Teleported you to <[location].simple>"
            - teleport <[location]>

      # @ possibilities:
      # | /world teleport <player_name> <world_name>
      - case 3:
        - define player <server.match_player[<context.args.get[2]>].is_truthy>

        # % ██ [  Check if player exists ] ██
        - if !<[player]>:
          - define reason "That world is unloaded or does not exist."
          - inject command_error

        # % ██ [  Check if world is loaded ] ██
        - if !<[loaded_worlds].contains[<[world_name]>]>:
          - define reason "That world is unloaded or does not exist."
          - inject command_error

        - flag player behr.essentials.teleport.back.location:<[player].location>
        - flag player behr.essentials.teleport.back.name:<[player].world.name>
        - define location <world[<[world_name]>].spawn_location>
        - narrate format:colorize_green "Teleported <[player].name> to <[location].simple>"
        - narrate format:colorize_green "Teleported you to <[location].simple>" targets:<[player]>
        - teleport <[player]> <[location]>

  create_world:
    - if !<player.has_flag[behrry.essentials.world.prompt.create]>:
      - flag player behrry.essentials.world.prompt.create duration:10s
      - define hover "<proc[colorize].context[Click to create:|green]><&nl><&e><[world_name]>"
      - define text <&a>[<&2><&l><&chr[2714]><&r><&a>]
      - define command "world create <[world_name]>"
      - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
      - narrate "<&b>| <[accept]> <&b>| <proc[colorize].context[Create world?:|green]> <&e><[world_name]>"
      - stop

    - flag player behrry.essentials.world.prompt.create:!
    - narrate format:colorize_green "creating world..."
    - createworld <[world_name]>
    - wait 1s
    - narrate "<&a>world created<&2>: <&6>[<&e><[world_name]><&6>]"

  load_world:
    - if !<player.has_flag[behrry.essentials.world.prompt.load]>:
      - flag player behrry.essentials.world.prompt.load duration:10s
      - define hover "<proc[colorize].context[Click to load:|green]><&nl><&e><[world_name]>"
      - define text <&a>[<&2><&l><&chr[2714]><&r><&a>]
      - define command "world load <[world_name]>"
      - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
      - narrate "<&b>| <[accept]> <&b>| <proc[colorize].context[Load world?:|green]> <&e><[world_name]>"
      - stop

    - flag player behrry.essentials.world.prompt.load:!
    - narrate format:colorize_green "loading world..."
    - createworld <[world_name]>
    - wait 1s
    - narrate "<&a>world loaded<&2>: <&6>[<&e><[world_name]><&6>]"

worldfilelist:
    type: data
    worlds:
        - world
        - world_nether
        - world_the_end
        - hub
        - creative
        - runescape50px1

        - gielinor3
        - bandit-craft
        - 04192020_import
        - gaybabyjail
    blacklist:
        - banned-ips.json
        - banned-players.json
        - bukkit.yml
        - cache
        - commands.yml
        - crash-reports
        - data
        - eula.txt
        - help.yml
        - logs
        - ops.json
        - paper.yml
        - permissions.yml
        - plugins
        - server-icon.png
        - server.properties
        - spigot.yml
        - usercache.json
        - version_history.json
        - wepif.yml
        - whitelist.json
