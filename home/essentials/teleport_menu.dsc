teleport_menu_command:
  type: command
  debug: true
  name: teleport_menu
  usage: /teleport_menu (force_update)
  description: Opens the teleport_menu menu, or teleports you to the named location
  permission: behr.essentials.teleport_menu
  tab completions:
    1: force_update
  aliases:
    - tm
  script:
    - if !<context.args.is_empty>:
      - if <context.args.first> == force_update && <context.args.size> == 1:
        - flag server behr.essentials.teleport_menu_locations_last_update:<util.time_now>
        - narrate "<&a>The teleport menu has been forced to update on next load."
      - else:
        - narrate "<&c>Just use <&6>/<&e>teleport<&6>_<&e>menu"
      - stop

    - inject teleport_menu

teleport_menu:
  type: task
  script:
    - if !<server.has_flag[behr.essentials.teleport_menu_locations_last_update]> || <server.flag[behr.essentials.teleport_menu_locations_last_update].is_after[<server.flag[behr.essentials.teleport_menu_locations_last_update_cache].if_null[<util.time_now.sub[30d]>]>].if_null[true]>:
      - flag server behr.essentials.teleport_menu_locations_last_update:<util.time_now.sub[1t]>
      - flag server behr.essentials.teleport_menu_locations_last_update_cache:<util.time_now>
      - note <inventory[teleport_menu_template]> as:teleport_menu
    - inventory open d:teleport_menu

teleport_menu_template:
  type: inventory
  debug: true
  inventory: chest
  size: 54
  title: <script.parsed_key[data.title].unseparated>
  data:
    title:
    - <&f><proc[negative_spacing].context[8].font[utility:spacing]>
    - <&chr[1006].font[gui]>
    - <proc[negative_spacing].context[171].font[utility:spacing]>
    - <element[●<strikethrough><&sp.repeat[7]><reset><bold>(].color_gradient[from=#ff7200;to=#c8ff00]>
    - <&sp.repeat[2]><black>Teleport Menu<&sp.repeat[2]>
    - <element[<bold>)<reset><strikethrough><&sp.repeat[7]><reset>●].color_gradient[from=#003cff;to=#ff0015]>
  gui: true
  procedural items:
    - define items <list>
    - foreach <server.flag[behr.essentials.teleport_menu_locations].if_null[<map>]> key:name as:values:
      - define display_name "<element[●<strikethrough><&sp.repeat[4]><reset><bold>(].color_gradient[from=#ff7200;to=#c8ff00]>  <&color[#F3FFAD]><[name].replace[_].with[ ].to_titlecase>  <element[<bold>)<reset><strikethrough><&sp.repeat[4]><reset>●].color_gradient[from=#003cff;to=#ff0015]>"
      - define lore "<element[Location<&co> <[values.location].simple.before_last[,].replace[,].with[, ]> <&at> <[values.world_name]>].color_gradient[from=#ff7200;to=#c8ff00]>"
      - definemap flag_data:
          location: <[values.location]>
          world: <[values.world_name]>
      - define flags location_data:<[flag_data]>
      - define item <item[<[values.icon]>].with[display=<[display_name]>;lore=<[lore]>;hides=all].with_flag[location_data:<[flag_data]>]>
      - define items <[items].include_single[<[item]>]>
    - determine <[items]>

teleport_menu_handler:
  type: world
  events:
    on player clicks item in teleport_menu:
      - if <context.item.has_flag[location_data]>:
        - teleport <player> <context.item.flag[location_data.location]>

teleport_menu_edit_command:
  type: command
  debug: true
  name: teleport_menu_edit
  usage: /teleport_menu_edit <&lt>add/modify/remove<&gt> <&lt>name<&gt> (location) (center)
  description: Adds a teleport to the teleport menu
  permission: behr.essentials.teleport_menu
  aliases:
    - tme
  tab completions:
    1: add|modify|remove
    2: <server.flag[behr.essentials.teleport_menu_locations].keys.if_null[<list>]>
    3: <list[my_location|below_me|cursor_on|cursor_on_above].include[<server.online_players.parse[name]>]>
  sub_paths:
    add_teleport:
      - definemap location_data:
          creator: <player>
          icon: <player.item_in_hand.if_null[stone]>
          location: <[location]>
          time_created: <util.time_now>
          world_name: <[location].world.name>

      - flag server behr.essentials.teleport_menu_locations.<[name]>:<[location_data]>
      - narrate "<&a>The teleport location named <&e><[name]> <&a>was saved with location <[location].simple>"
    check_location_arg:
      - choose <[location_arg]>:
        - case my_location:
          - define location <player.location>
        - case below_me:
          - define location <player.location.with_pitch[90].precise_cursor_on.round_down>
        - case cursor_on:
          - define location <player.cursor_on>
        - case cursor_on_above:
          - define location <player.cursor_on.above>
        - default:
          - define player <server.match_player[<[location_arg]>].if_null[null]>
          - if !<[player].is_truthy>:
            - narrate "<&c>Must specify a valid location, or reference a valid player for their location"
            - stop
          - define location <[player].location>

    check_for_duplicates:
      - if <server.has_flag[behr.essentials.teleport_menu_locations.<[name]>]>:
        - narrate "<&c>This location is already in the teleport menu. Did you mean to modify?"
        - stop

      - define duplicate_Locations <server.flag[behr.essentials.teleport_menu_locations].filter_tag[<[filter_key].get[<[location]>].if_null[<map>]>].keys.if_null[<list>]>
      - if !<[duplicate_locations].is_empty>:
        - narrate "<&c>This location already exists for the location named <[duplicate_locations].keys.first>"
        - stop

  script:
    - if <context.args.is_empty>:
      - narrate "<&c>You need to specify if you're adding, modifying, listing the available teleports, or removing a teleport from the teleport menu"
      - stop

    - else if <context.args.size> == 1:
      - narrate "<&c>You need to specify the name of the location you're adding to the teleport menu"
      - stop

    - else if <context.args.size> == 2:
      - define name <context.args.last>
      - define location <player.location>
      - choose <context.args.first>:
        - case add:
          - inject teleport_menu_edit_command.sub_paths.check_for_duplicates
          - inject teleport_menu_edit_command.sub_paths.add_teleport

        - case modify:
          # todo: add a GUI for editing the icon and location of teleport locations
          - narrate "<&c>You need to specify what to modify for teleport locations"
          - stop

        - case remove:
          - if !<server.has_flag[behr.essentials.teleport_menu_locations.<[name]>]>:
            - narrate "<&c>This location isn't a saved teleport to remove"
            - stop

          - flag server behr.essentials.teleport_menu_locations.<[name]>:!
          - narrate "<&a>Removed the teleport location<&e><[name]>"

    - else if <context.args.size> == 3:
      - define name <context.args.get[2]>
      - define location_arg <context.args.last>
      - choose <context.args.first>:
        - case add:
          - if <[location_arg]> == center:
            - define location <player.location.center>
          - else:
            - inject teleport_menu_edit_command.sub_paths.check_location_arg
          - inject teleport_menu_edit_command.sub_paths.check_for_duplicates
          - inject teleport_menu_edit_command.sub_paths.add_teleport

        - case modify:
          - if !<server.has_flag[behr.essentials.teleport_menu_locations.<[name]>]>:
            - narrate "<&c>This location isn't a saved teleport to modify"
            - stop

          - inject teleport_menu_edit_command.sub_paths.check_location_arg
          - inject teleport_menu_edit_command.sub_paths.add_teleport

        - case remove:
          - narrate "<&c>The remove argument only takes a teleport location name"
          - stop

    - else if <context.args.size> == 4:
      - if <context.args.first> == remove:
          - narrate "<&c>The remove argument only takes a teleport location name"
          - stop
      - if <context.args.last> != center:
        - narrate "<&c>The menu adjusting command only takes an action, a location name, the location, and whether to center it or not"
        - stop
      - define name <context.args.get[2]>
      - define location_arg <context.args.get[3]>
      - inject teleport_menu_edit_command.sub_paths.check_location_arg

      - define location <[location].center>
      - if <context.args.first> == add:
        - inject teleport_menu_edit_command.sub_paths.check_for_duplicates

      - else if <context.args.first> != modify:
        - narrate "<&c>Invalid usage -  /teleport_menu_adjust <&lt>add/modify/remove<&gt> <&lt>name<&gt> (location) (center)"
        - stop

      - inject teleport_menu_edit_command.sub_paths.add_teleport

    - else if <context.args.size> > 4:
      - narrate "<&c>The menu adjusting command only takes an action, a location name, the location, and whether to center it or not"
      - stop
    - flag server behr.essentials.teleport_menu_locations_last_update:<util.time_now>
