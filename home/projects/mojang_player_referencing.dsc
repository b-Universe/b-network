mojang_player_referencing:
  type: task
  debug: true
  definitions: name
  script:
    - if !<[name].exists>:
      - narrate "<&c>No player name provided"
      - stop

    - ~webget https://api.mojang.com/users/profiles/minecraft/<[name]> save:response
    - if <entry[response].failed>:
      - narrate "<&c>Unexpected error<&co> <entry[response].status.if_null[invalid]> @ <entry[response].result.if_null[invalid]><n>Is the name correct?"
      - stop

    # correct player name capitalization, claim uuid
    - define name <util.parse_yaml[<entry[response].result>].get[name]>
    - define uuid <util.parse_yaml[<entry[response].result>].get[id].proc[player_uuid_fix_dashes]>

player_uuid_fix_dashes:
  type: procedure
  definitions: text
  script:
    - determine <[text].replace_text[-].with[].to_list.insert[-].at[9].insert[-].at[14].insert[-].at[19].insert[-].at[24].unseparated>
