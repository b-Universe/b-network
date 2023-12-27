suit_handler:
  type: world
  debug: false
  events:
    on player equips *_space_suit_* flagged:!behr.essentials.space_suit_ratelimit:
      - if <player.equipment.filter[script.name.contains_text[_space_suit_]].size> < 3:
        - flag <player> behr.essentials.space_suit_ratelimit expire:1t
        - flag player behr.essentials.space_suit_equipped

    on player unequips *_space_suit_*:
      - if <player.equipment.filter[script.name.contains_text[_space_suit_]].size> < 3:
        - flag player behr.essentials.space_suit_equipped:!
        - cast jump remove

    after player joins flagged:!behr.essentials.players_online:
      - flag server behr.essentials.players_online

    after player quits:
      - if <server.online_players.is_empty>:
        - flag server behr.essentials.players_online:!

    after delta time secondly every:2:
      - define players <server.online_players_flagged[!behr.essentials.space_suit_equipped].filter[is_truthy].filter[location.is_within[biome_mine].not]>
      - stop if:<[players].is_empty>
      # todo: remove
      - define players <[players].filter[gamemode.equals[survival]]>
      - define players <[players].filter[world.name.equals[home_the_end]]>
      - actionbar "<red>OXYGEN WARNING" targets:<[players]>
      - hurt 2 <[players]>

    after delta time secondly every:7 server_flagged:behr.essentials.players_online:
      - define players <server.online_players_flagged[behr.essentials.space_suit_equipped]>
      - cast jump duration:10s amplifier:2 <[players]> hide_particles no_icon no_clear

respira_space_suit_helmet_WC1:
  type: item
  debug: false
  material: player_head
  display name: <&f>Respira Helmet WC1
  mechanisms:
    hides: all
    skull_skin: 89534842-85d7-44a2-a2f8-0650e455ab58|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMWNmOGZiZDc2NTg2OTIwYzUyNzM1MTk5Mjc4NjJmZGMxMTE3MDVhMTg1MWQ0ZDFhYWM0NTBiY2ZkMmIzYSJ9fX0=|

respira_space_suit_helmet_WC2:
  type: item
  debug: false
  material: player_head
  display name: <&f>Respira Helmet WC2
  mechanisms:
    hides: all
    skull_skin: 5e14448d-5f96-4d3e-ba3b-8c077a459737|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWI5MmIwODYyMjY0ZmYyY2JhMWRiZDg4MTkyY2M4MTU0M2ZhYjU0OTY5ZTExN2Q0ZmU0MzUzYjk1MyJ9fX0=|

respira_space_suit_top:
  type: item
  debug: false
  material: leather_chestplate
  display name: <&f>Respira Suit
  mechanisms:
    hides: all
    color: white
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 7
          slot: chest

respira_space_suit_bottom:
  type: item
  debug: false
  material: leather_leggings
  display name: <&f>Respira Suit
  mechanisms:
    hides: all
    color: white
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 7
          slot: legs

respira_space_suit_boots:
  type: item
  debug: false
  material: leather_boots
  display name: <&f>Respira Suit
  mechanisms:
    hides: all
    color: white
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 6
          slot: feet

neptunea_space_suit_helmet:
  type: item
  debug: false
  material: player_head
  display name: <&f>Neptunea Helmet
  mechanisms:
    hides: all
    skull_skin: a15de337-98ad-443c-a217-cfb1e0d0392b|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNTVlMDU1NjZmNTNhMDc2YTA5OTAxNzg1ODFjM2E5YTQ5M2ZjOTMyNDQ5OTRmYmVlZDAxNjMyNTYyMDRkNjYwYyJ9fX0=|

neptunea_space_suit_top:
  type: item
  debug: false
  material: leather_chestplate
  display name: <&f>Neptunea Suit
  mechanisms:
    hides: all
    color: 222,165,74
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 7
          slot: chest

neptunea_space_suit_bottom:
  type: item
  debug: false
  material: leather_leggings
  display name: <&f>Neptunea Suit
  mechanisms:
    hides: all
    color: 222,165,74
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 7
          slot: legs

neptunea_space_suit_boots:
  type: item
  debug: false
  material: leather_boots
  display name: <&f>Neptunea Suit
  mechanisms:
    hides: all
    color: 222,165,74
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 6
          slot: feet

crimson_coppersight_space_suit_helmet:
  type: item
  debug: false
  material: player_head
  display name: <&f>Crimson Coppersight Helmet
  mechanisms:
    hides: all
    skull_skin: b2345824-4025-5615-664f-074062ae3d70|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZTRmNTNmM2Q5OTZlYjYzMDNhYmM5OGI0MmY0YWYwZTdmOTQ1OWM4MGE4ODZkMWM2YWFjMjVlOGFiMDMzZjM3NiJ9fX0=|

crimson_coppersight_space_suit_top:
  type: item
  debug: false
  material: leather_chestplate
  display name: <&f>Crimson Coppersight Suit
  mechanisms:
    hides: all
    color: 145,145,145
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 7
          slot: chest

crimson_coppersight_space_suit_bottom:
  type: item
  debug: false
  material: leather_leggings
  display name: <&f>Crimson Coppersight Suit
  mechanisms:
    hides: all
    color: 145,145,145
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 7
          slot: legs

crimson_coppersight_space_suit_boots:
  type: item
  debug: false
  material: leather_boots
  display name: <&f>Crimson Coppersight Suit
  mechanisms:
    hides: all
    color: 145,145,145
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 6
          slot: feet

copperclad_space_suit_helmet:
  type: item
  debug: false
  material: player_head
  display name: <&f>Copperclad Exosuit Helmet
  mechanisms:
    hides: all
    skull_skin: 970e0a59-b95d-45a9-9039-b43ac4fbfc7c|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTA1NjQ4MTdmY2M4ZGQ1MWJjMTk1N2MwYjdlYTE0MmRiNjg3ZGQ2ZjFjYWFmZDM1YmI0ZGNmZWU1OTI0MjFjIn19fQ==|

copperclad_space_suit_top:
  type: item
  debug: false
  material: leather_chestplate
  display name: <&f>Copperclad Exosuit
  mechanisms:
    hides: all
    color: 174,114,10
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 7
          slot: chest
copperclad_space_suit_bottom:
  type: item
  debug: false
  material: leather_leggings
  display name: <&f>Copperclad Exosuit
  mechanisms:
    hides: all
    color: 174,114,10
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 7
          slot: legs
copperclad_space_suit_boots:
  type: item
  debug: false
  material: leather_boots
  display name: <&f>Copperclad Exosuit
  mechanisms:
    hides: all
    color: 235,215,14
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 6
          slot: feet

bio_verdigris_space_suit_helmet:
  type: item
  debug: false
  material: player_head
  display name: <&f>Copperclad Exosuit Helmet
  mechanisms:
    hides: all
    skull_skin: bb8529ed-0908-4708-97fd-a22180dcc327|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNjIwNzZiNTRkMmFjOGRmNjVmODg4N2I0MTRhMjYzOGExZWJjMzU5MjA5Y2U1NWZmODcyZjYwYmQyZDA0YTU3MiJ9fX0=|

bio_verdigris_space_suit_top:
  type: item
  debug: false
  material: leather_chestplate
  display name: <&f>Copperclad Exosuit
  mechanisms:
    hides: all
    color: 235,215,14
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 7
          slot: chest
bio_verdigris_space_suit_bottom:
  type: item
  debug: false
  material: leather_leggings
  display name: <&f>Bio-Verdigris Exosuit
  mechanisms:
    hides: all
    color: 235,215,14
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 7
          slot: legs
bio_verdigris_space_suit_boots:
  type: item
  debug: false
  material: leather_boots
  display name: <&f>Bio-Verdigris Exosuit
  mechanisms:
    hides: all
    color: 235,215,14
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 6
          slot: feet

cryo_verdigris_space_suit_helmet:
  type: item
  debug: false
  material: player_head
  display name: <&f>Cryo Verdigris Exosuit
  mechanisms:
    hides: all
    skull_skin: 70562cc3-7c90-4032-89e8-c38fe58e8ce1|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYmE5YWYwYjhhZDYwNzFkM2I1MTllMTI0NWIxNjQzZmJhNjQ0ZDE5MTc3MTIwM2M0YTA1OTY4ZjE3NmM5YWEwOSJ9fX0=|

cryo_verdigris_space_suit_top:
  type: item
  debug: false
  material: leather_chestplate
  display name: <&f>Cryo Verdigris Exosuit
  mechanisms:
    hides: all
    color: blue
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 7
          slot: chest
cryo_verdigris_space_suit_bottom:
  type: item
  debug: false
  material: leather_leggings
  display name: <&f>Cryo Verdigris Exosuit
  mechanisms:
    hides: all
    color: blue
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 7
          slot: legs
cryo_verdigris_space_suit_boots:
  type: item
  debug: false
  material: leather_boots
  display name: <&f>Cryo Verdigris Exosuit
  mechanisms:
    hides: all
    color: blue
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 6
          slot: feet

nordic_glacier_space_suit_helmet:
  type: item
  debug: false
  material: player_head
  display name: <&f>Nordic Glacier Space Armor Helmet
  mechanisms:
    hides: all
    skull_skin: 4f1e87a0-9642-4480-82d8-fa675daf004b|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvODJmYWQ4MDY4N2U2OTVhMDA1NjdhZGNhMzMzMThmYzdmODEyNmVjZjJkYmUwMGJkYmUxZGI0ZWI2NmU5MmI5NyJ9fX0=|

nordic_glacier_space_suit_top:
  type: item
  debug: false
  material: leather_chestplate
  display name: <&f>Nordic Glacier Space Armor
  mechanisms:
    hides: all
    color: blue
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 7
          slot: chest
nordic_glacier_space_suit_bottom:
  type: item
  debug: false
  material: leather_leggings
  display name: <&f>Nordic Glacier Space Armor
  mechanisms:
    hides: all
    color: blue
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 7
          slot: legs
nordic_glacier_space_suit_boots:
  type: item
  debug: false
  material: leather_boots
  display name: <&f>Nordic Glacier Space Armor
  mechanisms:
    hides: all
    color: blue
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 6
          slot: feet
