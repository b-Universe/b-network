# new flags:
# - server behr.essentials.soundboard.total_sound_pages
# - player behr.essentials.soundboard.active_page

soundboard_command:
  type: command
  debug: false
  name: soundboard
  usage: /soundboard (search <&lt>criteria<&gt>/page <&lt><&ns><&gt>/favorites/play <&lt>sound<&gt>)
  description: Utilizes the Soundboard to test and experiment with sounds
  script:
    - if <context.args.size> > 2:
      - inject command_syntax_error

    - playsound <player> entity_player_levelup pitch:<util.random.int[8].to[12].div[10]> volume:0.3
    - if <context.args.is_empty>:
      - inventory open d:soundboard_main_menu
      - if !<player.has_flag[behr.essentials.soundboard.favorites]>:
        - inventory adjust d:<player.open_inventory> slot:5 material:black_stained_glass
        - inventory adjust d:<player.open_inventory> slot:5 "display:<&8>Favorited sounds"
        - inventory adjust d:<player.open_inventory> slot:5 "lore:<&[fancy_yellow_1]>Shows your favorited sounds;|<&[fancy_yellow_2]>If you had any, anyways"

    - else:
      - choose <context.args.first>:
        - case search:
          - narrate search
        - case page:
          - narrate page
        - case favorites:
          - narrate favorites

        - case play:
          - if <context.args.size> != 2:
            - inject command_syntax_error

          - define sound <context.args.last>

          - if !<server.sound_types.contains[<[sound]>]>:
            - define reason "Invalid sound name"
            - inject command_error
          - else:
            - playsound <player> <[sound]>


testing_soundboard:
  type: world
  debug: false
  events:
    after player clicks in soundboard_sound_menu:
      - stop if:<context.item.material.name.equals[air].if_null[true]>
      - choose <context.item.script.name.if_null[invalid]>:
        - case bsoundboard_first_page_button:
          - run bsoundboard_page_selection def:1
        - case bsoundboard_previous_page_button:
          - run bsoundboard_page_selection def:<player.flag[behr.essentials.soundboard.active_page].sub[1].min[<server.flag[behr.essentials.soundboard.total_sound_pages]>].max[1]>

        - case bsoundboard_main_menu_button:
          - inventory open d:soundboard_main_menu
          - if !<player.has_flag[behr.essentials.soundboard.favorites]>:
            - inventory adjust d:<player.open_inventory> slot:5 material:black_stained_glass
            - inventory adjust d:<player.open_inventory> slot:5 "display:<&8>Favorited sounds"
            - inventory adjust d:<player.open_inventory> slot:5 "lore:<&[fancy_yellow_1]>Shows your favorited sounds;|<&[fancy_yellow_2]>If you had any, anyways"

        - case bsoundboard_stop_sound_button:
          - adjust <player> stop_sound

        - case bsoundboard_favorites_button:
          - if !<player.has_flag[behr.essentials.soundboard.favorites]>:
            - playsound <player> pitch:1 block_candle_extinguish
            - actionbar "<&[red]>You have no favorited sounds."
            #- narrate "<&[red]>You have no favorited sounds."
          - else:
            - playsound <player> entity_ender_eye_death pitch:<util.random.int[8].to[12].div[10]> volume:0.3
            - inventory open d:soundboard_favorites_menu

        - case bsoundboard_favorites_disabled_button:
          - playsound <player> pitch:1 block_candle_extinguish
          - actionbar "<&[red]>You have no favorited sounds."
          #- narrate "<&[red]>You have no favorited sounds."

        - case bsoundboard_pitch_button:
          - playsound <player> entity_ender_eye_death pitch:<util.random.int[8].to[12].div[10]> volume:0.3

        - case bsoundboard_search_button:
          - playsound <player> entity_ender_eye_death pitch:<util.random.int[8].to[12].div[10]> volume:0.3

        - case bsoundboard_next_page_button:
          - run bsoundboard_page_selection def:<player.flag[behr.essentials.soundboard.active_page].add[1].min[<server.flag[behr.essentials.soundboard.total_sound_pages]>].max[1]>
        - case bsoundboard_last_page_button:
          - run bsoundboard_page_selection def:<server.flag[behr.essentials.soundboard.total_sound_pages]>

      - stop if:!<context.item.has_flag[sound]>
      - define sound <context.item.flag[sound]>
      - choose <context.click>:
        - case left:
          - playsound <player> <[sound]>

        - case right:
          - define copy_text "- playsound <&lt>player<&gt> <[sound]>"
          - narrate "<&a>Click to copy to clipboard<&co> <&b><underline><[sound].on_click[<[copy_text]>].type[copy_to_clipboard]>"
          - playsound <player> <[sound]>

        - case shift_left:
          #- playsound <player> <[sound]>
          - drop <item[dsoundboard_music_disc].with[display=<&[fancy_title]><[sound].to_titlecase.replace_text[_].with[ ]>].with_flag[sound:<[sound]>]>

        - case shift_right:
          - playsound <player> <[sound]>

    after player clicks block with:dsoundboard_music_disc:
      - define sound <context.item.flag[sound]>
      - if <context.click_type.contains_any_text[left]>:
        - playsound <player> <[sound]>
      - else:
        - define copy_text "- playsound <&lt>player<&gt> <[sound]>"
        #- define hover_text "<&[green]>Click to copy<&co><n><&[yellow]><[sound]>" .on_hover[<[hover_text]>]
        - narrate "<&a>Click to copy to clipboard<&co> <[sound].on_click[<[copy_text]>].type[copy_to_clipboard]>"
        - playsound <player> <[sound]>

    after player drops dsoundboard_music_disc:
      - define disc_entity <context.entity>
      - define sound <context.item.flag[sound]>
      #@- spawn test_text_entity <[disc_entity].location.above[0.6]> save:hologram
      - spawn temp_hologram[custom_name=<&[green]><[sound].to_titlecase.replace_text[_].with[ ]>] <[disc_entity].location.above[0.6]> save:hologram
      - define hologram <entry[hologram].spawned_entity>
      - attach <[hologram]> to:<[disc_entity]> offset:0,0.6,0
      - define timer 10
      #@- adjust <[hologram]> display_entity_data:<[hologram].display_entity_data.with[text].as[<&[green]><[sound].to_titlecase.replace_text[_].with[ ]>]>
      - adjust <[disc_entity]> custom_name:<&[red]>10s
      - wait 1s
      - adjust <[disc_entity]> custom_name_visible:true
      - adjust <[hologram]> custom_name_visible:true
      - waituntil <[disc_entity].is_on_ground> rate:5t max:10s
      - define color <color[0,255,0]>
      - while <[disc_entity].is_truthy> && <[timer]> > 0:
        # from green to red; time (10s) / rate (2t) == 100 cycles; 255 / 3 == 85; 85 / 100 == 0.85; loop index * -0.85 starting at green (hue 85)
        - define color <[color].with_hue[<[loop_index].mul[-0.85].round.add[85]>]>
        - adjust <[disc_entity]> custom_name:<&color[<[color]>]><[timer].sub[0.1].format_number[0.0]>s
        - define timer:-:0.1
        - define location <[disc_entity].location.above[0.2]>
        - wait 2t

      - wait 4t
      - if <[disc_entity].is_truthy>:
        - playeffect effect:smoke at:<[location]> quantity:10 offset:0.2
        - playeffect effect:cloud at:<[location]> quantity:4 offset:0.2
        - playsound <[location]> pitch:1 block_candle_extinguish
        - wait 2t
        - remove <[disc_entity]> if:<[disc_entity].is_truthy>
      - remove <[hologram]> if:<[hologram].is_truthy>

      - wait 10t
      - playsound <[location]> pitch:1 <[sound]>

test_text_entity:
  type: entity
  debug: false
  entity_type: text_display
  mechanisms:
    display_entity_data:
      transformation_scale: 1,1,1
      #text: hi
      transformation_left_rotation: 0|0|0|1
      transformation_right_rotation: 0|0|0|1
      transformation_translation: 0,0,0
      view_range: 100
      billboard: center
      #brightness_block: 15
      #brightness_sky: 15

temp_hologram:
  type: entity
  entity_type: armor_stand
  mechanisms:
    visible: false
    marker: true

dsoundboard_music_disc:
  type: item
  debug: false
  material: music_disc_13
  lore:
    - <&[fancy_green_1]>Left click<&co> <&[fancy_yellow_1]>Play Sound
    - <&[fancy_green_2]>Right click<&co> <&[fancy_yellow_2]>Copy sound
  enchantments:
    - vanishing_curse:1
  mechanisms:
    hides: all

bsoundboard_page_selection:
  type: task
  debug: false
  definitions: page
  script:
    - playsound <player> entity_ender_eye_death pitch:<util.random.int[8].to[12].div[10]> volume:0.3
    - define page 1 if:!<[page].is_truthy>
    - flag player behr.essentials.soundboard.active_page:<[page]>
    - define items <server.flag[behr.essentials.soundboard.sound_page.<[page]>]>
    - define sound_menu <inventory[soundboard_sound_menu]>
    - inventory set d:<[sound_menu]> o:<[items]> slot:1
    # todo:  add | Sounds | to title after font
    - adjust <[sound_menu]> "title:<&[fancy_title]>bSoundBoard ( page <[page]> / <server.flag[behr.essentials.soundboard.total_sound_pages]> )"
    - if <[page]> == 1:
      - inventory set d:<[sound_menu]> o:air|air slot:46
    - else if <[page]> == 2:
      - inventory set d:<[sound_menu]> o:air slot:46
    - else if <[page]> == <server.flag[behr.essentials.soundboard.total_sound_pages].sub[1]>:
      - inventory set d:<[sound_menu]> o:air slot:54
    - else if <[page]> == <server.flag[behr.essentials.soundboard.total_sound_pages]>:
      - inventory set d:<[sound_menu]> o:air|air slot:53

    - if !<player.has_flag[behr.essentials.soundboard.favorites]>:
      - inventory set d:<[sound_menu]> o:bsoundboard_favorites_disabled_button slot:50

    - inventory open d:<[sound_menu]>


soundboard_handler:
  type: world
  debug: false
  data:
    lore:
      - <&[fancy_green_1]>Left click<&co> <&[fancy_yellow_1]>Play Sound
      - <&[fancy_green_2]>Right click<&co> <&[fancy_yellow_2]>Copy sound
      - <&[fancy_green_3]>Ctrl-Left click<&co> <&[fancy_yellow_3]>Drop soundtrack of sound
      - <&[fancy_green_4]>Ctrl-Right click<&co> <&[fancy_yellow_4]>Add sound to favorites
  events:
    after server start:
      - define sounds <server.sound_types>
      - define sound_pages <[sounds].sub_lists[45]>
      - flag server behr.essentials.soundboard.total_sounds:<[sounds].size>
      - flag server behr.essentials.soundboard.total_sound_pages:<[sound_pages].size>
      - if !<server.has_flag[behr.essentials.soundboard.cached]>:
        - define data <map>
        - foreach <[sound_pages]> as:sound_list:
          - define sound_list_items <list>
          - foreach <[sound_list]> as:sound:
            - define item <[sound].proc[soundgui_itemproc]>
            - define item <[item].as[item].with[display=<&[fancy_title]><[sound].to_titlecase.replace_text[_].with[ ]>]>
            - define item <[item].with_single[lore=<script.parsed_key[data.lore]>]>
            - define item <[item].with_flag[sound:<[sound]>]>
            - define sound_list_items <[sound_list_items].include_single[<[item]>]>
          - define data <[data].with[<[loop_index]>].as[<[sound_list_items]>]>
        - flag server behr.essentials.soundboard.sound_page:<[data]>
        #- flag server behr.essentials.soundboard.cached

    after player clicks bsoundboard_all_sounds_button in soundboard_main_menu:
      - playsound <player> entity_ender_eye_death pitch:<util.random.int[8].to[12].div[10]> volume:0.3
      - define page 1
      - flag player behr.essentials.soundboard.active_page:1
      - define items <server.flag[behr.essentials.soundboard.sound_page.<[page]>]>
      - define sound_menu <inventory[soundboard_sound_menu]>
      - inventory set d:<[sound_menu]> o:<[items]> slot:1
      # todo:  add | Sounds | to title after font
      - adjust <[sound_menu]> "title:<&[fancy_title]>bSoundBoard ( page <[page]> / <server.flag[behr.essentials.soundboard.total_sound_pages]> )"
      - inventory open d:<[sound_menu]>





soundboard_main_menu:
  type: inventory
  debug: false
  inventory: chest
  title: <&[fancy_title]>bSoundBoard
  gui: true
  definitions:
    1: bsoundboard_all_sounds_button
    2: bsoundboard_favorites_button
    3: bsoundboard_search_button
  slots:
    - [] [] [1] [] [2] [] [3] [] []
    # main menu:
    # [] [] [Soundbar_Menu] [] [Favorites] [] [Search] [] []

soundboard_sound_menu:
  type: inventory
  debug: false
  inventory: chest
  title: <&[fancy_title]>bSoundBoard | Sounds | ( page <&ns> of <server.flag[behr.essentials.soundboard.sound_page].size> )
  gui: true
  size: 54
  definitions:
    1: bsoundboard_first_page_button
    2: bsoundboard_previous_page_button
    3: bsoundboard_main_menu_button
    4: bsoundboard_stop_sound_button
    5: bsoundboard_favorites_button
    6: bsoundboard_pitch_button
    7: bsoundboard_search_button
    8: bsoundboard_next_page_button
    9: bsoundboard_last_page_button
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [1] [2] [3] [4] [5] [6] [7] [8] [9]
    # main menu:
    # [     ] [    ] [main menu] [          ] [favorites] [        ] [search  ] [     ] [    ]

    # sound menu:
    # [first] [left] [main menu] [stop sound] [favorites] [pitch+/-] [search  ] [right] [last]

    # favorites menu:
    # [first] [left] [main menu] [stop sound] [favorites] [pitch+/-] [search  ] [right] [last]

    # search menu:
    # [first] [left] [main menu] [stop sound] [favorites] [pitch+/-] [research] [right] [last]

bsoundboard_main_menu_button:
  type: item
  debug: false
  material: yellow_stained_glass
  display name: <&[fancy_title]>Go to main menu

bsoundboard_all_sounds_button:
  type: item
  debug: false
  material: white_stained_glass
  display name: <&[fancy_title]>All sounds
  lore:
  - <&[fancy_yellow_1]>Shows all current <&lb><server.sound_types.size><&rb> sounds
  - <&[fancy_yellow_2]>Preview, favorite, or use for development

bsoundboard_favorites_button:
  type: item
  debug: false
  material: light_blue_stained_glass
  display name: <&[fancy_title]>Favorited sounds
  lore:
  - <&[fancy_yellow_1]>Shows all current <&lb><player.flag[behr.essentials.soundboard.favorites].size.if_null[0]><&rb> favorited sounds
  - <&[fancy_yellow_2]>Preview, manage favorites, or use for development

bsoundboard_favorites_disabled_button:
  type: item
  debug: false
  material: black_stained_glass
  display name: <&8>Favorited sounds
  lore:
  - <&[fancy_yellow_1]>Shows your favorited sounds;
  - <&[fancy_yellow_2]>If you had any, anyways

bsoundboard_search_button:
  type: item
  debug: false
  material: blue_stained_glass
  display name: <&[fancy_title]>Search sounds
  lore:
  - <&[fancy_yellow_1]>Shows all sounds matching a search criteria

bsoundboard_first_page_button:
  type: item
  debug: false
  material: red_stained_glass
  display name: <&[fancy_title]>Go to first page

bsoundboard_next_page_button:
  type: item
  debug: false
  material: purple_stained_glass
  display name: <&[fancy_title]>Go to next page

bsoundboard_previous_page_button:
  type: item
  debug: false
  material: orange_stained_glass
  display name: <&[fancy_title]>Go to previous page

bsoundboard_last_page_button:
  type: item
  debug: false
  material: pink_stained_glass
  display name: <&[fancy_title]>Go to last page

bsoundboard_stop_sound_button:
  type: item
  debug: false
  material: lime_stained_glass
  display name: <&[fancy_title]>Stop sounds

bsoundboard_pitch_button:
  type: item
  debug: false
  material: cyan_stained_glass
  display name: <&[fancy_title]>Change pitch of sound
  lore:
    - <&[fancy_green_1]>Left click<&co> <&[fancy_yellow_1]>Increase pitch by 0.1
    - <&[fancy_green_2]>Right click<&co> <&[fancy_yellow_2]>Decrease pitch by 0.1
    - <&[fancy_green_3]>Shift-Left click<&co> <&[fancy_yellow_3]>Increase pitch by 1
    - <&[fancy_green_4]>Shift-Right click<&co> <&[fancy_yellow_4]>Decrease pitch by 1


bsoundboard_sounds_menu:
  type: inventory
  debug: false
  inventory: chest
  #title: <&[fancy_title]>bSoundBoard ( page # of # )
  gui: true

bsoundboard_favorites_menu:
  type: inventory
  debug: false
  inventory: chest
  #title: <&[fancy_title]>bSoundBoard
  gui: true
  slots:
    - [] [] [] [] [] [] [] [] []

bsoundboard_search_menu:
  type: inventory
  debug: false
  inventory: chest
  #title: <&[fancy_title]>bSoundBoard
  gui: true
  slots:
    - [] [] [] [] [] [] [] [] []



# soundgui_itemproc script credits:
# @author Apademide
# @edited Bear / Hydra
# @date 2021-09-12
# @denizen-build 1.2.1-b5752-DEV
# @script-version 1.0
soundgui_itemproc:
  type: procedure
  definitions: SOUND
  debug: false
  script:
  - choose <[SOUND].before[_]>:
    - case AMBIENT:
      - determine <script.data_key[data.AMBIENT.CUSTOMS.<[SOUND]>].if_null[red_stained_glass]>
    - case BLOCK:
      - determine <script.data_key[data.BLOCKS.CUSTOMS.<[SOUND]>].if_null[<script.data_key[data.BLOCKS.MATERIALS].filter_tag[<[FILTER_VALUE].advanced_matches[*<[SOUND].after[BLOCK_].before[_]>*]>].first.if_null[red_stained_glass]>]>
    - case ENTITY:
      - determine <script.data_key[data.ENTITIES.CUSTOMS.<[SOUND]>].if_null[<script.data_key[data.ENTITIES.MATERIALS].filter_tag[<[FILTER_VALUE].advanced_matches[*<[SOUND].after[ENTITY_].before[_]>*]>].first.if_null[red_stained_glass]>]>
    - case ITEM:
      - determine <script.data_key[data.ITEMS.CUSTOMS.<[SOUND]>].if_null[<script.data_key[data.ITEMS.MATERIALS].filter_tag[<[FILTER_VALUE].advanced_matches[*<[SOUND].after[ITEM_].before[_]>*]>].first.if_null[red_stained_glass]>]>
    - default:
      - if <material[<[SOUND]>].is_item.if_null[false]>:
        - determine <[SOUND]>
      #- determine NOTE_BLOCK
      - determine white_stained_glass
  data:
    AMBIENT:
      CUSTOMS:
        AMBIENT_BASALT_DELTAS_ADDITIONS: music_disc_pigstep
        AMBIENT_BASALT_DELTAS_LOOP: music_disc_pigstep
        AMBIENT_BASALT_DELTAS_MOOD: music_disc_pigstep
        AMBIENT_CAVE: music_disc_13
        AMBIENT_CRIMSON_FOREST_ADDITIONS: music_disc_blocks
        AMBIENT_CRIMSON_FOREST_LOOP: music_disc_blocks
        AMBIENT_CRIMSON_FOREST_MOOD: music_disc_blocks
        AMBIENT_NETHER_WASTES_ADDITIONS: music_disc_chirp
        AMBIENT_NETHER_WASTES_LOOP: music_disc_chirp
        AMBIENT_NETHER_WASTES_MOOD: music_disc_chirp
        AMBIENT_SOUL_SAND_VALLEY_ADDITIONS: music_disc_stal
        AMBIENT_SOUL_SAND_VALLEY_LOOP: music_disc_stal
        AMBIENT_SOUL_SAND_VALLEY_MOOD: music_disc_stal
        AMBIENT_UNDERWATER_ENTER: music_disc_wait
        AMBIENT_UNDERWATER_EXIT: music_disc_wait
        AMBIENT_UNDERWATER_LOOP: music_disc_wait
        AMBIENT_UNDERWATER_LOOP_ADDITIONS: music_disc_wait
        AMBIENT_UNDERWATER_LOOP_ADDITIONS_RARE: music_disc_wait
        AMBIENT_UNDERWATER_LOOP_ADDITIONS_ULTRA_RARE: music_disc_wait
        AMBIENT_WARPED_FOREST_ADDITIONS: music_disc_5
        AMBIENT_WARPED_FOREST_LOOP: music_disc_5
        AMBIENT_WARPED_FOREST_MOOD: music_disc_5
      MATERIALS:
        idk: something
    ITEMS:
      CUSTOMS:
        ITEM_CROP_PLANT: wheat
        ITEM_FIRECHARGE_USE: fire_charge
        ITEM_FLINTANDSTEEL_USE: flint_and_steel
      MATERIALS:
      - armor_stand
      - waxed_copper_block
      - bone_block
      - bookshelf
      - glass_bottle
      - bucket
      - chorus_plant
      - crossbow
      - white_dye
      - elytra
      - glowstone
      - wooden_hoe
      - honeycomb
      - honey_block
      - pink_wool
      - lodestone
      - nether_gold_ore
      - shield
      - wooden_shovel
      - spyglass
      - totem_of_undying
      - trident
    ENTITIES:
      CUSTOMS:
        ENTITY_GENERIC_BIG_FALL: leather_boots
        ENTITY_GENERIC_BURN: flint_and_steel
        ENTITY_GENERIC_DEATH: iron_sword
        ENTITY_GENERIC_DRINK: glass_bottle
        ENTITY_GENERIC_EAT: cooked_beef
        ENTITY_GENERIC_EXPLODE: tnt
        ENTITY_GENERIC_EXTINGUISH_FIRE: flint_and_steel
        ENTITY_GENERIC_HURT: iron_sword
        ENTITY_GENERIC_SMALL_FALL: leather_boots
        ENTITY_GENERIC_SPLASH: water_bucket
        ENTITY_GENERIC_SWIM: water_bucket
        ENTITY_HOSTILE_BIG_FALL: leather_boots
        ENTITY_HOSTILE_DEATH: iron_sword
        ENTITY_HOSTILE_HURT: iron_sword
        ENTITY_HOSTILE_SMALL_FALL: leather_boots
        ENTITY_HOSTILE_SPLASH: water_bucket
        ENTITY_HOSTILE_SWIM: water_bucket
        ENTITY_ILLUSIONER_AMBIENT: splash_potion
        ENTITY_ILLUSIONER_CAST_SPELL: splash_potion
        ENTITY_ILLUSIONER_DEATH: splash_potion
        ENTITY_ILLUSIONER_HURT: splash_potion
        ENTITY_ILLUSIONER_MIRROR_MOVE: splash_potion
        ENTITY_ILLUSIONER_PREPARE_BLINDNESS: splash_potion
        ENTITY_ILLUSIONER_PREPARE_MIRROR: splash_potion
        ENTITY_LEASH_KNOT_BREAK: lead
        ENTITY_LEASH_KNOT_PLACE: lead
      MATERIALS:
      - armor_stand
      - arrow
      - axolotl_bucket
      - bat_spawn_egg
      - beef
      - blaze_rod
      - oak_boat
      - cat_spawn_egg
      - chicken
      - cod_bucket
      - cow_spawn_egg
      - creeper_spawn_egg
      - dolphin_spawn_egg
      - donkey_spawn_egg
      - dragon_egg
      - drowned_spawn_egg
      - elder_guardian_spawn_egg
      - enderman_spawn_egg
      - endermite_spawn_egg
      - ender_chest
      - evoker_spawn_egg
      - experience_bottle
      - firework_rocket
      - fishing_rod
      - pufferfish
      - fox_spawn_egg
      - ghast_tear
      - glowstone
      - goat_spawn_egg
      - hoglin_spawn_egg
      - horse_spawn_egg
      - husk_spawn_egg
      - iron_ore
      - item_frame
      - lightning_rod
      - lingering_potion
      - llama_spawn_egg
      - magma_block
      - minecart
      - mooshroom_spawn_egg
      - mule_spawn_egg
      - ocelot_spawn_egg
      - painting
      - panda_spawn_egg
      - parrot_spawn_egg
      - phantom_spawn_egg
      - piglin_spawn_egg
      - pig_spawn_egg
      - pillager_spawn_egg
      - player_head
      - polar_bear_spawn_egg
      - rabbit_spawn_egg
      - ravager_spawn_egg
      - salmon_bucket
      - sheep_spawn_egg
      - shulker_box
      - silverfish_spawn_egg
      - skeleton_spawn_egg
      - slime_block
      - snowball
      - snow
      - spider_eye
      - splash_potion
      - glow_squid_spawn_egg
      - stray_spawn_egg
      - strider_spawn_egg
      - tnt
      - tropical_fish_bucket
      - turtle_egg
      - vex_spawn_egg
      - villager_spawn_egg
      - vindicator_spawn_egg
      - wandering_trader_spawn_egg
      - witch_spawn_egg
      - wither_rose
      - wolf_spawn_egg
      - zoglin_spawn_egg
      - zombie_spawn_egg
      - zombified_piglin_spawn_egg
    BLOCKS:
      CUSTOMS:
        BLOCK_CROP_BREAK: wheat
        BLOCK_BLASTFURNACE_FIRE_CRACKLE: blast_furnace
        BLOCK_ENCHANTMENT_TABLE_USE: enchanting_table
        BLOCK_METAL_BREAK: iron_block
        BLOCK_METAL_FALL: iron_block
        BLOCK_METAL_HIT: iron_block
        BLOCK_METAL_PLACE: iron_block
        BLOCK_METAL_PRESSURE_PLATE_CLICK_OFF: iron_block
        BLOCK_METAL_PRESSURE_PLATE_CLICK_ON: iron_block
        BLOCK_METAL_STEP: iron_block
      MATERIALS:
      - amethyst_block
      - ancient_debris
      - anvil
      - azalea_leaves
      - bamboo
      - barrel
      - basalt
      - beacon
      - beehive
      - bell
      - big_dripleaf
      - bone_block
      - brewing_stand
      - dead_bubble_coral_block
      - cake
      - calcite
      - campfire
      - candle
      - cave_spider_spawn_egg
      - chain
      - chest
      - chorus_plant
      - comparator
      - composter
      - conduit
      - copper_ore
      - dead_tube_coral_block
      - deepslate
      - dispenser
      - dripstone_block
      - ender_chest
      - end_rod
      - oak_fence
      - dead_fire_coral_block
      - flowering_azalea_leaves
      - crimson_fungus
      - furnace
      - gilded_blackstone
      - glass
      - grass_block
      - gravel
      - grindstone
      - hanging_roots
      - honey_block
      - iron_ore
      - ladder
      - jack_o_lantern
      - large_fern
      - lava_bucket
      - lever
      - lily_of_the_valley
      - lodestone
      - medium_amethyst_bud
      - moss_carpet
      - netherite_block
      - netherrack
      - nether_gold_ore
      - note_block
      - crimson_nylium
      - piston
      - pointed_dripstone
      - polished_granite
      - end_portal_frame
      - white_concrete_powder
      - pumpkin
      - redstone_ore
      - respawn_anchor
      - rooted_dirt
      - crimson_roots
      - sand
      - scaffolding
      - sculk_sensor
      - shroomlight
      - shulker_box
      - slime_block
      - small_dripleaf
      - smithing_table
      - smoker
      - snow
      - soul_sand
      - spore_blossom
      - crimson_stem
      - stone
      - sweet_berries
      - tripwire_hook
      - tuff
      - weeping_vines
      - nether_wart_block
      - water_bucket
      - wet_sponge
      - wooden_sword
      - stripped_oak_wood
      - white_wool
