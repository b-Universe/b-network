quick_fix:
  type: task
  debug: false
  script:
  - flag server behr:!
  - yaml id:emoji_list load:data/emoji_board/emoji_lang_file.json
  - execute as_op "project add bread_factory a gui minigame for players to own their own bread factory"
  - execute as_op "add_contributor _Behr bread_factory Primary project coordinator"
  - execute as_op "add_contributor Nimsy bread_factory Giving me the bread theme to reflect his original idea of Bread Clicker"
  - execute as_op "project add emoji_board an emoji gui made for copying and pasting emojis into the chat"
  - execute as_op "add_contributor _Behr emoji_board Primary project coordinator"
  - execute as_op "add_contributor HalbFettKaese emoji_board Creator of the animated text core shader, even if discovering it were on accident lol"
  - execute as_op "add_contributor Mergu emoji_board Suggested page numbers - on the to-do list!"
  - execute as_op "add_contributor apademide emoji_board Helped with <&dq>the essential emojis<&dq>"

  - note remove as:fishing_area
  - note remove as:fishing_area_fish_spawn
  - note remove as:fishing_area_spawnable
  - note remove as:no_swim_zome
  - note <cuboid[home,767,58,731,720,89,684]> as:fishing_area
  - note <cuboid[home,751,63,715,733,63,697]> as:fishing_area_fish_spawn
  - note <cuboid[home,696,55,660,777,89,741]> as:fishing_area_spawnable
  - note <cuboid[home,1269,-500,1269,420,300,420]> as:spawn

  - note <cuboid[home,719,60,683,763,62,727]> as:no_swim_zone
  - flag server behr.spawn.no_swim_zone_respawns:|:<script[behr_spawn_no_swim_zone_respawns].data_key[fishing_area.locations].parse_tag[<location[<[parse_value]>].face[<script[behr_spawn_no_swim_zone_respawns].data_key[fishing_area.aim_at]>]>]>

  - flag server behr.essentials.saved_skins.Pescetarian_Puffman.url:https://cdn.discordapp.com/attachments/980166207426670633/984184991128891492/puffer_overlay.png
  - flag server behr.essentials.saved_skins.Pescetarian_Puffman.skin_blob:ewogICJ0aW1lc3RhbXAiIDogMTY1NDcxOTI4NDA2MiwKICAicHJvZmlsZUlkIiA6ICIxNmFkYTc5YjFjMDk0MjllOWEyOGQ5MjgwZDNjNjE5ZiIsCiAgInByb2ZpbGVOYW1lIiA6ICJMYXp1bGl0ZV9adG9uZSIsCiAgInNpZ25hdHVyZVJlcXVpcmVkIiA6IHRydWUsCiAgInRleHR1cmVzIiA6IHsKICAgICJTS0lOIiA6IHsKICAgICAgInVybCIgOiAiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS9hNTNjMTA2Mjc0ZTY4NWY3ZjUwMzU5MzNkYzhhNDMwM2IyZjhhYjNlYjFhYzY4YjcyNTEwNjA0ZjM4Mzg0ZjVkIgogICAgfQogIH0KfQ==;Bzw2pn0Xeq04thd5FUbe5UT4YYRbtbcAerPEjW/kfDECOV+wyB2VqyR3vYdIHz3Jz9PoM9LeqFc4fywQFWemC+vyXU273wO2+bUp8jmF6DYiQxpNH365Ln6dtnkYR0th1/WYINkLVUTZLwzy5QzSfRYQ08bi7C5PN2BUw14t+ulJmwtGbU4vSEJbRYm6x9HKQqoRA1VHD2W/BcLahcuERhYDrjBqlrJXMqx0gcPDk9h3gs46N/ERRY5Rok7YX+TcP4cZ4J2f9wc8MWO9Efsmev5UL9teBj7Y4r0suDjhyUr3suE4Yl9umXE3c/Rk7o/LmRd8oaE1a4tkdrJ1ec63/p0M1jh0JnAyGMfnH4+/2XQ8oAXvu6xngYBmtQw90eRLJnbsK/ABYH+nCnUnxsJAL+/wYgwdMClnH9mko7h7wiVLejtYgzNlCysVfb8qBv6f82yRAHRKbKPxJrsEyhOfWi6ow8mSHAD6N7nBxXHbj1zF1Y83AiKZ3moGJ6ZOs6VBDOcXqOkCeNuZEyANRNSRdyrrSkFgen0j/WSUHI3ta2lQ+RfXkgZ87FSED7HErgcPxAh06zUXJgkO0eJP8I7Bzu/mfKFJoLhghGqrcd5G7x+uXGnV3nzPllCt6C1D3r/6gwKatYs93xN2lvRsvokeTp/4KFz0xcxHc0gSnivbxwU=

behr_spawn_no_swim_zone_respawns:
  type: data
  fishing_area:
    aim_at: 744,61,707,home
    locations:
      - 758,64,722,home
      - 760,64,720,home
      - 762,64,718,home
      - 764,64,716,home
      - 764,64,713,home
      - 764,64,710,home
      - 764,64,707,home
      - 760,63,707,home
      - 756,63,707,home
      - 764,64,704,home
      - 764,64,701,home
      - 764,64,698,home
      - 760,63,694,home
      - 756,63,694,home
      - 752,64,687,home
      - 748,64,686,home
      - 743,63,692,home
      - 736,63,687,home
      - 723,63,699,home
      - 728,63,707,home
      - 723,64,712,home
      - 723,64,716,home
      - 726,63,720,home
      - 730,63,720,home
      - 734,64,728,home
      - 737,64,728,home
      - 743,64,720,home
      - 743,64,724,home
      - 746,64,728,home
      - 749,64,728,home
      - 754,64,726,home
      - 756,64,724,home
