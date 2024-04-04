castle_wars_hardcode_definitions:
  type: task
  data:
    team:
      blue:
        flag:
          location: <location[-325,339,250,0,135,home]>
          direction: north_west
        spawn_doors:
          blue:
            displays:
              north:
                location: <location[-331,327,237.1,0,0,home]>
                scale: 2,3,0.8
              west:
                location: <location[-337.9,3277,246,0,0,home]>
                scale: 0.8,3,2
          red:
            displays:
              south:
                location: <location[-437,327,145.1,0,0,home]>
                scale: 2,3,1.8
              east:
                location: <location[-429.9,327,136,0,0,home]>
                scale: 1.8,3,2
      red:
        flag:
          location: <location[-442,339,133,0,315,home]>
          direction: south_east
    text_displays:
      game_time: <location[-383.5,369,192.5,home]>

    noted_single_cuboids:
      blue_flag_area:
        1: <location[-443,337,132,home]>
        2: <location[-440,342,135,home]>

      blue_floor_4:
        1: -331,336,244
        2: -321,343,254
      blue_floor_3:
        1: -338,331,237
        2: -319,336,256
      blue_floor_2:
        1: -344,326,231
        2: -319,331,256

      blue_stairs_3_to_4:
        1: -333,331,244
        2: -331,343,252
      blue_stairs_2_to_3:
        1: -327,327,235
        2: -320,336,237
      blue_stairs_1_to_2:
        1: -346,321,237
        2: -344,331,245
      blue_stairs_1_to_center:
        1: -349,322,244
        2: -347,332,252

      blue_wooden_doors_north:
        1: <location[-329,323,221,home]>
        2: <location[-330,322,221,home]>
      blue_wooden_doors_north_area:
        1: -331,322,220
        2: -327,327,224
      blue_wooden_doors_west:
        1: <location[-354,323,252,home]>
        2: <location[-354,322,253,home]>
      blue_wooden_doors_west_area:
        1: -355,322,251
        2: -351,327,255

      blue_spawn_door_north:
        1: <location[-330,329,237,home]>
        2: <location[-331,327,237,home]>
      blue_spawn_door_north_area:
        1: -332,326,235
        2: -328,331,238
      blue_spawn_door_west:
        1: <location[-338,329,246,home]>
        2: <location[-338,327,247,home]>
      blue_spawn_door_west_area:
        1: -340,326,245
        2: -337,331,249
      blue_spawn_door_top:
        1: <location[-325,331,250,home]>
        2: <location[-326,331,249,home]>
      blue_spawn_door_top_area:
        1: -327,331,248
        2: -323,334,252


      red_flag_area:
        1: <location[-326,337,249,home]>
        2: <location[-323,342,252,home]>

      red_floor_4:
        1: -445,336,130
        2: -435,343,140
      red_floor_3:
        1: -447,331,128
        2: -428,336,147
      red_floor_2:
        1: -447,326,128
        2: -422,331,153

      red_stairs_3_to_4:
        1: -435,331,132
        2: -433,343,140
      red_stairs_2_to_3:
        1: -446,326,147
        2: -438,336,149
      red_stairs_1_to_2:
        1: -422,321,139
        2: -420,331,147
      red_stairs_1_to_center:
        1: -419,321,132
        2: -417,332,140

      red_wooden_door_south:
        1: <location[-438,323,162,home]>
        2: <location[-437,322,162,home]>
      red_wooden_doors_south_area:
        1: -439,322,160
        2: -435,327,164
      red_wooden_door_east:
        1: <location[-413,322,131,home]>
        2: <location[-413,322,130,home]>
      red_wooden_doors_east_area:
        1: -416,321,128
        2: -411,327,133

      red_spawn_door_south:
        1: <location[-437,329,146,home]>
        2: <location[-436,327,146,home]>
      red_spawn_door_south_area:
        1: -438,326,146
        2: -434,331,149
      red_spawn_door_east:
        1: <location[-429,329,137,home]>
        2: <location[-429,327,136,home]>
      red_spawn_door_east_area:
        1: -429,326,135
        2: -426,331,139
      red_spawn_door_top:
        1: <location[-443,331,132,home]>
        2: <location[-442,331,133,home]>
      red_spawn_door_top_area:
        1: -444,331,131
        2: -440,334,135

      red_lobby_portal:
        1: -312,321,232
        2: -307,325,237
      green_lobby_portal:
        1: -312,321,217
        2: -308,325,223
      blue_lobby_portal:
        1: -312,321,203
        2: -307,325,208

    noted_multi_cuboids:
      blue_center:
        1: -355,326,227
        2: -349,322,251
        3: -359,326,216
        4: -348,332,227
        5: -348,326,220
        6: -331,332,226
      red_center:
        1: -435,326,158
        2: -418,332,164
        3: -417,326,133
        4: -411,332,157
        5: -418,326,157
        6: -407,332,168


  script:
    # reset the notes:
    - foreach <util.notes[cuboids].filter[note_name.starts_with[castle_wars]]> as:name:
      - note as:<[name]> remove
    - flag server behr.minigames.castle_wars:!

    # save the special locations:
    - flag server behr.minigames.castle_wars:<script.parsed_key[data.team]>
    #- foreach <script.parsed_key[data.noted_locations]> key:name as:object:
    #  - note <[object].as[location]> as:castle_wars_<[name]>

    # save the special areas:
    - foreach <script.parsed_key[data.noted_single_cuboids]> key:name as:location:
      - note <[location.1].as[location].to_cuboid[<[location.2].as[location]>]> as:castle_wars_<[name]>

    # save the special areas:
    #- foreach <script.parsed_key[data.noted_multi_cuboids].parsed_key[data.]> key:name as:location:
    #  - define cuboid <[location.1].as[location].to_cuboid[<[location.2].as[location]>]>
    #  - repeat <[location].size.div[2].sub[1]> as:loop_index:
    #    - define sub_cuboid <[location.<[loop_index].mul[2].sub[1]>].as[location].to_cuboid[<[location.<[loop_index].mul[2]>].as[location]>]>
    #    - define cuboid <[cuboid].add_member[<[sub_cuboid]>]>
    #  - note <[cuboid]> as:castle_wars_<[name]>

cast_test:
  type: task
  script:
    - define location <player.cursor_on.above.with_pose[0,0]>
    - spawn block_display[glowing=true;material=spruce_door[half=top]] <[location].above> save:door_entity1
    - spawn block_display[glowing=true;material=spruce_door[half=bottom]] <[location]> save:door_entity2
    - define door_entity1 <entry[door_entity1].spawned_entity>
    - define door_entity2 <entry[door_entity2].spawned_entity>
    - wait 1s
    - remove <[door_entity1]>
    - remove <[door_entity2]>

    # save the special cuboids
castle_wars_flag_animation:
  type: task
  debug: false
  definitions: animation|team
  script:
    - define location <server.flag[behr.minigames.castle_wars.<[team]>.flag.location]>
    - define center_location <[location].center.below[1.5]>

    - choose <[animation]>:
      - case return:
        - playsound <[location]> ENTITY_PHANTOM_FLAP volume:2
        - spawn <[team]>_flag_block_display <[location]> save:flag_entity
        - wait 3t
        - definemap properties:
            scale: 0.9,0.9,0.9
            interpolation_start: 0s
            interpolation_duration: 1s
        - adjust <entry[flag_entity].spawned_entity> <[properties]>
        - repeat 100 as:loop_index:
          - define x <[loop_index].div[4].round_up.power[1.1].div[30]>
          - define y <[loop_index].div[30]>
          - define particle_location <[center_location].add[<location[<[x]>,<[y]>,0].rotate_around_y[<[loop_index].to_radians.mul[92]>]>]>
          - playeffect effect:redstone at:<[particle_location]> special_data:1.4|<[team]> visibility:250 offset:0
          - if <[loop_index].mod[7]> == 0:
            - playeffect at:<[particle_location]> effect:crit visibility:250 quantity:2 offset:0.3 velocity:0,1,0
            - playeffect at:<[particle_location]> effect:end_rod visibility:250 quantity:2 offset:0.3 velocity:0,0.1,0
            - playeffect effect:cloud at:<[center_location].above[2]>  visibility:250 offset:0.2,0.5,0.2

            - wait 1t
        - playsound <[location]> ENTITY_PHANTOM_FLAP volume:2
        - wait 2s
        - remove <entry[flag_entity].spawned_entity>

red_flag_block_display:
  type: entity
  debug: false
  entity_type: item_display
  mechanisms:
    item: red_banner
    display: HEAD
    scale: 0,0,0
    interpolation_start: 0s
    interpolation_duration: 1s
    translation: 0,-0.3,1.1
    tracking_range: 256

blue_flag_block_display:
  type: entity
  debug: false
  entity_type: item_display
  mechanisms:
    item: blue_banner
    display: HEAD
    scale: 0,0,0
    interpolation_start: 0s
    interpolation_duration: 1s
    translation: 0,-0.3,-0.35
    tracking_range: 256

game_timer_task:
  type: task
  debug: false
  definitions: action|time
  script:
    - if !<server.has_flag[behr.minigames.castle_wars.text_displays.game_time].is_truthy>:
      - define location <script[castle_wars_hardcode_definitions].parsed_Key[data.text_displays.game_time]>
      - spawn castle_wars_game_time_text_display <[location]> save:text_entity
      - flag server behr.minigames.castle_wars.text_displays.game_time:<entry[text_entity].spawned_entity>

    - define text_entity <server.flag[behr.minigames.castle_wars.text_displays.game_time]>

    - choose <[action]>:
      - case start:
        - if !<[time].exists>:
          - define time 20m

        - flag <[text_entity]> active expire:<[time]>
        - while <[text_entity].has_flag[active]> && <[text_entity].is_truthy>:
          - define time_left <[text_entity].flag_expiration[active].from_now>
          - define mm <[time_left].in_minutes.round_down.pad_left[2].with[0]>
          - define ss <[time_left].in_seconds.round_down.mod[60].pad_left[2].with[0]>
          - adjust <[text_entity]> text:<&e><[mm]><&6><&co><&e><[ss]>
          - wait 19t

        - adjust <[text_entity]> text:<&c>00<&4><&co><&c>00
        - wait 5s
        - adjust <[text_entity]> text:<&7>--<&8><&co><&7>--

      - case idle:
        - adjust <[text_entity]> text:<&7>--<&8><&co><&7>--

castle_wars_game_time_text_display:
  type: entity
  entity_type: text_display
  mechanisms:
    pivot: center
    scale: 40,40,40
    text: <&7>--<&8><&co><&7>--
    tracking_range: 256

selection_handler:
  type: world
  debug: false
  events:
    after player quits:
      - flag player behr.minigames.control.selecting:!
      - if <player.has_flag[behr.minigames.control.selected_npcs]>:
        - define old_entities <player.flag[behr.minigames.control.selected_npcs]>
        - flag <player> behr.minigames.control.selected_npcs:!
        - flag <[old_entities]> selected:!
        - glow <[old_entities]> false

    on player clicks block with:testing_selection_stick flagged:!behr.minigames.control.selecting:
      - determine passively cancelled

      - if <player.has_flag[behr.minigames.control.selected_npcs]> && !<player.is_sneaking>:
        - define old_entities <player.flag[behr.minigames.control.selected_npcs]>
        - flag <player> behr.minigames.control.selected_npcs:!
        - flag <[old_entities]> selected:!
        - glow <[old_entities]> false

      - if <player.target.exists>:
        - define entity <player.target>
        - glow <[entity]> true

      - define origin_location <context.location.if_null[<player.cursor_on.if_null[<player.eye_location.forward[10]>]>].below[2]>
      - flag player behr.minigames.control.selecting expire:1h

      - inject define_block_task
      - inject define_entity_task
      - while <player.has_flag[behr.minigames.control.selecting]>:
        - wait 4t

        #- if !<player.is_on_ground>:
        #  - stop

        - if <[cursor_location]> == <player.cursor_on.below[2].if_null[null]>:
          - debugblock <[blocks]> d:5t
          - while next

        - inject define_block_task
        - inject define_entity_task

      - flag player behr.minigames.control.selecting:!

      - if !<[entities].is_empty>:
        - flag <[entities]> selected:<player> expire:1h
        - flag <player> behr.minigames.control.selected_npcs:|:<[entities]> expire:1h
        - repeat 5:
          - sneak <[entities]> start
          - wait 2t
          - sneak <[entities]> stop
          - wait 2t


    on player clicks block with:testing_selection_stick flagged:behr.minigames.control.selecting:
      - determine passively cancelled
      - flag player behr.minigames.control.selecting:!
      - define origin_location <context.location.if_null[<player.cursor_on.if_null[<player.eye_location.forward[10]>]>]>


    on player clicks block with:testing_move_stick:
      - define entities <player.flag[behr.minigames.control.selected_npcs].if_null[<list>]>
      - if <[entities].is_empty>:
        - stop

      - define origin_location <context.location.if_null[<player.cursor_on.if_null[<player.eye_location.forward[10]>]>]>
      - define walk_locations <[origin_location].find_spawnable_blocks_within[<[entities].size.min[20]>]>
      - if <[walk_locations].is_empty>:
        - define walk_locations <list_single[<[origin_location]>]>
      - foreach <[entities]> as:entity:
        - define location <[walk_locations].get[<[loop_index].mod[<[entities].size.add[1]>].max[1]>]>
        - run walk_naturally_dammit def:<[entity]>|<[location]>

walk_naturally_dammit:
  type: task
  debug: false
  definitions: entity|location
  script:
    - ~walk <[entity]> <[location]> lookat:<[location].above[2.5]>
    - look <[entity]> <[entity].eye_location.forward_flat[1].random_offset[0.3,0.1,0.3]>

define_block_task:
  type: task
  debug: false
  script:
        - define cursor_location <player.cursor_on.below[2].if_null[null]>
        - if !<[cursor_location].is_truthy>:
          - stop

        - if <[cursor_location].distance[<[origin_location]>]> > 20:
          - stop

        - define cuboid <[origin_location].to_cuboid[<[cursor_location]>]>
        - define blocks <[cuboid].shell>

        - define blocks <[blocks].parse_tag[<[parse_value].points_between[<[parse_value].highest>]>].combine.deduplicate.filter[advanced_matches[!air]]>
        - debugblock <[blocks]> d:5t

define_entity_task:
  type: task
  debug: false
  script:
    - if <[entity_cuboid].exists>:
      - define entity_cuboid <[cuboid].with_max[<[cuboid].max.above[5]>]>
      - if !<[entities].exclude[<[entity_cuboid].entities[npc]>].is_empty>:
        - glow <[entities].exclude[<[entity_cuboid].entities[npc]>]> false

    - define entity_cuboid <[cuboid].with_max[<[cuboid].max.above[5]>]>
    - define entities <[entity_cuboid].entities[npc]>
    - glow <[entities]> true


testing_selection_stick:
  type: item
  debug: false
  material: stick
  display name: selection sticc


testing_move_stick:
  type: item
  debug: false
  material: stick
  display name: move sticc
