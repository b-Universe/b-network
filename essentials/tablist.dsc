tablist_handler:
  type: world
  debug: false
  data:
    header:
      - <&chr[E001].font[banner]><n><n><n><n><n><n><n><n>
      - <[color_left]><&m><&l>----------
      - <&color[<color[255,0,0].with_hue[<[hue_index].add[130]>]>]><&l>(
      - <&sp.repeat[5]>
      - <reset><[color_center]>Welcome to <&l>B!
      - <&sp.repeat[5]>
      - <[color_right]><&l>)<strikethrough>---------

      - <n><reset><[color_center]><&lb> <&e>Online<[color_center]><&l><&co> <&e><server.online_players.size> <[color_center]><&rb>
      - <&sp.repeat[10]>
      - <[color_center]><&lb> <&e>Discord<[color_center]><&l><&co> <&e><server.flag[behr.essentials.tablist.discord_player_presence].if_null[-]> <[color_center]><&rb>
      - <n><reset><[color_center]>
      - <n><server.flag[behr.essentials.tablist.starry_background]>

    footer:
      - <n>
      - <[color_center]><&lb> <&e>
      - <util.time_now.format[hh<&co>mm<&co>ss a].to_lowercase.replace_text[<&co>].with[<[color_center]><&l><&co><&e>]>
      - <[color_center]> <&rb>
      - <&sp.repeat[10]>
      - <[color_center]><&lb> <&e>
      #- TPS<[color_center]><&l><&co><&e> <list[20|20|20].separated_by[<[color_center]><&l>, <&e>]>
      - TPS<[color_center]><&l><&co><&e> <server.recent_tps.parse[round_to_precision[0.1]].separated_by[<[color_center]><&l>,<&e>]>
      - <[color_center]> <&rb>

  events:
    after tick every:2:
      - flag server behr.essentials.tab_hue_index:+:5
      - define hue_index <server.flag[behr.essentials.tab_hue_index]>
      - define color_left <&gradient[from=<color[255,0,0].with_hue[<[hue_index]>]>;to=<color[255,0,0].with_hue[<[hue_index].add[128]>]>]>
      - define color_center <&gradient[from=<color[255,0,0].with_hue[<[hue_index].add[32]>]>;to=<color[255,0,0].with_hue[<[hue_index].add[64]>]>]>
      - define color_right <&gradient[from=<color[255,0,0].with_hue[<[hue_index].add[128]>]>;to=<color[255,0,0].with_hue[<[hue_index]>]>]>
      - adjust <server.online_players> tab_list_info:<script.parsed_key[data.header].unseparated>|<script.parsed_key[data.footer].unseparated>

    after system time minutely every:30:
      - ~webget https://discord.com/api/guilds/901618453356630046/widget.json headers:[User-Agent=B] save:response
      - define result <entry[response].result.parse_yaml.get[presence_count].if_null[null]>
      - stop if:!<[result].is_truthy>

      - flag server behr.essentials.tablist.discord_player_presence:<[result]>

    after system time minutely:
      - flag server behr.essentials.tablist.starry_background:<&chr[<util.random.int[57346].to[57350].number_to_hex>].font[banner]>
