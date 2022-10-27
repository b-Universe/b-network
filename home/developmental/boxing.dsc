random_names:
  type: data
  debug: false
  names:
    - _neast
    - Arabela_OxO
    - creepyturnipz
    - uJoseph
    - NoteZerZ
    - RENDMOIMESCHIIPS
    - xXia_Mi
    - RisiblesAmours
    - cukie___
    - i_miss_him_
    - neonplayer09
    - Kyning
    - Conflates
    - PotatoBo1Liam
    - Lin_Moo_Hon_Gan
    - zikzikpukpuk
    - shvlyy
    - BonSauciflard
    - Wooshy
    - LordMonke
    - AlbyPr0
    - DucToan_VN
    - GenNi_
    - binghuan1012
    - Alisaku9
    - SSuchAPPain
    - Yanukiii
    - Tacuumseh
    - 123RickCrafter
    - Mantou_san
    - NOT_SimaLife
    - Yukkuri_Aki527CH
    - DRAGONDEFT
    - WoodWind877
    - komp_rogkh0

test_create_audience:
  type: task
  debug: false
  script:
    - define area <player.we_selection>
    - foreach <[area].blocks[quartz_stairs]> as:chair:
      - define location <[chair].center.add[0.35,0,0]>
      - create player <script[random_names].data_key[names].get[<[loop_index]>]> <[location]> save:npc
      - wait 2t
      - look <entry[npc].spawned_npc> <location[407,9,-297,wwe]>
