experience_handler:
  type: world
  debug: false
  events:
    on player breaks block in:!biome_mine:
      - if !<player.has_flag[behr.essentials.profile.stats.construction]>:
        - flag player behr.essentials.profile.stats.construction.experience:0
        - flag player behr.essentials.profile.stats.construction.level:1

      - flag player behr.essentials.profile.stats.construction.experience:+:<util.random.int[1].to[5]>

      - flag player behr.essentials.waitlist.construction_experience expire:5s
      - waituntil !<player.has_flag[behr.essentials.waitlist.construction_experience]>
      - inject check_for_levelup

      #- definemap data:
      #    player: <player>
      #    time: <util.time_now>
      #- flag <context.location> behr.essentials.block_data:<[data]>

check_for_levelup:
  type: task
  debug: false
  script:
    - define construction <player.flag[behr.essentials.profile.stats.construction]>

    - define next_level <[construction.level].add[1]>
    - if <[construction.experience]> > <script[level_chart].data_key[level.<[next_level]>]>:
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3
      - toast "<&[green]>Construction Levelup<&co> <&[yellow]><[next_level]>" frame:goal icon:bricks
      - narrate "<&[green]>You leveled up! Construction level<&co> <&[yellow]><[next_level]>"
      - flag player behr.essentials.profile.stats.construction.level:++

level_chart:
  type: data
  level:
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
    127: 200000000
    169: 6969696969696969
