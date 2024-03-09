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
        - playeffect at:<[location].center.above[0.1]> effect:end_rod offset:0.50 quantity:10
      - else:
        - playeffect at:<[location].center.above[0.1]> effect:end_rod offset:0.25 quantity:10

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
      - playeffect at:<[location].center> effect:block_dust special_data:<[new_material]> offset:0.25 quantity:50 visibility:100
    - else:
      - playeffect at:<[location].center> effect:block_dust special_data:<[old_material]> offset:0.25 quantity:50 visibility:100
      #- flag <[location]> behr.essentials.bedit.history.<[time]>:<[old_material]> expire:1d
    - if <[location].material.supports[waterlogged]> && <[location].material.waterlogged> && !<[new_material].name.contains_text[waterlogged=]> && <[new_material].supports[waterlogged]>:
      - define new_material <[new_material].with_map[waterlogged=true]>
    - flag player behr.essentials.bedit.undo_history.<[time]>:->:<map.with[location].as[<[location]>].with[material].as[<[old_material]>]> expire:4h
    - modifyblock <[location]> <[new_material]>
    - flag player behr.essentials.profile.stats.construction.experience:++
