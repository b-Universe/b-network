
gui_settings_menu_handler:
  type: world
  debug: false
  events:
    on player clicks color_menu_button in !gui_settings_menu:
      - inventory open d:gui_settings_menu
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

    on player clicks gui_settings_menu_button_* in gui_settings_menu:
      - if !<context.is_shift_click>:
        - define i 5
      - else:
        - define i 25
      - choose <context.slot>:
        - case 32:
          - flag player behr.essentials.settings.gui.pattern:<player.flag[behr.essentials.settings.gui.pattern].add[1].mod[24].if_null[1]>

        - case 35:
          - if <player.flag[behr.essentials.settings.gui.pattern].sub[1].if_null[1]> < 0:
            - define b 23
          - else:
            - define b <player.flag[behr.essentials.settings.gui.pattern].sub[1]>
          - flag player behr.essentials.settings.gui.pattern:<[b]>

        # red
        - case 10:
          - flag player behr.essentials.settings.gui.color.r:<player.flag[behr.essentials.settings.gui.color.r].add[<[i]>].min[255].if_null[0]>
          - actionbar "<&color[<proc[prgb]>]>New color set<&co> <&color[<proc[argb]>]><proc[argb].rgb>"
        - case 28:
          - flag player behr.essentials.settings.gui.color.r:<player.flag[behr.essentials.settings.gui.color.r].sub[<[i]>].max[0].if_null[0]>
          - actionbar "<&color[<proc[prgb]>]>New color set<&co> <&color[<proc[argb]>]><proc[argb].rgb>"

        # green
        - case 11:
          - flag player behr.essentials.settings.gui.color.g:<player.flag[behr.essentials.settings.gui.color.g].add[<[i]>].min[255].if_null[0]>
          - actionbar "<&color[<proc[prgb]>]>New color set<&co> <&color[<proc[argb]>]><proc[argb].rgb>"
        - case 29:
          - flag player behr.essentials.settings.gui.color.g:<player.flag[behr.essentials.settings.gui.color.g].sub[<[i]>].max[0].if_null[0]>
          - actionbar "<&color[<proc[prgb]>]>New color set<&co> <&color[<proc[argb]>]><proc[argb].rgb>"

        # blue
        - case 12:
          - flag player behr.essentials.settings.gui.color.b:<player.flag[behr.essentials.settings.gui.color.b].add[<[i]>].min[255].if_null[0]>
          - actionbar "<&color[<proc[prgb]>]>New color set<&co> <&color[<proc[argb]>]><proc[argb].rgb>"
        - case 30:
          - flag player behr.essentials.settings.gui.color.b:<player.flag[behr.essentials.settings.gui.color.b].sub[<[i]>].max[0].if_null[0]>
          - actionbar "<&color[<proc[prgb]>]>New color set<&co> <&color[<proc[argb]>]><proc[argb].rgb>"

        # brightness
        - case 13:
          - define base <proc[prgb]>
          - define new <[base].with_brightness[<[base].brightness.add[<[i]>].min[255]>]>
          - flag player behr.essentials.settings.gui.color.r:<[new].red>
          - flag player behr.essentials.settings.gui.color.g:<[new].green>
          - flag player behr.essentials.settings.gui.color.b:<[new].blue>
          - actionbar "<&color[<proc[prgb]>]>New color set<&co> <&color[<proc[argb]>]><proc[argb].rgb>"
        - case 31:
          - define base <proc[prgb]>
          - define new <[base].with_brightness[<[base].brightness.sub[<[i]>].max[0]>]>
          - flag player behr.essentials.settings.gui.color.r:<[new].red>
          - flag player behr.essentials.settings.gui.color.g:<[new].green>
          - flag player behr.essentials.settings.gui.color.b:<[new].blue>
          - actionbar "<&color[<proc[prgb]>]>New color set<&co> <&color[<proc[argb]>]><proc[argb].rgb>"

        - default:
          - stop
      - inventory open d:gui_settings_menu
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>


gui_settings_menu:
  type: inventory
  debug: false
  inventory: chest
  title: <script.parsed_key[data.title].unseparated>
  data:
    title:
      - <proc[bbackground].context[36|e002]>
      - <&color[<proc[prgb]>]>
      - <proc[sp].context[17]>
      - <element[Colors].color[<proc[argb]>].font[minecraft_8.5]>
      - <proc[sp].context[28]>
      - <element[Main Text].color[<proc[prgb]>].font[minecraft_18]>
      - <proc[-sp].context[45]>
      - <element[Accent Text].color[<proc[argb]>].font[minecraft_26]>
  size: 36
  gui: true
  definitions:
    x: air
    i: stone
  procedural items:
    - define items <list>
    - define items <[items].include_single[<item[profile_button].with[skull_skin=<player.skull_skin>;display=<&color[<proc[argb]>]>Profile]>]>
    - define items <[items].include[<item[color_menu_button].with[display=<&color[<proc[argb]>]>Color Settings].repeat_as_list[3]>]>
    - define items <[items].include_single[<item[b_commands_settings_button].with[display=<&color[<proc[argb]>]>B Command Settings]>]>

    - foreach up|active|down as:button:
      - define items <[items].include_single[gui_settings_menu_button_red_<[button]>]>
      - define items <[items].include_single[gui_settings_menu_button_green_<[button]>]>
      - define items <[items].include_single[gui_settings_menu_button_blue_<[button]>]>
      - define items <[items].include_single[gui_settings_menu_button_brightness_<[button]>]>

    - define items <[items].include[gui_settings_menu_button_background_left|gui_settings_menu_button_background_right|close_button]>
    - determine <[items]>
  slots:
    - [] [] [] [] [] [x] [x] [x] [x]
    - [] [] [] [] [x] [x] [x] [x] [x]
    - [] [] [] [] [x] [x] [x] [x] [x]
    - [] [] [] [] [] [x] [x] [] []

color_menu_button:
  debug: false
  type: item
  material: player_head
  mechanisms:
    custom_model_data: 1053

gui_settings_menu_button_red_up:
  debug: false
  type: item
  material: player_head
  display name: <&e>Click<&co> <&color[<proc[prgb]>]>+5 Red
  lore:
  - <&e>Shift-click<&co> <&color[<proc[prgb]>]>+25 Red
  mechanisms:
    custom_model_data: 1053

gui_settings_menu_button_green_up:
  debug: false
  type: item
  material: player_head
  display name: <&e>Click<&co> <&color[<proc[prgb]>]>+5 Green
  lore:
  - <&e>Shift-click<&co> <&color[<proc[prgb]>]>+25 Green
  mechanisms:
    custom_model_data: 1053

gui_settings_menu_button_blue_up:
  debug: false
  type: item
  material: player_head
  display name: <&e>Click<&co> <&color[<proc[prgb]>]>+5 Blue
  lore:
  - <&e>Shift-click<&co> <&color[<proc[prgb]>]>+25 Blue
  mechanisms:
    custom_model_data: 1053

gui_settings_menu_button_brightness_up:
  debug: false
  type: item
  material: player_head
  display name: <&e>Click<&co> <&color[<proc[prgb]>]>+5 Brightness
  lore:
  - <&e>Shift-click<&co> <&color[<proc[prgb]>]>+25 Brightness
  mechanisms:
    custom_model_data: 1053

gui_settings_menu_button_red_active:
  debug: false
  type: item
  material: player_head
  display name: <&color[<proc[prgb]>]>Red<&co> <&color[<proc[argb]>]><player.flag[behr.essentials.settings.gui.color.r].if_null[0]>
  mechanisms:
    custom_model_data: 1053

gui_settings_menu_button_green_active:
  debug: false
  type: item
  material: player_head
  display name: <&color[<proc[prgb]>]>Green<&co> <&color[<proc[argb]>]><player.flag[behr.essentials.settings.gui.color.g].if_null[0]>
  mechanisms:
    custom_model_data: 1053

gui_settings_menu_button_blue_active:
  debug: false
  type: item
  material: player_head
  display name: <&color[<proc[prgb]>]>Blue<&co> <&color[<proc[argb]>]><player.flag[behr.essentials.settings.gui.color.b].if_null[0]>
  mechanisms:
    custom_model_data: 1053

gui_settings_menu_button_brightness_active:
  debug: false
  type: item
  material: player_head
  display name: <&color[<proc[prgb]>]>Brightness<&co> <&color[<proc[argb]>]><proc[argb].brightness>
  mechanisms:
    custom_model_data: 1053

gui_settings_menu_button_red_down:
  debug: false
  type: item
  material: player_head
  display name: <&e>Click<&co> <&color[<proc[prgb]>]>-5 Red
  lore:
  - <&e>Shift-click<&co> <&color[<proc[prgb]>]>-25 Red
  mechanisms:
    custom_model_data: 1053

gui_settings_menu_button_green_down:
  debug: false
  type: item
  material: player_head
  display name: <&e>Click<&co> <&color[<proc[prgb]>]>-5 Green
  lore:
  - <&e>Shift-click<&co> <&color[<proc[prgb]>]>-25 Green
  mechanisms:
    custom_model_data: 1053

gui_settings_menu_button_blue_down:
  debug: false
  type: item
  material: player_head
  display name: <&e>Click<&co> <&color[<proc[prgb]>]>-5 Blue
  lore:
  - <&e>Shift-click<&co> <&color[<proc[prgb]>]>-25 Blue
  mechanisms:
    custom_model_data: 1053

gui_settings_menu_button_brightness_down:
  debug: false
  type: item
  material: player_head
  display name: <&e>Click<&co> <&color[<proc[prgb]>]>-5 Brightness
  lore:
  - <&e>Shift-click<&co> <&color[<proc[prgb]>]>-25 Brightness
  mechanisms:
    custom_model_data: 1053

gui_settings_menu_button_background_left:
  debug: false
  type: item
  material: player_head
  display name: <&e>Click<&co> <&color[<proc[prgb]>]>Change Background
  mechanisms:
    custom_model_data: 1053

gui_settings_menu_button_background_right:
  debug: false
  type: item
  material: player_head
  display name: <&e>Click<&co> <&color[<proc[prgb]>]>Change Background
  mechanisms:
    custom_model_data: 1053
