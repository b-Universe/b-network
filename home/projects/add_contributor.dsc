add_contributor_command:
  type: command
  debug: true
  name: add_contributor
  usage: /add_contributor <&lt>player<&gt> <&lt>project<&gt> <&lt>contributions<&gt>
  description: Adds contributors or contributions for a contributor
  permission: behr.essentials.contributor_coordinator
  tab completions:
    1: username
    2: <server.flag[behr.projects].keys.if_null[<list>]>
    3: contributions
  script:
    - if <context.args.is_empty>:
      - narrate "<&c>No player or notes used"
      - stop

    - if <context.args.size> == 1:
      - narrate "<&c>Need to provide a player and contribution notes"
      - stop

    - define projects <server.flag[behr.projects]>
    - define project <context.args.get[2]>
    - if <context.args.size> == 2:
      - narrate "<&c>Need to provide a project and contribution notes. Active projects<&co><n><&a><[projects].keys.separated_by[<&e>, <&a>]>"
      - stop

    - if !<[projects].contains[<[project]>]>:
      - narrate "<&c><[project]> is not a valid project. Active projects<&co><n><&a><[projects].keys.separated_by[<&e>, <&a>]>"
      - stop

    - define player <server.match_offline_player[<context.args.first>].if_null[null]>
    - define contributions "<context.raw_args.after[<[project]> ]>"
    - if !<[player].is_truthy>:
      - if <[player].length> > 16:
        - if !<server.has_flag[behr.back_data.wait_for_player.<[project]>.contributor.<[player]>]>:
          - flag server behr.back_data.wait_for_player.<[project]>.contributor:<[player]>
      - else:
        - define name <context.args.first>
        - inject mojang_player_referencing
        - flag server behr.back_data.wait_for_player:<[uuid]>

      - flag server "behr.back_data.wait_for_player.<[project]>.contributor.<[uuid]>.contributions:->:<&color[#F3FFAD]>● <&color[#C1F2F7]><[contributions]>"
      - flag server behr.<[project]>.mystery_contributors.<[name]>.uuid:<[uuid]>
      - flag server "behr.<[project]>.mystery_contributors.<[name]>.contributions:->:<&color[#F3FFAD]>● <&color[#C1F2F7]><[contributions]>"

    - else:
      - define name <[player].name>
      - flag server behr.<[project]>.contributors:<[player]>
      - flag server "behr.<[project]>.contributors.<[player]>:->:<&color[#F3FFAD]>● <&color[#C1F2F7]><[contributions]>"

    - narrate "<&a>Added <&e><[name]> <&a>as a contributor to <&e><[project]> <&a>with contributions<&co><n><&e><[contributions]>"
    - flag server behr.<[project]>.contributor_last_update:<util.time_now>
