bwand:
  type: item
  debug: false
  material: blaze_rod
  display name: <&[fancy_title]>bEdit Wand
  mechanisms:
    custom_model_data: 1
  lore:
    - <&[fancy_green_1]>Mode<&co> <&[fancy_yellow_1]>Selection
    - <&[fancy_green_2]>Left click<&co> <&[fancy_yellow_1]>Position 1
    - <&[fancy_green_3]>Right click<&co> <&[fancy_yellow_1]>Position 2
    #- <&[fancy_green_2]>Left/Right click<&co> <&[fancy_yellow_2]>Creates selections
    #- <&[fancy_green_3]>Selection type<&co> <&[fancy_yellow_3]>Cuboid

obtain_bwand:
  type: command
  debug: false
  name: /bwand
  usage: //bwand (player)
  description: Gives the bWand
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
    - if <context.args.size> > 1:
      - inject command_syntax_error

    - if <context.args.is_empty>:
      - define player <player>
    - else:
      - define player_name <context.args.first>
      - inject command_player_verification
      - narrate "<&[yellow]><[player_name]> <&[green]>obtained the bWand!"
    - narrate "<&[green]>You've obtained the bWand!" targets:<[player]>
    - playsound <[player]> entity_player_levelup pitch:<util.random.int[8].to[12].div[10]> volume:0.3
    #- flag <[player]> behr.essentials.bedit.settings.wand_mode:cuboid_selection
    - give to:<[player].inventory> bwand

bwand_format_data:
  type: data
  mode:
    cuboid_selection:
      lore:
        - <&[fancy_green_1]>Mode<&co> <&[fancy_yellow_1]>Selection
        - <&[fancy_green_2]>Left/Right click<&co> <&[fancy_yellow_2]>Creates selections
        - <&[fancy_green_3]>Selection type<&co> <&[fancy_yellow_3]>Cuboid
    schematic_paste:
      lore:
        - <&[fancy_green_1]>Mode<&co> <&[fancy_yellow_1]>Schematic Paste
        - <&[fancy_green_2]>Left click<&co> <&[fancy_yellow_2]>Places a schematic
        - <&[fancy_green_3]>Right click<&co> <&[fancy_yellow_3]>Toggles schematic preview
        - <&[fancy_green_4]>Scrolling<&co> <&[fancy_yellow_4]>Cycles through schematics if
        - <&[fancy_yellow_5]>using categories or sections

bedit_wand_handler:
  type: world
  debug: false
  events:
  # Cancel the achievement if they don't already have it:
    on player granted advancement criterion advancement:nether/obtain_blaze_rod:
      - determine cancelled if:!<player.inventory.list_contents.filter[advanced_matches[!bwand]].parse[material.name].contains[blaze_rod]>

  # Remove selections when changing worlds:
    on player changes world flagged:behr.essentials.bedit.selection:
      - if <player.has_flag[behr.essentials.bedit.selection.cuboid]>:
          - narrate "<&[green]>all selections cleared"
      - else <player.has_flag[behr.essentials.bedit.selection.right_selection]>:
        - narrate "<&[green]>right selection cleared"
      - else:
        - narrate "<&[green]>left selection cleared"
      - flag <player> behr.essentials.bedit.selection:!

  # Remove selections when logging out:
    on player quits flagged:behr.essentials.bedit.selection:
      - foreach left|right as:position:
        - define entity <player.flag[behr.essentials.bedit.selection.<[position]>.entity].if_null[null]>
        - remove <[entity]> if:<[entity].is_truthy>
      - flag <player> behr.essentials.bedit.selection:!

  # Handle selections with the bWand:
    on player clicks block with:bwand:
      - determine passively cancelled
    # Create basic definitions:
      - define location <context.location.if_null[<player.cursor_on[100].if_null[<player.location.forward[20]>].round>]>
      - define color <[location].map_color>
      - if <context.click_type.contains_any_text[left]>:
        - define position left
      - else:
        - define position right

    # Check if it's a cancellation
      - if <player.flag[behr.essentials.bedit.selection.<[position]>.location].xyz.if_null[null]> == <[location].xyz>:
        - inject bedit_clear_selections
        - stop

      - inject bedit_set_position

dense_cuboid_particle:
  type: task
  debug: false
  definitions: cuboid
  script:
    - define locations <list>

    - definemap min:
        x: <[cuboid].min.x>
        y: <[cuboid].min.y>
        z: <[cuboid].min.z>
    - definemap max:
        x: <[cuboid].max.x>
        y: <[cuboid].max.y>
        z: <[cuboid].max.z>

    - define location_1 <[cuboid].min>
    - define location_2 <[cuboid].min.with_x[<[max.x]>]>
    - define location_3 <[cuboid].min.with_y[<[max.y]>]>
    - define location_4 <[cuboid].min.with_z[<[max.z]>]>
    - define locations <[locations].include[<[location_1].points_between[<[location_2]>].distance[.2]>]>
    - define locations <[locations].include[<[location_1].points_between[<[location_3]>].distance[.2]>]>
    - define locations <[locations].include[<[location_1].points_between[<[location_4]>].distance[.2]>]>

    - define location_1 <[cuboid].max>
    - define location_2 <[cuboid].max.with_x[<[min.x]>]>
    - define location_3 <[cuboid].max.with_y[<[min.y]>]>
    - define location_4 <[cuboid].max.with_z[<[min.z]>]>
    - define locations <[locations].include[<[location_1].points_between[<[location_2]>].distance[.2]>]>
    - define locations <[locations].include[<[location_1].points_between[<[location_3]>].distance[.2]>]>
    - define locations <[locations].include[<[location_1].points_between[<[location_4]>].distance[.2]>]>

    - define location_1 <[cuboid].max.with_x[<[min.x]>]>
    - define location_2 <[cuboid].max.with_x[<[min.x]>].with_z[<[min.z]>]>
    - define location_3 <[cuboid].max.with_y[<[min.y]>].with_x[<[min.x]>]>
    - define locations <[locations].include[<[location_1].points_between[<[location_2]>].distance[.2]>]>
    - define locations <[locations].include[<[location_1].points_between[<[location_3]>].distance[.2]>]>
    #- playeffect effect:barrier at:<[location_2].center> offset:0.1 quantity:5

    - define location_1 <[cuboid].min.with_x[<[max.x]>].with_z[<[min.z]>]>
    - define location_2 <[location_1].with_z[<[max.z]>]>
    - define location_3 <[cuboid].max.with_z[<[min.z]>]>
    - define location_4 <[cuboid].min.with_z[<[max.z]>]>
    - define location_5 <[cuboid].max.with_x[<[min.x]>].with_z[<[min.z]>]>
    - define locations <[locations].include[<[location_1].points_between[<[location_2]>].distance[.2]>]>
    - define locations <[locations].include[<[location_1].points_between[<[location_3]>].distance[.2]>]>
    - define locations <[locations].include[<[location_2].points_between[<[location_4]>].distance[.2]>]>
    - define locations <[locations].include[<[location_3].points_between[<[location_5]>].distance[.2]>]>
    #- playeffect effect:barrier at:<[location_3].center> offset:0.1 quantity:5

    #- define location_1 <[cuboid].min.with_x[<[max.x]>].with_y[<[max.y]>]>
    #- define location_2 <[cuboid].min.with_y[<[max.y]>]>
    #- define locations <[locations].include[<[location_1].points_between[<[location_2]>].distance[.2]>]>

    - playeffect effect:flame at:<[locations].parse[add[0.5,0.5,0.5]]> offset:0

bedit_selection_block:
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
    - determine <&a>(<&e><[location].round.xyz.replace[,].with[<&a>, <&e>]><&a>)
