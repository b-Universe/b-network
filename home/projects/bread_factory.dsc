bread_factory_command:
  type: command
  debug: true
  name: bread_factory
  usage: /bread_factory
  description: Opens the bread factory menus
  aliases:
    - bf
  script:
    - if !<context.args.is_empty>:
      - narrate "<&c>Just use <&6>/<&e>bread<&6>_<&e>factory<&c> or <&6>/<&e>bf"
      - stop
    - if <player.has_flag[bread_factory]>:
      - inventory open d:bread_factory_menu
    - else:
      - inventory open d:bread_factory_new_baker

bread_factory_new_baker:
  type: inventory
  debug: true
  inventory: hopper
  title: bread factory menu
  gui: true
  definitions:
    new: oak_planks[display_name=new factory]
    others: iron_block[display_name=other factories]
    credit: gold_block[display_name=<element[●<strikethrough><&sp.repeat[10]><reset><bold>(].color_gradient[from=#ff7200;to=#c8ff00]>  <&color[#F3FFAD]>Credit  <element[<bold>)<reset><strikethrough><&sp.repeat[10]><reset>●].color_gradient[from=#003cff;to=#ff0015]>;lore=<&color[#C1F2F7]>A special thanks to all of the|<&color[#C1F2F7]>contributors for this project!]
  slots:
    - [] [new] [others] [credit] []

bread_factory_menu:
  type: inventory
  debug: true
  inventory: chest
  title: bread factory menu
  gui: true
  definitions:
    factory: oak_planks
    others: iron_block
    workshop: emerald_block
    credit: gold_block
  slots:
    - [] [factory] [] [others] [] [workshop] [] [credit] []


bread_factory_template:
  type: inventory
  debug: true
  inventory: chest
  size: 54
  title: <script.parsed_key[data.lines].unseparated>
  gui: true
  definitions:
    ground: black_stained_glass_pane[custom_model_data=4]
    left: black_stained_glass_pane[custom_model_data=5]
    right: black_stained_glass_pane[custom_model_data=6]
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [left] [right] [] [] []
    - [] [] [] [] [ground] [] [] [] []
    - [] [] [] [] [] [] [] [] []
  data:
    lines:
      - <proc[negative_spacing].context[8].font[utility:spacing]>
      - <&f><&chr[0004].font[gui]>
      #new
      - <proc[negative_spacing].context[208].font[utility:spacing]>
      - <&f><&chr[0005].font[gui]>


bread_handlers:
  type: world
  debug: true
  events:
    after player clicks in bread_factory_new_baker:
      - choose <context.slot>:
        - case 2:
          - if !<player.has_flag[bread_factory]>:
            - define inventory "<inventory[bread_factory_template].with[title=<player.name>'s bread factory]>"
            - note <player.uuid>_bread_factory as:<[inventory]>
          - inventory open d:<player.uuid>_bread_factory
        - case 3:
          - inventory open d:top_factories_and_friends_factories
        - case 4:
          - inject generate_bread_contributors_inventory
          - inventory open d:bread_contributors

    after player clicks in bread_factory_menu:
      - choose <context.slot>:
        - case 2:
          - inventory open d:<player.uuid>_bread_factory
        - case 4:
          - inventory open d:top_factories_and_friends_factories
        - case 6:
          - inventory open d:bread_workshop
        - case 8:
          - inject generate_bread_contributors_inventory
          - inventory open d:bread_contributors


contributor_info_item:
  type: item
  debug: false
  material: gold_block
  display name: <&color[#F3FFAD]>Contributor List
  lore:
    - <&color[#C1F2F7]>This is a completed list of
    - <&color[#C1F2F7]>contributors to this project

generate_bread_contributors_inventory:
  type: task
  script:
    - if !<server.has_flag[behr.bread_factory.contributors]>:
      - flag server "behr.bread_factory.contributors.<server.match_player[_behr]>:->:<&color[#F3FFAD]>● <&color[#F3FFAD]>Primary project coordinator"

    - if !<inventory[bread_contributors].exists> || <server.flag[behr.bread_factory.contributor_last_update].if_null[<util.time_now.sub[29d]>].is_after[<server.flag[behr.bread_factory.contributor_last_update_cache].if_null[<util.time_now.sub[30d]>]>]>:
      - define row_1 <item[air].repeat_as_list[8].insert[<item[contributor_info_item]>].at[5]>

      # create heads for the contributors
      - define contributors <list>
      - foreach <server.flag[behr.bread_factory.contributors]> key:player as:contributions:
        - define display_name "<element[●<strikethrough><&sp.repeat[10]><reset><bold>(].color_gradient[from=#ff7200;to=#c8ff00]>  <&color[#F3FFAD]><[player].name>  <element[<bold>)<reset><strikethrough><&sp.repeat[10]><reset>●].color_gradient[from=#003cff;to=#ff0015]>"
        - define player_contributor <[player].skull_item.with[display_name=<[display_name]>;lore=<[contributions].parse[split_lines_by_width[200].split[<n>]].combine.parse_tag[<&color[#C1F2F7]><[parse_value]>]>]>
        - define contributors <[contributors].include_single[<[player_contributor]>]>

      - if <server.has_flag[behr.bread_factory.mystery_contributors]>:
        - foreach <server.flag[behr.bread_factory.mystery_contributors]> key:name as:data:
          - if <server.has_flag[behr.mysterious_player_heads.<[data.uuid]>]>:
            - define player_contributor <server.flag[behr.mysterious_player_heads.<[data.uuid]>]>
          - else:
            - define display_name "<element[●<strikethrough><&sp.repeat[10]><reset><bold>(].color_gradient[from=#ff7200;to=#c8ff00]>  <&color[#F3FFAD]><[name]>  <element[<bold>)<reset><strikethrough><&sp.repeat[10]><reset>●].color_gradient[from=#003cff;to=#ff0015]>"
            - define player_contributor <item[player_head].with[display=<[display_name]>;skull_skin=<[data.uuid]>]>
            - flag server behr.mysterious_player_heads.<[data.uuid]>:<[player_contributor]>
          - define player_contributor <[player_contributor].with[lore=<[data.contributions].parse[split_lines_by_width[200].split[<n>]].combine.parse_tag[<&color[#C1F2F7]><[parse_value]>]>]>
          - define contributors <[contributors].include_single[<[player_contributor]>]>

      - define contents <[row_1].include[<[contributors]>]>
      # todo: this inventory size is hard-coded and needs to be procedural, including >45 contributors
      - define inventory <inventory[generic[size=18;contents=<[contents]>]]>
      - flag server behr.bread_factory.contributor_last_update_cache:<util.time_now>
      - note <[inventory]> as:bread_contributors
