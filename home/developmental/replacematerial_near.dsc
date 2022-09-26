replace_material_near:
  type: command
  debug: false
  name: replace_material_near
  usage: /replace_material_near <&lt>material_type<&gt> <&lt>old_material<&gt> <&gt>new_material<&lt>
  description: replaces material inteligently
  tab complete:
    - define material_types <list[stairs|slab|wall|pane]>
    - if <context.args.is_empty>:
      - determine <[material_types]>

    - define arg_count <context.args.size>
    - if "<context.raw_args.ends_with[ ]>":
      - define arg_count:++

    - if <[arg_count]> == 1:
      - determine <[material_types].filter[starts_with[<context.args.first>]]>

    - else if <[arg_count]> == 2:
      - foreach stairs|slab|wall|pane as:material_type:
        - if <context.args.first.contains_any_text[<[material_type]>]>:
          - determine <server.material_types.filter[name.contains_any_text[<[material_type]>]].parse[name.before[_<[material_type]>]].include[item_on_cursor]>

    - else if <[arg_count]> == 3:
      - foreach stairs|slab|wall|pane as:material_type:
        - if <context.args.first.contains_any_text[<[material_type]>]>:
          - determine <server.material_types.filter[name.contains_any_text[<[material_type]>]].parse[name.before[_<[material_type]>]].include[item_in_hand]>

  script:
    - define material_type <context.args.first>

    - if <context.args.get[2]> == item_on_cursor:
      - if !<player.cursor_on.is_truthy>:
        - narrate "<&c>There is nothing on your cursor"
        - stop
      - define old_material <player.cursor_on.material.name.before_last[_]>
    - else:
      - define old_material <context.args.get[2]>

    - if <context.args.last> == item_in_hand:
      - if !<player.item_in_hand.is_truthy>:
        - narrate "<&c>There is nothing in your hand"
        - stop
      - if !<player.item_in_hand.material.is_block>:
        - narrate "<&c>That isn't a block you can place"
        - stop
      - define new_material <player.item_in_hand.material.name.before_last[_]>
    - else:
      - define new_material <context.args.last>

    - choose <[material_type]>:
      - case stairs:
        - foreach <[old_material]>|<[new_material]> as:material:
          - if !<material[<[material]>_stairs].is_truthy>:
            - narrate "<&c><[material]>_stairs is an invalid material"
            - stop
        - foreach north|east|south|west as:direction:
          - foreach top|bottom as:half:
            - foreach inner_left|inner_right|outer_left|outer_right|straight as:shape:
              - define mechanisms <&lb>facing=<[direction]>,half=<[half]>,shape=<[shape]><&rb>
              - execute as_player "/replace <[old_material]>_stairs<[mechanisms]> <[new_material]>_stairs<[mechanisms]>"

      - case slab:
        - foreach <[old_material]>|<[new_material]> as:material:
          - if !<material[<[material]>_slab].is_truthy>:
            - narrate "<&c><[material]>_slab is an invalid material"
            - stop
        - foreach top|bottom|double as:type:
          - define mechanisms <&lb>type=<[type]><&rb>
          - execute as_player "/replace <[old_material]>_slab<[mechanisms]> <[new_material]>_slab<[mechanisms]>"

      - case wall:
        - foreach <[old_material]>|<[new_material]> as:material:
          - if !<material[<[material]>_wall].is_truthy>:
            - narrate "<&c><[material]>_wall is an invalid material"
            - stop

        - foreach low|tall|none as:type_1:
          - foreach low|tall|none as:type_2:
            - foreach low|tall|none as:type_3:
              - foreach low|tall|none as:type_4:
                - foreach true|false as:up:
                  - define mechanisms <&lb>north=<[type_1]>,south=<[type_2]>,east=<[type_3]>,west=<[type_4]>,up=<[up]><&rb>
                  - execute as_player "/replace <[old_material]>_wall<[mechanisms]> <[new_material]>_wall<[mechanisms]>"

      - case pane:
        - foreach <[old_material]>|<[new_material]> as:material:
          - if !<material[<[material]>_pane].is_truthy>:
            - narrate "<&c><[material]>_pane is an invalid material"
            - stop
        - foreach true|false as:direction_1_boolean:
          - foreach true|false as:direction_2_boolean:
            - foreach true|false as:direction_3_boolean:
              - foreach true|false as:direction_4_boolean:
                - define mechanisms <&lb>north=<[direction_1_boolean]>,east=<[direction_2_boolean]>,south=<[direction_3_boolean]>,west=<[direction_4_boolean]><&rb>
                - execute as_player "/replace <[old_material]>_pane<[mechanisms]> <[new_material]>_pane<[mechanisms]>"
