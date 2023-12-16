group_command:
  type: command
  debug: false
  name: group
  usage: /group <&lt>player<&gt> <&lt>grant/revoke<&gt> <&lt>group<&gt>
  description: Grants or revokes a player from a group
  tab completions:
    1: <server.players.parse[name]>
    2: grant|revoke
    3: <script[permission_data].list_keys[groups]>
  script:
    - if <context.args.size> != 3:
      - inject command_syntax_error

    - define player_name <context.args.first>
    - inject command_player_verification

    # todo: temp: find the source of missing group placement
    - if !<[player].has_flag[behr.essentials.groups]>:
      - definemap data:
          player: <[player]>
          action: grant
          group: newbie
      - run group_permission_handler defmap:<[data]>

    - define action <context.args.get[2]>
    - if <[action]> !in grant|revoke:
      - define error "Specify to either grant or revoke the player's specified group"
      - inject command_error

    - define group <context.args.last>
    - define group_data <script[permission_data].data_key[groups]>
    - define groups <[group_data].keys>

    - if <[group]> !in <[groups]>:
      - define error "Specify any of<&co> <&e><[groups].separated_by[<&6>,<&e> ]>"
      - inject command_error

    - define player_level <[player].proc[group_level]>
    - define issuer_level <player.proc[group_level]>
    - define required_level <[group_data].deep_get[<[group]>.level]>

    - if <[issuer_level]> <= <[required_level]>:
      - define reason "Requires security clearance level <&e><[required_level]>"
      - inject command_permission_error

    - if <[player]> == <player> && <[issuer_level]> < 5:
      - define reason "Requires security clearance level <&e>5"
      - inject command_permission_error

    - if <[action]> == grant:
      - if <[group]> in <[player].flag[behr.essentials.groups]>:
        - if <[player]> != <player>:
          - define reason "Player is already in the <&e><[group]> <&c>group"
        - else:
          - define reason "You are already in the <&e><[group]> <&c>group"
        - inject command_error

      - define grammar "added to"
      - flag <[player]> behr.essentials.groups:->:<[group]>

    - else:
      - if <[group]> !in <[player].flag[behr.essentials.groups]>:
        - if <[player]> != <player>:
          - define reason "Player is not in the <&e><[group]> <&c>group"
        - else:
          - define reason "You are not in the <&e><[group]> <&c>group"
        - inject command_error

      - define grammar "removed from"
      - flag <[player]> behr.essentials.groups:<-:<[group]>

    - definemap data:
        player: <[player]>
        action: <[action]>
        group: <[group]>
    - run group_permission_handler defmap:<[data]>

    - if <[player]> != <player>:
      - narrate "<&e><[player].name> <&a>was <[grammar]> the <&e><[group]> <&a>group"
    - narrate "<&a>You were <[grammar]> the <&e><[group]> <&a>group" targets:<[player]>
