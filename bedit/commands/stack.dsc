bedit_stack_command:
  type: command
  debug: false
  enabled: true
  name: /stack
  usage: //stack (<&ns>) (direction)
  description: Sets a selection to a set material
  tab completions:
    1: up|down|left|right|north|northeast|east|southeast|south|southwest|west|northwest
    2: up|down|left|right|north|northeast|east|southeast|south|southwest|west|northwest
  data:
    direction:
      north: 0,0,-1
      northeast: 1,0,-1
      east: 1,0,0
      southeast: 1,0,1
      south: 0,0,1
      southwest: -1,0,1
      west: -1,0,0
      northwest: -1,0,-1
      up: 0,1,0
      down: 0,-1,0
      left: <location[0,0,0].with_pose[<player>].left>
      right: <location[0,0,0].with_pose[<player>].right>
      forward: <location[0,0,0].with_pose[<player>].forward_flat>
      back: <location[0,0,0].with_pose[<player>].backward_flat>
  sub_paths:
    direction:
    - if <player.location.pitch> < -60:
      - define direction <location[0,1,0]>
    - else if <player.location.pitch> > 60:
      - define direction <location[0,-1,0]>
    - else:
      - define direction <script.parsed_key[data.direction.<player.location.direction>].as[location]>
  script:
    # % ██ [ check if using the command wrongly               ] ██:
    - define args <context.args>
    - if <[args].size> > 2:
      - inject command_syntax_error

    # % ██ [ check if a player has a selection they can stack ] ██:
    - inject bedit_check_for_selection

    # % ██ [ determine the stack amount and direction         ] ██:
    - choose <[args].size>:
      # % ██ [ //bstack                                       ] ██:
      - case 0:
        - define frequency 1
        - inject bedit_stack_command.sub_paths.direction
      # % ██ [ //bstack #                                     ] ██:
      # % ██ [ //bstack direction                             ] ██:
      - case 1:
        - if <[args].first.is_integer>:
          - define frequency <[args].first>
          - inject bedit_stack_command.sub_paths.direction
        - else if <[args].first> in <script.list_keys[data.direction]>:
          - define frequency 1
          - define direction <script.parsed_key[data.direction.<[args].first>].as[location]>
        - else:
          - inject command_syntax_error
      # % ██ [ //bstack # direction                           ] ██:
      # % ██ [ //bstack direction #                           ] ██:
      - case 2:
        - if <[args].first.is_integer>:
          - define frequency <[args].first>
          - if <[args].last> in <script.list_keys[data.direction]>:
            - define direction <script.parsed_key[data.direction.<[args].last>].as[location]>
          - else:
            - inject command_syntax_error

        - else if <[args].first> in <script.list_keys[data.direction]>:
          - define direction <script.parsed_key[data.direction.<[args].first>].as[location]>
          - if <[args].last.is_integer>:
            - define frequency <[args].last>
          - else:
            - inject command_syntax_error

        - else:
          - inject command_syntax_error

      - default:
        - inject command_syntax_error

    # % ██ [ //bstack direction #                             ] ██:
    - define size <[cuboid].size>
    - define locations <[cuboid].blocks>
    - foreach <[locations]> as:location:
      - define blocks.<[location]> <[location].material>
    - define block_count <[blocks].size.mul[<[frequency]>]>

    # % ██ [ Check for permissions                            ] ██:
    - if <player.uuid> in <server.flag[behr.uuids]>:
      - define level 169
    - else:
      - define level <player.flag[behr.essentials.profile.stats.construction.level]>
    - define max_allowed_blocks <[level].div[10].round_down.add[4].power[3]>
    - if <[block_count]> > <[max_allowed_blocks]>:
      - define reason "Stack quantity too large - Maximum is <[max_allowed_blocks]> blocks"
      - inject command_error

    # % ██ [ Count block requirements                          ] ██:
    - foreach <[blocks].keys.parse[as[location].material.name].deduplicate> as:material:
      - define count <[cuboid].blocks[<[material]>].size.mul[<[frequency]>]>
      - if !<player.inventory.contains_item[<[material]>].quantity[<[count]>]> && <player.gamemode> == survival:
        - define reason "You don't have enough <&e><[material]> <&c>for that <&6>(<&e><player.inventory.quantity_item[<[material]>]><&6>/<&e><[count]><&6>)"
        - inject command_error

    # % ██ [ Run the command            ] ██:
    - define time <util.time_now.epoch_millis>
    - flag player behr.essentials.bedit.undo_history_events:->:<[time]> expire:4h
    - repeat <[frequency]> as:frequency_index:
      - define x <[size].x.mul[<[direction].x.mul[<[frequency_index]>]>]>
      - define y <[size].y.mul[<[direction].y.mul[<[frequency_index]>]>]>
      - define z <[size].z.mul[<[direction].z.mul[<[frequency_index]>]>]>
      - define offset <[x]>,<[y]>,<[z]>
      - foreach <[blocks]> key:location as:new_material:
        - define old_material <[location].add[<[offset]>].material>
        - if <[new_material].name> matches air && <[old_material].name> matches air:
          - foreach next
        - flag <[location].add[<[offset]>]> behr.essentials.bedit.old_material:<[old_material]>
        - foreach next if:<[new_material].equals[<[old_material].name>]>
        - if <player.gamemode> == survival && !<player.inventory.contains_item[<[new_material].name>]> && <[new_material]> !matches air:
          - foreach stop

        - define sound <[location].add[<[offset]>].material.block_sound_data>
        - if <[new_material].name> matches air && <[old_material]> !matches air:
          - playsound <[location].add[<[offset]>]> sound:<[sound.break_sound]> volume:<[sound.volume].add[1]> pitch:<[sound.pitch]>

        - else if <[location].add[<[offset]>]> !matches <[new_material].name>:
          - playsound <[location].add[<[offset]>]> sound:<[sound.place_sound]> volume:<[sound.volume].add[1]> pitch:<[sound.pitch]>
          - take item:<[new_material].name> if:<player.gamemode.equals[survival]>

        - if <[location].add[<[offset]>]> !matches air:
          - if <[location].add[<[offset]>]> !matches <[new_material].name> && <player.gamemode.equals[survival]>:
            - give <[location].add[<[offset]>].material.item> to:<player.inventory>
            - playeffect at:<[location].add[<[offset]>].center> effect:block_dust special_data:<[new_material]> offset:0.25 quantity:50 visibility:100
        - else:
          - playeffect at:<[location].add[<[offset]>].center> effect:block_dust special_data:<[old_material]> offset:0.25 quantity:50 visibility:100
        - flag player behr.essentials.bedit.undo_history.<[time]>:->:<map.with[location].as[<[location]>].with[material].as[<[old_material]>]> expire:4h
        - modifyblock <[location].add[<[offset]>]> <[new_material]>
        - flag player behr.essentials.profile.stats.construction.experience:++
        - wait 1t
