bedit_undo_command:
  type: command
  debug: true
  enabled: true
  name: /undo
  usage: //undo
  description: Undoes a previous bEdit
  script:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

    # % ██ [ Check if a player has a selection they can set  ] ██:
    - inject bedit_check_for_selection

    # % ██ [ Run the command            ] ██:
    - run bedit_hide_selection_corners

    - if !<player.has_flag[behr.essentials.bedit.undo_history_events]>:
      - narrate "<&c>Nothing left to undo saved"
      - stop

    - define blocks <[cuboid].blocks>
    - define blocks <[blocks].filter[advanced_matches[bedrock].not].sort_by_value[distance[<player.eye_location>]]>
    - define old_time <player.flag[behr.essentials.bedit.undo_history_events].highest>
    - define new_time <util.time_now.epoch_millis>
    - run bedit_hide_selection_corners
    - foreach <player.flag[behr.essentials.bedit.undo_history.<[old_time]>]> as:data:
      - flag player behr.essentials.bedit.redo_history.<[new_time]>.material:<[data.location].material> expire:1d
      - flag player behr.essentials.bedit.redo_history.<[new_time]>.location:<[data.location]> expire:1d

      - define old_material <[data.location].material>
      - foreach next if:<[data.material].equals[<[old_material]>]>
      - if <player.gamemode> == survival && !<player.inventory.contains_item[<[data.material].name>]> && <[data.material]> !matches air:
        - foreach stop

      - define sound <[data.location].material.block_sound_data>
      - if <[data.material]> matches air && <[old_material]> !matches air:
        - give <[data.location].material.item> to:<player.inventory> if:<player.gamemode.equals[survival]>
        - playsound <[data.location]> sound:<[sound.break_sound]> volume:<[sound.volume].add[1]> pitch:<[sound.pitch]>

      - else:
        - playsound <[data.location]> sound:<[sound.place_sound]> volume:<[sound.volume].add[1]> pitch:<[sound.pitch]>
        - if <[data.material].name> != <[old_material].name> && <player.gamemode.equals[survival]>:
          - take item:<[data.material].name>
          - drop <[old_material].name>

      - if <[data.material]> !matches air:
        - playeffect at:<[data.location].center> effect:block_dust special_data:<[data.material]> offset:0.25 quantity:50 visibility:100
      - else:
        - playeffect at:<[data.location].center> effect:block_dust special_data:<[old_material]> offset:0.25 quantity:50 visibility:100
        #- flag <[data.location]> behr.essentials.bedit.history.<[time]>:<[old_material]> expire:1d
      - flag player behr.essentials.bedit.undo_history.<[old_time]>:<-:<map.with[data.location].as[<[data.location]>].with[material].as[<[old_material]>]> expire:4h
      - if <[data.location].material.supports[waterlogged]> && <[data.location].material.waterlogged> && !<[data.material].name.contains_text[waterlogged=]> && <[data.material].supports[waterlogged]>:
        - define data.material <[data.material].with_map[waterlogged=true]>

      - modifyblock <[data.location]> <[data.material]>
      - flag player behr.essentials.profile.stats.construction.experience:++
      - wait 1t

    - flag player behr.essentials.bedit.undo_history_events:<-:<[old_time]> expire:4h
    - inject check_for_levelup
    - inject bedit_refresh_selection_corners
