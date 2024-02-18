bblock:
  type: entity
  debug: false
  entity_type: block_display
  mechanisms:
    glowing: true
    translation: -0.01,-0.01,-0.01
    scale: 1.02,1.02,1.02
    brightness:
      sky: 15
      block: 15

bedit_location_format:
  type: procedure
  debug: false
  definitions: location
  script:
    - determine <&[green]>(<&[yellow]><[location].round.xyz.replace[,].with[<&[green]>, <&[yellow]>]><&[green]>)

lpos:
  type: procedure
  debug: false
  definitions: player
  script:
    - determine <player.flag[behr.essentials.bedit.left.selection].if_null[null]>
rpos:
  type: procedure
  debug: false
  definitions: player
  script:
    - determine <player.flag[behr.essentials.bedit.right.selection].if_null[null]>
bsel:
  type: procedure
  debug: false
  definitions: player
  script:
    - determine <player.flag[behr.essentials.bedit.selection.cuboid].if_null[null]>

bedit_hide_selection_corners:
  type: task
  debug: false
  script:
    #@GREEN@#- remove <player.flag[behr.essentials.bedit.cuboid.selection_entity].if_null[null]> if:<player.flag[behr.essentials.bedit.cuboid.selection_entity].is_truthy>
    - foreach left|right as:corner:
      - define location <player.flag[behr.essentials.bedit.<[corner]>.selection].if_null[null]>
      - foreach next if:!<[location].is_truthy>
      - remove <player.flag[behr.essentials.bedit.<[corner]>.selection_entity].if_null[null]> if:<player.flag[behr.essentials.bedit.<[corner]>.selection_entity].is_truthy>

bedit_refresh_selection_corners:
  type: task
  debug: false
  script:
    #@GREEN@#- remove <player.flag[behr.essentials.bedit.cuboid.selection_entity].if_null[null]> if:<player.flag[behr.essentials.bedit.cuboid.selection_entity].is_truthy>
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
      #@GREEN@#- if <[cuboid].is_truthy>:
      #@GREEN@#  - spawn bcuboid[scale=<[cuboid].size.add[<[cuboid].size.div[10]>]>] <[cuboid].center> save:selection_display
      #@GREEN@#  - define selection_display_display <entry[selection_display].spawned_entity>
      #@GREEN@#  - flag player behr.essentials.bedit.cuboid.selection_entity:<[selection_display]>



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



#@GREEN@# ---------------------------------------------------- #@GREEN@#
test_display:
  type: task
  debug: false
  script:
    - define left_location <player.flag[behr.essentials.bedit.left.selection].if_null[null]>
    - define right_location <player.flag[behr.essentials.bedit.right.selection].if_null[null]>
    - define cuboid <player.flag[behr.essentials.bedit.selection.cuboid].if_null[null]>
    - spawn bcuboid[scale=<[cuboid].size.add[<[cuboid].size.div[100]>]>] <[cuboid].center> save:block
    - wait 2s
    - remove <entry[block].spawned_entity>

bcuboid:
  type: entity
  debug: false
  entity_type: item_display
  mechanisms:
    item: selection_block
    glowing: true
    translation: -0.02,-0.02,-0.02
    brightness:
      sky: 15
      block: 15

selection_block:
  type: item
  debug: false
  material: music_disc_11
  mechanisms:
    custom_model_data: 2001
