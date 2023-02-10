experience_handler:
  type: world
  debug: false
  events:
    after discord message received:
      - define user <context.new_message.author>

    # % ██ [ lazy implementation of checking if the message is a gif or has a link      ] ██
      - if <context.new_message.text.contains_any_text[https<&co>//|http<&co>//]>:
        - define experience <util.random.int[10].to[15]>
      - else:
        - define experience <util.random.int[2].to[5]>
      - if <[user].has_flag[1m_activity]>:
        - define experience <[experience].add[<[user].flag[experience].min[5]>]>

    # % ██ [ track active activity by the minute, increase experience                   ] ██
      - flag <[user]> activity:++ expire:1m
      - flag <[user]> experience:+:<[experience]>
      - define user_id <[user].id>
      - flag server behr.discord.users.<[user_id]>.experience:+:<[experience]>

    # % ██ [ disable announcing her own level-ups                                       ] ██
      - stop if:<[user].advanced_matches[<context.bot.self_user>]>

    # % ██ [ define the experience and level for the user                               ] ██
      - define current_experience <[user].flag[experience]>
      - define current_level <[user].flag[level].if_null[0]>
      - if <[current_level]> != invalid && !<[current_level].is_integer>:
        - flag <[user]> level:0

    # % ██ [ define the experience and level for the next level for the user            ] ██
      - define next_level <[current_level].add[1].if_null[0]>
      - define next_experience <server.flag[level.experience.<[next_level]>]>

    # % ██ [ determine if we're leveling up, or not                                     ] ██
      - if <[current_experience]> < <[next_experience]>:
        - stop

    # % ██ [ set the new data; increase the level, halt more level-up prompts           ] ██
      - stop if:<server.has_flag[behr.discord.temp.level_up.<[user_id]>]>
      - flag <[user]> level:<[next_level]>
      - flag server behr.discord.temp.level_up.<[user_id]> expire:10s
      - flag server behr.discord.users.<[user_id]>.level:<[next_level]>

    # % ██ [ check if its gif channel                                                   ] ██
      - define channel_id <context.channel.id>
      - if <[channel_id]> == 1072553008560349205:
        - ~discordmessage id:c reply:<context.new_message> <script.parsed_key[data.gif_responses].random>
        - flag server behr.discord.temp.level_up.<[user_id]>:!
        - discord id:c stop_typing channel:<context.channel>
        - stop

    # % ██ [ use the AI endpoint to create a custom response                            ] ██
      - define url https://api.openai.com/v1/completions

    # % ██ [ define the headers                                                         ] ██
      - definemap headers:
          Authorization: <secret[ai]>
          Content-Type: application/json
          User-Agent: B

    # % ██ [ construct the payload                                                      ] ██
      - define user_name <[user].nickname[901618453356630046].if_null[<[user].name>]>
      - define message_prompt <script.parsed_key[data.message_prompts].random>
      - definemap data:
          model: text-davinci-003
          prompt: <[message_prompt]>
          temperature: 0.7
          max_tokens: 200

    # % ██ [ request a level-up response, pretend to type                               ] ██
      - discord id:c start_typing channel:<context.channel>
      - ~webget <[url]> data:<[data].to_json[native_types=true]> headers:<[headers]> save:response


      #todo: ----- convert back from webget to discordmessage ------------------------- ] ██
      #- definemap embed_map:
      #    color: <color[0,255,254]>
      #    title: Level-up!
      #    thumbnail: <[user].avatar_url>
      #    description: <util.parse_yaml[<entry[response].result>].get[choices].first.get[text].if_null[You've achieved level <[new_level]>!]>
      #- define embed <discord_embed.with_map[<[embed_map]>]>
      #- ~discordmessage id:c channel:<[channel_id]> <[embed]>

      #todo: ----- from v to ^ -------------------------------------------------------- ] ██

      - define url https://discord.com/api/channels/<[channel_id]>/messages
      - definemap headers:
          Authorization: <secret[cbot]>
          Content-Type: application/json
          User-Agent: B
      - definemap data:
          color: 65534
          title: Level-up!
          thumbnail:
            url: <[user].avatar_url>
          description: <util.parse_yaml[<entry[response].result>].get[choices].first.get[text].if_null[You've achieved level <[new_level]>!]>
      - define embeds <map.with[embeds].as[<list_single[<[data]>]>]>
      - ~webget <[url]> headers:<[headers]> data:<[embeds].to_json> save:response
      #todo: -------------------------------------------------------------------------- ] ██

      - flag server behr.discord.temp.level_up.<[user_id]>:!
      - discord id:c stop_typing channel:<context.channel>
  data:
    message_prompts:
      - Create a message congratulating a user named <&dq><[user_name]><&dq> on achieving level <[next_level]>.
      - Create a message congratulating a user named <&dq><[user_name]><&dq> on achieving level <[next_level]>.
      - Create a message congratulating a user named <&dq><[user_name]><&dq> on achieving level <[next_level]>.
      - Make a joke about a user named <&dq><[user_name]><&dq> just achieving level <[next_level]>.
      - Make a joke about a user named <&dq><[user_name]><&dq> just achieving level <[next_level]>.
      - Make a funny response in response to a user named <&dq><[user_name]><&dq> achieving level <[next_level]>.
      - Make a funny response in response to a user named <&dq><[user_name]><&dq> achieving level <[next_level]>.
      - Create a message asking a user named <&dq><[user_name]><&dq> achieving level <[next_level]> what they will do with their achievement.

    gif_responses:
      - https<&co>//tenor.com/view/level-up-flexing-level-strong-gif-15476717
      - https<&co>//tenor.com/view/dabjultsu-levelup-gif-16298509
      - https<&co>//tenor.com/view/level-up-gif-level-up-gif-yes-level-up-woah-gif-26005396
      - https<&co>//tenor.com/view/bawr-level-up-hype-gif-20395169
      - https<&co>//tenor.com/view/klikcz-agentklik-hulalala-czklik-klik-gif-25117030
      - https<&co>//tenor.com/view/level-up-gif-gif-24816587
      - https<&co>//tenor.com/view/level-up-level-up-kasey-kasey-woo-energy-gif-12935690
      - https<&co>//tenor.com/view/level-up-gif-25793244
      - https<&co>//tenor.com/view/level-up-next-level-another-level-energy-letterkenny-gif-19755373
      - https<&co>//tenor.com/view/level-up-oh-yeah-happy-dance-happy-woo-gif-14637361
      - https<&co>//media.tenor.com/BPhfT0r2VpMAAAAC/bawr-levelup.gif



























fix_levels:
  type: task
  debug: false
  script:
    - foreach <script[level_chart].data_key[levels]> key:level as:experience:
      - flag server level.experience.<[level]>:<[experience]>

    - define users <discord_group[c,901618453356630046].members.if_null[<list>]>
    - stop if:<[users].is_empty>
    # temp fix
    #- define users <[users].filter[name.equals[Hydra Melody]]>

    - foreach <[users]> as:user:
      - flag <[user]> level:!
      - flag server behr.discord.users.<[user].id>.level:!
      - flag server behr.discord.users.<[user].id>.experience:!
      - define current_experience <[user].flag[experience].if_null[0]>
      - flag server behr.discord.users.<[user].id>.experience:<[current_experience].if_null[0]>
      #- flag <[user]> experience:<[current_experience].div[15].round_up>

      - repeat 120 as:level from:0:
        - if <[current_experience]> > <server.flag[level.experience.<[level]>]>:
          - repeat next
        - flag <[user]> level:<[level]>
        - flag server behr.discord.users.<[user].id>.level:<[level]>
        - repeat stop

    - narrate "<n><n><&e><[users].parse_tag[<&e><[parse_value].name><&6><&co> <&a><[parse_value].flag[level].if_null[0]> <&b>| <&a><[parse_value].flag[experience]>].separated_by[<n>]>"
    #- narrate "<n><n><&e><discord_group[c,901618453356630046].members.filter[id.exists].parse_tag[<&e><[parse_value].name><&6><&co> <&a><[parse_value].flag[level].if_null[0]>].separated_by[<n>]>"
#
#levelup_check:
#  type: task
#  debug: true
#  definitions: user|channel_id
#  script:
#    - define current_experience <[user].flag[experience].if_null[0]>
#    - define current_level <[user].flag[level].if_null[0]>
#    - define new_level <[current_level].add[1]>
#    - define next_level_experience <server.flag[level.experience.<[new_level]>]>
#
#    - if <[current_experience]> > <[next_level_experience]>:
#      - define url https://api.openai.com/v1/completions
#      - definemap headers:
#          Authorization: <secret[ai]>
#          Content-Type: application/json
#          User-Agent: B
#      - define user_name <[user].nickname[901618453356630046].if_null[<[user].name>].proc[bad_json_proc]>
#      - define message_prompt <script.parsed_key[data.message_prompts].random.proc[bad_json_proc]>
#      - define data '{"model":"text-davinci-003","prompt": "<[message_prompt]>","temperature": 0.7,"max_tokens": 200}'
#      - ~webget <[url]> data:<[data]> headers:<[headers]> save:response
#      #- inject web_debug.webget_response
#      - flag <[user]> level:<[new_level]>
##
##      #todo: convert back from webget to discordmessage
##      #- definemap embed_map:
##      #    color: <color[0,255,254]>
##      #    title: Level-up!
##      #    thumbnail: <[user].avatar_url>
##      #    description: <util.parse_yaml[<entry[response].result>].get[choices].first.get[text].if_null[You've achieved level <[new_level]>!]>
##      #- define embed <discord_embed.with_map[<[embed_map]>]>
##      - flag <[user]> level:<[new_level]>
##      #- ~discordmessage id:c channel:<[channel_id]> <[embed]>
##      #todo: convert back from webget to discordmessage
#      - define url https://discord.com/api/channels/<[channel_id]>/messages
#      - definemap headers:
#          Authorization: <secret[cbot]>
#          Content-Type: application/json
#          User-Agent: B
#      - definemap data:
#          color: 65534
#          title: Level-up!
#          thumbnail:
#            url: <[user].avatar_url>
#          description: <util.parse_yaml[<entry[response].result>].get[choices].first.get[text].if_null[You've achieved level <[new_level]>!]>
#      - define embeds <map.with[embeds].as[<list_single[<[data]>]>]>
#      - ~webget <[url]> headers:<[headers]> data:<[embeds].to_json> save:response
#      #- inject web_debug.webget_response
#  data:
#    message_prompts:
#      - Create a message congratulating a user named <&dq><[user_name]><&dq> on achieving level <[new_level]>
#      - Make a joke about a user named <&dq><[user_name]><&dq> just achieving level <[new_level]>
#
bad_json_proc:
  type: procedure
  debug: false
  definitions: text
  script:
  - determine <[text].replace_text[<&sq>].with[\<&sq>].replace_text[<&dq>].with[\<&dq>]>


leaderboards_command_create:
  type: task
  debug: false
  script:
    - ~discordcommand id:c create name:leaderboards "description:Serves the leaderboards link for user experience and level data" group:901618453356630046

leaderboards_command_handler:
  type: world
  debug: false
  events:
    on discord slash command name:leaderboards group:901618453356630046:
      - define description <list>

      - define users <server.flag[behr.discord.users]>
      - define users <[users].sort_by_value[get[experience]].reverse>
      - define new_list <list>

      - foreach <[users]> key:user as:data:
        - define experience <[data].get[experience]>
        - if <[loop_index]> > 10 || <[experience]> == 0:
          - foreach stop
        - define discord_user <discord_user[c,<[user]>]>
        - define new_list <[new_list].include_single[Rank <[loop_index]> - <[discord_user].mention> | `(<[discord_user].name>)`<&co> Level<&co> **<[discord_user].flag[level]>** (Exp<&co> **<[discord_user].flag[experience].format_number>**)]>

      - define description <[description].include[<[new_list]>]>

      - definemap embed_data:
          title: "`<&lb>IceBear Leveling Dashboard for B<&rb>`"
          title_url: https://stat.icecapa.de/grafana/public-dashboards/90a220f38928488a8a091d7f377b4548?orgId=1
          color: <color[0,254,255]>
          description: <[description].separated_by[<n>]>

      - ~discordinteraction reply interaction:<context.interaction> <discord_embed.with_map[<[embed_data]>]>

rank_command_create:
  type: task
  debug: false
  script:
    - definemap options:
        1:
          type: user
          name: user
          description: Specifies a user to reference for their ranking here in b by level and experience
          required: false

    - ~discordcommand id:c create options:<[options]> name:rank "description:Returns yours or another user's rank by level and experience here in B" group:901618453356630046

rank_command_handler:
  type: world
  debug: false
  events:
    on discord slash command name:rank group:901618453356630046:
      - if <context.options.contains[user]>:
        - define user <context.options.get[user]>
      - else:
        - define user <context.interaction.user>

      - define level <[user].flag[level]>
      - define experience <[user].flag[experience]>

      - definemap embed_data:
          title: "`<&lb>IceBear Leveling Dashboard<&rb>` Level <[level]>"
          title_url: https://stat.icecapa.de/grafana/public-dashboards/90a220f38928488a8a091d7f377b4548?orgId=1
          color: <color[0,254,255]>
          thumbnail: <[user].avatar_url>

      - define rank <server.flag[behr.discord.users].sort_by_value[get[experience]].reverse.to_list.parse[before[/]].find[<[user].id>]>

      - define embed <discord_embed.with_map[<[embed_data]>]>
      - define embed <[embed].add_inline_field[User].value[<[user].mention>(`<[user].name>`)]>
      - define embed <[embed].add_inline_field[Experience].value[`<[experience].format_number>`/`<server.flag[level.experience.<[level].add[1]>].format_number>`]>
      - define embed <[embed].add_inline_field[Rank].value[`<[rank]>`]>

      - ~discordinteraction reply interaction:<context.interaction> <[embed]>


level_chart:
    type: data
    levels:
        1: 0
        2: 83
        3: 174
        4: 276
        5: 388
        6: 512
        7: 650
        8: 801
        9: 969
        10: 1154
        11: 1358
        12: 1584
        13: 1833
        14: 2107
        15: 2411
        16: 2746
        17: 3115
        18: 3523
        19: 3973
        20: 4470
        21: 5018
        22: 5624
        23: 6291
        24: 7028
        25: 7842
        26: 8740
        27: 9730
        28: 10824
        29: 12031
        30: 13363
        31: 14833
        32: 16456
        33: 18247
        34: 20224
        35: 22406
        36: 24815
        37: 27473
        38: 30408
        39: 33648
        40: 37224
        41: 41171
        42: 45529
        43: 50339
        44: 55649
        45: 61512
        46: 67983
        47: 75127
        48: 83014
        49: 91721
        50: 101333
        51: 111945
        52: 123660
        53: 136594
        54: 150872
        55: 166636
        56: 184040
        57: 203254
        58: 224466
        59: 247886
        60: 273742
        61: 302288
        62: 333804
        63: 368599
        64: 407015
        65: 449428
        66: 496254
        67: 547953
        68: 605032
        69: 668051
        70: 737627
        71: 814445
        72: 899257
        73: 992895
        74: 1096278
        75: 1210421
        76: 1336443
        77: 1475581
        78: 1629200
        79: 1798808
        80: 1986068
        81: 2192818
        82: 2421087
        83: 2673114
        84: 2951373
        85: 3258594
        86: 3597792
        87: 3972294
        88: 4385776
        89: 4842295
        90: 5346332
        91: 5902831
        92: 6517253
        93: 7195629
        94: 7944614
        95: 8771558
        96: 9684577
        97: 10692629
        98: 11805606
        99: 13034431
        100: 14391160
        101: 15889109
        102: 17542976
        103: 19368992
        104: 21385073
        105: 23611006
        106: 26068632
        107: 28782069
        108: 31777943
        109: 35085654
        110: 38737661
        111: 42769801
        112: 47221641
        113: 52136869
        114: 57563718
        115: 63555443
        116: 70170840
        117: 77474828
        118: 85539082
        119: 94442737
        120: 104273167
        121: 115126838
        122: 127110260
        123: 140341028
        124: 154948977
        125: 171077457
        126: 188884740
