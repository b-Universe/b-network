##ignorewarning short_script_name
bblock:
  type: entity
  debug: false
  entity_type: block_display
  mechanisms:
    glowing: true
    translation: -0.001,-0.001,-0.001
    scale: 1.0021,1.0021,1.0021

bblock_handler:
  type: world
  debug: false
  events:
    on bblock spawns:
      - define block_entity <context.entity>
      - flag server behr.essentials.bedit.display_blocks:->:<[block_entity]>
      - define blocks <list[<[block_entity].location.left>|<[block_entity].location.right>|<[block_entity].location.forward>|<[block_entity].location.backward>|<[block_entity].location.up>]>
      - define block_light <[blocks].parse[light.blocks].exclude[0]>
      - if <[block_light].is_empty>:
        - define block_light 0
      - else:
        - define block_light <[block_light].sum.div[<[block_light].size>].round>
      - define sky_light <[blocks].parse[light.sky].highest.max[<[blocks].parse[light].highest>]>
      - adjust <[block_entity]> brightness:<map[sky=<[sky_light]>;block=<[block_light]>]>

    on bblock despawns:
      - flag server behr.essentials.bedit.display_blocks:<-:<context.entity>

    after time changes:
    - stop
    - define display_blocks <server.flag[behr.essentials.bedit.display_blocks].filter[is_truthy]>
    - foreach <[display_blocks]> as:block_entity:
      - if <[loop_index].mod[25]> == 0:
        - wait 1t
      - define blocks <list[<[block_entity].location.left>|<[block_entity].location.right>|<[block_entity].location.forward>|<[block_entity].location.backward>|<[block_entity].location.up>]>
      - define block_light <[blocks].parse[light.blocks].exclude[0]>
      - if <[block_light].is_empty>:
        - define block_light 0
      - else:
        - define block_light <[block_light].sum.div[<[block_light].size>].round>
      - define sky_light <[blocks].parse[light.sky].highest.max[<[blocks].parse[light].highest>]>
      - define data <[block_entity].brightness>
      - if <[data.sky]> == <[sky_light]> && <[data.block]> == <[block_light]>:
        - foreach next
      - adjust <[block_entity]> brightness:<map[sky=<[sky_light]>;block=<[block_light]>]>

bedit_location_format:
  type: procedure
  debug: false
  definitions: location
  script:
    - determine <&[green]>(<&[yellow]><[location].round.xyz.replace[,].with[<&[green]>, <&[yellow]>]><&[green]>)

pos:
  type: procedure
  debug: false
  definitions: click_type
  script:
    - determine <player.flag[behr.essentials.bedit.<[click_type]>.selection].if_null[null]>
lpos:
  type: procedure
  debug: false
  script:
    - determine <player.flag[behr.essentials.bedit.left.selection].if_null[null]>
rpos:
  type: procedure
  debug: false
  script:
    - determine <player.flag[behr.essentials.bedit.right.selection].if_null[null]>
bsel:
  type: procedure
  debug: false
  script:
    - determine <player.flag[behr.essentials.bedit.selection.cuboid].if_null[null]>

bedit_hide_selection_corners:
  type: task
  debug: false
  script:
    - foreach left|right as:corner:
      - define location <player.flag[behr.essentials.bedit.<[corner]>.selection].if_null[null]>
      - foreach next if:!<[location].is_truthy>
      - remove <player.flag[behr.essentials.bedit.<[corner]>.selection_entity].if_null[null]> if:<player.flag[behr.essentials.bedit.<[corner]>.selection_entity].is_truthy>

bedit_refresh_selection_corners:
  type: task
  debug: false
  script:
    - foreach left|right as:corner:
      - define location <player.flag[behr.essentials.bedit.<[corner]>.selection].if_null[null]>
      - foreach next if:!<[location].is_truthy>
      - remove <player.flag[behr.essentials.bedit.<[corner]>.selection_entity].if_null[null]> if:<player.flag[behr.essentials.bedit.<[corner]>.selection_entity].is_truthy>

      - if <[location].material.is_occluding>:
        - playeffect effect:end_rod at:<[location].center.above[0.1]> offset:0.50 quantity:10
      - else:
        - playeffect effect:end_rod at:<[location].center.above[0.1]> offset:0.25 quantity:10

      - define color <[location].map_color>
      - playsound <player> block_amethyst_cluster_place pitch:<util.random.int[7].to[10].div[10]> volume:2
      - spawn bblock[material=<[location].material>;glow_color=<[color]>] <[location]> save:block_display
      - define block_display <entry[block_display].spawned_entity>
      - flag player behr.essentials.bedit.<[corner]>.selection_entity:<[block_display]>
      - flag player behr.essentials.bedit.<[corner]>.quick_release expire:10s

      - define cuboid <player.flag[behr.essentials.bedit.selection.cuboid].if_null[null]>

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

        - case set_command center_command:
          - define reason "You must make a selection to set it's material"

        - case replace_command:
          - define reason "You must make some kind of selection to stack"

        - default:
          - inject command_syntax_error

      - inject command_error

bedit_place_block:
  type: task
  debug: false
  definitions: new_material|location|time
  script:
    - define old_material <[location].material>
    - stop if:<[new_material].equals[<[old_material]>]>
    - if <player.gamemode> == survival && !<player.inventory.contains_item[<[new_material_name]>]> && <[new_material]> !matches air:
      - stop

    - define sound <[location].material.block_sound_data>
    - if <[new_material]> matches air && <[old_material]> !matches air:
      - give <[location].material.item> to:<player.inventory> if:<player.gamemode.equals[survival]>
      - playsound <[location]> sound:<[sound.break_sound]> volume:<[sound.volume].add[1]> pitch:<[sound.pitch]>

    - else:
      - playsound <[location]> sound:<[sound.place_sound]> volume:<[sound.volume].add[1]> pitch:<[sound.pitch]>
      - if <[new_material].name> != <[old_material].name> && <player.gamemode.equals[survival]>:
        - take item:<[new_material].name>
        - drop <[old_material].name>

    - if <[new_material]> !matches air:
      - playeffect effect:block_dust at:<[location].center> special_data:<[new_material]> offset:0.25 quantity:50 visibility:100
    - else:
      - playeffect effect:block_dust at:<[location].center> special_data:<[old_material]> offset:0.25 quantity:50 visibility:100
      #- flag <[location]> behr.essentials.bedit.history.<[time]>:<[old_material]> expire:1d
    - if <[location].material.supports[waterlogged]> && <[location].material.waterlogged> && !<[new_material].name.contains_text[waterlogged=]> && <[new_material].supports[waterlogged]>:
      - define new_material <[new_material].with_map[waterlogged=true]>
    - flag player behr.essentials.bedit.undo_history.<[time]>:->:<map.with[location].as[<[location]>].with[material].as[<[old_material]>]> expire:4h
    - modifyblock <[location]> <[new_material]>
    - flag player behr.essentials.profile.stats.construction.experience:++

bedit_hide_display_entity:
  type: task
  debug: false
  script:
    - foreach left|right as:selection_point:
      - define entity <player.flag[behr.essentials.bedit.selection.<[selection_point]>.entity].if_null[null]>
      - foreach next if:!<[entity].is_truthy>
      - adjust <[entity]> material:air
      - adjust <[entity]> glowing:false

bedit_show_display_entity:
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

    #-      H _ _ _ _ _ _ G
    #-     /|           /|
    #-    / |          / |
    #- E /_ + _ _ _ _F/  |
    #-   |  |_ _ _ _ |_ _| C
    #-   | /D        |  /
    #-   |/          | /
    #-   /_ _ _ _ _ _|/
    #- A             B

    #- AB, AD, AE
    #- GH, GF, GC
    #- CB, CD
    #- EF, EH
    #- HD, FB
