# note - left text cannot be more than 116 in pixel width
nbar_task:
  type: task
  debug: false
  definitions: destination|left_text
  script:
    - if !<server.has_flag[nbar.cached]>:
      - run cache_nbar

    - define left_text_width_padding_size <element[116].sub[<[left_text].text_width>]>
    - define left_text <proc[positive_spacing].context[<[left_text_width_padding_size].div[2].round_down>].font[utility:spacing].if_null[<empty>]><[left_text]><proc[positive_spacing].context[<[left_text_width_padding_size].div[2].round_up>].font[utility:spacing].if_null[<empty>]>

    - define uuid <player.uuid>
    - define lpad <server.flag[nbar.left_padding]>
    - define rpad <server.flag[nbar.right_padding]>

    - bossbar id:nbar_<[uuid]>_top create title:<server.flag[nbar.top_bar]>
    - bossbar id:nbar_<[uuid]>_bottom create title:<empty>

    - flag <player> nbarvigating
    - while <player.has_flag[nbarvigating]> && <player.is_online> && <player.is_on_ground>:
      - define ploc <player.location>
      - define angle <[ploc].face[<[destination]>].yaw.sub[<[ploc].yaw>].round_to_precision[15].mod[359]>
      - define angle <[angle].add[360]> if:<[angle].is_less_than[0]>
      #- define arrow <server.flag[nbar.arrow.<[angle]>]>
      - define direction <server.flag[nbar.direction.<[angle]>]>
      - bossbar id:nbar_<[uuid]>_bottom update title:<[lpad]><[left_text]><[direction]><[rpad]>
      - wait 2t

    - flag <player> nbarvigating:! if:<player.has_flag[nbarvigating]>
    - wait 2s
    - bossbar id:nbar_<[uuid]>_top remove
    - bossbar id:nbar_<[uuid]>_bottom remove


cache_nbar:
  type: task
  debug: false
  script:
    - flag server nbar.top_bar:<&chr[e820]><proc[negative_spacing].context[2].font[utility:spacing]><&chr[e821]>
    - flag server nbar.left_padding:<proc[negative_spacing].context[143].font[utility:spacing]>
    - flag server nbar.right_padding:<proc[negative_spacing].context[142].font[utility:spacing]>

    - define loc <server.worlds.first.spawn_location>
    - repeat 24 from:0 as:angle:
      - define angle <[angle].mul[15]>
      - define loc <[loc].with_yaw[<[angle]>]>
      - define right_text "<&a><[loc].direction> <&2>/ <&a><[angle]><&2>°<proc[positive_spacing].context[2].font[utility:spacing]>"
      - define right_text_width_padding <element[116].sub[<[right_text].text_width>]>
      - define right_text <proc[positive_spacing].context[<[right_text_width_padding].div[2].round_up>].font[utility:spacing].if_null[<empty>]><[right_text]><proc[positive_spacing].context[<[right_text_width_padding].div[2].round_down>].font[utility:spacing].if_null[<empty>]>

      - define arrow <proc[positive_spacing].context[10].font[utility:spacing]><&f><&chr[e<[angle].div[15].add[832].round>]><proc[positive_spacing].context[11].font[utility:spacing]>
      - flag server nbar.direction.<[angle]>:<[arrow]><[right_text]>

    - flag server nbar.cached



bossbar_furnished_short:
  type: task
  debug: true
  definitions: left_text|right_text|character
  script:
    - define 1 <proc[negative_spacing].context[143].font[utility:spacing]>
    - define left_text_width_padding_size <element[116].sub[<[left_text].text_width>]>
    - define 2 <proc[positive_spacing].context[<[left_text_width_padding_size].div[2].round_down>].font[utility:spacing].if_null[<empty>]><[left_text]><proc[positive_spacing].context[<[left_text_width_padding_size].div[2].round_up>].font[utility:spacing].if_null[<empty>]>
    - define arrow_padding <proc[positive_spacing].context[10].font[utility:spacing]>
    - define 3 <&f><[arrow_padding]><[character]><[arrow_padding]>
    - define right_text_width_padding <element[116].sub[<[right_text].text_width>]>
    - define 4 <proc[positive_spacing].context[<[right_text_width_padding].div[2].round_up>].font[utility:spacing].if_null[<empty>]><[right_text]><proc[positive_spacing].context[<[right_text_width_padding].div[2].round_down>].font[utility:spacing].if_null[<empty>]>
    - define 5 <proc[negative_spacing].context[142].font[utility:spacing]>
    - bossbar id:2 update title:<&chr[e820]><proc[negative_spacing].context[2].font[utility:spacing]><&chr[e821]>
    - bossbar id:2 update title:<[1]><[2]><[3]><[4]><[5]>

bossbar_furnished_long:
  type: task
  debug: false
  definitions: left_text|right_text|character
  script:
    # 1: beginning of left negative spacing
    - define 1 <proc[negative_spacing].context[144].font[utility:spacing]>

    # 2: the left text and it's padding
    - define left_text_width <[left_text].text_width>
    - define left_text_width_padding_size <element[116].sub[<[left_text_width]>]>
    - define left_text_left_padding_size <[left_text_width_padding_size].div[2].round_down>
    - define left_text_right_padding_size <[left_text_width_padding_size].div[2].round_up>
    - define left_text_left_padding <proc[positive_spacing].context[<[left_text_left_padding_size]>].font[utility:spacing].if_null[<empty>]>
    - define left_text_right_padding <proc[positive_spacing].context[<[left_text_right_padding_size]>].font[utility:spacing].if_null[<empty>]>
    - define 2 <[left_text_left_padding]><[left_text]><[left_text_right_padding]>

    # 3: the arrow and it's padding
    - define arrow_padding_size 10
    - define arrow_padding <proc[positive_spacing].context[<[arrow_padding_size]>].font[utility:spacing]>
    - define 3 <&f><[arrow_padding]><[character]><[arrow_padding]>

    # 4: the right text and it's padding
    - define right_text_width <[right_text].text_width>
    - define right_text_width_padding <element[116].sub[<[right_text_width]>]>
    - define right_text_left_padding_size <[right_text_width_padding].div[2].round_up>
    - define right_text_right_padding_size <[right_text_width_padding].div[2].round_down>
    - define right_text_left_padding <proc[positive_spacing].context[<[right_text_left_padding_size]>].font[utility:spacing].if_null[<empty>]>
    - define right_text_right_padding <proc[positive_spacing].context[<[right_text_right_padding_size]>].font[utility:spacing].if_null[<empty>]>
    - define 4 <[right_text_left_padding]><[right_text]><[right_text_right_padding]>


    # 5: the ending negative spacing
    - define 5 <proc[negative_spacing].context[142].font[utility:spacing]>

    # | order list:
    # - 1: the bar's left negative spacing
    # - 2: the left text's left padding, the text, and the right padding
    # - 3: the arrows's left padding, the arrow, and right padding
    # - 4: the left text's left padding, the text, and the right padding
    # - 5: the bar's right negative spacing

    - bossbar id:2 update title:<&chr[e820]><proc[negative_spacing].context[2].font[utility:spacing]><&chr[e821]>
    - bossbar id:2 update title:<[1]><[2]><[3]><[4]><[5]>
