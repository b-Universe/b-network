b_commands_menu_handler:
  type: world
  debug: false
  events:
    on player clicks b_commands_button in !b_commands_menu:
      - inventory open d:b_commands_menu
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

    on player clicks settings_* in b_commands_menu:
      - choose <context.item.script.name.after[settings_]>:
        - case commands_playsound:
          - if <player.has_flag[behr.essentials.settings.playsounds]>:
            - flag player behr.essentials.settings.playsounds:!
            - definemap message:
                text: <&color[<proc[prgb]>]>Commands and menu sounds disabled
                hover_1: <&color[<proc[argb]>]>Click to re-enable<n>command and menu sounds
                hover_2: <&color[<proc[argb]>]>Command and menu sounds are disabled
                click: /settings commands_playsound true
            - inventory set destination:<context.inventory> origin:<item[settings_commands_playsound].with[lore=<script[settings_commands_playsound].parsed_key[data.disabled_lore]>]> slot:<context.slot>

          - else:
            - flag player behr.essentials.settings.playsounds
            - definemap message:
                text: <&color[<proc[prgb]>]>Commands and menu sounds enabled
                hover_1: <&color[<proc[argb]>]>Click to re-disable<n>command and menu sounds
                hover_2: <&color[<proc[argb]>]>Command and menu sounds are enabled
                click: /settings commands_playsound false
            - inventory set destination:<context.inventory> origin:<item[settings_commands_playsound].with[lore=<script[settings_commands_playsound].parsed_key[lore]>]> slot:<context.slot>

          - define message.hover_3 "<&color[<proc[argb]>]>*Excludes bEdit commands"
          - narrate <element[<&color[<proc[argb]>]><&lb>⏺<&rb> ].on_hover[<[message.hover_1]>].on_click[<[message.click]>]><[message.text].on_hover[<[message.hover_2]>]><element[*].on_hover[<[message.hover_3]>]>

          - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>


b_commands_menu:
  type: inventory
  debug: false
  inventory: chest
  title: <script.parsed_key[data.title].unseparated>
  data:
    title:
      - <proc[bbackground].context[36|e003]>
      - <&color[<proc[prgb]>]>
      - <proc[positive_spacing].context[32]>
      - <element[ Commands].color[<proc[argb]>].font[minecraft_8.5]>
  size: 36
  gui: true
  definitions:
    x: air
  procedural items:
    - define items <list>
    - define items <[items].include_single[<item[profile_button].with[skull_skin=<player.skull_skin>;display=<&color[<proc[argb]>]>Profile]>]>
    - define items <[items].include_single[<item[color_menu_button].with[display=<&color[<proc[argb]>]>Color Settings]>]>
    - define items <[items].include[<item[b_commands_button].with[display=<&color[<proc[argb]>]>B Command Settings].repeat_as_list[4]>]>
    - determine <[items]>
  slots:
    - [] [] [] [] [] [] [] [] []
    - [settings_commands_playsound] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
b_commands_button:
  debug: false
  type: item
  material: player_head
  mechanisms:
    custom_model_data: 1053

settings_commands_playsound:
  type: item
  debug: false
  material: mojang_banner_pattern
  display name: <&color[<proc[prgb]>]>Command and Menu Sounds
  lore:
    - <&2><strikethrough><proc[positive_spacing].context[53]><&2><&lc> <&a>Enabled <&2><&rc><strikethrough><proc[positive_spacing].context[53]>
    - <&color[<proc[argb]>]>Changes whether or not you
    - <&color[<proc[argb]>]>hear command and menu sounds
    - <&6>*<&8>Excludes bEdit
    - <&2><strikethrough><proc[positive_spacing].context[162]>
  data:
    disabled_lore:
      - <&4><strikethrough><bold><proc[positive_spacing].context[48]><&4><bold><&lc> <&c>Disabled <&4><bold><&rc><bold><strikethrough><proc[positive_spacing].context[49]>
      - <&color[<proc[argb]>]>Changes whether or not you
      - <&color[<proc[argb]>]>hear command and menu sounds
      - <&6>*<&8>Excludes bEdit
      - <&4><strikethrough><bold><proc[positive_spacing].context[160]>
  mechanisms:
    hides: all
