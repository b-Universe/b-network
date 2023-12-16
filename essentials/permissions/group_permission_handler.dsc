group_permission_handler:
  type: task
  debug: false
  definitions: player|action|group
  script:
    # Manage inherited permissions
    - define player_groups <[player].flag[behr.essentials.groups].if_null[<list>]>
    - define inheritances <script[permission_data].data_key[groups.<[group]>.permissions.inherits].if_null[null]>
    - if <[inheritances].is_truthy>:
      - foreach <[inheritances].exclude[<[player_groups].include[<[group]>]>]> as:inheritance:
        - definemap data:
            player: <[player]>
            action: <[action]>
            group: <[inheritance]>
        - run group_permission_handler defmap:<[data]>

    - define permissions <script[permission_data].data_key[groups.<[group]>.permissions.commands].if_null[<list>]>
    - stop if:!<[permissions].is_truthy>
    - foreach <[permissions]> as:permission:
      - if <[action]> == grant:
        - foreach next if:<[player].has_flag[behr.essentials.permission.<[permission]>]>
        - flag <[player]> behr.essentials.permission.<[permission]>
        - announce to_console "<&e><[player].name> <&b>permission<&3><&co><&a>+<&3><&co><&e><[permission]>"
      - else:
        - foreach next if:!<[player].has_flag[behr.essentials.permission.<[permission]>]>
        - flag <[player]> behr.essentials.permission.<[permission]>:!
        - announce to_console "<&e><[player].name> <&b>permission<&3><&co><&c>-<&3><&co><&e><[permission]>"

    - adjust server save
    - wait 1s
    - reload
