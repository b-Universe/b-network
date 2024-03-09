bedit_set_command:
  type: command
  debug: false
  enabled: true
  name: /set
  usage: //set <&lt>material<&gt>
  description: Sets a selection to a set material
  tab complete:
  - define materials <server.material_types.filter[is_block].parse[name]>
  - determine <[materials]> if:<context.args.is_empty>

  - define input <context.args.first>
  - if <[input].contains_any_text[<&lb>]>:
    - define material <[input].before[<&lb>]>
    - if <[input].ends_with[<&lb>]>:
      - determine <material[<[material]>].property_map.keys.if_null[<list>].parse_tag[<[input].before[<[parse_value]>]><[parse_value]>]>

    - if <material[<[material]>].property_map.is_truthy>:
      - stop if:<[input].to_list.count[<&lb>].is_less_than_or_equal_to[<[input].to_list.count[<&rb>]>]>
      - define properties <material[<[material]>].property_map.keys>

      - if <[input].contains_any_text[;]>:
        - define current_property <[input].after_last[;]>
        - define properties <[properties].exclude[<[input].after[<&lb>].split[;].parse[before[=]]>]>
      - else:
        - define current_property <[input].after[<&lb>]>

      - define property_input <material[<[material]>].property_map.keys.filter[starts_with[<[input].after[<[current_property]>]>]]>
      - if <[property_input].exists>:
        - if <[input].contains_any_text[;]>:
          - determine <[properties].filter[starts_with[<[input].after_last[;]>]].parse_tag[<[input].before_last[;]>;<[parse_value]>]>
        - else:

          - determine <material[<[material]>].property_map.keys.if_null[<list>].filter[starts_with[<[input].after[<&lb>]>]].parse_tag[<[material]><&lb><[parse_value]>]>

  - determine <[materials].filter[starts_with[<[input]>]]>

  data:
    invert_direction:
      north: south
      east: west
      south: north
      west: east
  script:
    - if <context.args.is_empty>:
      - inject command_syntax_error

    # % ██ [ Check if a player has a selection they can set  ] ██:
    - inject bedit_check_for_selection

    # % ██ [ Check material             ] ██:
    - define new_material_name <context.args.first>
    - if !<material[<[new_material_name]>].exists>:
      - define reason "<[new_material_name]> is an invalid material."
      - inject command_error

    # % ██ [ Check for convenience      ] ██:
    - define new_material <material[<[new_material_name]>]>
    - if !<[new_material_name].contains_text[direction=]> && <[new_material].supports[direction]>:
      - define new_material <[new_material].with_map[direction=<player.location.yaw.simple>]>
    - if !<[new_material_name].contains_text[half=]> && <[new_material].supports[half]>:
      - if <player.location.pitch> < 0:
        - define new_material <[new_material].with_map[half=top]>
      - else:
        - define new_material <[new_material].with_map[half=bottom]>

    # % ██ [ Add base definitions       ] ██:
    - define sound <[new_material].block_sound_data>
    - define time <util.time_now.epoch_millis>
    - define blocks <[cuboid].blocks>
    - if <[new_material]> matches air:
      - define blocks <[blocks].filter[advanced_matches[!air]]>

    # % ██ [ Check for permissions      ] ██:
    - if <player.uuid> in <server.flag[behr.uuids]>:
      - define level 169
    - else:
      - define level <player.flag[behr.essentials.profile.stats.construction.level]>
    - define cuboid_size <[cuboid].max.sub[<[cuboid].min>].add[1,1,1]>
    - define block_count <[cuboid_size].x.mul[<[cuboid_size].y>].mul[<[cuboid_size].z>]>

    - define max_allowed_blocks <[level].div[10].round_down.add[4].power[3]>
    - if <[block_count]> > <[max_allowed_blocks]>:
      - define reason "Selection too large - Maximum is <[max_allowed_blocks]> blocks"
      - inject command_error

    # % ██ [ Count block requirements   ] ██:
    - define blocks_unaffected <[cuboid].blocks[<[new_material]>].size>
    - if !<player.inventory.contains_item[<[new_material_name]>].quantity[<[block_count].sub[<[blocks_unaffected]>]>]> && <[new_material_name]> !matches air && <player.gamemode> == survival:
      - define reason "You don't have enough <&e><[new_material_name]> <&c>for that <&6>(<&e><player.inventory.quantity_item[<[new_material_name]>].add[<[blocks_unaffected]>]><&6>/<&e><[block_count]><&6>)"
      - inject command_error

    # % ██ [ Run the command            ] ██:
    - run bedit_hide_selection_corners
    - define blocks <[blocks].filter[advanced_matches[bedrock].not].sort_by_value[distance[<player.eye_location>]]>
    - flag player behr.essentials.bedit.undo_history_events:->:<[time]> expire:4h
    - foreach <[blocks]> as:location:
      - run bedit_place_block def:<list_single[<[new_material]>].include[<[location]>|<[time]>]>
      - wait 1t

    - inject check_for_levelup
    - inject bedit_refresh_selection_corners
