##IgnoreWarning todo_comment
world_handler_command:
  type: command
  debug: false
  usage: /worldhandler
  name: worldhandler
  description: manages how worlds are handled
  aliases:
    - wh
  tab completions:
    1: gui
  script:
    - if <context.args.is_empty>:
      - inventory open d:world_handler_gui_main_menu

world_loading_handler:
  type: world
  events:
    on server prestart:
      - stop if:!<server.has_flag[behr.essentials.world_settings]>
      - foreach <server.flag[behr.essentials.world_settings]> key:world:
        - if <server.has_flag[behr.essentials.world_settings.<[world]>.settings.load_on_restart]>:
          - createworld <[world]>

world_handler_gui_handler:
  type: world
  debug: true
  events:
    after player clicks world_load_handler_gui_button in world_handler_gui_main_menu:
      - inventory open d:world_handler_gui_world_load_gui

    after player clicks world_loader_gui_button in world_handler_gui_world_load_gui:
      - inventory open d:world_handler_gui_world_loader_gui
    after player clicks world_unloader_gui_button in world_handler_gui_world_load_gui:
      - inventory open d:world_handler_gui_world_unloader_gui
    after player clicks world_loading_settings_gui_button in world_handler_gui_world_load_gui:
      - inventory open d:world_handler_gui_world_load_settings_gui
    after player clicks world_destroyer_gui_button in world_handler_gui_world_load_gui:
      - if !<player.has_flag[behr.essentials.admin]>:
        - narrate "<&c>You do not have permission to destroy"
        - stop
      - inventory open d:world_handler_gui_world_destroyer_gui

    after player clicks item in world_handler_gui_world_loader_gui:
      - define world <context.item.flag[world_name].if_null[null]>
      - stop if:!<[world].is_truthy>
      - clickable usages:1 save:yes:
        - createworld <[world]>
        # todo: check if world was actually loaded
        - narrate "<&6><[world]> <&e>was loaded"
      - clickable usages:1 save:no:
        - narrate "<&6>Nothing interesting happened"
      - define yes "<&2><&lb><&a><element[yes].on_click[<entry[yes].command>].on_hover[Load the world]><&2><&rb><&e>"
      - define no "<&4><&lb><&c><element[no].on_click[<entry[no].command>].on_hover[Don't do anything]><&4><&rb><&e>"
      - narrate "<&6>Load the world <&e><[world]><&6>? <[yes]> <&b>| <[no]>"

    after player clicks item in world_handler_gui_world_unloader_gui:
      - define world <context.item.flag[world_name].if_null[null]>
      - stop if:!<[world].is_truthy>
      - clickable usages:1 save:yes:
        - adjust <world[<[world]>]> unload
        # todo: check if world was actually unloaded
        - narrate "<&6><[world]> <&e>was unloaded"
      - clickable usages:1 save:no:
        - narrate "<&6>Nothing interesting happened"
      - define yes "<&2><&lb><&a><element[yes].on_click[<entry[yes].command>].on_hover[Unload the world]><&2><&rb><&e>"
      - define no "<&4><&lb><&c><element[no].on_click[<entry[no].command>].on_hover[Don't do anything]><&4><&rb><&e>"
      - narrate "<&6>Unload the world <&e><[world]><&6>? <[yes]> <&b>| <[no]>"
      - inventory close

    after player clicks item in world_handler_gui_world_load_settings_gui:
      - define data <context.item.flag[data].if_null[null]>
      - stop if:!<[data].is_truthy>
      - define world_name <[data.world_name]>
      - choose <[data.setting_name]>:
        - case open_world:
          - foreach load_on_restart as:setting:
            - if <server.has_flag[behr.essentials.world_settings.<[world_name]>.settings.<[setting]>]>:
              - define setting_item <item[house_true].with[display_name=<&e><[setting]><&co>;lore=<&a>Enabled].with_flag[setting.<[setting]>]>
            - else:
              - define setting_item <item[house_false].with[display_name=<&e><[setting]><&co>;lore=<&c>Disabled]>
            - choose <[setting]>:
              - case load_on_restart:
                - if <server.has_flag[behr.essentials.world_settings.<[world_name]>.settings.<[setting]>]>:
                  - define setting_item "<[setting_item].with[lore=<&a>Enabled|<&e>This world load|<&e>when the server restarts]>"
                - else:
                  - define setting_item "<[setting_item].with[lore=<&c>Disabled|<&e>This world will not load|<&e>when the server restarts]>"

            - define setting_item <[setting_item].with_flag[data.world_name:<[world_name]>]>
            - define setting_item <[setting_item].with_flag[data.setting_name:<[setting]>]>
            - define setting_buttons:->:<[setting_item]>

          - define blanks <item[air].repeat_as_list[<element[27].sub[<[setting_buttons].size>].sub[1]>]>
          - define back_item "<item[back_button].with[lore=<&e>Previous menu<&co>|<&e>World loading menu].with_flag[menu:world_handler_gui_world_load_settings_gui]>"
          - define setting_buttons <[setting_buttons].include[<[blanks]>].include_single[<[back_item]>]>
          - inventory clear
          - inventory set destination:<context.inventory> origin:<[setting_buttons]> slot:1

        - case load_on_restart:
          - if <server.has_flag[behr.essentials.world_settings.<[world_name]>.settings.load_on_restart]>:
            # from true to false
            - flag server behr.essentials.world_settings.<[world_name]>.settings.load_on_restart:!
            - define new_item <item[house_false]>
            - define display "<&6>World load on startup"
            - define lore "<list[<&c>Disabled|<&e>This world will not load|<&e>when the server restarts]>"
            - narrate "<&e><[world_name]> <&6>will no longer load when the server restarts."
          - else:
            # from false to true
            - flag server behr.essentials.world_settings.<[world_name]>.settings.load_on_restart
            - define new_item <item[house_true]>
            - define display "<&6>World load on startup"
            - define lore "<list[<&a>Enabled|<&e>This world load|<&e>when the server restarts]>"
            - narrate "<&e><[world_name]> <&6>will now load when the server restarts."
          - define new_item <[new_item].with[display_name=<[display]>;lore=<[lore]>].with_flag[data.world_name:<[world_name]>]>
          - define new_item <[new_item].with_flag[data.setting_name:load_on_restart]>
          - inventory set destination:<context.inventory> slot:<context.raw_slot> origin:<[new_item]>

        - default:
          - narrate "<&6>Nothing interesting happens"

    after player clicks item in world_handler_gui_world_destroyer_gui:
      - if !<player.has_flag[behr.essentials.admin]>
      - define world <context.item.flag[world_name].if_null[null]>
      - stop if:!<[world].is_truthy>
      - clickable usages:1 save:yes:
        # todo: check if world is blacklisted from deletion
        # todo: check if the world is actually loaded or not
        - adjust <world[<[world]>]> destroy
        # todo: check if world was actually destroyed
        - narrate "<&6><[world]> <&e>was destroyed"
      - clickable usages:1 save:no:
        - narrate "<&6>Nothing interesting happened"
      - define yes "<&2><&lb><&a><element[yes].on_click[<entry[yes].command>].on_hover[Destroy the world]><&2><&rb><&e>"
      - define no "<&4><&lb><&c><element[no].on_click[<entry[no].command>].on_hover[Don't do anything]><&4><&rb><&e>"
      - narrate "<&6>Unload the world <&e><[world]><&6>? <[yes]> <&b>| <[no]>"
      - inventory close

    after player clicks back_button in world_handler_gui_world_*_gui:
      - stop if:!<context.item.has_flag[menu]>
      - inventory open d:<context.item.flag[menu]>

world_handler_gui_main_menu:
  type: inventory
  debug: false
  inventory: chest
  title: World handler menu
  size: 27
  gui: true
  definitions:
    1: world_load_handler_gui_button
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [1] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []

world_item:
  type: item
  debug: false
  material: player_head
  mechanisms:
    skull_skin: 67303f01-b659-4ce5-8706-b623a16c1db2|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvY2Y3Y2RlZWZjNmQzN2ZlY2FiNjc2YzU4NGJmNjIwODMyYWFhYzg1Mzc1ZTlmY2JmZjI3MzcyNDkyZDY5ZiJ9fX0=
back_button:
  type: item
  debug: false
  material: barrier
  display name: <&6>Return to previous menu
house_true:
  type: item
  debug: false
  material: player_head
  mechanisms:
    skull_skin: 0d27b3fe-e781-4c7e-87b5-ab4e54850356|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZmMxYmQ3Y2UyZDUyN2VjNmY3NmI4ZTgxZjE5ZDY5ZDFiOWZmNGQ1YjZjZDZjYzc2NGVlZDE5NDVhNmM2YyJ9fX0=
house_false:
  type: item
  debug: false
  material: player_head
  mechanisms:
    skull_skin: 60f715e9-213d-4aa4-bbf3-f3cf3f52c444|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNzU0NjVmNzdlN2ZkNDIxNzM4NDk5OGMzMzg1OWFkOTYzNmUxODkzYmVlNDA1ZGQyNTE5NDIzYjUxNzY3In19fQ==
world_load_handler_gui_button:
  type: item
  debug: false
  material: stone
  display name: <&6>World Loading Settings
  lore:
    - <&e>handles how worlds loading settings,
    - <&e>unloads loaded worlds,
    - <&e>and loads unloaded worlds

world_handler_gui_world_load_gui:
  type: inventory
  debug: false
  inventory: chest
  title: World loading menu
  size: 27
  gui: true
  definitions:
    1: world_loader_gui_button
    2: world_unloader_gui_button
    4: world_loading_settings_gui_button
    3: world_destroyer_gui_button
    # do i even need a flag? .with_flag[gui:world_handler_gui_main_menu]
    back: <item[back_button].with[lore=<&e>Previous menu<&co>|<&e>World handler menu].with_flag[menu:world_handler_gui_main_menu]>
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [1] [2] [3] [4] [] [] [] []
    - [] [] [] [] [] [] [] [] [back]

world_loader_gui_button:
  type: item
  debug: false
  material: player_head
  display name: <&6>World Loader Menu
  lore:
    - <&e>Load unloaded worlds
  mechanisms:
    skull_skin: fe557cd7-61b9-4905-9d33-e45dd86dda42|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNWQ4NjA0YjllMTk1MzY3Zjg1YTIzZDAzZDlkZDUwMzYzOGZjZmIwNWIwMDMyNTM1YmM0MzczNDQyMjQ4M2JkZSJ9fX0=

world_unloader_gui_button:
  type: item
  debug: false
  material: player_head
  display name: <&6>World Unloader Menu
  lore:
    - <&e>Unload loaded worlds
  mechanisms:
    skull_skin: de781e5a-a05e-42d5-8431-c0e6615ff94d|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNDgyYzIzOTkyYTAyNzI1ZDllZDFiY2Q5MGZkMDMwN2M4MjYyZDg3ZTgwY2U2ZmFjODA3ODM4N2RlMThkMDg1MSJ9fX0=
world_loading_settings_gui_button:
  type: item
  debug: false
  material: player_head
  display name: <&6>World loading settings Menu
  lore:
    - <&e>Adjust worlds loaded on startup
  mechanisms:
    skull_skin: 84f960c7-ba13-411c-9e17-ca3afcda823a|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjdkNmJlMWRjYTUzNTJhNTY5M2UyOWVhMzVkODA2YjJhMjdjNGE5N2I2NGVlYmJmNjMyYzk5OGQ1OTQ4ZjFjNCJ9fX0=
world_destroyer_gui_button:
  type: item
  debug: false
  material: player_head
  display name: <&6>World Destroyer Menu
  lore:
    - <&e>Destroy loaded worlds
    - <&a>Requires behrry administrative permissions
  mechanisms:
    skull_skin: 4d37c12c-eb19-4499-8c62-33d84c4d9761|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNTVkNWM3NWY2Njc1ZWRjMjkyZWEzNzg0NjA3Nzk3MGQyMjZmYmQ1MjRlN2ZkNjgwOGYzYTQ3ODFhNTQ5YjA4YyJ9fX0=

world_handler_gui_world_loader_gui:
  type: inventory
  debug: false
  inventory: chest
  title: World Loader Menu
  size: 27
  gui: true
  procedural items:
    - define worlds <util.list_files[../../].filter_tag[<util.list_files[../../<[filter_value]>].contains[level.dat].if_null[false]>]>
    - define worlds <[worlds].exclude[<server.worlds.parse[name]>]>
    - define world_items "<[worlds].parse_tag[<item[world_item].with[display_name=<&6><[parse_value]>;lore=<&e>Click to load world].with_flag[world_name:<[parse_value]>]>]>"
    - define blanks <element[27].sub[<[world_items].size>].sub[1]>
    - define back_item "<item[back_button].with[lore=<&e>Previous menu<&co>|<&e>World loading menu].with_flag[menu:world_handler_gui_world_load_gui]>"
    - determine <[world_items].include[<item[air].repeat_as_list[<[blanks]>]>].include[<[back_item]>]>

world_handler_gui_world_unloader_gui:
  type: inventory
  debug: false
  inventory: chest
  title: World Unloader Menu
  size: 27
  gui: true
  procedural items:
    - define world_items "<server.worlds.parse[name].parse_tag[<item[world_item].with[display_name=<&6><[parse_value]>;lore=<&e>Click to unload world].with_flag[world_name:<[parse_value]>]>]>"
    - define blanks <element[27].sub[<[world_items].size>].sub[1]>
    - define back_item "<item[back_button].with[lore=<&e>Previous menu<&co>|<&e>World loading menu].with_flag[menu:world_handler_gui_world_load_gui]>"
    - determine <[world_items].include[<item[air].repeat_as_list[<[blanks]>]>].include[<[back_item]>]>

world_handler_gui_world_load_settings_gui:
  type: inventory
  debug: false
  inventory: chest
  title: World loading settings Menu
  size: 27
  gui: true
  procedural items:
    - define all_worlds <util.list_files[../../].filter_tag[<util.list_files[../../<[filter_value]>].contains[level.dat].if_null[false]>]>
    #- define loaded_worlds <[worlds].exclude[<server.worlds.parse[name]>]>
    - foreach <[all_worlds]> as:world:
      - define world_item "<item[world_item].with[display_name=<&6><[world]>;lore=<&e>Click to change world settings]>"
      - define world_item <[world_item].with_flag[data.world_name:<[world]>]>
      - define world_item <[world_item].with_flag[data.setting_name:open_world]>
      - define world_items:->:<[world_item]>

    - define blanks <item[air].repeat_as_list[<element[27].sub[<[world_items].size>].sub[1]>]>
    - define back_item "<item[back_button].with[lore=<&e>Previous menu<&co>|<&e>World loading menu].with_flag[menu:world_handler_gui_world_load_gui]>"
    - determine <[world_items].include[<[blanks]>].include_single[<[back_item]>]>

world_handler_gui_world_destroyer_gui:
  type: inventory
  debug: false
  inventory: chest
  title: World Destroyer Menu
  size: 27
  gui: true
  procedural items:
    - define world_items "<server.worlds.parse[name].parse_tag[<item[world_item].with[display_name=<&6><[parse_value]>;lore=<&e>Click to unload world].with_flag[world_name:<[parse_value]>]>]>"
    - define blanks <element[27].sub[<[world_items].size>].sub[1]>
    - define back_item "<item[back_button].with[lore=<&e>Previous menu<&co>|<&e>World loading menu].with_flag[menu:world_handler_gui_world_load_gui]>"
    - determine <[world_items].include[<item[air].repeat_as_list[<[blanks]>]>].include[<[back_item]>]>


test_lego1_gui:
  type: inventory
  inventory: chest
  size: 54
  gui: true
  title: <script.parsed_key[data.title].unseparated>
  data:
    title:
      # gui background
      - <&f><proc[negative_spacing].context[8].font[utility:spacing]>
      - <&chr[1019].font[gui]>


test_lego2_gui:
  type: inventory
  inventory: chest
  size: 36
  title: <script.parsed_key[data.title].unseparated>
  data:
    title:
      # gui background
      - <&f><proc[negative_spacing].context[19].font[utility:spacing]>
      - <&color[#0ffc03]><&chr[1020].font[gui]><proc[negative_spacing].context[1].font[utility:spacing]><&chr[1021].font[gui]>
      - <proc[negative_spacing].context[178].font[utility:spacing]>
      - <&a>something something, rocks
