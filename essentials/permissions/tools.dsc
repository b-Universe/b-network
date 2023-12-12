group_level:
  type: procedure
  debug: false
  definitions: player
  script:
    - define player_groups <player.flag[behr.essentials.groups].if_null[newbie]>
    - define group_data <script[permission_data].data_key[groups]>
    - define player_group_levels <[group_data].get[<[player_groups]>].parse[get[level]]>
    - determine <[player_group_levels].highest>
