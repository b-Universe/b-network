settings_command:
  type: command
  debug: false
  name: settings
  usage: /settings
  description: Configures your b settings
  tab complete:
    - define categories <list[commands|bedit]>
    - if <context.args.is_empty>:
      - determine <[categories]>

    - define arg_count <context.args.size>
    - if <context.raw_args.ends_with[ ]>:
      - define arg_count <[arg_count].add[1]>

    - if <[arg_count]> == 1:
      - determine <[categories].filter[starts_with[<context.args.first>]]>

    - else if <[arg_count]> == 2:
      - define current_arg <context.args.get[2].if_null[<empty>]>
      - if <context.args.first> == commands:
        - determine <list[playsound].filter[starts_with[<[current_arg]>]]>
      - else if <context.args.first> == bedit:
        - determine <list[selection_color].filter[starts_with[<[current_arg]>]]>

    - else if <[arg_count]> == 3:
      - if <context.args.first> == commands:
        - determine <list[true|false].filter[starts_with[<[current_arg]>]]>
      - if <context.args.first> == bedit:
        - determine <list[default|block|favorite].filter[starts_with[<[current_arg]>]]>

  script:
    # ██ [  open settings menu                             ] ██:
    - if <context.args.is_empty>:
      - inventory open destination:settings_main_menu
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
      - stop

    # ██ [  choose setting category to configure           ] ██:
    - choose <context.args.first>:
      - case commands:
        # ██ [  choose the setting command to configure    ] ██:
        - define command <context.args.get[2]>
        - choose <[command]>:
          # ██ [  adjust whether players hear sounds when using commands, or not ] ██:
          - case playsound:
            - if <context.args.size> > 3:
              - narrate "<&c>invalid usage - no command setting uses more than true/false values"
              - stop

            # ██ [  define the setting we're changing to   ] ██:
            - if <context.args.size> == 2:
              - define new_setting <player.has_flag[behr.essentials.settings.playsounds].not>
            - else:
              - define new_setting <context.args.last>
              - if <[new_setting]> !in true|false:
                - narrate "<&c>invalid usage - this can only be true or false"
                - stop

            # ██ [  base definitions based on new setting  ] ██:
            - if <[new_setting]>:
              - flag player behr.essentials.settings.playsounds:!
              - definemap message:
                  text: <&a>Commands and menu sounds disabled
                  hover_1: <&b>Click to re-enable<n>command and menu sounds
                  hover_2: <&b>Command and menu sounds are disabled
                  click: /settings commands playsound true

            - else:
              - flag player behr.essentials.settings.playsounds
              - definemap message:
                  text: <&a>Commands and menu sounds enabled
                  hover_1: <&b>Click to re-disable<n>command and menu sounds
                  hover_2: <&b>Command and menu sounds are enabled
                  click: /settings commands playsound false
            - define message.hover_3 "<&e>*Excludes bEdit commands"

            # ██ [  send confirmation                      ] ██:
            - narrate <element[<&lb>⏺<&rb> ].on_hover[<[message.hover_1]>].on_click[<[message.click]>]><[message.text].on_hover[<[message.hover_2]>]><element[*].on_hover[<[message.hover_3]>]>
            - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

      - case bEdit:
        - define setting_name <context.args.get[2]>
        - choose <[setting_name]>:
          - case selection_color:
            - define selection_style <context.args.get[3]>
            - if <[selection_style]> == default:
              - if <context.args.size> > 3:
                - narrate "<&c>invalid usage - default has no sub-arguments"
                - stop

              # ██ [  base definitions based on new setting  ] ██:
              - flag player behr.essentials.settings.bedit.selection.left:<color[255,254,0]>
              - flag player behr.essentials.settings.bedit.selection.right:<color[0,255,254]>
              - flag player behr.essentials.settings.bedit.selection.style:default
              - definemap message:
                  text: <&a>Selection color set to defaults
                  #hover_1: <&b>Click to re-enable<n>command and menu sounds
                  hover_2: <&b>Command and menu sounds are disabled
                  #click: /settings bedit selection_color old_setting

              # ██ [  send confirmation                      ] ██:
              - narrate <element[<&lb>⏺<&rb> ]><[message.text].on_hover[<[message.hover_2]>]>
              - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

            - else if <[selection_style]> == block:
              - if <context.args.size> > 3:
                - narrate "<&c>invalid usage - block default has no sub-arguments"
                - stop

              # ██ [  base definitions based on new setting  ] ██:
              - flag player behr.essentials.settings.bedit.selection.left:<color[255,254,0]>
              - flag player behr.essentials.settings.bedit.selection.right:<color[0,255,254]>
              - definemap message:
                  text: <&a>Selection color set to defaults
                  #hover_1: <&b>Click to re-enable<n>command and menu sounds
                  hover_2: <&b>Command and menu sounds are disabled
                  #click: /settings bedit selection_color old_setting

              # ██ [  send confirmation                      ] ██:
              - narrate <element[<&lb>⏺<&rb> ]><[message.text].on_hover[<[message.hover_2]>]>
              - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

            - else:
              - narrate "<&c>invalid usage - can only use default, block, or favorite"
              - stop


  data:
    categories:
      all:
        - common fucking sense
        - playsound
      commands:
        - playsound
      sounds:
        - playsound

settings_menu_handler:
  type: world
  debug: false
  events:
    after player clicks settings_commands_button in settings_main_menu:
      #- narrate fire
      - define inventory <inventory[settings_commands_main_menu]>
      # playsound/others
      - if <player.has_flag[behr.essentials.settings.playsounds]>:
        - inventory set origin:<item[settings_commands_playsound].with[material=green_stained_glass;display=<&b><italic>Command and Menu Sounds;lore=<&e>Setting<&co> <&a>disabled]> destination:<[inventory]> slot:1
      - else:
        - inventory set origin:<item[settings_commands_playsound].with[material=red_stained_glass;display=<&b><italic>Command and Menu Sounds;lore=<&e>Setting<&co> <&a>enabled]> destination:<[inventory]> slot:1
      # back
      - inventory set destination:<[inventory]> slot:<[inventory].size> origin:<item[settings_back_button].with_flag[previous_menu:<player.open_inventory.script.name>]>
      - inventory open destination:<[inventory]>
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

    after player clicks bedit_commands_button in settings_main_menu:
      #- narrate fire
      - define inventory <inventory[settings_bedit_main_menu]>
      # playsound/others
      - if <player.has_flag[behr.essentials.settings.playsounds]>:
        - inventory set origin:<item[settings_commands_playsound].with[material=green_stained_glass;display=<&b><italic>Command and Menu Sounds;lore=<&e>Setting<&co> <&a>disabled]> destination:<[inventory]> slot:1
      - else:
        - inventory set origin:<item[settings_commands_playsound].with[material=red_stained_glass;display=<&b><italic>Command and Menu Sounds;lore=<&e>Setting<&co> <&a>enabled]> destination:<[inventory]> slot:1
      # back
      - inventory set destination:<[inventory]> slot:<[inventory].size> origin:<item[settings_back_button].with_flag[previous_menu:<player.open_inventory.script.name>]>
      - inventory open destination:<[inventory]>
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

    after player clicks settings_back_button in inventory:
      - inventory open destination:<context.item.flag[previous_menu]>
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

    after player clicks settings_commands_playsound in settings_commands_main_menu:
    #after player clicks settings_commands_playsound in settings_commands_main_menu|settings_sounds_main_menu:
      - if <player.has_flag[behr.essentials.settings.playsounds]>:
        - flag player behr.essentials.settings.playsounds:!
        - definemap message:
            text: <&a>Commands and menu sounds disabled
            hover_1: <&b>Click to re-enable<n>command and menu sounds
            hover_2: <&b>Command and menu sounds are disabled
            click: /settings commands playsound true
        - inventory set origin:<item[settings_commands_playsound].with[material=red_stained_glass;display=<&b><italic>Command and Menu Sounds;lore=<&e>Setting<&co> <&a>disabled]> destination:<context.inventory> slot:1

      - else:
        - flag player behr.essentials.settings.playsounds
        - definemap message:
            text: <&a>Commands and menu sounds enabled
            hover_1: <&b>Click to re-disable<n>command and menu sounds
            hover_2: <&b>Command and menu sounds are enabled
            click: /settings commands playsound false
        - inventory set origin:<item[settings_commands_playsound].with[material=green_stained_glass;display=<&b><italic>Command and Menu Sounds;lore=<&e>Setting<&co> <&a>enabled]> destination:<context.inventory> slot:1

      - define message.hover_3 "<&e>*Excludes bEdit commands"
      - narrate <element[<&lb>⏺<&rb> ].on_hover[<[message.hover_1]>].on_click[<[message.click]>]><[message.text].on_hover[<[message.hover_2]>]><element[*].on_hover[<[message.hover_3]>]>

      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>



settings_back_button:
  type: item
  debug: false
  material: stone
  display name: Back
  mechanisms:
    hides: all
  enchantments:
    - vanishing_curse:69

settings_main_menu:
  type: inventory
  debug: false
  inventory: hopper
  #inventory: chest
  title: Settings | Categories
  #size: 27
  gui: true
  definitions:
    1: settings_commands_button
    2: bedit_commands_button
  slots:
    - [1] [2] [] [] []
    #- [] [] [] [] [] [] [] [] []
    #- [] [] [] [] [] [] [] [] []
    #- [] [] [] [] [] [] [] [] []

settings_commands_button:
  type: item
  debug: false
  material: stone
  display name: Commands
  lore:
    - <&a>Configure settings related
    - <&a>to when using commands
  mechanisms:
    hides: all
  enchantments:
    - vanishing_curse:69

bedit_commands_button:
  type: item
  debug: false
  material: wooden_sword
  display name: bEdit
  lore:
    - <&a>Configure settings
    - <&a>related to bEdit
  mechanisms:
    hides: all
    custom_model_data: 1000
  enchantments:
    - vanishing_curse:69

settings_commands_main_menu:
  type: inventory
  debug: false
  inventory: hopper
  title: Settings | Commands
  #size: 27
  gui: true
  #definitions:
  #  1: settings_commands_playsound
  #slots:
  #  - [1] [] [] [] []

settings_commands_playsound:
  type: item
  debug: false
  material: stone
  display name: Play Sounds
  lore:
    - <empty>
    - Changes whether or not you
    - hear command and menu sounds
    - *Excludes bEdit
  mechanisms:
    hides: all

settings_bedit_main_menu:
  type: inventory
  debug: false
  inventory: hopper
  title: Settings | bEdit
  #size: 27
  gui: true
  #definitions:
  #  1: settings_commands_playsound
  #slots:
  #  - [1] [] [] [] []

settings_bedit_selection_color:
  type: item
  debug: false
  material: stone
  display name: Play Sounds
  lore:
    - <empty>
    - Changes whether to use block
    - colors, favorited colors,
    - or default selection colors
  mechanisms:
    hides: all
