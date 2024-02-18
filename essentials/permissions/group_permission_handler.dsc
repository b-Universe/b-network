group_permission_handler:
  type: task
  debug: false
  definitions: player|action|group
  script:
    - if <server.has_flag[behr.developmental.debug]>:
      - announce to_console "<&e><[player].name> Permissions<&3><&co>"

    - flag <[player]> behr.essentials.groups:<-:<[group]>
    - if <[action]> ==  grant:
      - announce to_console <&b>Group<&3><&co><&a>+<&3><&co><[group]>
      - flag <[player]> behr.essentials.groups:->:<[group]>
    - else:
      - announce to_console <&b>Group<&3><&co><&c>-<&3><&co><[group]>

    - foreach <script[permission_data].parsed_key[groups.<[group]>.permissions.commands].if_null[<list>]> as:command:
      - if <[action]> ==  grant:
        - flag <[player]> behr.essentials.permission.<[command]>
        - announce to_console <&b>Permission<&3><&co><&a>+<&3><&co><[command]> if:<server.has_flag[behr.developmental.debug]>
      - else:
        - flag <[player]> behr.essentials.permission.<[command]>:!
        - announce to_console <&b>Permission<&3><&co><&c>-<&3><&co><[command]> if:<server.has_flag[behr.developmental.debug]>
    - foreach <script[permission_data].parsed_key[groups.<[group]>.permissions.inherits].if_null[<list>]> as:inheritance:
      - definemap data:
          player: <[player]>
          action: <[action]>
          group: <[inheritance]>
      - run group_permission_handler defmap:<[data]>
