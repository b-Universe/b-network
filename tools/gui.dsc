bbackground:
  type: procedure
  debug: false
  data:
    lines:
      - <proc[-sp].context[8]>
      - <&color[<proc[prgb]>]>
      - <&chr[<[character_index].number_to_hex>].font[bgui]>
      - <proc[-sp].context[176]>

  definitions: size|menu_character
  script:
    - define base_character 57344
    - define character_index <[size].div[9].sub[1].mul[50].add[57344].add[<player.flag[behr.essentials.settings.gui.pattern].if_null[1]>]>
    - define lines <script.parsed_key[data.lines]>
    - define lines <[lines].include_single[<&f><&chr[<[menu_character]>].font[bgui]><proc[-sp].context[152]>]>
    - determine <[lines].unseparated>

prgb:
  type: procedure
  debug: false
  script:
    - define r <player.flag[behr.essentials.settings.gui.color.r].if_null[0]>
    - define g <player.flag[behr.essentials.settings.gui.color.g].if_null[254]>
    - define b <player.flag[behr.essentials.settings.gui.color.b].if_null[255]>
    - determine <color[<[r]>,<[g]>,<[b]>]>
argb:
  type: procedure
  debug: false
  script:
    - determine <proc[prgb].with_brightness[<proc[prgb].brightness.sub[75].max[0]>]>

profile_handler:
  type: world
  debug: false
  events:
    on player clicks close_button in inventory:
      - inventory close

close_button:
  type: item
  debug: false
  material: player_head
  display name: <&color[<proc[prgb]>]>Close
  mechanisms:
    custom_model_data: 1053
