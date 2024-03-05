bedit_center_command:
  type: command
  debug: false
  enabled: true
  name: /center
  usage: //center
  description: Changes the material at the center of the selection
  script:
    # % ██ [ Check if a player has a selection they can set ] ██:
    - inject bedit_check_for_selection

    - if <context.args.is_empty>:
      - inject command_syntax_error

    # % ██ [ Check material             ] ██:
    - define new_material_name <context.args.first>
    - define new_material <material[<[new_material_name]>]>
    - if !<material[<[new_material_name]>].exists>:
      - define reason "<[new_material_name]> is an invalid material."
      - inject command_error

    # % ██ [ Add base definitions       ] ██:
    - define sound <[new_material].block_sound_data>
    - define time <util.time_now.epoch_millis>
    - define blocks <[cuboid].blocks>
    - if <[new_material_name]> == air:
      - define blocks <[blocks].filter[advanced_matches[!air]]>
    - define center <[cuboid].center>

    - flag player behr.essentials.bedit.undo_history_events:->:<[time]> expire:4h
    - foreach <[center].sub[0.4,0.4,0.4].to_cuboid[<[center].add[0.4,0.4,0.4]>].blocks> as:location:
      - run bedit_place_block def:<list_single[<[new_material]>].include[<[location]>|<[time]>]>
      - wait 1t
