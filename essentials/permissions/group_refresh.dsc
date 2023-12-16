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
    - define group_data <script[permission_data].data_key[groups]>
    - define groups <[group_data].keys>

    - if <[group]> !in <[groups]>:
      - define error "Specify any of<&co> <&e><[groups].separated_by[<&6>,<&e> ]>"
      - inject command_error

    - define players <server.players>
    - foreach <[players]> as:player:
      - define inheritance <script[permission_data].data_key[groups.<[group]>.permissions.inherits].if_null[<list>]>
      - if !<[player].flag[behr.essentials.groups].contains[<[group]>]>:
        - define players <[players].exclude[<[player]>]>

    - foreach <[players]> as:player:
      - flag <[player]> behr.essentials.permission:!
      - definemap data:
          player: <[player]>
          action: grant
          group: <[group]>
      - run group_permission_handler defmap:<[data]>
      - wait 1t
    - adjust server save
    - wait 1s
    - reload
