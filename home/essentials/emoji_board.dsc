emoji_board_command:
  type: command
  debug: true
  name: emoji_board
  usage: /emoji_board
  description: Opens the emoji board
  aliases:
    - em
  script:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

    - run emoji_board

emoji_board:
  type: task
  debug: false
  data:
    page_header: <element[<element[●<strikethrough><&sp.repeat[4]><reset><bold>].color_gradient[from=#ff7200;to=#c8ff00]> <yellow><proc[negative_spacing].context[2].font[utility:spacing]><bold><&chr[e630]> <red><bold>Menu <proc[negative_spacing].context[2].font[utility:spacing]><&b><bold><&chr[e630]><proc[negative_spacing].context[3].font[utility:spacing]><element[<bold><reset><strikethrough><&sp.repeat[4]><reset>●].color_gradient[from=#55ffff;to=#ff0015]>].on_hover[Main Menu].on_click[48].type[CHANGE_PAGE]>
  script:
    - if !<server.has_flag[behr.emoji_board.base_book_pages_cache]>:
      - define emojis <yaml[emoji_list].read[].values>
      - define categories_data <script[page_data].parsed_key[categories]>
      - define category_map <map>
      - define page_header <script.parsed_key[data.page_header]>
      - define pages <list>
      - define category_data <script[page_data].parsed_key[categories]>

      - foreach <[category_data]> key:category as:category_data:
        - define category_emojis <[emojis].get[<[category_data.from]>].to[<[category_data.to]>]>
        - define category_map <[category_map].with[<[category]>].as[<[category_emojis]>]>

      - foreach <[category_map]> key:category as:emojis:
        - define category_pages <list>

        # % ██ [ create header, category line, and the padding ] ██
        - define base_page "<list_single[<[page_header]>].include_single[<element[●<strikethrough><&sp.repeat[<[category_data.<[category]>.line_padding].first>]><reset><bold>].color_gradient[from=#ff7200;to=#c8ff00]> <yellow><proc[negative_spacing].context[2].font[utility:spacing]><bold><&chr[e630]> <red><[category]>  <proc[negative_spacing].context[3].font[utility:spacing]><&b><bold><&chr[e630]><proc[negative_spacing].context[3].font[utility:spacing]><element[<bold><reset><strikethrough><&sp.repeat[<[category_data.<[category]>.line_padding].last>]><reset>●].color_gradient[from=#55ffff;to=#ff0015]>].include[<n>]>"

        # % ██ [ add emojis by category into the page list ] ██
        - foreach <[emojis].sub_lists[48]> as:page_emojis:
          - define pages "<[pages].include_single[<[base_page].separated_by[<n>]><&f><[page_emojis].parse_tag[<[parse_value].on_hover[Copy!].on_click[<[parse_value]>].type[COPY_TO_CLIPBOARD]>].sub_lists[8].parse[separated_by[ ]].separated_by[<p><&f>]>]>"

      # % ██ [ add menu page - page 48 ] ██
      - define lines "<list_single[<element[●<strikethrough><&sp.repeat[2]><reset><bold>].color_gradient[from=#ff7200;to=#c8ff00]> <yellow><proc[negative_spacing].context[2].font[utility:spacing]><bold><&chr[e630]><red>Main Menu <proc[negative_spacing].context[3].font[utility:spacing]><&b><bold><&chr[e630]><proc[negative_spacing].context[3].font[utility:spacing]><element[<bold><reset><strikethrough><&sp.repeat[2]><reset>●].color_gradient[from=#55ffff;to=#ff0015]>]>"
      - define lines "<[lines].include_single[<element[<&f>🗒<red>Categories<&f>🗒<n>].on_hover[<element[Click to change to].color_gradient[from=#ff4d00;to=#04ff00]><n><element[the <bold>Categories<reset> page!].color_gradient[from=#ffb300;to=#00ff33]><n><element[(or click the next page)].color_gradient[from=#fff700;to=#00ffa2]>].on_click[49].type[CHANGE_PAGE]>]>"
      #- define lines "<[lines].include_single[<element[Favorites<n>].on_hover[<element[Click to change to].color_gradient[from=#ff4d00;to=#04ff00]><n><element[the <bold>Favorites<reset> page!].color_gradient[from=#ffb300;to=#00ff33]>].on_click[50].type[CHANGE_PAGE]>]>"
      - define lines "<[lines].include_single[<element[<&f>🏆<red>Credits<&f>🥇].on_hover[<element[Click to change to].color_gradient[from=#ff4d00;to=#04ff00]><n><element[the <bold>Credits<reset> page!].color_gradient[from=#ffb300;to=#00ff33]>].on_click[50].type[CHANGE_PAGE]><n>]>"
      - define pages <[pages].include_single[<[lines].separated_by[<p>]>]>

      # % ██ [ add category page - page 49 ] ██
      - definemap categories:
          People: <&f>😃 🥳 <black><bold>People <&f>👍 👏
          Nature: <&f>🦁 🐸 <black><bold>Nature <&f>🌈 🔥
          Food: <&f>🍎 🍆 <black><bold>Food <&f>🌮 🍺
          Activities: <&f>⚽ 🏀 <black><bold>Activities <&f>🥇 🚴
          Travel: <&f>🚗 ⛵ <black><bold>Travel <&f>🚔 🚁
          Objects: <&f>⚔ 🛠 <black><bold>Objects <&f>⚙ ✉
          Symbols: <&f>❤ ⛔ <black><bold>Symbols <&f>⚠ 🇧
          Flags: <&f>󿇨 󺀃 <black><bold>Flags <&f>󿀔 🏁
      - definemap category_page:
          People: 1
          Nature: 13
          Food: 18
          Activities: 21
          Travel: 25
          Objects: 28
          Symbols: 34
          Flags: 42

      - define lines <list.include_single[<[page_header]><n>]>
      - foreach <[categories]> key:category as:text:
        - define lines "<[lines].include_single[<[text].on_hover[<element[Click to change to].color_gradient[from=#ff4d00;to=#04ff00]><n><element[the <bold><[category]><reset> category!].color_gradient[from=#ffb300;to=#00ff33]>].on_click[<[category_page].get[<[category]>]>].type[CHANGE_PAGE]>]>"
      - define pages <[pages].include_single[<&f><[lines].separated_by[<n>]>]>

      # % ██ [ add favorites page - page 50 ] ██
      #- define lines <list_single[<[page_header]>].include_single[Favorites]>
      #- define pages <[pages].include_single[<[lines].separated_by[<p>]>]>

      # % ██ [ add credits page - page 51, 50 without favorites ] ██
      - define lines "<list_single[<[page_header]>].include_single[<&f>🥇💖🥇 <red>Credits <&f>🏆💖🏆]>"
      - define lines "<[lines].include_single[A special thanks to these contributors for all of their contributions, big or small. Sharing ideas when building projects like these are what make them as great as they are!<&f><element[▶].on_hover[<element[Recognize the <&ns> contributors].color_gradient[from=#ff4d00;to=#04ff00]><n><element[on the next pages!].color_gradient[from=#ffb300;to=#00ff33]>].on_click[51].type[CHANGE_PAGE]>]>"
      - define pages <[pages].include_single[<[lines].separated_by[<p>]>]>

      # % ██ [ save everything up to this point in a flag ] ██
      - flag server behr.emoji_board.base_book_pages_cache:<[pages]>

    # % ██ [ check for credits update ] ██
    - if <server.flag[behr.emoji_board.contributor_last_update].if_null[<util.time_now.sub[29d]>].is_after[<server.flag[behr.emoji_board.contributor_last_update_cache].if_null[<util.time_now.sub[30d]>]>]>:

      # % ██ [ foreach credits ] ██
      - define credit_page_header "<list_single[<script.parsed_key[data.page_header]>].include_single[<n><&f>🥇💖🥇 <red>Credits <&f>🏆💖🏆<n>]>"
      - define lines <list>

      #- if !<server.has_flag[behr.emoji_board.contributors]>:
      #  - flag server "behr.emoji_board.contributors.<server.match_player[_behr]>:->:<&color[#F3FFAD]>● <&color[#C1F2F7]>Primary project coordinator"

      # % ██ [ add known player contributors ] ██
      - foreach <server.flag[behr.emoji_board.contributors]> key:player as:contributions:
        - define lines <[lines].include_single[<&f>🏆<black><[player].name.on_hover[<[contributions].parse[split_lines_by_width[200].split[<n>]].combine.parse_tag[<[parse_value]>].separated_by[<n>]>]>]>

      # % ██ [ add mysterious player contributors ] ██
      - if <server.has_flag[behr.emoji_board.mystery_contributors]>:
        - foreach <server.flag[behr.emoji_board.mystery_contributors]> key:name as:data:
          - define lines <[lines].include_single[<&f>🏆<black><[name].on_hover[<[data.contributions].parse[split_lines_by_width[200].split[<n>]].combine.parse_tag[<[parse_value]>].separated_by[<n>]>]>]>
      - flag server behr.emoji_board.contributor_last_update_cache:<util.time_now>

      - define credit_pages <[lines].sub_lists[8].parse_tag[<[credit_page_header].include_single[<[parse_value].separated_by[<n>]>].separated_by[<n>]>]>
      - define pages <server.flag[behr.emoji_board.base_book_pages_cache].include[<[credit_pages]>]>
      - flag server behr.emoji_board.book_item:<item[written_book].with_map[<map.with[book].as[<map[author=_Behr;title=howdy].with[pages].as[<[pages]>]>]>]>

    # % ██ [ show the book ] ██
    - adjust <player> show_book:<server.flag[behr.emoji_board.book_item]>

  category_page:
    - define page_header "<element[●<strikethrough><&sp.repeat[4]><reset><bold>].color_gradient[from=#ff7200;to=#c8ff00]> <yellow><proc[negative_spacing].context[2].font[utility:spacing]><bold><&chr[e630]> <red><bold>Menu <proc[negative_spacing].context[2].font[utility:spacing]><&b><bold><&chr[e630]><proc[negative_spacing].context[3].font[utility:spacing]><element[<bold><reset><strikethrough><&sp.repeat[4]><reset>●].color_gradient[from=#55ffff;to=#ff0015]>"
    - definemap categories:
        People: <&f>😃 <&f>🥳 <black><bold>People <&f>👍 <&f>👏
        Nature: <&f>🦁 <&f>🐸 <black><bold>Nature <&f>🌈 <&f>🔥
        Food: <&f>🍎 <&f>🍆 <black><bold>Food <&f>🌮 <&f>🍺
        Activities: <&f>⚽ <&f>🏀 <black><bold>Activities <&f>🥇 <&f>🚴
        Travel: <&f>🚗 <&f>⛵ <black><bold>Travel <&f>🚔 <&f>🚁
        Objects: <&f>⚔ <&f>🛠 <black><bold>Objects <&f>⚙ <&f>✉
        Symbols: <&f>❤ <&f>⛔ <black><bold>Symbols <&f>⚠ <&f>🇧
        Flags: <&f>󿇨 <&f>🏳️‍🌈 <black><bold>Flags <&f>🇺🇦 <&f>🏁
    - definemap category_page:
        People: 1
        Nature: 13
        Food: 18
        Activities: 21
        Travel: 25
        Objects: 28
        Symbols: 34
        Flags: 42

    - define page <list>
    - define lines <list.include_single[<[page_header]>]>
    - foreach <[categories]> key:category as:text:
      - define lines "<[lines].include_single[<[text].on_hover[<element[Click to change to].color_gradient[from=#ff4d00;to=#04ff00]><n><element[the <bold><[category]><reset> category!].color_gradient[from=#ffb300;to=#00ff33]>].on_click[<[category_page].get[<[category]>]>].type[CHANGE_PAGE]>]>"
    - define page <[page].include_single[<&f><[lines].separated_by[<p>]>]>

    # % ██ [ show the book ] ██
    - adjust <player> show_book:<item[written_book].with_map[<map.with[book].as[<map[author=_Behr;title=howdy].with[pages].as[<[page]>]>]>]>

  return all uncategorized:
    - define emojis <yaml[emoji_list].read[].values.sub_lists[48]>
    - define page_base <script[page_data].parsed_key[header]>
    - define pages <list>
    - foreach <[emojis]> as:page_emojis:
      - define page "<&f><[page_base].separated_by[<n>]><n><&f><[emojis].get[<[loop_index]>].parse_tag[<[parse_value].on_hover[Copy!].on_click[<[parse_value]>].type[COPY_TO_CLIPBOARD]>].sub_lists[8].parse[separated_by[ ]].separated_by[<p><&f>]>"
      - define pages <[pages].include_single[<[page]>]>
    - adjust <player> show_book:<item[written_book].with_map[<map.with[book].as[<map[author=_Behr;title=howdy].with[pages].as[<[pages]>]>]>]>


emoji_book:
  type: book
  title: Emoji Book
  author: _Behr
  signed: true
  text:
  - <script[page_data].parsed_key[lines].separated_by[<n>]>

page_data:
  type: data
  categories:
    People:
      from: 1
      to: 535
      total: 535
      line_padding:
        - 3
        - 3
    nature:
      from: 536
      to: 750
      total: 215
      line_padding:
        - 3
        - 3
    food:
      from: 751
      to: 887
      total: 137
      line_padding:
        - 4
        - 4
    activities:
      from: 888
      to: 1035
      total: 148
      line_padding:
        - 2
        - 1
    travel:
      from: 1036
      to: 1179
      total: 144
      line_padding:
        - 4
        - 3
    objects:
      from: 1180
      to: 1429
      total: 250
      line_padding:
        - 2
        - 2
    symbols:
      from: 1430
      to: 1766
      total: 337
      line_padding:
        - 3
        - 2
    flags:
      from: 1767
      to: 2036
      total: 270
      line_padding:
        - 4
        - 4

# % ██ [ general notes ] ██

emoji_startup_flag_fixer_thing_for_other_servers:
  type: world
  events:
    after server start:
      - if <server.has_flag[behr.emoji_board.initiated]>:
        - yaml id:emoji_list load:Denizen/plugins/data/emoji_board/emoji_lang_file.json

      - else:
        - if !<server.has_file[data/emoji_board/emoji_lang_file.json]>:
          - define url https://raw.githubusercontent.com/BehrRiley/TinyEmojiFontResource/main/assets/twemoji/lang/en_us.json
          - ~webget <[url]> save:lang_file
          - if <entry[lang_file].failed>:
            - announce to_console "<&[warning]>Warning<&co> the yaml file did not download from the github source<&co><[url]><n>Download the file, save to `Denizen/plugins/data/emoji_board/` as `emoji_lang_file.json` to resolve loading this yaml file"
            - stop
          - yaml id:emoji_list create
          - yaml id:emoji_list set <empty>:<util.parse_yaml[<entry[lang_file].result>]>
          - yaml id:emoji_list savefile:data/emoji_board/emoji_lang_file.json

contributors_for_emoji_book:
  type: data
  project: an emoji gui made for copying and pasting emojis into the chat
  last_update: <time[2022/06/02_08:26:18:0445_-04:00]>
  contributors:
    _Behr:
      uuid: d82da59b-44fc-4a72-a20d-a7f7ae5ef382
      contributions:
      - <&color[#F3FFAD]>● <&color[#C1F2F7]>Primary project coordinator

    HalbFettKaese:
      uuid: c5a4e97e-3a03-4e6b-979d-f971fb0ccb08
      contributions:
      - <&color[#F3FFAD]>● <&color[#C1F2F7]>Original creator of the animated text, even if discovering it were on accident lol

    Mergu:
      uuid: 4f1e61de-6f0c-46aa-8c26-52354c4bd9cc
      contributions:
      - <&color[#F3FFAD]>● <&color[#C1F2F7]>Suggested page numbers - on the to-do list!

    apademide:
      uuid: 9c10e6c0-b675-4b42-9197-9c77771eb1be
      contributions:
      - <&color[#F3FFAD]>● <&color[#C1F2F7]>Helped with <&dq>the essential emojis<&dq>

    amber:
      contributions:
      - <&color[#F3FFAD]>● <&color[#C1F2F7]>constructed the emoji resource pack assets
