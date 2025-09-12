bedit_set_command:
  type: command
  debug: false
  enabled: true
  name: bset
  usage: /bset <&lt>material<&gt>
  description: Sets a selection to a set material
  tab complete:
  - define materials <server.material_types.filter[is_block].parse[name]>
  - determine <[materials]> if:<context.args.is_empty>

  - define input <context.args.first>
  - if <[input].contains_any_text[<&lb>]>:
    - define material <[input].before[<&lb>]>
    - if <[input].ends_with[<&lb>]>:
      - determine <material[<[material]>].property_map.keys.parse_tag[<[parse_value]>=].if_null[<list>].parse_tag[<[input].before[<[parse_value]>]><[parse_value]>]>


    - if <material[<[material]>].property_map.is_truthy>:
      - stop if:<[input].to_list.count[<&lb>].is_less_than_or_equal_to[<[input].to_list.count[<&rb>]>]>
      - define properties <material[<[material]>].property_map.keys>
      - define properties_modified <[properties].parse_tag[<[parse_value]>=]>

      - if <[properties].filter[starts_with[<[input].after_last[<&lb>]>]].any>:
        - determine <[properties].filter[starts_with[<[input].after_last[<&lb>]>]].parse_tag[<[input]><[parse_value].after[<[input].after_last[<&lb>]>]>=]>

      - if <[input].after_last[<&lb>]>= in <[properties].parse_tag[<[parse_value]>=]>:
        - determine <[properties_modified].parse_tag[<[input]><[parse_value]>]>

      - define current_property <[input].after_last[<&lb>].before_last[=]>
      - if <[input].ends_with[=]> || <[current_property]> in <[properties]>:
        - choose <[current_property]>:
          - case direction:
            - define available_properties <list[north|south|east|west].filter[starts_with[<[input].after_last[=]>]]>
            - determine <[available_properties].parse_tag[<[input]><[parse_value].after[<[input].after_last[=]>]>]>

  - determine <[materials].filter[starts_with[<[input]>]]>
  data:
    arguments:
      -i: instant
      #-p: no physics
      #-a: no air
  script:
    # % ██ [ check if a player has a selection they can set ] ██:
    - inject bedit_check_for_selection

    - if <context.args.is_empty>:
      - inject command_syntax_error

    - define new_material <context.args.first>

    # % ██ [ check material             ] ██:
    - if !<material[<[new_material]>].exists>:
      - define reason "<[new_material]> is an invalid material."
      - inject command_error

    # % ██ [ shuffle definitions lol    ] ██:
    - define sound <[new_material].as[material].block_sound_data>
    - if <[new_material]> != air:
      - define blocks <[cuboid].blocks.filter[advanced_matches[!<[new_material]>]]>
    - else:
      - define blocks <[cuboid].blocks.filter[advanced_matches[!air]]>

    # % ██ [ check for permissions      ] ██:
    - if !<player.uuid.advanced_matches[<server.flag[behr.uuids]>]> && <player.name> != Behrrance:
      - define block_count <[cuboid].volume>

      - if !<player.has_flag[behr.profile]>:
        - flag player behr.profile.level:1
        - flag player behr.profile.experience:0
      - define level <player.flag[behr.profile.level]>

      - define max_allowed_blocks <[level].div[10].round_down.add[3].power[3]>
      - if <[block_count]> > <[max_allowed_blocks]> && !<player.is_op>:
        - define reason "Selection too large - Maximum is <[max_allowed_blocks]> blocks"
        - inject command_error

      - define blocks_unaffected <[cuboid].blocks[<[new_material]>].size>
      - if !<player.inventory.contains_item[<[new_material]>].quantity[<[block_count].sub[<[blocks_unaffected]>]>]> && <[new_material]> !matches air && <player.gamemode> == survival:
        - define reason "You don't have enough <[new_material]> for that (<player.inventory.quantity_item[<[new_material]>]>/<[block_count].sub[<[blocks_unaffected]>]>)"
        - inject command_error

    # % ██ [ ship it, place the stuff   ] ██:
    - inject hide_bedit_display_entity

    - define time <util.time_now.epoch_millis>
    - foreach <[blocks].sort_by_value[distance[<player.eye_location>]]> as:location:
      - define old_material <[location].material>
      - define old_sound <[old_material].block_sound_data>
      - if <[old_material]> !matches air:
        - playsound <[location]> sound:<[old_sound.break_sound]> volume:<[old_sound.volume].add[1]> pitch:<[old_sound.pitch]>
      - wait 1t
      - if <[new_material]> !matches air:
        - playsound <[location]> sound:<[sound.place_sound]> volume:<[sound.volume].add[1]> pitch:<[sound.pitch]>
      - playeffect at:<[location].center> effect:block_dust special_data:<[old_material]> offset:0.25 quantity:50 visibility:100
      - playeffect at:<[location].center> effect:block_dust special_data:<material[<[new_material]>]> offset:0.25 quantity:50 visibility:100
      - modifyblock <[location]> <[new_material]> no_physics
      - if <player.gamemode.equals[survival]>:
        - take item:<[new_material]>
        - drop <[old_material].item> <[location].center> speed:0

      - flag <[location]> behr.essentials.bedit.history.<[time]>.player:<player> expire:1d
      - flag <[location]> behr.essentials.bedit.history.<[time]>.old_material:<[old_material]> expire:1d
      - flag <[location]> behr.essentials.bedit.history.<[time]>.action:set expire:1d
      - flag <player> behr.essentials.bedit.history.<[time]>.block.<[location].simple>:<[old_material]> expire:1d
      - flag <player> behr.essentials.bedit.history.<[time]>.action:set expire:1d

    - inject show_bedit_display_entity

    - if <player.flag[behr.essentials.bedit.history].size> > 10:
      - define time <player.flag[behr.essentials.bedit.history].keys.lowest>
      - flag <player> behr.essentials.bedit.history.<[time]>:!
