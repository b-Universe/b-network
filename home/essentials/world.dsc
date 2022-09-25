world_command:
  type: command
  name: world
  debug: false
  description:  manages worlds or teleports youself or another player to the specified world
  usage: /world (create/destroy/help/list/list_unloaded/load/unload/teleport (player)) <&lt>worldname<&gt>
  permission: behr.essentials.world
  tag_data:
    valid_folders: <util.list_files[../../].filter_tag[<util.list_files[../../<[filter_value]>].contains[level.dat].if_null[<empty>]>]>
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

    - else if <[arg_count]> == 2 && <list[destroy|unload].contains[<context.args.first>]>:
      - determine <[loaded_worlds].filter[starts_with[<context.args.get[2].if_null[<empty>]>]]>

    - else if <[arg_count]> == 2 && <context.args.first> == load:
      - define valid_folders <script.parsed_key[tag_data.valid_folders].exclude[<[loaded_worlds]>]>
      - determine <[valid_folders].filter[starts_with[<context.args.get[2].if_null[<empty>]>]]>

    - else if <[arg_count]> == 2 && <context.args.first> == teleport:
      - determine <[loaded_worlds].include[<server.online_players.parse[name].exclude[<player.name>]>].filter[starts_with[<context.args.get[2].if_null[<empty>]>]]>

    - else if <[arg_count]> == 3 && <context.args.first> == teleport && <server.match_player[<context.args.get[2]>].is_truthy>:
      - determine <[loaded_worlds].filter[starts_with[<context.args.get[3].if_null[<empty>]>]]>
  data:
    syntax:
      - /world help | Shows you this helpful list
      - /world create <&lt>world_name<&gt> | Creates a world
      - /world destroy <&lt>world_name<&gt> | Permanently deletes a world
      - /world list | Lists the loaded worlds
      - /world list_unloaded | Lists the unloaded worlds
      - /world load <&lt>world_name<&gt> | Loads a world
      - /world unload <&lt>world_name<&gt> | Unloads a world
      - /world teleport (player_name) <&lt>world_name<&gt> | Teleports you or a player to a world
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
            - narrate <script.parsed_key[data.syntax].parse[proc[command_syntax_format]].separated_by[<n>]>

          - case list:
            - define world_list <list>
            - foreach <[loaded_worlds]> as:world_name:
              - define hover "<&[green]>Click to teleport to world<&co><n><&[yellow]><[world_name]>"
              - define text "<&[green]><&lb><&chr[2714]><&rb> <&[yellow]><[world_name]>"
              - define command "world teleport <[world_name]>"
              - define world_list <[world_list].include[<[text].on_hover[<[hover]>].on_click[/<[command]>].type[RUN_COMMAND]>]>

            - narrate "<&[green]>Loaded worlds <&[yellow]>(<[loaded_worlds].size>)<&co>"
            - narrate <[world_list].separated_by[<n>]>
            # "

          - case list_unloaded:
            - define valid_folders <script.parsed_key[tag_data.valid_folders].exclude[<[loaded_worlds]>]>
            - define unloaded_worlds <[valid_folders].exclude[<[loaded_worlds]>]>
            - define world_list <list>
            - foreach <[unloaded_worlds]> as:world_name:
              - define hover "<&[green]>Click to load<&co><n><&[yellow]><[world_name]>"
              - define text <&[yellow]><[world_name]>
              - define command "world load <[world_name]>"
              - define world_list <[world_list].include_single[<[text].on_hover[<[hover].on_click[/<[command]>]>]>]>

            - narrate "Unloaded worlds (<[unloaded_worlds].size>)<&co><n><[world_list].separated_by[<&f>, ]>"

          - default:
            - if !<server.worlds.parse[name].contains[<[world_name]>]>:
              - define valid_folders <script.parsed_key[tag_data.valid_folders].exclude[<[loaded_worlds]>]>

              - if <[valid_folders].contains[<[world_name]>]>:
                - narrate "<&[red]>This world is not loaded."
                - inject world_command.load_world
                - stop

              - define reason "Invalid world name"
              - inject command_error

            - flag player behr.essentials.teleport.back.location:<player.location>
            - flag player behr.essentials.teleport.back.name:<player.world.name>
            - define location <world[<context.args.first>].spawn_location>
            - narrate "<&[green]>Teleported you to <[location].simple>"
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
              - narrate "<&[red]>World already exists and is loaded"
              - stop

            - if <[valid_folders].contains[<[world_name]>]>:
              - narrate "<&[red]>This world already exists."
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
              - define hover "<&[red]>Click to destroy:<&nl><&[yellow]><[world_name]>"
              - define text <&[green]>[<&chr[2714]>]
              - define command "world destroy <[world_name]>"
              - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
              - narrate "<&b>| <[accept]> <&b>| <&[green]>Destroy world?: <&[yellow]><[world_name]>"
              - stop

            # % ██ [  Check if they're really serious ] ██
            - if !<player.has_flag[behrry.essentials.world.prompt.destroy.1]>:
              - flag player behrry.essentials.world.prompt.destroy.1 duration:10s
              - define hover "<&[red]>Click to destroy:<&nl><&[yellow]><[world_name]>"
              - define text <&[green]>[<&chr[2714]>]
              - define command "world destroy <[world_name]>"
              - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
              - narrate "<&b>| <[accept]> <&b>| <&[green]>Really really destroy world?: <&[yellow]><[world_name]>"
              - stop

            - flag player behrry.essentials.world.prompt.destroy:!
            - narrate "<&[green]>destroying world..."
            - adjust <world[<[world_name]>]> destroy
            - wait 1s
            - narrate "<&[red]>world destroyed: <&[yellow]><[world_name]>"

          - case load:
            # % ██ [  Check if world is already loaded ] ██
            - if <[loaded_worlds].contains[<[world_name]>]>:
              - define reason "That world is already loaded."
              - inject command_error

            - define valid_folders <script.parsed_key[tag_data.valid_folders]>

            # % ██ [  Check if world file exists ] ██
            - if !<[valid_folders].contains[<[world_name]>]>:
              - narrate "<&[red]>World doesn't exist. Create instead?"
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
              - define hover "<&[green]>Click to unload<&nl><&[yellow]><[world_name]>"
              - define text <&[green]>[<&chr[2714]>]
              - define command "world unload <[world_name]>"
              - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
              - narrate "<&b>| <[accept]> <&b>| <&[green]>Unload world?: <[world_name]>"
              - stop

            - flag player behrry.essentials.world.prompt.unload:!
            - narrate "<&[green]>unloading world..."
            - adjust <world[<[world_name]>]> unload
            - wait 1s
            - narrate "<&[green]>world unloaded: <&[yellow]><[world_name]>"

          - case teleport:
            # % ██ [  Check if world is loaded ] ██
            - if !<[loaded_worlds].contains[<context.args.last>]>:
              - define reason "That world is unloaded or does not exist."
              - inject command_error

            - flag player behr.essentials.teleport.back.location:<player.location>
            - flag player behr.essentials.teleport.back.name:<player.world.name>
            - define location <world[<[world_name]>].spawn_location>
            - narrate "<&[green]>Teleported you to <[location].simple>"
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
        - narrate "<&[green]>Teleported <[player].name> to <[location].simple>"
        - narrate "<&[green]>Teleported you to <[location].simple>" targets:<[player]>
        - teleport <[player]> <[location]>

  create_world:
    - if !<player.has_flag[behrry.essentials.world.prompt.create]>:
      - flag player behrry.essentials.world.prompt.create duration:10s
      - define hover "<&[green]>Click to create<&nl><&[yellow]><[world_name]>"
      - define text <&[green]>[<&chr[2714]>]
      - define command "world create <[world_name]>"
      - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
      - narrate "<&b>| <[accept]> <&b>| <&[green]>Create world?<&co> <&[yellow]><[world_name]>"
      - stop

    - flag player behrry.essentials.world.prompt.create:!
    - narrate "<&[green]>creating world..."
    - createworld <[world_name]>
    - wait 1s
    - narrate "<&[green]>world created<&co> <&[yellow]><[world_name]>"

  load_world:
    - if !<player.has_flag[behrry.essentials.world.prompt.load]>:
      - flag player behrry.essentials.world.prompt.load duration:10s
      - define hover "<&[green]>Click to load:<&nl><&[yellow]><[world_name]>"
      - define text <&[green]>[<&chr[2714]>]
      - define command "world load <[world_name]>"
      - define accept <proc[msg_cmd].context[<[hover]>|<[text]>|<[command]>]>
      - narrate "<&b>| <[accept]> <&b>| <&[green]>Load world<&co> <&[yellow]><[world_name]>"
      - stop

    - flag player behrry.essentials.world.prompt.load:!
    - narrate "<&[green]>loading world..."
    - createworld <[world_name]>
    - wait 1s
    - narrate "<&[green]>world loaded<&co> <&[yellow]><[world_name]>"
