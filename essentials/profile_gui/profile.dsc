
profile_main_menu:
  type: inventory
  debug: false
  inventory: chest
  title: <script.parsed_key[data.title].unseparated>
  data:
    title:
      - <proc[bbackground].context[36|e001]>
      - <&color[<proc[prgb]>]><element[Profile].color[<proc[argb]>].font[minecraft_8.5]>
      - <proc[negative_spacing].context[16]>
      #- <element[Cheesebehrgeur].color_gradient[from=#FF0000;to=#0000FF;style=hsb].font[minecraft_18]>
      - <element[<player.name>].font[minecraft_18]>
      - <proc[negative_spacing].context[<player.name.text_width>]>
      - <element[@Hydra Melody].font[minecraft_27]>
    intro_lore:
      1: <&color[<proc[prgb]>]><player.name><&color[<proc[argb]>]><&co> Hey you, it's me, you!~
      2:
        - <&color[<proc[argb]>]>This is your profile page. In the
        - <&color[<proc[argb]>]>tabs above you can find different
        - <&color[<proc[argb]>]>pages to change settings and check
        - <&color[<proc[argb]>]>out your stats, badges, and stuff!
  size: 36
  gui: true
  definitions:
    x: air
  procedural items:
    - define items <list>
    - define display <script.parsed_key[data.intro_lore.1]>
    - define lore <script.parsed_key[data.intro_lore.2]>
    - define items <[items].include_single[<item[profile_button].with[skull_skin=<player.skull_skin>;display=<&color[<proc[argb]>]>Profile]>]>
    - define items <[items].include[<item[player_head].with[custom_model_data=1053;display=<&color[<proc[argb]>]>Profile].repeat_as_list[2]>]>
    - define items <[items].include_single[<item[color_menu_button].with[display=<&color[<proc[argb]>]>Color Settings]>]>
    - define items <[items].include_single[<item[b_commands_button].with[display=<&color[<proc[argb]>]>B Command Settings]>]>
    - define items <[items].include_single[<item[profile_face_angled].with[skull_skin=<player.skull_skin>;display=<[display]>;lore=<[lore]>]>]>
    - define items <[items].include_single[<item[profile_body_suited].with[display=<[display]>;lore=<[lore]>]>]>
    - define equipment_map <player.equipment_map>
    - definemap item_map:
        Helmet: <[equipment_map].get[helmet].if_null[null]>
        Chestplate: <[equipment_map].get[chestplate].if_null[null]>
        Leggings: <[equipment_map].get[leggings].if_null[null]>
        Boots: <[equipment_map].get[boots].if_null[null]>
        Item in hand: <player.item_in_hand>
        Item in offhandhand: <player.item_in_offhand>
    - foreach <[item_map]> key:slot as:item:
      - if <[item].is_truthy>:
        - define items <[items].include_single[<[item]>]>
      - else:
        - define new_item <item[profile_blank_item_slot].with[display=<&color[<proc[prgb]>]><[slot]>;custom_model_data=<[loop_index].add[1041]>]>
        - define items <[items].include_single[<[new_item]>]>
    - define items <[items].include[close_button]>
    - determine <[items]>
  slots:
    - [] [] [] [] [] [x] [x] [x] [x]
    - [] [x] [x] [x] [x] [x] [x] [x] [x]
    - [] [x] [x] [x] [x] [x] [x] [x] [x]
    - [] [] [] [] [] [] [] [x] [x]

profile_menu_handler:
  type: world
  debug: false
  events:
    on player clicks profile_button in !profile_main_menu:
      - inventory open d:profile_main_menu
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

profile_button:
  debug: false
  type: item
  material: player_head
  mechanisms:
    custom_model_data: 1054
profile_face_angled:
  debug: false
  type: item
  material: player_head
  mechanisms:
    custom_model_data: 1000
profile_body_suited:
  debug: false
  type: item
  material: potion
  mechanisms:
    custom_model_data: 2
    hides: all
    color: <proc[argb]>
profile_blank_item_slot:
  debug: false
  type: item
  material: player_head
