bwand:
  type: item
  debug: false
  material: wooden_sword
  display name: <&[fancy_title]>bWand ● Master Building Tool
  lore:
    - <&[fancy_green_1]>Left click<&co> <&[fancy_yellow_1]>Position 1
    - <&[fancy_green_2]>Right click<&co> <&[fancy_yellow_2]>Position 2
  mechanisms:
    custom_model_data: 1000
    hides: all
  recipes:
    1:
      type: shaped
      input:
        - molten_gold_block|molten_redstone_block|molten_gold_block
        - molten_gold_block|perfect_emerald|molten_gold_block
        - iron_block|fortified_blaze_rod|iron_block

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
      - playsound <player> entity_player_levelup pitch:<util.random.int[8].to[12].div[10]> volume:0.3

    - narrate "<&[green]>You've obtained the bWand!" targets:<[player]>
    - playsound <[player]> entity_player_levelup pitch:<util.random.int[8].to[12].div[10]> volume:0.3
    - give bwand to:<[player].inventory>

bedit_wand_handler:
  type: world
  debug: true
  events:
    after player quits:
      - foreach left|right as:corner:
        - flag <player> behr.essentials.bedit.<[corner]>.selection:!
        - remove <player.flag[behr.essentials.bedit.<[corner]>.selection_entity].if_null[null]> if:<player.flag[behr.essentials.bedit.<[corner]>.selection_entity].is_truthy>
      - flag <player> behr.essentials.bedit.selection.cuboid:!

    after player breaks block location_flagged:behr.essentials.bedit:
      - remove <context.location.to_cuboid[<context.location>].entities[display_entity]>
      - if <context.location> == <player.proc[lpos]>:
        - remove <player.flag[behr.essentials.bedit.left.selection_entity].if_null[null]> if:<player.flag[behr.essentials.bedit.left.selection_entity].is_truthy>
        - spawn bblock[material=glass;glow_color=white] <player.proc[lpos]> save:block_display
        - define block_display <entry[block_display].spawned_entity>
        - flag player behr.essentials.bedit.left.selection_entity:<[block_display]>
      - if <context.location> == <player.proc[rpos]>:
        - remove <player.flag[behr.essentials.bedit.right.selection_entity].if_null[null]> if:<player.flag[behr.essentials.bedit.right.selection_entity].is_truthy>
        - spawn bblock[material=glass;glow_color=white] <player.proc[rpos]> save:block_display
        - define block_display <entry[block_display].spawned_entity>
        - flag player behr.essentials.bedit.right.selection_entity:<[block_display]>

    after player places block location_flagged:behr.essentials.bedit:
      - remove <context.location.to_cuboid[<context.location>].entities[display_entity]>
      - if <context.location> == <player.proc[lpos]>:
        - remove <player.flag[behr.essentials.bedit.left.selection_entity].if_null[null]> if:<player.flag[behr.essentials.bedit.left.selection_entity].is_truthy>
        - spawn bblock[material=<context.location.material.name>;glow_color=<context.location.map_color>] <player.proc[lpos]> save:block_display
        - define block_display <entry[block_display].spawned_entity>
        - flag player behr.essentials.bedit.left.selection_entity:<[block_display]>
      - if <context.location> == <player.proc[rpos]>:
        - remove <player.flag[behr.essentials.bedit.right.selection_entity].if_null[null]> if:<player.flag[behr.essentials.bedit.right.selection_entity].is_truthy>
        - spawn bblock[material=<context.location.material.name>;glow_color=<context.location.map_color>] <player.proc[rpos]> save:block_display
        - define block_display <entry[block_display].spawned_entity>
        - flag player behr.essentials.bedit.right.selection_entity:<[block_display]>

    on player clicks block with:bwand:
      - determine passively cancelled

    # % ██ [ Define side and color                 ] ██:
      - define location <context.location.if_null[<player.cursor_on[100].if_null[<player.location.forward[20].round>]>]>
      # behr.essentials.settings.bedit.selection.right.color
      - if <context.click_type.contains_any_text[left]>:
        - define click_type Left
      - else:
        - define click_type Right

    # % ██ [ Check for structure_block             ] ██:
      - if <[location]> matches structure_block:
        - define cuboid <player.flag[behr.essentials.bedit.selection.cuboid].if_null[null]>
        - if <[cuboid].is_truthy>:
          - if  <[cuboid].min.distance[<[location]>]> > 47:
            - actionbar "<&c>Distance from structure min point exceeds 48"
            - stop
          - definemap structure_data:
              box_position: <[cuboid].min.sub[<[location]>]>
              size: <[cuboid].size>
          - adjust <[location]> structure_block_data:<[structure_data]>
        - stop

      - define color <[location].map_color>
      - playsound <[location]> block_amethyst_cluster_place pitch:<util.random.int[7].to[10].div[10]> volume:2
      - remove <player.flag[behr.essentials.bedit.<[click_type]>.selection_entity].if_null[null]> if:<player.flag[behr.essentials.bedit.<[click_type]>.selection_entity].is_truthy>
      #@GREEN@#- remove <player.flag[behr.essentials.bedit.cuboid.selection_entity].if_null[null]> if:<player.flag[behr.essentials.bedit.cuboid.selection_entity].is_truthy>

    # % ██ [ Check for rapid release               ] ██:
      - if <player.has_flag[behr.essentials.bedit.<[click_type]>.selection]> && <[location]> == <player.flag[behr.essentials.bedit.<[click_type]>.selection]> && <player.has_flag[behr.essentials.bedit.<[click_type]>.quick_release]>:
        - define offhand_click <list[left|right].exclude[<[click_type]>].first>
        #@GREEN@#- remove <player.flag[behr.essentials.bedit.cuboid.selection_entity].if_null[null]> if:<player.flag[behr.essentials.bedit.cuboid.selection_entity].is_truthy>
        - remove <player.flag[behr.essentials.bedit.<[offhand_click]>.selection_entity].if_null[null]> if:<player.flag[behr.essentials.bedit.<[offhand_click]>.selection_entity].is_truthy>
        - playsound <[location]> block_amethyst_cluster_place pitch:<util.random.int[7].to[10].div[10]> volume:2
        - flag player behr.essentials.bedit.<[click_type]>.selection:!
        - flag player behr.essentials.bedit.<[click_type]>.selection_entity:!
        - flag player behr.essentials.bedit.<[click_type]>.quick_release:!
        #@GREEN@#- flag player behr.essentials.bedit.cuboid.selection_entity:!
        - flag player behr.essentials.bedit.selection.cuboid:!
        - actionbar "<&[green]><[click_type].to_titlecase> selecton<&co> <&[yellow]>cleared"
        - stop

    # % ██ [ Display selection entity              ] ██:
      - spawn bblock[material=<[location].material>;glow_color=<[color]>] <[location]> save:block_display
      - define block_display <entry[block_display].spawned_entity>
      - flag player behr.essentials.bedit.<[click_type]>.selection_entity:<[block_display]>
      - flag player behr.essentials.bedit.<[click_type]>.quick_release expire:10s

      - if <[location].material.is_occluding>:
        - playeffect at:<[location].center.above[0.1]> effect:end_rod offset:0.50 quantity:10
      - else:
        - playeffect at:<[location].center.above[0.1]> effect:end_rod offset:0.25 quantity:10

    # % ██ [ Manage flag data and display message  ] ██:
      - flag <[location]> behr.essentials.bedit expire:1d
      - flag player behr.essentials.bedit.<[click_type]>.selection:<[location]>
      - define left_selection <player.flag[behr.essentials.bedit.left.selection].if_null[null]>
      - define right_selection <player.flag[behr.essentials.bedit.right.selection].if_null[null]>
      - if <[left_selection].is_truthy> && <[right_selection].is_truthy>:
        - flag player behr.essentials.bedit.selection.cuboid:<[left_selection].to_cuboid[<[right_selection]>]>
        - define cuboid <player.flag[behr.essentials.bedit.selection.cuboid]>
        - actionbar "<&[green]><[click_type]> selecton<&co> <[location].proc[bedit_location_format]> <[cuboid].size.proc[bedit_location_format]>"
        #@GREEN@#- spawn bcuboid[scale=<[cuboid].size.add[<[cuboid].size.div[10]>]>] <[cuboid].center> save:selection_display
        #@GREEN@#- define selection_display_display <entry[selection_display].spawned_entity>
        #@GREEN@#- flag player behr.essentials.bedit.cuboid.selection_entity:<[selection_display_display]>
      - else:
        - actionbar "<&[green]><[click_type]> selecton<&co> <[location].proc[bedit_location_format]>"
