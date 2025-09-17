bedit_stack_command:
  type: command
  debug: false
  enabled: true
  name: bstack
  usage: /bstack (<&ns>/(<&ns>) direction)
  description: Stacks the selection you currently have set in a direction
  tab completions:
    1: forward|forward_flat|backward|backward_flat|left|right|north|northeast|east|southeast|south|southwest|west|up|above|down|below
  sub_script:
    syntax_error:
      - define reason "Available directions are <[directions].keys.comma_separated> and miscellaneous directions are <[miscellaneous_directions].keys.exclude[cursor_on].comma_separated>"
      - inject command_error

    inputless_direction:
      - if <player.location.pitch> < -45:
        - define direction up
      - else if <player.location.pitch> > 45:
        - define direction down
      - else:
        - define direction <player.location.direction>
      - define offset <[directions].get[<[direction]>].as[location]>

  script:
    # % ██ [ Check if a player has a selection they can set   ] ██:
    - inject bedit_check_for_selection

    # % ██ [ Check if using the command wrongly               ] ██:
    - define args <context.args>
    - if <[args].size> > 2:
      - inject command_syntax_error


    - define directions <script[bedit_directions].data_key[directions]>
    - define miscellaneous_directions <script[bedit_directions].data_key[miscellaneous_directions]>

    - choose <[args].size>:
      - case 0:
        - define stacks 1
        - inject bedit_stack_command.sub_script.inputless_direction
        - define offset <[directions].get[<[direction]>].as[location]>

      - case 1:
        - if <[args].first.is_integer>:
          - define stacks <[args].first>
          - inject bedit_stack_command.sub_script.inputless_direction
          - define offset <[directions].get[<[direction]>].as[location]>

        - else:
          - define stacks 1
          - define direction <[args].first>
          - if <[direction]> in <[directions]>:
            - define offset <[directions].get[<[direction]>].as[location]>
          - else if <[direction]> in <[miscellaneous_directions]>:
            - define origin_location <location[0,0,0]>
            - define offset <[miscellaneous_directions].get[<[direction]>].parsed>
          - else:
            - inject bedit_stack_command.sub_script.syntax_error

      - case 2:
        - if !<[args].first.is_integer>:
          - define reason "Invalid integer for stacking"
          - inject command_error

        - define stacks <[args].first>
        - define offset <[directions].get[<[direction]>].as[location]>

        - define direction <[args].last>
        - if <[direction]> in <[directions]>:
          - define offset <[directions].get[<[direction]>].as[location]>
        - else if <[direction]> in <[miscellaneous_directions]>:
          - define origin_location <location[0,0,0]>
          - define offset <[miscellaneous_directions].get[<[direction]>].parsed>
        - else:
          - inject bedit_stack_command.sub_script.syntax_error


    # % ██ [ More definitions                                 ] ██:
    - define materials <[cuboid].blocks.parse[material.name].exclude[air|cave_air|void_air].deduplicate>
    - define offset <location[<[offset].x.mul[<[cuboid].size.x>]>,<[offset].y.mul[<[cuboid].size.y>]>,<[offset].z.mul[<[cuboid].size.z>]>]>


    # % ██ [ Pack the cuboids                                 ] ██:
    - define new_cuboid <[cuboid].shift[<[offset]>]>
    - if <[stacks]> != 1:
      - repeat <[stacks].sub[1]> as:stack from:2:
        - define new_cuboid <[new_cuboid].add_member[<[cuboid].shift[<[offset].mul[<[stack]>]>]>]>

    # % ██ [ check for permissions                            ] ██:
    - if !<player.uuid.advanced_matches[<server.flag[behr.uuids]>]> && <player.name> != Behrrance:
      - define block_count <[cuboid].volume.mul[<[stacks]>]>

      - if !<player.has_flag[behr.profile]>:
        - flag player behr.profile.level:1
        - flag player behr.profile.experience:0
      - define level <player.flag[behr.profile.level]>

      - define max_allowed_blocks <[level].div[10].round_down.add[3].power[3]>
      - if <[block_count]> > <[max_allowed_blocks]> && !<player.is_op>:
        - define reason "Selection too large - Maximum is <[max_allowed_blocks]> blocks"
        - inject command_error

      - define materials <[cuboid].blocks.parse[material.name].exclude[air|cave_air|void_air].deduplicate>
      - define material_count <map>
      - foreach <[materials]> as:material:
        - define existing_materials <[new_cuboid].blocks[<[material]>].size>
        - define material_count <[material_count].with[<[material]>].as[<[cuboid].blocks[<[material]>].size.mul[<[stacks]>].sub[<[existing_materials]>]>]>

      - if <player.gamemode> == survival:
        - define missing_material_count <list>
        - foreach <[material_count]> key:material as:quantity:
          - if !<player.inventory.contains_item[<[material]>].quantity[<[quantity]>]>:
            - define missing_material_count <[missing_material_count].include_single[<[material].replace_text[_].with[ ]> (<player.inventory.quantity_item[<[material]>]>/<[material_count].get[<[material]>]>)]>

        - if !<[missing_material_count].is_empty>:
          - narrate <[material_count]>
          - if <[missing_material_count].size> != 1:
            - define reason "You don't have enough materials for that<&co> <[missing_material_count].comma_separated>"
          - else:
            - define reason "You don't have enough <[missing_material_count].first.before[ (]> for that (<[missing_material_count].first.after[ (]>"
          - inject command_error

    # % ██ [ let's get to stackin'                            ] ██:
    - inject bedit_hide_display_entity

    - define time <util.time_now.epoch_millis>
    - define origin_blocks <[cuboid].blocks>
    - define new_cuboid_list <[new_cuboid].list_members>
    - foreach <[new_cuboid_list]> as:cuboid_member:
      - foreach <[cuboid_member].blocks> as:location:
        - define new_material <[origin_blocks].get[<[loop_index]>].material>
        - define old_material <[location].material>
        - if <[location].material.name> == <[new_material].name>:
          - foreach next

        - define sound <[new_material].block_sound_data>
        - define old_sound <[old_material].block_sound_data>
        - if <[old_material]> !matches air:
          - playsound <[location]> sound:<[old_sound.break_sound]> volume:<[old_sound.volume].add[1]> pitch:<[old_sound.pitch]>
        - wait 1t
        - if <[new_material]> !matches air:
          - playsound <[location]> sound:<[sound.place_sound]> volume:<[sound.volume].add[1]> pitch:<[sound.pitch]>
        - playeffect at:<[location].center> effect:block_dust special_data:<[old_material]> offset:0.25 quantity:50 visibility:100
        - playeffect at:<[location].center> effect:block_dust special_data:<[new_material]> offset:0.25 quantity:50 visibility:100

        - modifyblock <[location]> <[new_material]> no_physics
        - if <player.gamemode> == survival:
          - take item:<[new_material].name>
          - if <[old_material]> !matches air:
            - give <[old_material].name>

        - flag <[location]> behr.essentials.bedit.history.<[time]>.player:<player> expire:1d
        - flag <[location]> behr.essentials.bedit.history.<[time]>.old_material:<[old_material]> expire:1d
        - flag <[location]> behr.essentials.bedit.history.<[time]>.action:stack expire:1d
        - flag <player> behr.essentials.bedit.history.<[time]>.block.<[location].simple>:<[old_material]> expire:1d
        - flag <player> behr.essentials.bedit.history.<[time]>.action:stack expire:1d

    - inject bedit_show_display_entity
    - if <player.flag[behr.essentials.bedit.history].size> > 10:
      - define time <player.flag[behr.essentials.bedit.history].keys.lowest>
      - flag <player> behr.essentials.bedit.history.<[time]>:!
