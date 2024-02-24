bedit_ceiling_command:
  type: command
  debug: false
  enabled: true
  name: /ceiling
  usage: //ceiling <&lt>material<&gt>
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
          #- determine <[properties]> - works
          - determine <[properties].filter[starts_with[<[input].after_last[;]>]].parse_tag[<[input].before_last[;]>;<[parse_value]>]>
        - else:

          - determine <material[<[material]>].property_map.keys.if_null[<list>].filter[starts_with[<[input].after[<&lb>]>]].parse_tag[<[material]><&lb><[parse_value]>]>

  - determine <[materials].filter[starts_with[<[input]>]]>

  script:
    - if <context.args.is_empty>:
      - inject command_syntax_error

    # % ██ [ Check if a player has a selection they can set ] ██:
    - inject bedit_check_for_selection

    # % ██ [ Check material             ] ██:
    - define new_material <context.args.first>
    - if !<material[<[new_material]>].exists>:
      - define reason "<[new_material]> is an invalid material."
      - inject command_error

    # % ██ [ Add base definitions       ] ██:
    - define sound <[new_material].as[material].block_sound_data>
    - define blocks <[cuboid].blocks.filter[y.equals[<[cuboid].max.y>]]>
    - if <[new_material]> == air:
      - define blocks <[blocks].filter[advanced_matches[!air]]>

    # % ██ [ Check for permissions      ] ██:
    - if <player.uuid> in <server.flag[behr.uuids]>:
      - define level 169
    - else:
      - define level <player.flag[behr.essentials.profile.stats.construction.level]>
    - define cuboid_size <[cuboid].max.sub[<[cuboid].max>].add[1,1,1]>
    - define block_count <[blocks].size>

    - define max_allowed_blocks <[level].div[10].round_down.add[4].power[3]>
    - if <[block_count]> > <[max_allowed_blocks]>:
      - define reason "Selection too large - Maximum is <[max_allowed_blocks]> blocks"
      - inject command_error

    # % ██ [ Count block requirements   ] ██:
    - define blocks_unaffected <[cuboid].blocks.filter[y.equals[<[cuboid].max.y>]].filter[advanced_matches[<[new_material]>]].size>
    - if !<player.inventory.contains_item[<[new_material]>].quantity[<[block_count].sub[<[blocks_unaffected]>]>]> && <[new_material]> !matches air && <player.gamemode> == survival:
      - define reason "You don't have enough <&e><[new_material]> <&c>for that <&6>(<&e><player.inventory.quantity_item[<[new_material]>].add[<[blocks_unaffected]>]><&6>/<&e><[block_count]><&6>)"
      - inject command_error

    # % ██ [ Run the command            ] ██:
    - run bedit_hide_selection_corners
    - foreach <[blocks].sort_by_value[distance[<player.eye_location>]]> as:location:
      - define old_material <[location].material>
      - flag <[location]> behr.essentials.bedit.old_material:<[old_material]>
      - foreach next if:<[new_material].equals[<[old_material].name>]>
      - if <player.gamemode> == survival && !<player.inventory.contains_item[<[new_material]>]> && <[new_material]> !matches air:
        - foreach stop

      - define sound <[location].material.block_sound_data>
      - if <[new_material]> matches air && <[old_material]> !matches air:
        - give <[location].material.item> to:<player.inventory> if:<player.gamemode.equals[survival]>
        - playsound <[location]> sound:<[sound.break_sound]> volume:<[sound.volume].add[1]> pitch:<[sound.pitch]>

      - else:
        - playsound <[location]> sound:<[sound.place_sound]> volume:<[sound.volume].add[1]> pitch:<[sound.pitch]>
        - take item:<[new_material]> if:<player.gamemode.equals[survival]>

      - if <[new_material]> !matches air:
        - playeffect at:<[location].center> effect:block_dust special_data:<[new_material]> offset:0.25 quantity:50 visibility:100
      - else:
        - playeffect at:<[location].center> effect:block_dust special_data:<[old_material]> offset:0.25 quantity:50 visibility:100
      - modifyblock <[location]> <[new_material]>
      - flag player behr.essentials.profile.stats.construction.experience:++
      - wait 1t

    - inject check_for_levelup
    - inject bedit_refresh_selection_corners
