bedit_pos1_command:
  type: command
  debug: false
  enabled: true
  name: /pos1
  usage: //pos1
  description: Manual selectors for positions
  tab complete:
    - inject pos_task.tab_complete
  script:
    - define click_type left
    - inject pos_task

bedit_pos2_command:
  type: command
  debug: false
  enabled: true
  name: /pos2
  usage: //pos2
  description: Manual selectors for positions
  tab complete:
    - inject pos_task.tab_complete
  tab completions:
    1: north|northeast|east|southeast|south|southwest|west|northwest|up|down|left|right|forward|backward|cursor_on|clear|move
    2: north|northeast|east|southeast|south|southwest|west|northwest|up|down|left|right|forward|backward
    3: north|northeast|east|southeast|south|southwest|west|northwest|up|down|left|right|forward|backward
  script:
    - define click_type right
    - inject pos_task

pos_task:
  type: task
  debug: false
  tab_complete:
    - define directions <list[north|northeast|east|southeast|south|southwest|west|northwest|up|down|left|right|forward|backward]>
    - define commands <[directions].include[cursor_on|clear|move]>
    - determine <[commands]> if:<context.args.is_empty>

    - define arg_count <context.args.size>
    - if <context.raw_args.ends_with[ ]>:
      - define arg_count:++

    - if <[arg_count]> == 1:
      - determine <[commands].filter[starts_with[<context.args.first>]]>

    - else if <[arg_count]> == 2 && ( <context.args.first.advanced_matches[move]> || <context.args.first.is_integer> ):
      - determine <[directions].filter[starts_with[<context.args.last.if_null[<empty>]>]]>

    - else if <[arg_count]> == 3 && <context.args.first.advanced_matches[move]>:
      - determine <[directions].filter[starts_with[<context.args.last.if_null[<empty>]>]]>
  data:
    direction:
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
      left: <location[0,0,0].with_pose[<player>].left>
      right: <location[0,0,0].with_pose[<player>].right>
      forward: <location[0,0,0].with_pose[<player>].forward_flat>
      back: <location[0,0,0].with_pose[<player>].backward_flat>
  script:

    - if <player.location.is_within[biome_mine]> || <player.location.is_within[galactic_federation_of_b]>:
      - narrate "<&[red]>This can't be used here"
      - stop

    # % ██ [ define location                       ] ██:
    - choose <context.args.size>:
      # //pos:
      - case 0:
        - define location <player.location.with_pose[0,0].round_down>

      - case 1:
        - choose <context.args.first>:
          # //pos clear:
          - case clear:
            - if <player.has_flag[behr.essentials.bedit.<[click_type]>.selection]>:
              - flag <player> behr.essentials.bedit.<[click_type]>.selection:!
              - flag <player> behr.essentials.bedit.selection.cuboid:!
              - narrate "<&e><[click_type].to_titlecase> <&a>selection cleared"
            - else:
              - narrate "<&e><[click_type].to_titlecase> <&c>selection is not set"

          # //pos cursor_on:
          - case cursor_on:
            - define location <player.cursor_on>

          # //pos direction:
          - case north northeast east southeast south southwest west northwest up down left right forward back:
            - define direction <script.parsed_key[data.direction.<context.args.first>].as[location]>
            - define location <player.location.add[<[direction]>]>

          - default:
            - inject command_syntax_error

      # //pos # direction:
      # //pos direction #:
      # //pos move direction:
      - case 2:
        - if <context.args.first> == move:
          - define length 1
          - if <context.args.first> in <script.parsed_key[data.direction]>:
            - define direction <script.parsed_key[data.direction.<context.args.last>].as[location]>
            - define location <[click_type].proc[pos].add[<[direction]>]>
          - else:
            - inject command_syntax_error

        - else if <context.args.first.is_integer>:
          - define length <context.args.first>
          - if <context.args.last> in <script.parsed_key[data.direction]>:
            - define direction <script.parsed_key[data.direction.<context.args.last>].as[location]>
            - define direction <[direction].mul[<[length]>]>
            - define location <player.location.add[<[direction]>]>
          - else:
            - inject command_syntax_error

        - else if <context.args.first> in <script.parsed_key[data.direction]>:
          - define direction <script.parsed_key[data.direction.<context.args.first>].as[location]>
          - if <context.args.last.is_integer>:
            - define length <context.args.last>
            - define direction <[direction].mul[<[length]>]>
            - define location <player.location.add[<[direction]>]>
          - else:
            - inject command_syntax_error

        - else:
          - inject command_syntax_error

      # //pos move direction #
      # //pos move # direction
      - case 3:
        - if <context.args.first> == move:
          - define base_location <proc[lpos]>
          - if !<[base_location].is_truthy>:
            - narrate "<&e><[click_type].to_titlecase> <&c>not set"
            - stop

          - if <context.args.get[2].is_integer>:
            - define length <context.args.get[2]>
            - if <context.args.last> in <script.parsed_key[data.direction]>:
              - define direction <script.parsed_key[data.direction.<context.args.last>].as[location]>
              - define direction <[direction].mul[<[length]>]>
              - define location <[base_location].add[<[direction]>]>
            - else:
              - inject command_syntax_error

          - else if <context.args.get[2]> in <script.parsed_key[data.direction]>:
            - define direction <script.parsed_key[data.direction.<context.args.get[2]>].as[location]>
            - if <context.args.last.is_integer>:
              - define length <context.args.last>
              - define direction <[direction].mul[<[length]>]>
              - define location <[base_location].add[<[direction]>]>
            - else:
              - inject command_syntax_error

        - else:
          - inject command_syntax_error

      - default:
        - inject command_syntax_error

    - define location <[location].with_pose[0,0]>

    # % ██ [ define color and sounds               ] ██:
    - if <[location]> matches air:
      - define color <color[white]>
    - else:
      - define color <[location].map_color>

    - playsound <player> block_amethyst_cluster_place pitch:<util.random.int[7].to[10].div[10]> volume:2

    # % ██ [ display selection entity              ] ██:
    - if <player.flag[behr.essentials.bedit.<[click_type]>.selection_entity].is_truthy>:
      - adjust <player.flag[behr.essentials.bedit.<[click_type]>.selection_entity]> interpolation_duration:5t
      - adjust <player.flag[behr.essentials.bedit.<[click_type]>.selection_entity]> scale:0,0,0
      - wait 5t
      - remove <player.flag[behr.essentials.bedit.<[click_type]>.selection_entity].if_null[null]>
    - spawn bblock[material=glass;glow_color=<[color]>] <[location]> save:block_display
    - define block_display <entry[block_display].spawned_entity>
    - flag player behr.essentials.bedit.<[click_type]>.selection_entity:<[block_display]>
    - flag player behr.essentials.bedit.<[click_type]>.quick_release expire:10s

    - if <[location].material.is_occluding>:
      - playeffect effect:end_rod at:<[location].center.above[0.1]> offset:0.50 quantity:10
    - else:
      - playeffect effect:end_rod at:<[location].center.above[0.1]> offset:0.25 quantity:10

    # % ██ [ manage flag data and display message  ] ██
      - flag <[location]> behr.essentials.bedit expire:1d
      - flag player behr.essentials.bedit.<[click_type]>.selection:<[location]>
      - define left_selection <proc[lpos]>
      - define right_selection <proc[rpos]>
      - if <[left_selection].is_truthy> && <[right_selection].is_truthy>:
        - flag player behr.essentials.bedit.selection.cuboid:<[left_selection].to_cuboid[<[right_selection]>]>
        - define cuboid <player.flag[behr.essentials.bedit.selection.cuboid]>
        - actionbar "<&[green]><[click_type]> selecton<&co> <[location].proc[bedit_location_format]> <[cuboid].size.proc[bedit_location_format]>"
      - else:
        - actionbar "<&[green]><[click_type]> selecton<&co> <[location].proc[bedit_location_format]>"
