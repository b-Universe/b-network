# begin start of horribly written draft, heavy cleaning to do

builder_mode_command:
  type: command
  name: buildermode
  debug: false
  description: Adjusts another user or your gamemode
  usage: /buildermode (player (duration))
  permission: behr.essentials.gamemode.builder
  tab completions:
    1: <server.online_players.parse[name].exclude[<player.name>]>
  aliases:
    - gmb
  script:
    - if <player.has_flag[behr.essentials.gamemode.builder_mode]>:
      - flag <player> behr.essentials.gamemode.builder_mode:!
      - repeat 5 as:slot:
        - inventory set slot:<[slot]> o:air d:<player.open_inventory>
      - narrate "<&[green]>Builder mode deactivated"
      - stop

    - flag <player> behr.essentials.gamemode.builder_mode
    - if !<player.has_flag[behr.essentials.builder_mode.flight_disabled]>:
      - adjust <player> can_fly:true
    - narrate "<&[green]>Builder mode activated"
    - inject builder_mode_handler.set_inventory

open_inv:
  type: task
  debug: false
  script:
    - define items <script[material_list].data_key[blocks.stairs_and_slabs].sub_lists[8]>
    - define inventory <inventory[material_list_inventory_testing]>

    - foreach 1|10|19|28|37|46 as:slot:
      - inventory set d:<[inventory]> slot:<[slot]> o:<[items].get[<[loop_index]>]>
    - inventory set slot:54 d:<[inventory]> o:barrier

    - inventory open d:<[inventory]>

material_list_inventory_testing:
  type: inventory
  debug: false
  # Must be a valid inventory type.
  # Valid inventory types: ANVIL, BREWING, CHEST, DISPENSER, ENCHANTING, ENDER_CHEST, HOPPER, WORKBENCH
  # | All inventory scripts MUST have this key!
  inventory: chest
  title: <script.parsed_key[data.title].unseparated>
  size: 54
  data:
    title:
      - <&f><proc[negative_spacing].context[9].font[utility:spacing]>
      - <&chr[1026].font[gui]>
      #- <proc[negative_spacing].context[130].font[utility:spacing]>
      #- <&[green]>Material List

color_settings_menu:
  type: inventory
  inventory: anvil
  title: <script.parsed_key[data.title].unseparated>
  gui: true
  data:
    title:
      - <&f><proc[negative_spacing].context[62].font[utility:spacing]>
      - <&chr[1027].font[gui]>
      - <proc[negative_spacing].context[179].font[utility:spacing]>
      - <&[green]>Color Setting
  definitions:
    command_menu: inventory_item[custom_model_data=1;flag=menu:commands]
    accept: sand
    preview: grass_block
  slots:
    - [command_menu] [accept] [preview]

builder_mode_handler_testing:
  type: world
  debug: true
  events:
    after player clicks item in flight_menu_gui:
      - stop if:!<context.item.has_flag[flight]>
      - define player_flight_speed <player.fly_speed.round_to_precision[0.05]>
      - choose <context.item.flag[flight]>:
        - case increase:
          - define new_fly_speed <[player_flight_speed].add[0.05]>
          - if <[new_fly_speed]> > 1:
            - narrate "<&[red]>Fly speed is already maximized"
          - else:
            - adjust <player> fly_speed:<[new_fly_speed]>
            - narrate "<&[green]>Fly speed increased to <&[yellow]><[new_fly_speed].mul[10]>"
            - define new_increase <[new_fly_speed].add[0.05].mul[10].min[10]>
            - if <[new_fly_speed]> == 1:
              - inventory adjust d:<player.open_inventory> slot:2 "lore:<&[red]>Maximum fly speed"
            - else:
              - inventory adjust d:<player.open_inventory> slot:2 "lore:<&[green]>Increase to<&co> <&[yellow]><[new_increase]>"
            - inventory adjust d:<player.open_inventory> slot:3 "display:<&[green]>Fly speed<&co>"
            - if <[new_fly_speed]> == 0.2:
              - inventory adjust d:<player.open_inventory> slot:3 "lore:<&[green]>Speed<&co> <&[yellow]><[new_fly_speed].mul[10]>|<&[yellow]>(Default)"
            - else:
              - inventory adjust d:<player.open_inventory> slot:3 "lore:<&[green]>Speed<&co> <&[yellow]><[new_fly_speed].mul[10]>|<&[yellow]>Click to reset"
            - inventory adjust d:<player.open_inventory> slot:4 "lore:<&[green]>Decrease to<&co> <&[yellow]><[new_fly_speed].sub[0.05].mul[10].max[0]>"

        - case decrease:
          - define new_fly_speed <[player_flight_speed].sub[0.05]>
          - if <[player_flight_speed].sub[0.05]> < 0:
            - narrate "<&[red]>Fly speed is already minimized"
          - else:
            - adjust <player> fly_speed:<[new_fly_speed]>
            - narrate "<&[green]>Fly speed decreased to <&[yellow]><[new_fly_speed].mul[10]>"
            - define new_decrease <[new_fly_speed].sub[0.05].mul[10].max[0]>
            - inventory adjust d:<player.open_inventory> slot:2 "lore:<&[green]>Increase to<&co> <&[yellow]><[new_fly_speed].add[0.05].mul[10].min[10]>"
            - inventory adjust d:<player.open_inventory> slot:3 "display:<&[green]>Fly speed<&co>"
            - if <[new_fly_speed]> == 0.2:
              - inventory adjust d:<player.open_inventory> slot:3 "lore:<&[green]>Speed<&co> <&[yellow]><[new_fly_speed].mul[10]>|<&[yellow]>(Default)"
            - else:
              - inventory adjust d:<player.open_inventory> slot:3 "lore:<&[green]>Speed<&co> <&[yellow]><[new_fly_speed].mul[10]>|<&[yellow]>Click to reset"
            - if <[player_flight_speed].sub[0.05].mul[10].max[0]> == 0:
              - inventory adjust d:<player.open_inventory> slot:4 "lore:<&[red]>Minimum fly speed"
            - else:
              - inventory adjust d:<player.open_inventory> slot:4 "lore:<&[green]>Decrease to<&co> <&[yellow]><[new_decrease]>"

        - case enable:
          - flag player behr.essentials.builder_mode.flight_disabled:!
          - if !<player.can_fly>:
            - adjust <player> can_fly:true

            - inventory adjust d:<player.open_inventory> slot:2 "display:<&[green]>increase flight speed"
            - inventory adjust d:<player.open_inventory> slot:2 "lore:<&[green]>Increase to<&co> <&[yellow]><[player_flight_speed].add[0.05].round_to_precision[0.05].min[1].mul[10]>"
            - inventory adjust d:<player.open_inventory> slot:3 "display:<&[green]>Fly speed<&co>"
            - inventory adjust d:<player.open_inventory> slot:3 "lore:<&[yellow]><[player_flight_speed].mul[10]>|<&[yellow]>Click to reset"
            - inventory adjust d:<player.open_inventory> slot:4 "display:<&[green]>decrease flight speed"
            - inventory adjust d:<player.open_inventory> slot:4 "lore:<&[green]>Decrease to<&co> <&[yellow]><[player_flight_speed].sub[0.05].round_to_precision[0.05].max[0].mul[10]>"
            - narrate "<&[green]>Flight enabled"
          - else:
            - narrate "<&[red]>Flight is already enabled"

        - case disable:
          - if <player.can_fly>:
            - adjust <player> can_fly:false
            - narrate "<&[green]>Flight disabled"
            - flag player behr.essentials.builder_mode.flight_disabled
            - inventory set slot:2 d:<player.open_inventory> "o:<item[book].with[display=<&[green]>Flight Disabled].with_flag[flight:enable].repeat_as_list[3]>"
          - else:
            - narrate "<&[red]>Flight is already disabled"

        - case default:
          - if <player.fly_speed> == 0.2:
            - narrate "<&[red]>Your fly speed is already the default"
          - else:
            - adjust <player> fly_speed:0.2
            - inventory adjust d:<player.open_inventory> slot:2 "lore:<&[green]>Increase to<&co> <&[yellow]>2.5"
            - inventory adjust d:<player.open_inventory> slot:3 "lore:<&[green]>Speed<&co> <&[yellow]>2"
            - inventory adjust d:<player.open_inventory> slot:4 "lore:<&[green]>Decrease to<&co> <&[yellow]>1.5"
            - narrate "<&[green]>Fly speed set to <&[yellow]>2"

    after player clicks item in walk_menu_gui:
      - stop if:!<context.item.has_flag[walk]>
      - define player_walk_speed <player.walk_speed.round_to_precision[0.05]>
      - choose <context.item.flag[walk]>:
        - case increase:
          - define new_walk_speed <[player_walk_speed].add[0.05]>
          - if <[new_walk_speed]> > 1:
            - narrate "<&[red]>Walk speed is already maximized"
          - else:
            - adjust <player> walk_speed:<[new_walk_speed]>
            - narrate "<&[green]>walk speed increased to <&[yellow]><[new_walk_speed].mul[10]>"
            - define new_increase <[new_walk_speed].add[0.05].mul[10].min[10]>

            - if <[new_walk_speed]> == 1:
              - inventory adjust d:<player.open_inventory> slot:4 "lore:<&[red]>Maximum walk speed"
            - else:
              - if <[new_increase]> == 2:
                - inventory adjust d:<player.open_inventory> slot:4 "lore:<&[green]>Increase to<&co> <&[yellow]>2|<&[yellow]>(Default)"
              - else:
                - inventory adjust d:<player.open_inventory> slot:4 "lore:<&[green]>Increase to<&co> <&[yellow]><[new_increase]>"

            - inventory adjust d:<player.open_inventory> slot:5 "display:<&[green]>walk speed<&co>"
            - if <[new_walk_speed]> == 0.2:
              - inventory adjust d:<player.open_inventory> slot:5 "lore:<&[green]>Speed<&co> <&[yellow]>2|<&[yellow]>(Default)"
            - else if <[new_walk_speed]> == 1:
              - inventory adjust d:<player.open_inventory> slot:5 "lore:<&[red]>Maximum walk speed"
            - else:
              - inventory adjust d:<player.open_inventory> slot:5 "lore:<&[green]>Speed<&co> <&[yellow]><[new_walk_speed].mul[10]>|<&[yellow]>Click to reset"

            - if <[new_walk_speed]> == 2:
              - inventory adjust d:<player.open_inventory> slot:6 "lore:<&[green]>Decrease to<&co> <&[yellow]>2|<&[yellow]>(Default)"
            - else:
              - inventory adjust d:<player.open_inventory> slot:6 "lore:<&[green]>Decrease to<&co> <&[yellow]><[new_walk_speed].sub[0.05].mul[10].max[0]>"

        - case decrease:
          - define new_walk_speed <[player_walk_speed].sub[0.05]>
          - if <[player_walk_speed].sub[0.05]> < 0:
            - narrate "<&[red]>Walk speed is already minimized"
          - else:
            - adjust <player> walk_speed:<[new_walk_speed]>
            - narrate "<&[green]>Walk speed decreased to <&[yellow]><[new_walk_speed].mul[10]>"
            - define new_decrease <[new_walk_speed].sub[0.05].mul[10].max[0]>

            - inventory adjust d:<player.open_inventory> slot:4 "display:<&[green]>walk speed<&co>"
            - if <[new_walk_speed]> == 0:
              - inventory adjust d:<player.open_inventory> slot:4 "lore:<&[red]>Minimum walk speed"
            - else if <[new_walk_speed]> == 0.2:
              - inventory adjust d:<player.open_inventory> slot:4 "lore:<&[green]>Increase to<&co> <&[yellow]>2|<&[yellow]>(Default)"
            - else:
              - inventory adjust d:<player.open_inventory> slot:4 "lore:<&[green]>Increase to<&co> <&[yellow]><[new_walk_speed].add[0.05].mul[10].min[10]>"

            - if <[new_walk_speed]> == 0.2:
              - inventory adjust d:<player.open_inventory> slot:5 "lore:<&[green]>Speed<&co> <&[yellow]><[new_walk_speed].mul[10]>|<&[yellow]>(Default)"
            - else if <[new_walk_speed]> == 0:
              - inventory adjust d:<player.open_inventory> slot:4 "lore:<&[red]>Minimum walk speed"
            - else:
              - inventory adjust d:<player.open_inventory> slot:5 "lore:<&[green]>Speed<&co> <&[yellow]><[new_walk_speed].mul[10]>|<&[yellow]>Click to reset"

            - if <[player_walk_speed].sub[0.05].mul[10].max[0]> == 0:
              - inventory adjust d:<player.open_inventory> slot:6 "lore:<&[red]>Minimum walk speed"
            - else if <[new_decrease]> == 2:
              - inventory adjust d:<player.open_inventory> slot:6 "lore:<&[green]>Decrease to<&co> <&[yellow]>2|<&[yellow]>(Default)"
            - else:
              - inventory adjust d:<player.open_inventory> slot:6 "lore:<&[green]>Decrease to<&co> <&[yellow]><[new_decrease]>"

        - case default:
          - if <[player_walk_speed]> == 0.2:
            - narrate "<&[red]>Your walk speed is already the default"
          - else:
            - adjust <player> walk_speed:0.2
            - inventory adjust d:<player.open_inventory> slot:4 "lore:<&[green]>Increase to<&co> <&[yellow]>2.5"
            - inventory adjust d:<player.open_inventory> slot:5 "lore:<&[green]>Speed<&co> <&[yellow]>2|<&[yellow]>(Default)"
            - inventory adjust d:<player.open_inventory> slot:6 "lore:<&[green]>Decrease to<&co> <&[yellow]>1.5"
            - narrate "<&[green]>walk speed set to <&[yellow]>2"

    on player clicks in time_menu_gui:
      - stop if:!<context.item.has_flag[set_time]>
      - define time <context.item.flag[set_time]>

      - choose <[time]>:
        - case Bedtime:
          - define tick_time 0t
        - case Dawn:
          - define tick_time 1000t
        - case Day:
          - define tick_time 6000t
        - case Dusk:
          - define tick_time 11615t
        - case Midnight:
          - define tick_time 12542t
        - case Night:
          - define tick_time 12786t
        - case Noon:
          - define tick_time 13000t
        - case Start:
          - define tick_time 18000t
        - case Sunrise:
          - define tick_time 22200t
        - case Sunset:
          - define tick_time 23216t

        - case lock:
          - if <player.world.gamerule[doDaylightCycle]>:
            - gamerule <player.world> doDaylightCycle false
            - narrate "<&[green]>Time locked"
          - else:
            - narrate "<&[red]>Time already locked"
          - stop

        - case unlock:
          - if !<player.world.gamerule[doDaylightCycle]>:
            - gamerule <player.world> doDaylightCycle true
            - narrate "<&[green]>Time unlocked"
          - else:
            - narrate "<&[red]>Time is not locked"
          - stop

      - if <[tick_time]> == <player.world.time>t:
        - narrate "<&[red]>Time is already set to <[time]>"
        - stop

      - time <[tick_time]>
      - narrate "<&[green]>Time set to <&[yellow]><[time]>"

    on player clicks in weather_menu_gui:
      - stop if:!<context.item.has_flag[weather]>
      - determine passively cancelled

      - define weather <context.item.flag[weather]>
      - define world <player.world.name>
      - choose <[weather]>:
      # weather ({global}/player) [sunny/storm/thunder/reset] (<world>) (reset:<duration>)
        - case stormy storm:
          - if <server.has_flag[behr.essentials.weather.world.<[world]>.weather]> && <list[stormy|storm].contains[<server.flag[behr.essentials.weather.world.<[world]>.weather]>]>:
            - narrate "<&[red]>Weather for <&[yellow]><[world]> <&[red]>is already set to <&[yellow]><[weather]>"
          - else:
            - narrate "<&[green]> Weather for <&[yellow]><[world]> <&[green]>set to <&[yellow]><[weather]>"

          - if <server.has_flag[behr.essentials.weather.world.<[world]>.lock]>:
            - weather storm reset:1d
            - flag server behr.essentials.weather.world.<[world]>.weather:storm expire:1d
          - else:
            - weather <[weather]> reset:1h
            - flag server behr.essentials.weather.world.<[world]>.weather:storm expire:1h

        - case clear sunny:
          - if <server.has_flag[behr.essentials.weather.world.<[world]>.weather]> && <list[sunny|clear].contains[<server.flag[behr.essentials.weather.world.<[world]>.weather]>]>:
            - narrate "<&[red]>Weather for <&[yellow]><[world]> <&[red]>is already set to <&[yellow]><[weather]>"
          - else:
            - narrate "<&[green]> Weather for <&[yellow]><[world]> <&[green]>set to <&[yellow]><[weather]>"

          - if <server.has_flag[behr.essentials.weather.world.<[world]>.lock]>:
            - weather sunny reset:1d
            - flag server behr.essentials.weather.world.<[world]>.weather:sunny expire:1d
          - else:
            - weather <[weather]> reset:1h
            - flag server behr.essentials.weather.world.<[world]>.weather:sunny expire:1h

        - case thunder:
          - if <server.has_flag[behr.essentials.weather.world.<[world]>.weather]> && <server.flag[behr.essentials.weather.world.<[world]>.weather]> == thunder:
            - narrate "<&[red]>Weather for <&[yellow]><[world]> <&[red]>is already set to <&[yellow]><[weather]>"
          - else:
            - narrate "<&[green]> Weather for <&[yellow]><[world]> <&[green]>set to <&[yellow]>thunder"

          - if <server.has_flag[behr.essentials.weather.world.<[world]>.lock]>:
            - weather <[weather]> reset:1d
            - flag server behr.essentials.weather.world.<[world]>.weather:thunder expire:1d
          - else:
            - weather <[weather]> reset:1h
            - flag server behr.essentials.weather.world.<[world]>.weather:thunder expire:1h

        - case lock:
          - if <server.has_flag[behr.essentials.weather.world.<[world]>.lock]>:
            - weather reset:1t
            - flag server behr.essentials.weather.world.<[world]>.lock:!
            - narrate "<&[green]> Weather for <&[yellow]><[world]> <&[green]>unlocked"

          - else:
            - flag server behr.essentials.weather.world.<[world]>.lock
            - if <server.has_flag[behr.essentials.weather.world.<[world]>.weather]>:
              - narrate "<&[green]>Weather for <&[yellow]><[world]> <&[green]>locked to <&[yellow]><server.flag[behr.essentials.weather.world.<[world]>.weather]>"

            - else:
              - if <player.world.has_storm>:
                - flag player behr.essentials.weather.world.<[world]>.weather:storm expire:1d
                - weather storm reset:1h

              - else if <player.world.thundering>:
                - flag player behr.essentials.weather.world.<[world]>.weather:thunder expire:1d
                - weather thunder reset:1h

              - else:
                - flag player behr.essentials.weather.world.<[world]>.weather:sunny expire:1d
                - weather sunny reset:1h

              - narrate "<&[green]>Weather for <&[yellow]><[world]> <&[green]>unlocked"

    on player clicks block flagged:builder_spectator:
      - if <player.is_sneaking>:
        - adjust <player> gamemode:survival
        - adjust <player> can_fly:true
        - narrate "<&[green]>Spectator disabled"
        - flag player builder_spectator:!
    #on tick:
    #  - foreach <server.online_players> as:player:
    #    - inventory set d:<[player].inventory> slot:18 o:<[player].cursor_on.material.name.if_null[air]>
    on player clicks inventory_item in inventory:
      - determine passively cancelled
      - if <script[open_<context.item.flag[menu].if_null[invalid]>_menu].exists>:
        - run open_<context.item.flag[menu]>_menu

    on player prepares anvil craft item:
      - stop if:!<context.inventory.script.exists>
      - determine passively 0
      - determine <context.item.with[display=<context.item.display.parse_color.if_null[<&f>]>]>
    on player picks up item flagged:behr.essentials.item_pickup_disabled:
      - determine cancelled

open_commands_menu:
  type: task
  script:
    - inventory open d:builder_command_menu_inventory

builder_command_menu_inventory:
  type: inventory
  inventory: chest
  title: <script.parsed_key[data.title].unseparated>
  size: 18
  data:

    title:
      - <&f><proc[negative_spacing].context[9].font[utility:spacing]>
      - <&chr[1030].font[gui]>
  definitions:
    teleport: book
    material: inventory_item[display=materials;custom_model_data=1;flag=menu:materials]
    all_material: book
    favorite_materials: book
    crafting: inventory_item[material=crafting_table;display=crafting table;flag=menu:crafting_table]
    night_vision: inventory_item[material=golden_carrot;display=Toggle night vision;flag=menu:night_vision]
    spectator: inventory_item[material=feather;display=Toggle spectator;flag=menu:spectator]

    time: inventory_item[material=compass;display=Time;flag=menu:time]
    weather: inventory_item[material=compass;display=Weather;flag=menu:weather]
    flight: inventory_item[material=feather;display=flight speed settings;flag=menu:flight]
    walk: inventory_item[material=nautilus_shell;display=walk speed settings;flag=menu:walk]
    bedit: stick[display=bEdit Menu;lore=<&8><&lb><&7>disabled<&8><&rb>;custom_model_data=15]
    item_pickup: inventory_item[material=cauldron;display=Item pickup settings;flag=menu:item_pickup]
    settings: book
  slots:
    - [] [teleport] [material] [all_material] [favorite_materials] [crafting] [night_vision] [spectator] []
    - [] [time] [weather] [flight] [walk] [bedit] [item_pickup] [settings] []

open_item_pickup_menu:
  type: task
  script:
    - if <player.has_flag[behr.essentials.item_pickup_disabled]>:
      - flag <player> behr.essentials.item_pickup_disabled:!
      - narrate "<&[green]>Item pickup enabled"
    - else:
      - flag <player> behr.essentials.item_pickup_disabled
      - narrate "<&[green]>Item pickup disabled"

open_materials_menu:
  type: task
  debug: false
  script:
    - if !<player.has_flag[behr.essentials.builder.settings.material_list_verbose]>:
      - inventory open d:material_list_inventory_simple
    - else:
      - inventory open d:material_list_inventory_verbose


material_list_inventory_simple:
  type: inventory
  debug: false
  inventory: chest
  title: <script.parsed_key[data.title].unseparated>
  size: 27
  data:
    title:
      - <&f><proc[negative_spacing].context[9].font[utility:spacing]>
      - <&chr[1029].font[gui]>

  definitions:
    # menus
    command: inventory_item[color=<color[red].with_hue[100]>;display=<&[green]>commands;flag=menu:commands]
    teleport: inventory_item[color=<color[red].with_hue[120]>;display=<&[green]>teleport menu;flag=menu:teleport]
    something_else: inventory_item[color=<color[red].with_hue[140]>;display=<&[green]>materials;flag=menu:materials]

    # row 1
    building_blocks: stone_bricks
    colored: red_wool
    glass: red_stained_glass
    oceanic: pufferfish

    # row 2
    wood: oak_log
    stairs_and_slabs: oak_stairs
    fences_and_walls: oak_fence
    nature: poppy

    # row 3
    light: light[block_material=light[level=15]]
    favorite: diamond
    creative: blaze_rod[custom_model_data=1]
    search: spyglass

    # back button
    command_menu: inventory_item[custom_model_data=1;flag=menu:commands]
  slots:
    - [] [] [] [building_blocks] [colored] [glass] [oceanic] [] []
    - [] [] [] [wood] [stairs_and_slabs] [fences_and_walls] [nature] [] []
    - [] [] [] [light] [favorite] [creative] [search] [] [command_menu]

material_list_inventory_verbose:
  type: inventory
  debug: false
  inventory: chest
  title: <script.parsed_key[data.title].unseparated>
  size: 27
  data:
    title:
      - <&f><proc[negative_spacing].context[9].font[utility:spacing]>
      - <&chr[1028].font[gui]>
  definitions:
    building_blocks: stone
    stones_and_bricks: stone_bricks
    ores: diamond_ore
    colored: red_wool
    terracotta_and_concrete: red_terracotta
    glass: red_stained_glass

    copper: copper_block
    wood: oak_log
    stairs_and_slabs: oak_stairs
    fences_and_walls: oak_fence
    nature: poppy
    containers: chest

    oceanic: pufferfish
    buckets_and_fish: pufferfish_bucket
    light: light[block_material=light[level=15]]
    favorite: diamond
    creative: blaze_rod[custom_model_data=1]
    search: spyglass

    command_menu: inventory_item[custom_model_data=1;flag=menu:commands]

  slots:
    - [] [] [building_blocks] [stones_and_bricks] [ores] [colored] [terracotta_and_concrete] [glass] []
    - [] [] [copper] [wood] [stairs_and_slabs] [fences_and_walls] [nature] [containers] []
    - [] [] [oceanic] [buckets_and_fish] [light] [favorite] [creative] [search] [command_menu]


open_crafting_table_menu:
  type: task
  debug: false
  script:
    - define location <player.location.with_y[-64]>
    - define previous_material <[location].material>
    - modifyblock <[location]> crafting_table
    - adjust <player> show_workbench:<[location]>
    - modifyblock <[location]> <[previous_material]>

open_spectator_menu:
  type: task
  debug: false
  script:
    - if <player.gamemode> != spectator:
      - adjust <player> gamemode:spectator
      - narrate "<&[green]>Spectator enabled"
      - flag player behr.essentials.builder.settings.builder_spectator
      - inventory close
      - while <player.is_online> && <player.has_flag[behr.essentials.builder.settings.builder_spectator]>:
        - actionbar "<&[green]>Shift+click to exit Spectator mode"
        - wait 2s

open_night_vision_menu:
  type: task
  debug: false
  script:
    - if <player.effects_data.parse[get[type]].contains[night_vision]>:
      - cast night_vision remove <player>
      - narrate "<&[red]>Night vision disabled"
    - else:
      - cast night_vision d:1d no_ambient no_icon
      - narrate "<&[green]>Night vision enabled"

open_weather_menu:
  type: task
  debug: false
  script:
    - inventory open d:weather_menu_gui

weather_menu_gui:
  type: inventory
  debug: false
  inventory: chest
  title: <script.parsed_key[data.title].unseparated>
  size: 9
  gui: true
  data:
    title:
      - <&f><proc[negative_spacing].context[9].font[utility:spacing]>
      - <&chr[1032].font[gui]>
  definitions:
    clear: book[display=<&[green]>Clear;flag=weather:clear]
    stormy: book[display=<&[green]>Stormy;flag=weather:stormy]
    sunny: book[display=<&[green]>Sunny;flag=weather:sunny]
    thunder: book[display=<&[green]>Thunder;flag=weather:thunder]
    lock: book[display=<&[green]>Lock;flag=weather:lock]
    command_menu: inventory_item[display=back;custom_model_data=1;flag=menu:commands]
  slots:
    - [] [] [clear] [stormy] [sunny] [thunder] [lock] [] [command_menu]

open_time_menu:
  type: task
  debug: false
  script:
    - inventory open d:time_menu_gui

time_menu_gui:
  type: inventory
  debug: false
  inventory: chest
  title: <script.parsed_key[data.title].unseparated>
  size: 18
  gui: true
  data:
    title:
      - <&f><proc[negative_spacing].context[9].font[utility:spacing]>
      - <&chr[1034].font[gui]>
  definitions:
    bedtime: book[display=<&[green]>Bedtime;lore=<&[yellow]>Click to set;flag=set_time:Bedtime]
    dawn: book[display=<&[green]>Dawn;lore=<&[yellow]>Click to set;flag=set_time:Dawn]
    day: book[display=<&[green]>Day;lore=<&[yellow]>Click to set;flag=set_time:Day]
    dusk: book[display=<&[green]>Dusk;lore=<&[yellow]>Click to set;flag=set_time:Dusk]
    midnight: book[display=<&[green]>Midnight;lore=<&[yellow]>Click to set;flag=set_time:Midnight]

    night: book[display=<&[green]>Night;lore=<&[yellow]>Click to set;flag=set_time:Night]
    noon: book[display=<&[green]>Noon;lore=<&[yellow]>Click to set;flag=set_time:Noon]
    start: book[display=<&[green]>Start;lore=<&[yellow]>Click to set;flag=set_time:Start]
    sunrise: book[display=<&[green]>Sunrise;lore=<&[yellow]>Click to set;flag=set_time:Sunrise]
    sunset: book[display=<&[green]>Sunset;lore=<&[yellow]>Click to set;flag=set_time:Sunset]
    clear: book[display=<&[green]>Clear;flag=weather:clear]

    lock: book[display=<&[green]>lock;lore=<&[yellow]>Click to lock;flag=set_time:lock]
    unlock: book[display=<&[green]>unlock;lore=<&[yellow]>Click to unlock;flag=set_time:unlock]

    command_menu: inventory_item[display=Back;custom_model_data=1;flag=menu:commands]
  slots:
    - [] [start] [day] [noon] [sunset] [bedtime] [lock] [] []
    - [] [dusk] [night] [midnight] [sunrise] [dawn] [unlock] [] [command_menu]

open_flight_menu:
  type: task
  debug: false
  script:
    - define player_fly_speed <player.fly_speed.round_to_precision[0.05]>
    - define inventory <inventory[flight_menu_gui]>
    - if !<player.has_flag[behr.essentials.builder_mode.flight_disabled]>:
      - define new_increased_flight_speed <[player_fly_speed].add[0.05].mul[10]>
      - if <[new_increased_flight_speed]> > 10:
        - define controls "<list_single[<item[book].with[display=<&[green]>Increase fly speed;lore=<&[red]>Maximum fly speed].with_flag[flight:Increase]>]>"

      - else:
        - define controls "<list_single[<item[book].with[display=<&[green]>Increase fly speed;lore=<&[green]>Increase to<&co> <&[yellow]><[new_increased_flight_speed]>].with_flag[flight:Increase]>]>"
      - if <[player_fly_speed]> == 0.2:
        - define controls "<[controls].include_single[<item[book].with[display=<&[green]>Fly speed<&co>;lore=<&[green]>Speed<&co> <&[yellow]>Default (2)].with_flag[flight:default]>]>"
      - else:
        - define controls "<[controls].include_single[<item[book].with[display=<&[green]>Fly speed<&co>;lore=<&[green]>Speed<&co> <&[yellow]><[player_fly_speed].mul[10]>|<&[yellow]>Click to reset].with_flag[flight:default]>]>"

      - define new_decreased_flight_speed <[player_fly_speed].sub[0.05].mul[10]>
      - if <[new_decreased_flight_speed]> < 0:
        - define controls "<[controls].include_single[<item[book].with[display=<&[green]>Decrease fly speed;lore=<&[red]>Minimum fly speed].with_flag[flight:Decrease]>]>"
      - else:
        - define controls "<[controls].include_single[<item[book].with[display=<&[green]>Decrease fly speed;lore=<&[green]>Decrease to<&co> <&[yellow]><[new_decreased_flight_speed]>].with_flag[flight:Decrease]>]>"
      - inventory set slot:2 d:<[inventory]> o:<[controls]>

    - else:
      - inventory set slot:2 d:<[inventory]> "o:<item[book].with[display=<&[green]>Flight Disabled].with_flag[flight:enable].repeat_as_list[3]>"
    - inventory open d:<[inventory]>

flight_menu_gui:
  type: inventory
  debug: false
  inventory: chest
  title: <script.parsed_key[data.title].unseparated>
  size: 9
  gui: true
  data:
    title:
      - <&f><proc[negative_spacing].context[9].font[utility:spacing]>
      - <&chr[1031].font[gui]>
  definitions:
    enable: book[display=Enable;flag=flight:enable]
    disable: book[display=Disabled;flag=flight:disable]

    command_menu: inventory_item[display=back;custom_model_data=1;flag=menu:commands]
  slots:
    #- [] [increase] [preview] [decrease] [] [enable] [disable] [] [command_menu]
    - [] [] [] [] [] [] [enable] [disable] [command_menu]

open_walk_menu:
  type: task
  debug: false
  script:
    - define player_walk_speed <player.walk_speed.round_to_precision[0.05]>
    - define inventory <inventory[walk_menu_gui]>
    - define new_increased_walk_speed <[player_walk_speed].add[0.05].mul[10]>
    - if <[new_increased_walk_speed]> > 10:
      - define controls "<list_single[<item[book].with[display=<&[green]>Increase walk speed;lore=<&[red]>Maximum walk speed].with_flag[walk:Increase]>]>"
    - else if <[new_increased_walk_speed]> == 2:
      - define controls "<list_single[<item[book].with[display=<&[green]>Increase walk speed;lore=<&[green]>Increase to<&co> <&[yellow]>2|<&[yellow]>(Default)].with_flag[walk:Increase]>]>"
    - else:
      - define controls "<list_single[<item[book].with[display=<&[green]>Increase walk speed;lore=<&[green]>Increase to<&co> <&[yellow]><[new_increased_walk_speed]>].with_flag[walk:Increase]>]>"

    - if <[player_walk_speed]> == 0.2:
      - define controls "<[controls].include_single[<item[book].with[display=<&[green]>walk speed<&co>;lore=<&[green]>Speed<&co> <&[yellow]>2|<&[yellow]>(Default)].with_flag[walk:default]>]>"
    - else if <[player_walk_speed]> == 0:
      - define controls "<list_single[<item[book].with[display=<&[green]>Increase walk speed;lore=<&[red]>Minimum walk speed].with_flag[walk:Increase]>]>"
    - else if <[player_walk_speed]> == 1:
      - define controls "<[controls].include_single[<item[book].with[display=<&[green]>Decrease walk speed;lore=<&[red]>Maximum walk speed].with_flag[walk:Decrease]>]>"
    - else:
      - define controls "<[controls].include_single[<item[book].with[display=<&[green]>walk speed<&co>;lore=<&[green]>Speed<&co> <&[yellow]><[player_walk_speed].mul[10]>|<&[yellow]>Click to reset].with_flag[walk:default]>]>"

    - define new_decreased_walk_speed <[player_walk_speed].sub[0.05].mul[10]>
    - if <[new_decreased_walk_speed]> < 0:
      - define controls "<[controls].include_single[<item[book].with[display=<&[green]>Decrease walk speed;lore=<&[red]>Minimum walk speed].with_flag[walk:Decrease]>]>"
    - else if <[new_decreased_walk_speed]> == 2:
      - define controls "<[controls].include_single[<item[book].with[display=<&[green]>Decrease walk speed;lore=<&[green]>Decrease to<&co> <&[yellow]>2|<&[yellow]>].with_flag[walk:Decrease]>]>"
    - else:
      - define controls "<[controls].include_single[<item[book].with[display=<&[green]>Decrease walk speed;lore=<&[green]>Decrease to<&co> <&[yellow]><[new_decreased_walk_speed]>].with_flag[walk:Decrease]>]>"
    - inventory set slot:4 d:<[inventory]> o:<[controls]>

    - inventory open d:<[inventory]>

walk_menu_gui:
  type: inventory
  debug: false
  inventory: chest
  title: <script.parsed_key[data.title].unseparated>
  size: 9
  gui: true
  data:
    title:
      - <&f><proc[negative_spacing].context[9].font[utility:spacing]>
      - <&chr[1035].font[gui]>

  definitions:
    command_menu: inventory_item[display=back;custom_model_data=1;flag=menu:commands]
  slots:
    - [] [] [] [] [] [] [] [] [command_menu]


inventory_item:
  debug: false
  type: item
  material: leather_horse_armor

builder_mode_handler:
  type: world
  debug: false
  data:
    items:
      - inventory_item[color=<color[red].with_hue[100]>;display=<&[green]>commands;flag=menu:commands]
      - inventory_item[color=<color[red].with_hue[120]>;display=<&[green]>teleport menu;flag=menu:teleport]
      - inventory_item[color=<color[red].with_hue[140]>;display=<&[green]>materials;flag=menu:materials]
      - inventory_item[color=<color[red].with_hue[160]>;display=<&[green]>crafting;flag=menu:crafting]

  set_inventory:
    - if <player.inventory> != <player.open_inventory>:
      - wait 1t

    - stop if:!<player.inventory.equals[<player.open_inventory.if_null[logged_out]>]>

    - define inventory <player.open_inventory>

    # Needed to prevent death dropping
    - repeat 5 as:slot:
      - inventory set slot:<[slot]> o:air d:<[inventory]>
    - wait 1t

    - stop if:<player.is_online.not>
    - foreach <script.parsed_key[data.items]> as:item:
      - inventory set slot:<[loop_index].add[1]> o:<[item]> d:<[inventory]>
    - wait 1t

    # this is the far right edge of the screen
    #- inventory set slot:1 o:sand d:<[inventory]>
    - inventory update

  events:
    after player joins flagged:behr.essentials.gamemode.builder_mode:
      - inject builder_mode_handler.set_inventory
      - adjust <player> can_fly:true if:!<player.has_flag[behr.essentials.builder_mode.flight_disabled]>
      - if <player.has_flag[behr.essentials.builder_mode.logged_flying]>:
        - adjust <player> flying:true
        - flag player behr.essentials.builder_mode.logged_flying:!

    on player quits flagged:behr.essentials.gamemode.builder_mode:
      - if <player.is_flying>:
        - flag <player> behr.essentials.builder_mode.logged_flying

    on player closes inventory flagged:behr.essentials.gamemode.builder_mode:
      - inject builder_mode_handler.set_inventory

    on player dies flagged:behr.essentials.gamemode.builder_mode:
      - inventory close
      - inventory clear d:<player.open_inventory>

    on player teleports flagged:behr.essentials.gamemode.builder_mode:
      - inventory close
      - inject builder_mode_handler.set_inventory

    on player uses recipe book flagged:behr.essentials.gamemode.builder_mode:
      - if <player.open_inventory.inventory_type> != WORKBENCH:
        - determine cancelled

    on player respawns flagged:behr.essentials.gamemode.builder_mode:
      - inject builder_mode_handler.set_inventory

    on player clicks item_flagged:builder_gamemode_item in inventory:
      - determine cancelled

    on player drops item_flagged:builder_gamemode_item:
      - determine cancelled

    on entity targets player flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player changes farmland into dirt flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player changes food level flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player combusts flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player damaged flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player changes xp flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player consumes item flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player empties lava_bucket flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    after player empties water_bucket flagged:behr.essentials.gamemode.builder_mode:
      - if <player.item_in_hand.material.name> == water_bucket:
        - inventory set slot:hand destination:<player.inventory> origin:water_bucket
      - else if <player.item_in_offhand.material.name> == water_bucket:
        - inventory set slot:offhand destination:<player.inventory> origin:water_bucket
      - else:
        - inventory set slot:<player.inventory.find_item[bucket]> origin:water_bucket

    on player item takes damage flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    after player leaves bed flagged:behr.essentials.gamemode.builder_mode:
      - narrate "<&[green]>Goodmorning cutie, happy building ;3"

    after player locale change:
      - if <context.new_locale> != en_us:
        - narrate "<&[red]>Note<&co> <&[yellow]>Only english and pirate are supported currently."

    on player picks up launched arrow flagged:behr.essentials.gamemode.builder_mode:
      - determine cancelled

    on player changes gamemode to creative|spectator flagged:behr.essentials.gamemode.builder_mode:
      - if <player.is_flying>:
        - flag <player> behr.essentials.builder_mode.was_flying

    on player changes gamemode to survival flagged:behr.essentials.gamemode.builder_mode:
      - inject builder_mode_handler.set_inventory
      - adjust <player> can_fly:true if:!<player.has_flag[behr.essentials.builder_mode.flight_disabled]>
      - if <player.has_flag[behr.essentials.builder_mode.was_flying]>:
        - adjust <player> flying:true
        - flag player behr.essentials.builder_mode.was_flying:!
    #on player clicks inventory_item in inventory:
    #  - if <context.inventory> == <player.open_inventory> && <list[1|2|3|4|5].contains[<context.raw_slot>]>:
    #    - determine cancelled
#<proc[negative_spacing].context[40].font[utility:spaci].space_separated>

material_list:
  type: data
  blocks:
    building_blocks:
      - stone
      - granite
      - polished_granite
      - diorite
      - polished_diorite
      - andesite
      - polished_andesite
      - deepslate
      - cobbled_deepslate
      - polished_deepslate
      - calcite
      - tuff
      - dripstone_block
      - grass_block
      - dirt
      - coarse_dirt
      - podzol
      - rooted_dirt
      - mud
      - crimson_nylium
      - warped_nylium
      - cobblestone
      - bedrock
      - sand
      - red_sand
      - gravel
      - ancient_debris
      - coal_block
      - raw_iron_block
      - raw_copper_block
      - raw_gold_block
      - amethyst_block
      - budding_amethyst
      - iron_block
      - copper_block
      - gold_block
      - diamond_block
      - netherite_block
      - exposed_copper
      - weathered_copper
      - oxidized_copper
      - cut_copper
      - exposed_cut_copper
      - weathered_cut_copper
      - oxidized_cut_copper
      - waxed_copper_block
      - waxed_exposed_copper
      - waxed_weathered_copper
      - waxed_oxidized_copper
      - waxed_cut_copper
      - waxed_exposed_cut_copper
      - waxed_weathered_cut_copper
      - waxed_oxidized_cut_copper
      - crimson_hyphae
      - warped_hyphae
      - sponge
      - wet_sponge
      - lapis_block
      - sandstone
      - chiseled_sandstone
      - cut_sandstone
      - white_wool
      - orange_wool
      - magenta_wool
      - light_blue_wool
      - yellow_wool
      - lime_wool
      - pink_wool
      - gray_wool
      - light_gray_wool
      - cyan_wool
      - purple_wool
      - blue_wool
      - brown_wool
      - green_wool
      - red_wool
      - black_wool
      - smooth_quartz
      - smooth_red_sandstone
      - smooth_sandstone
      - smooth_stone
      - bricks
      - bookshelf
      - mossy_cobblestone
      - obsidian
      - purpur_block
      - purpur_pillar
      - farmland
      - ice
      - snow_block
      - clay
      - netherrack
      - soul_sand
      - soul_soil
      - basalt
      - polished_basalt
      - smooth_basalt
      - glowstone
      - stone_bricks
      - mossy_stone_bricks
      - cracked_stone_bricks
      - chiseled_stone_bricks
      - packed_mud
      - mud_bricks
      - deepslate_bricks
      - cracked_deepslate_bricks
      - deepslate_tiles
      - cracked_deepslate_tiles
      - chiseled_deepslate
      - reinforced_deepslate
      - brown_mushroom_block
      - red_mushroom_block
      - mushroom_stem
      - mycelium
      - nether_bricks
      - cracked_nether_bricks
      - chiseled_nether_bricks
      - sculk
      - sculk_catalyst
      - end_stone
      - end_stone_bricks
      - emerald_block
      - beacon
      - chiseled_quartz_block
      - quartz_block
      - quartz_bricks
      - quartz_pillar
      - white_terracotta
      - orange_terracotta
      - magenta_terracotta
      - light_blue_terracotta
      - yellow_terracotta
      - lime_terracotta
      - pink_terracotta
      - gray_terracotta
      - light_gray_terracotta
      - cyan_terracotta
      - purple_terracotta
      - blue_terracotta
      - brown_terracotta
      - green_terracotta
      - red_terracotta
      - black_terracotta
      - hay_block
      - terracotta
      - packed_ice
      - dirt_path
      - prismarine
      - prismarine_bricks
      - dark_prismarine
      - sea_lantern
      - red_sandstone
      - chiseled_red_sandstone
      - cut_red_sandstone
      - magma_block
      - nether_wart_block
      - warped_wart_block
      - red_nether_bricks
      - bone_block
      - white_glazed_terracotta
      - orange_glazed_terracotta
      - magenta_glazed_terracotta
      - light_blue_glazed_terracotta
      - yellow_glazed_terracotta
      - lime_glazed_terracotta
      - pink_glazed_terracotta
      - gray_glazed_terracotta
      - light_gray_glazed_terracotta
      - cyan_glazed_terracotta
      - purple_glazed_terracotta
      - blue_glazed_terracotta
      - brown_glazed_terracotta
      - green_glazed_terracotta
      - red_glazed_terracotta
      - black_glazed_terracotta
      - white_concrete
      - orange_concrete
      - magenta_concrete
      - light_blue_concrete
      - yellow_concrete
      - lime_concrete
      - pink_concrete
      - gray_concrete
      - light_gray_concrete
      - cyan_concrete
      - purple_concrete
      - blue_concrete
      - brown_concrete
      - green_concrete
      - red_concrete
      - black_concrete
      - white_concrete_powder
      - orange_concrete_powder
      - magenta_concrete_powder
      - light_blue_concrete_powder
      - yellow_concrete_powder
      - lime_concrete_powder
      - pink_concrete_powder
      - gray_concrete_powder
      - light_gray_concrete_powder
      - cyan_concrete_powder
      - purple_concrete_powder
      - blue_concrete_powder
      - brown_concrete_powder
      - green_concrete_powder
      - red_concrete_powder
      - black_concrete_powder
      - dead_tube_coral_block
      - dead_brain_coral_block
      - dead_bubble_coral_block
      - dead_fire_coral_block
      - dead_horn_coral_block
      - tube_coral_block
      - brain_coral_block
      - bubble_coral_block
      - fire_coral_block
      - horn_coral_block
      - blue_ice
      - redstone_block
      - slime_block
      - honey_block
      - redstone_lamp
      - note_block
      - dried_kelp_block
      - cauldron
      - chest
      - ender_chest
      - composter
      - barrel
      - smoker
      - blast_furnace
      - cartography_table
      - fletching_table
      - grindstone
      - smithing_table
      - stonecutter
      - shroomlight
      - bee_nest
      - beehive
      - honeycomb_block
      - lodestone
      - crying_obsidian
      - blackstone
      - gilded_blackstone
      - polished_blackstone
      - chiseled_polished_blackstone
      - polished_blackstone_bricks
      - cracked_polished_blackstone_bricks
      - respawn_anchor
      - ochre_froglight
      - verdant_froglight
      - pearlescent_froglight
    wood:
      - oak_planks
      - spruce_planks
      - birch_planks
      - jungle_planks
      - acacia_planks
      - dark_oak_planks
      - mangrove_planks
      - crimson_planks
      - warped_planks
      - oak_log
      - spruce_log
      - birch_log
      - jungle_log
      - acacia_log
      - dark_oak_log
      - mangrove_log
      - mangrove_roots
      - muddy_mangrove_roots
      - crimson_stem
      - warped_stem
      - stripped_oak_log
      - stripped_spruce_log
      - stripped_birch_log
      - stripped_jungle_log
      - stripped_acacia_log
      - stripped_dark_oak_log
      - stripped_mangrove_log
      - stripped_crimson_stem
      - stripped_warped_stem
      - stripped_oak_wood
      - stripped_spruce_wood
      - stripped_birch_wood
      - stripped_jungle_wood
      - stripped_acacia_wood
      - stripped_dark_oak_wood
      - stripped_mangrove_wood
      - stripped_crimson_hyphae
      - stripped_warped_hyphae
      - oak_wood
      - spruce_wood
      - birch_wood
      - jungle_wood
      - acacia_wood
      - dark_oak_wood
      - mangrove_wood
      - crimson_hyphae
      - warped_hyphae
      - oak_leaves
      - spruce_leaves
      - birch_leaves
      - jungle_leaves
      - acacia_leaves
      - dark_oak_leaves
      - mangrove_leaves
      - azalea_leaves
      - flowering_azalea_leaves
      - oak_slab
      - spruce_slab
      - birch_slab
      - jungle_slab
      - acacia_slab
      - dark_oak_slab
      - mangrove_slab
      - crimson_slab
      - warped_slab
      - oak_stairs
      - spruce_stairs
      - birch_stairs
      - jungle_stairs
      - acacia_stairs
      - dark_oak_stairs
      - mangrove_stairs
      - crimson_stairs
      - warped_stairs
      - oak_pressure_plate
      - spruce_pressure_plate
      - birch_pressure_plate
      - jungle_pressure_plate
      - acacia_pressure_plate
      - dark_oak_pressure_plate
      - mangrove_pressure_plate
      - crimson_pressure_plate
      - warped_pressure_plate
      - oak_door
      - spruce_door
      - birch_door
      - jungle_door
      - acacia_door
      - dark_oak_door
      - mangrove_door
      - crimson_door
      - warped_door
      - oak_trapdoor
      - spruce_trapdoor
      - birch_trapdoor
      - jungle_trapdoor
      - acacia_trapdoor
      - dark_oak_trapdoor
      - mangrove_trapdoor
      - crimson_trapdoor
      - warped_trapdoor
      - oak_fence_gate
      - spruce_fence_gate
      - birch_fence_gate
      - jungle_fence_gate
      - acacia_fence_gate
      - dark_oak_fence_gate
      - mangrove_fence_gate
      - crimson_fence_gate
      - warped_fence_gate
      - oak_sign
      - spruce_sign
      - birch_sign
      - jungle_sign
      - acacia_sign
      - dark_oak_sign
      - mangrove_sign
      - crimson_sign
      - warped_sign
      - oak_fence
      - spruce_fence
      - birch_fence
      - jungle_fence
      - acacia_fence
      - dark_oak_fence
      - mangrove_fence
      - crimson_fence
      - warped_fence
      - ladder
    fences_and_walls:
      - cobblestone_wall
      - mossy_cobblestone_wall
      - brick_wall
      - prismarine_wall
      - red_sandstone_wall
      - mossy_stone_brick_wall
      - granite_wall
      - stone_brick_wall
      - nether_brick_wall
      - andesite_wall
      - red_nether_brick_wall
      - sandstone_wall
      - end_stone_brick_wall
      - diorite_wall
      - blackstone_wall
      - polished_blackstone_wall
      - polished_blackstone_brick_wall
      - cobbled_deepslate_wall
      - polished_deepslate_wall
      - deepslate_brick_wall
      - deepslate_tile_wall
      - oak_fence
      - spruce_fence
      - birch_fence
      - jungle_fence
      - acacia_fence
      - dark_oak_fence
      - crimson_fence
      - warped_fence
      - nether_brick_fence
      - oak_fence_gate
      - spruce_fence_gate
      - birch_fence_gate
      - jungle_fence_gate
      - acacia_fence_gate
      - dark_oak_fence_gate
      - crimson_fence_gate
      - warped_fence_gate
    colored:
      - white_wool
      - orange_wool
      - magenta_wool
      - light_blue_wool
      - yellow_wool
      - lime_wool
      - pink_wool
      - gray_wool
      - light_gray_wool
      - cyan_wool
      - purple_wool
      - blue_wool
      - brown_wool
      - green_wool
      - red_wool
      - black_wool
      - chiseled_quartz_block
      - quartz_block
      - quartz_bricks
      - quartz_pillar
      - white_terracotta
      - orange_terracotta
      - magenta_terracotta
      - light_blue_terracotta
      - yellow_terracotta
      - lime_terracotta
      - pink_terracotta
      - gray_terracotta
      - light_gray_terracotta
      - cyan_terracotta
      - purple_terracotta
      - blue_terracotta
      - brown_terracotta
      - green_terracotta
      - red_terracotta
      - black_terracotta
      - white_carpet
      - orange_carpet
      - magenta_carpet
      - light_blue_carpet
      - yellow_carpet
      - lime_carpet
      - pink_carpet
      - gray_carpet
      - light_gray_carpet
      - cyan_carpet
      - purple_carpet
      - blue_carpet
      - brown_carpet
      - green_carpet
      - red_carpet
      - black_carpet
      - terracotta
      - white_stained_glass
      - orange_stained_glass
      - magenta_stained_glass
      - light_blue_stained_glass
      - yellow_stained_glass
      - lime_stained_glass
      - pink_stained_glass
      - gray_stained_glass
      - light_gray_stained_glass
      - cyan_stained_glass
      - purple_stained_glass
      - blue_stained_glass
      - brown_stained_glass
      - green_stained_glass
      - red_stained_glass
      - black_stained_glass
      - white_stained_glass_pane
      - orange_stained_glass_pane
      - magenta_stained_glass_pane
      - yellow_stained_glass_pane
      - lime_stained_glass_pane
      - pink_stained_glass_pane
      - light_gray_stained_glass_pane
      - cyan_stained_glass_pane
      - purple_stained_glass_pane
      - brown_stained_glass_pane
      - green_stained_glass_pane
      - red_stained_glass_pane
      - black_stained_glass_pane
      - white_glazed_terracotta
      - orange_glazed_terracotta
      - magenta_glazed_terracotta
      - light_blue_glazed_terracotta
      - yellow_glazed_terracotta
      - lime_glazed_terracotta
      - pink_glazed_terracotta
      - gray_glazed_terracotta
      - light_gray_glazed_terracotta
      - cyan_glazed_terracotta
      - purple_glazed_terracotta
      - blue_glazed_terracotta
      - brown_glazed_terracotta
      - green_glazed_terracotta
      - red_glazed_terracotta
      - black_glazed_terracotta
      - white_concrete
      - orange_concrete
      - magenta_concrete
      - light_blue_concrete
      - yellow_concrete
      - lime_concrete
      - pink_concrete
      - gray_concrete
      - light_gray_concrete
      - cyan_concrete
      - purple_concrete
      - blue_concrete
      - brown_concrete
      - green_concrete
      - red_concrete
      - black_concrete
      - white_concrete_powder
      - orange_concrete_powder
      - magenta_concrete_powder
      - light_blue_concrete_powder
      - yellow_concrete_powder
      - lime_concrete_powder
      - pink_concrete_powder
      - gray_concrete_powder
      - light_gray_concrete_powder
      - cyan_concrete_powder
      - purple_concrete_powder
      - blue_concrete_powder
      - brown_concrete_powder
      - green_concrete_powder
      - black_concrete_powder
      - tube_coral_block
      - brain_coral_block
      - bubble_coral_block
      - fire_coral_block
      - horn_coral_block
      - white_bed
      - orange_bed
      - magenta_bed
      - light_blue_bed
      - yellow_bed
      - lime_bed
      - pink_bed
      - gray_bed
      - light_gray_bed
      - cyan_bed
      - purple_bed
      - blue_bed
      - brown_bed
      - green_bed
      - red_bed
      - black_bed
      - white_banner
      - orange_banner
      - magenta_banner
      - light_blue_banner
      - yellow_banner
      - lime_banner
      - pink_banner
      - gray_banner
      - light_gray_banner
      - cyan_banner
      - purple_banner
      - blue_banner
      - brown_banner
      - green_banner
      - red_banner
      - black_banner
      - flower_banner_pattern
      - creeper_banner_pattern
      - skull_banner_pattern
      - mojang_banner_pattern
      - globe_banner_pattern
      - piglin_banner_pattern
      - candle
      - white_candle
      - orange_candle
      - magenta_candle
      - light_blue_candle
      - yellow_candle
      - lime_candle
      - pink_candle
      - gray_candle
      - light_gray_candle
      - cyan_candle
      - purple_candle
      - blue_candle
      - brown_candle
      - green_candle
      - red_candle
      - black_candle
      - white_dye
      - orange_dye
      - magenta_dye
      - light_blue_dye
      - yellow_dye
      - lime_dye
      - pink_dye
      - gray_dye
      - light_gray_dye
      - cyan_dye
      - purple_dye
      - blue_dye
      - brown_dye
      - green_dye
      - red_dye
      - black_dye
      - loom
    nature:
      - oak_leaves
      - spruce_leaves
      - birch_leaves
      - jungle_leaves
      - acacia_leaves
      - dark_oak_leaves
      - mangrove_leaves
      - azalea_leaves
      - flowering_azalea_leaves
      - cobweb
      - grass
      - fern
      - azalea
      - flowering_azalea
      - dead_bush
      - seagrass
      - sea_pickle
      - dandelion
      - poppy
      - blue_orchid
      - allium
      - azure_bluet
      - red_tulip
      - orange_tulip
      - white_tulip
      - pink_tulip
      - oxeye_daisy
      - cornflower
      - lily_of_the_valley
      - wither_rose
      - spore_blossom
      - brown_mushroom
      - red_mushroom
      - crimson_fungus
      - warped_fungus
      - crimson_roots
      - warped_roots
      - nether_sprouts
      - weeping_vines
      - twisting_vines
      - sugar_cane
      - kelp
      - moss_carpet
      - moss_block
      - hanging_roots
      - big_dripleaf
      - small_dripleaf
      - bamboo
      - oak_sapling
      - spruce_sapling
      - birch_sapling
      - jungle_sapling
      - acacia_sapling
      - dark_oak_sapling
      - mangrove_propagule
      - bone_meal
      - chorus_plant
      - chorus_flower
      - cactus
      - pumpkin
      - carved_pumpkin
      - jack_o_lantern
      - melon
      - vine
      - glow_lichen
      - lily_pad
      - red_mushroom_block
      - mushroom_stem
      - brown_mushroom_block
      - mycelium
      - lily_pad
      - grass_block
      - dirt
      - coarse_dirt
      - podzol
      - rooted_dirt
      - packed_mud
      - mud
      - sunflower
      - lilac
      - rose_bush
      - peony
      - tall_grass
      - large_fern
      - wheat_seeds
      - cocoa_beans
      - beetroot_seeds
      - potato
      - carrot
      - sweet_berries
      - glow_berries
      - pointed_dripstone
      - frogspawn
      - pointed_dripstone
      - mossy_cobblestone
      - mossy_stone_bricks
      - mossy_cobblestone_wall
      - mossy_stone_brick_wall
      - mossy_stone_brick_stairs
      - mossy_cobblestone_stairs
      - mossy_stone_brick_slab
      - mossy_stone_brick_slab
    glass:
      - glass
      - white_stained_glass
      - orange_stained_glass
      - magenta_stained_glass
      - light_blue_stained_glass
      - yellow_stained_glass
      - lime_stained_glass
      - pink_stained_glass
      - gray_stained_glass
      - light_gray_stained_glass
      - cyan_stained_glass
      - purple_stained_glass
      - blue_stained_glass
      - brown_stained_glass
      - green_stained_glass
      - red_stained_glass
      - black_stained_glass
      - tinted_glass
      - glass_pane
      - white_stained_glass_pane
      - orange_stained_glass_pane
      - magenta_stained_glass_pane
      - light_blue_stained_glass_pane
      - yellow_stained_glass_pane
      - lime_stained_glass_pane
      - pink_stained_glass_pane
      - gray_stained_glass_pane
      - light_gray_stained_glass_pane
      - cyan_stained_glass_pane
      - purple_stained_glass_pane
      - blue_stained_glass_pane
      - brown_stained_glass_pane
      - green_stained_glass_pane
      - red_stained_glass_pane
      - black_stained_glass_pane
    terracotta_and_concrete:
      - terracotta
      - white_terracotta
      - orange_terracotta
      - magenta_terracotta
      - light_blue_terracotta
      - yellow_terracotta
      - lime_terracotta
      - pink_terracotta
      - gray_terracotta
      - light_gray_terracotta
      - cyan_terracotta
      - purple_terracotta
      - blue_terracotta
      - brown_terracotta
      - green_terracotta
      - red_terracotta
      - black_terracotta
      - white_glazed_terracotta
      - orange_glazed_terracotta
      - magenta_glazed_terracotta
      - light_blue_glazed_terracotta
      - yellow_glazed_terracotta
      - lime_glazed_terracotta
      - pink_glazed_terracotta
      - gray_glazed_terracotta
      - light_gray_glazed_terracotta
      - cyan_glazed_terracotta
      - purple_glazed_terracotta
      - blue_glazed_terracotta
      - brown_glazed_terracotta
      - green_glazed_terracotta
      - red_glazed_terracotta
      - black_glazed_terracotta

      - white_concrete
      - orange_concrete
      - magenta_concrete
      - light_blue_concrete
      - yellow_concrete
      - lime_concrete
      - pink_concrete
      - gray_concrete
      - light_gray_concrete
      - cyan_concrete
      - purple_concrete
      - blue_concrete
      - brown_concrete
      - green_concrete
      - red_concrete
      - black_concrete
      - air
      - air
      - white_concrete_powder
      - orange_concrete_powder
      - magenta_concrete_powder
      - light_blue_concrete_powder
      - yellow_concrete_powder
      - lime_concrete_powder
      - pink_concrete_powder
      - gray_concrete_powder
      - light_gray_concrete_powder
      - cyan_concrete_powder
      - purple_concrete_powder
      - blue_concrete_powder
      - brown_concrete_powder
      - green_concrete_powder
      - red_concrete_powder
      - black_concrete_powder
    oceanic:
        - tube_coral_block
        - brain_coral_block
        - bubble_coral_block
        - fire_coral_block
        - horn_coral_block
        - tube_coral
        - brain_coral
        - bubble_coral
        - fire_coral
        - horn_coral
        - tube_coral_fan
        - brain_coral_fan
        - bubble_coral_fan
        - fire_coral_fan
        - horn_coral_fan
        - dead_tube_coral_block
        - dead_brain_coral_block
        - dead_bubble_coral_block
        - dead_fire_coral_block
        - dead_horn_coral_block
        - dead_brain_coral
        - dead_bubble_coral
        - dead_fire_coral
        - dead_horn_coral
        - dead_tube_coral
        - dead_tube_coral_fan
        - dead_brain_coral_fan
        - dead_bubble_coral_fan
        - dead_fire_coral_fan
        - dead_horn_coral_fan
        - sponge
        - wet_sponge
        - sand
        - dirt
        - gravel
        - clay_block
        - water_bucket
        - pufferfish_bucket
        - salmon_bucket
        - cod_bucket
        - tropical_fish_bucket
        - axolotl_bucket
        - seagrass
        - sea_lantern
        - sea_pickle
    ores:
      - coal_ore
      - deepslate_coal_ore
      - iron_ore
      - deepslate_iron_ore
      - copper_ore
      - deepslate_copper_ore
      - gold_ore
      - deepslate_gold_ore
      - redstone_ore
      - deepslate_redstone_ore
      - emerald_ore
      - deepslate_emerald_ore
      - lapis_ore
      - deepslate_lapis_ore
      - diamond_ore
      - deepslate_diamond_ore
      - nether_gold_ore
      - nether_quartz_ore
      - amethyst_block
      - budding_amethyst
      - raw_copper_block
      - raw_gold_block
      - raw_iron_block
      - coal_block
      - iron_block
      - copper_block
      - gold_block
      - diamond_block
      - netherite_block
      - glowstone
      - redstone_block
      - small_amethyst_bud
      - medium_amethyst_bud
      - large_amethyst_bud
      - amethyst_cluster
      - pointed_dripstone
      - gilded_blackstone
    stairs_and_slabs:
      - acacia_slab
      - acacia_stairs
      - andesite_slab
      - andesite_stairs
      - birch_slab
      - birch_stairs
      - blackstone_slab
      - blackstone_stairs
      - brick_slab
      - brick_stairs
      - cobbled_deepslate_slab
      - cobbled_deepslate_stairs
      - cobblestone_slab
      - cobblestone_stairs
      - crimson_slab
      - crimson_stairs
      - cut_copper_slab
      - cut_copper_stairs
      - cut_red_sandstone_slab
      - cut_sandstone_slab
      - dark_oak_slab
      - dark_oak_stairs
      - dark_prismarine_slab
      - dark_prismarine_stairs
      - deepslate_brick_slab
      - deepslate_brick_stairs
      - deepslate_tile_slab
      - deepslate_tile_stairs
      - diorite_slab
      - diorite_stairs
      - end_stone_brick_slab
      - end_stone_brick_stairs
      - exposed_cut_copper_slab
      - exposed_cut_copper_stairs
      - granite_slab
      - granite_stairs
      - jungle_slab
      - jungle_stairs
      - mangrove_slab
      - mangrove_stairs
      - mossy_cobblestone_slab
      - mossy_cobblestone_stairs
      - mossy_stone_brick_slab
      - mossy_stone_brick_stairs
      - mud_brick_slab
      - mud_brick_stairs
      - nether_brick_slab
      - nether_brick_stairs
      - oak_slab
      - oak_stairs
      - oxidized_cut_copper_slab
      - oxidized_cut_copper_stairs
      - petrified_oak_slab
      - polished_andesite_slab
      - polished_andesite_stairs
      - polished_blackstone_brick_slab
      - polished_blackstone_brick_stairs
      - polished_blackstone_slab
      - polished_blackstone_stairs
      - polished_deepslate_slab
      - polished_deepslate_stairs
      - polished_diorite_slab
      - polished_diorite_stairs
      - polished_granite_slab
      - polished_granite_stairs
      - prismarine_brick_slab
      - prismarine_brick_stairs
      - prismarine_slab
      - prismarine_stairs
      - purpur_slab
      - purpur_stairs
      - quartz_slab
      - quartz_stairs
      - red_nether_brick_slab
      - red_nether_brick_stairs
      - red_sandstone_slab
      - red_sandstone_stairs
      - sandstone_slab
      - sandstone_stairs
      - smooth_quartz_slab
      - smooth_quartz_stairs
      - smooth_red_sandstone_slab
      - smooth_red_sandstone_stairs
      - smooth_sandstone_slab
      - smooth_sandstone_stairs
      - smooth_stone_slab
      - spruce_slab
      - spruce_stairs
      - stone_brick_slab
      - stone_brick_stairs
      - stone_slab
      - stone_stairs
      - warped_slab
      - warped_stairs
      - waxed_cut_copper_slab
      - waxed_cut_copper_stairs
      - waxed_exposed_cut_copper_slab
      - waxed_exposed_cut_copper_stairs
      - waxed_oxidized_cut_copper_slab
      - waxed_oxidized_cut_copper_stairs
      - waxed_weathered_cut_copper_slab
      - waxed_weathered_cut_copper_stairs
      - weathered_cut_copper_slab
      - weathered_cut_copper_stairs
    copper:
      - exposed_copper
      - weathered_copper
      - oxidized_copper
      - cut_copper
      - exposed_cut_copper
      - weathered_cut_copper
      - oxidized_cut_copper
      - waxed_copper_block
      - waxed_exposed_copper
      - waxed_weathered_copper
      - waxed_oxidized_copper
      - waxed_cut_copper
      - waxed_exposed_cut_copper
      - waxed_weathered_cut_copper
      - waxed_oxidized_cut_copper
      - cut_copper_stairs
      - cut_copper_slab
      - exposed_cut_copper_stairs
      - exposed_cut_copper_slab
      - weathered_cut_copper_stairs
      - weathered_cut_copper_slab
      - oxidized_cut_copper_stairs
      - oxidized_cut_copper_slab
      - waxed_cut_copper_stairs
      - waxed_cut_copper_slab
      - waxed_exposed_cut_copper_stairs
      - waxed_exposed_cut_copper_slab
      - waxed_weathered_cut_copper_stairs
      - waxed_weathered_cut_copper_slab
      - waxed_oxidized_cut_copper_stairs
      - waxed_oxidized_cut_copper_slab
    light:
      - candle
      - white_candle
      - orange_candle
      - magenta_candle
      - light_blue_candle
      - yellow_candle
      - lime_candle
      - pink_candle
      - gray_candle
      - light_gray_candle
      - cyan_candle
      - purple_candle
      - blue_candle
      - brown_candle
      - green_candle
      - red_candle
      - black_candle
      - torch
      - soul_torch
      - redstone_torch
      - lantern
      - soul_lantern
      - jack_o_lantern
      - shroomlight
      - glowstone
      - campfire
      - soul_campfire
      - sea_lantern
      - sea_pickle
      - magma_block
      - end_rod
      - small_amethyst_bud
      - medium_amethyst_bud
      - large_amethyst_bud
      - amethyst_cluster
      - light[block_material=light[level=1]]
      - light[block_material=light[level=2]]
      - light[block_material=light[level=3]]
      - light[block_material=light[level=4]]
      - light[block_material=light[level=5]]
      - light[block_material=light[level=6]]
      - light[block_material=light[level=7]]
      - light[block_material=light[level=8]]
      - light[block_material=light[level=9]]
      - light[block_material=light[level=10]]
      - light[block_material=light[level=11]]
      - light[block_material=light[level=12]]
      - light[block_material=light[level=13]]
      - light[block_material=light[level=14]]
      - light[block_material=light[level=15]]
    creative:
      - light[block_material=light[level=1]]
      - light[block_material=light[level=2]]
      - light[block_material=light[level=3]]
      - light[block_material=light[level=4]]
      - light[block_material=light[level=5]]
      - light[block_material=light[level=6]]
      - light[block_material=light[level=7]]
      - light[block_material=light[level=8]]
      - light[block_material=light[level=9]]
      - light[block_material=light[level=10]]
      - light[block_material=light[level=11]]
      - light[block_material=light[level=12]]
      - light[block_material=light[level=13]]
      - light[block_material=light[level=14]]
      - light[block_material=light[level=15]]
      - barrier
      - structure_void
      - dragon_egg
      - skeleton_skull
      - wither_skeleton_skull
      - player_head
      - zombie_head
      - creeper_head
      - dragon_head
      - beacon
      - minecart
      - rail
      - powered_rail
      - detector_rail
      - activator_rail
      - saddle
      - armor_stand
      - lead
      - name_tag
