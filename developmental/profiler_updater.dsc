update_discord_user_database:
  type: task
  script:
    - define members_list <discord_group[c,901618453356630046].members>
    - foreach <[members_list]> as:member:
      - define member_id <[member].id>
      - flag server behr.essentials.discord.users.<[member_id]>.name:<[member].name>
      - flag server behr.essentials.discord.users.<[member_id]>.avatar_url:<[member].avatar_url>
      - flag server behr.essentials.discord.users.<[member_id]>.nickname:<[member].nickname[<discord_group[c,901618453356630046]>].escaped> if:<[member].nickname[<discord_group[c,901618453356630046]>].exists>
      - if <[member].discriminator> != 0000:
        - flag server behr.essentials.discord.users.<[member_id]>.discriminator:<[member].discriminator>
      - else:
        - flag server behr.essentials.discord.users.<[member_id]>.discriminator:!
      - wait 1s

update_profiler_font:
  type: task
  enabled: false
  data:
    provider:
      type: bitmap
      file: gui/custom/users/<[member.id]>.png
      ascent: 7
      height: 64
      chars:
        - <[member.font_character]>
  script:
    - define origin_path /denizen
    - define profiler_file_path <[origin_path]>/data/b-resource/assets/minecraf/font/profiler.json
    - define providers <list>

    - if !<server.has_flag[behr.essentials.discord.users_indexed]>:
      - flag server behr.essentials.discord.font_character_index:57343

    - foreach <server.flag[behr.essentials.discord.users]> key:member_id as:member:
      - if !<server.has_flag[behr.essentials.discord.users.<[member_id]>.font_character]>:
        - flag server behr.essentials.discord.font_character_index:++
        - define member.font_character <&chr[<server.flag[behr.essentials.discord.font_character_index]>]>
        - flag server behr.essentials.discord.users.<[member_id]>.font_character:<[member.font_character]>
        - ~webget <[member.avatar_url]> save:response
        - if <entry[response].failed>:
          - narrate "<&c>Failed to pull avatar for <&e><[member.name]><&4><&co> <&c><[member.avatar_url]>"
          - wait 5s
          - foreach next

      - define providers <[providers].include_single[<script.parsed_key[data.provider]>]>
      - wait 1s
      - define content <map.with[providers].as[<[providers]>]>

    - ~filewrite <[content].to_json[native_types=true].utf8_encode> path:<[profiler_file_path]>
