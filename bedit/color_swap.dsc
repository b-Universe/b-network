bedit_color_swap_command:
  type: command
  debug: false
  enabled: true
  name: /color_swap
  usage: //color_swap <&lt>color<&gt> <&lt>color<&gt>
  description: Swaps colors of materials
  tab completions:
    1: white|light_gray|gray|black|brown|red|orange|yellow|lime|green|cyan|light_blue|blue|purple|magenta|pink
    2: white|light_gray|gray|black|brown|red|orange|yellow|lime|green|cyan|light_blue|blue|purple|magenta|pink
  data:
    spruce:
      fence:
        - spruce_fence
        - wood
      fence_gate:
        - spruce_wood
        - wood
      stairs:
        - spruce_stairs
        - wood
      slab:
        - spruce_slab
        - wood
      door:
        - spruce_door
        - wood
      pressure_plate:
        - spruce_pressure_plate
        - wood
    oak:
      fence:
        - oak_fence
        - wood
      fence_gate:
        - oak_wood
        - wood
      stairs:
        - oak_stairs
        - wood
      slab:
        - oak_slab
        - wood
      door:
        - oak_door
        - wood
      pressure_plate:
        - oak_pressure_plate
        - wood
    white:
      fence:
        - pale_oak_fence
        - wood
      fence_gate:
        - pale_oak_fence_gate
        - wood
      stairs:
        - pale_oak_stairs
        - wood
      slab:
        - pale_oak_slab
        - wood
      door:
        - pale_oak_door
        - wood
      pressure_plate:
        - pale_oak_pressure_plate
        - wood
      trapped_door:
        - pale_oak_trapped_door
        - wood
    red:
      fence:
        - crimson_fence
        - nether_brick_fence
        - wood
      fence_gate: wood
      stairs: wood
      slab: wood
      door: wood
      pressure_plate: wood
    orange:
      fence: wood
      fence_gate: wood
      stairs: wood
      slab: wood
      door: wood
      pressure_plate: wood
    yellow:
      fence: wood
      fence_gate: wood
      stairs: wood
      slab: wood
      door: wood
      pressure_plate: wood
    lime:
      fence: wood
      fence_gate: wood
      stairs: wood
      slab: wood
      door: wood
      pressure_plate: wood
    green:
      fence: wood
      fence_gate: wood
      stairs: wood
      slab: wood
      door: wood
      pressure_plate: wood
    cyan:
      fence:
      - warped_fence
      - wood
      fence_gate:
      - warped_fence_gate
      - wood
      slab:
      - warped_slab
      - wood
      stairs:
      - warped_stairs
      - wood
      pressure_plate:
      - warped_pressure_plate
      - wood
      door:
      - warped_door
      - wood
    light_blue:
      fence:
      - warped_fence
      - wood
      fence_gate:
      - warped_fence_gate
      - wood
      slab:
      - warped_slab
      - wood
      stairs:
      - warped_stairs
      - wood
      pressure_plate:
      - warped_pressure_plate
      - wood
      door:
      - warped_door
      - wood
      trapped_door:
      - warped_trapdoor
      - wood
    blue:
      fence:
      - warped_fence
      - wood
      fence_gate:
      - warped_fence_gate
      - wood
      slab:
      - warped_slab
      - wood
      stairs:
      - warped_stairs
      - wood
      pressure_plate:
      - warped_pressure_plate
      - wood
      door:
      - warped_door
      - wood
    purple:
      fence:
      - warped_fence
      - wood
      fence_gate:
      - warped_fence_gate
      - wood
      slab:
      - warped_slab
      - wood
      stairs:
      - warped_stairs
      - wood
      pressure_plate:
      - warped_pressure_plate
      - wood
      door:
      - warped_door
      - wood
    magenta:
      fence: cherry_fence
      fence_gate: cherry_fence_gate
      slab: cherry_slab
      stairs: cherry_stairs
      pressure_plate: cherry_pressure_plate
      door: cherry_door
    pink:
      fence: cherry_fence
      fence_gate: cherry_fence_gate
      slab: cherry_slab
      stairs: cherry_stairs
      pressure_plate: cherry_pressure_plate
      door: cherry_door
            #- if <[color_from]>.<[material_fix]>].exists>:
          #- foreach <[cuboid].blocks[<[color_data.<[color_from]>.<[material_fix]>]>]> as:block:
  script:

#    # % ██ [ Check if a player has a selection they can set ] ██:
#    - inject bedit_check_for_selection
#
#    - if <context.args.size> != 2:
#      - inject command_syntax_error
#
    - define color_from <context.args.first>
    - define color_to <context.args.last>
    - define color_data <script.parsed_key[data]>
    - define woods <list[oak|spruce|birch|jungle|acacia|dark_oak|mangrove|pale_oak|cherry|bamboo]>
    - define cuboid <player.we_selection>

#    - foreach wool|carpet|stained_glass|concrete_bed|glass_pane|bed|pressure_plate as:material_fix:
#      - choose <[material_fix]>:
#        - case wool carpet stained_glass concrete pressure_plate:
#          - foreach <[cuboid].blocks[<[color_from]>_<[material_fix]>]> as:block:
#            - modifyblock <[block]> <[color_to]>_<[material_fix]> no_physics
#
#        - case glass_pane:
#          - foreach <[cuboid].blocks[<[color_from]>_stained_glass_pane]> as:block:
#            - modifyblock <[block]> <[color_to]>_stained_glass_pane[faces=<[block].material.faces>;waterlogged=<[block].material.waterlogged>]
#
#        - case bed:
#          - foreach <[cuboid].blocks[<[color_from]>_bed]> as:block:
#            - modifyblock <[block]> <[color_to]>_bed[direction=<[block].material.direction>;half=<[block].material.half>] no_physics

    #- foreach oak|spruce|birch|jungle|acacia|dark_oak|mangrove|cherry|bamboo|crimson|warped as:fence:
    - foreach fence|fence_gate|slab|stairs|door|trapdoor as:type:
      - if <[color_data.<[color_from]>.<[type]>].exists> && <[color_data.<[color_to]>.<[type]>].exists>:
        - if <[color_data.<[color_to]>.<[type]>].object_type> == element:
          - define material <[color_data.<[color_to]>.<[type]>]>
        - else:
          - define material <[color_data.<[color_to]>.<[type]>].exclude[<[color_data.<[color_from]>.<[type]>]>].random>
        - if <[material]> == wood:
          - define material <[woods].random>_<[type]>
        - if <[color_data.<[color_from]>.<[type]>].object_type> == element:
          - if <[color_data.<[color_from]>.<[type]>]> == wood:
            - define material_from <[woods].parse_tag[<[parse_value]>_<[type]>]>
          - else:
            - define material_from <[color_data.<[color_from]>.<[type]>]>
        - else:
          - if wood in <[color_data.<[color_from]>.<[type]>]>:
            - define material_from <[color_data.<[color_from]>.<[type]>].exclude[wood].include[<[woods].parse_tag[<[parse_value]>_<[type]>]>]>
          - else:
            - define material_from <[color_data.<[color_from]>.<[type]>]>

        - choose <[type]>:
          - case fence fence_gate:
            - foreach <[cuboid].blocks[<[material_from]>]> as:block:
              - modifyblock <[block]> <[material]>[faces=<[block].material.faces>;waterlogged=<[block].material.waterlogged>]

          - case slab:
            - foreach <[cuboid].blocks[<[material_from]>]> as:block:
              - modifyblock <[block]> <[material]>[type=<[block].material.type>;waterlogged=<[block].material.waterlogged>]

          - case stairs:
            - foreach <[cuboid].blocks[<[material_from]>]> as:block:
              - modifyblock <[block]> <[material]>[direction=<[block].material.direction>;half=<[block].material.half>;shape=<[block].material.shape>;waterlogged=<[block].material.waterlogged>]

          - case door:
            - foreach <[cuboid].blocks[<[material_from]>]> as:block:
              - modifyblock <[block]> <[material]>[direction=<[block].material.direction>;half=<[block].material.half>;hinge=<[block].material.hinge>;switched=<[block].material.switched>;waterlogged=<[block].material.waterlogged>]

          - case trapdoor:
            - foreach <[cuboid].blocks[<[material_from]>]> as:block:
              - modifyblock <[block]> <[material]>[direction=<[block].material.direction>;half=<[block].material.half>;switched=<[block].material.switched>;waterlogged=<[block].material.waterlogged>]

swap_task_temp:
  type: task
  script:
    # replaces nearby birch stairs for pale_oak:
    #- foreach north|south|east|west as:direction:
    #  - foreach inner_left|inner_right|outer_left|outer_right|straight as:shape:
    #    - foreach top|bottom as:half:
    #      - execute as_player "/replacenear 20 birch_stairs[facing=<[direction]>,half=<[half]>,shape=<[shape]>] pale_oak_stairs[facing=<[direction]>,half=<[half]>,shape=<[shape]>]"

    - define cuboid <player.we_selection>
    - define color_from oak_trapdoor
    - define color_to pale_oak_trapdoor

    # replace fence types
    #- foreach <[cuboid].blocks[<[color_from]>]> as:block:
    #  # waterlog? ;waterlogged=<[block].material.waterlogged>
    #  - modifyblock <[block]> <[color_to]>[faces=<[block].material.faces>]

    # replace trapdoor types
    - foreach north|south|east|west as:direction:
      - foreach top|bottom as:half:
        - foreach true|false as:open:
          - define properties [facing=<[direction]>,half=<[half]>,open=<[open]>]
          - execute as_op "/replace <[color_from]><[properties]> <[color_to]><[properties]>"