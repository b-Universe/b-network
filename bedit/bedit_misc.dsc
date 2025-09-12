bedit_check_for_selection:
  type: task
  debug: false
  script:
    # % ██ [ check if a player has a selection they can change ] ██
    - define cuboid <player.flag[behr.essentials.bedit.selection.cuboid].if_null[null]>
    - if !<[cuboid].is_truthy>:
      - choose <queue.script.name.after[bedit_]>:
        - case stack_command:
          - define reason "You must make some kind of selection to stack"

        - case set_command:
          - define reason "You must make a selection to set it's material"

        - case replace_command:
          - define reason "You must make some kind of selection to replace blocks with"

        - default:
          - inject command_syntax_error

      - inject command_error


hide_bedit_display_entity:
  type: task
  debug: false
  script:
    - foreach left|right as:selection_point:
      - define entity <player.flag[behr.essentials.bedit.selection.<[selection_point]>.entity].if_null[null]>
      - foreach next if:!<[entity].is_truthy>
      - adjust <[entity]> material:air
      - adjust <[entity]> glowing:false

show_bedit_display_entity:
  type: task
  debug: false
  script:
    - foreach left|right as:selection_point:
      - define entity <player.flag[behr.essentials.bedit.selection.<[selection_point]>.entity].if_null[null]>
      - foreach next if:!<[entity].is_truthy>
      - define entity_material <[entity].location.material>
      - if <[entity_material]> !matches air:
        - adjust <[entity]> material:<[entity_material]>
        - adjust <[entity]> glow_color:<[entity].location.map_color>
      - else:
        - adjust <[entity]> material:glass
        - adjust <[entity]> glow_color:white
      - adjust <[entity]> glowing:true

bedit_clear_selections:
  type: task
  debug: false
  definitions: position
  script:
    - if <[position]> in left|right:
      - define entity <player.flag[behr.essentials.bedit.selection.<[position]>.entity].if_null[null]>
      - remove <[entity]> if:<[entity].is_truthy>
      - if <player.has_flag[behr.essentials.bedit.selection.left]> && <player.has_flag[behr.essentials.bedit.selection.right]>:
        - flag <player> behr.essentials.bedit.selection.<[position]>:!
        - flag <player> behr.essentials.bedit.selection.cuboid:!
        - actionbar "<&[green]><[position].to_titlecase> selecton point<&co> <&[yellow]>cleared"
        - narrate "<&[green]><[position].to_titlecase> selecton point<&co> <&[yellow]>cleared"
      - else:
        - flag <player> behr.essentials.bedit.selection:!
        - actionbar "<&[green]>Selection<&co> <&[yellow]>cleared"
        - narrate "<&[green]>Selection<&co> <&[yellow]>cleared"
    - else:
      - foreach left|right as:position:
        - remove <player.flag[behr.essentials.bedit.selection.<[position]>.entity]> if:<player.flag[behr.essentials.bedit.selection.<[position]>.entity].is_truthy>
      - flag <player> behr.essentials.bedit.selection:!
      - actionbar "<&[green]>Selection<&co> <&[yellow]>cleared"
      - narrate "<&[green]>Selection<&co> <&[yellow]>cleared"


bedit_set_position:
  type: task
  debug: false
  definitions: location|color|position
  script:
        - if <[location].material.name> !in air|void_air|cave_air:
          - define material_name <[location].material.name>
        - else:
          - define material_name glass

        - playsound <player> block_amethyst_cluster_place pitch:<util.random.int[7].to[10].div[10]> volume:2
        - spawn bedit_selection_block[material=<[material_name]>;glow_color=<[color]>] <[location]> save:block_display
        - define entity <player.flag[behr.essentials.bedit.selection.<[position]>.entity].if_null[null]>
        - if <[entity].is_truthy>:
          - remove <[entity]>
        - define block_display <entry[block_display].spawned_entity>
        - flag <player> behr.essentials.bedit.selection.world_name:<player.world.name>
        - flag <player> behr.essentials.bedit.selection.<[position]>.entity:<[block_display]>
        - flag <player> behr.essentials.bedit.selection.<[position]>.location:<[location]>
        - flag <player> behr.essentials.bedit.selection.<[position]>.world_name:<player.world.name>
        - if <player.has_flag[behr.essentials.bedit.selection.left]> && <player.has_flag[behr.essentials.bedit.selection.right]>:
          - define cuboid <player.flag[behr.essentials.bedit.selection.left.location].to_cuboid[<player.flag[behr.essentials.bedit.selection.right.location]>]>
          - flag <player> behr.essentials.bedit.selection.cuboid:<[cuboid]>
          - actionbar "<&[green]><[position].to_titlecase> selecton<&co> <[location].proc[bedit_location_format]> <[cuboid].size.proc[bedit_location_format]>/(<&e><[cuboid].volume><&a>)"
          - narrate "<&[green]><[position].to_titlecase> selecton<&co> <[location].proc[bedit_location_format]> <[cuboid].size.proc[bedit_location_format]>/(<&e><[cuboid].volume><&a>)"
          - playeffect effect:wax_on at:<[cuboid].outline.parse[center]> offset:0 quantity:1
        - else:
          - actionbar "<&[green]><[position].to_titlecase> selecton<&co> <[location].proc[bedit_location_format]>"
          - narrate "<&[green]><[position].to_titlecase> selecton<&co> <[location].proc[bedit_location_format]>"

        - playeffect effect:electric_spark at:<[location].center> offset:0.4,0.4,0.4 quantity:20

bedit_directions:
  type: data
  directions:
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

  miscellaneous_directions:
    forward: <[origin_location].forward[<[distance]>].round_down.with_yaw[0].with_pitch[0]>
    backward: <[origin_location].backward[<[distance]>].round_down.with_yaw[0].with_pitch[0]>
    left: <[origin_location].left[<[distance]>].round_down.with_yaw[0].with_pitch[0]>
    right: <[origin_location].right[<[distance]>].round_down.with_yaw[0].with_pitch[0]>
    up: <[origin_location].up[<[distance]>].round_down.with_yaw[0].with_pitch[0]>
    above: <[origin_location].above[<[distance]>].round_down.with_yaw[0].with_pitch[0]>
    down: <[origin_location].down[<[distance]>].round_down.with_yaw[0].with_pitch[0]>
    below: <[origin_location].below[<[distance]>].round_down.with_yaw[0].with_pitch[0]>
    forward_flat: <[origin_location].forward_flat[<[distance]>].round_down.with_yaw[0].with_pitch[0]>
    backward_flat: <[origin_location].backward_flat[<[distance]>].round_down.with_yaw[0].with_pitch[0]>

    cursor_on: <player.cursor_on>