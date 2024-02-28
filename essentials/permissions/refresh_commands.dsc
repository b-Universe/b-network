group_refresh_command:
  type: command
  debug: false
  name: group_refresh
  usage: /group_refresh <&lt>group<&gt>
  description: Refreshes a group
  tab completions:
    1: <script[permission_data].list_keys[groups]>
  script:
    - if <context.args.is_empty>:
      - inject command_syntax_error

    - define group <context.args.first>
    - foreach <server.players.filter[flag[behr.essentials.groups].contains[<[group]>]]> as:player:
      - flag <[player]> behr.essentials.groups:!
      - run group_permission_handler defmap:[player=<[player]>;action=grant;group=<[group]>]

    - reload

command_refresh_command:
  type: command
  debug: false
  name: command_refresh
  usage: /command_refresh <&lt>command<&gt>
  description: Refreshes a command
  script:
    - if <context.args.size> != 1:
      - inject command_syntax_error

    - define command <context.args.first>
    - define refresh_groups <list>
    - foreach <script[permission_data].list_keys[groups]> as:group:
      - if <[command]> in <script[permission_data].parsed_key[groups.<[group]>.permissions.commands]>:
        - define refresh_groups <[refresh_groups].include_single[<[group]>]>
    - foreach <[refresh_groups]> as:group:
      - foreach <server.players.filter[flag[behr.essentials.groups].contains[<[group]>]]> as:player:
        - flag <[player]> behr.essentials.groups:!
        - run group_permission_handler defmap:[player=<[player]>;action=grant;group=<[group]>]
