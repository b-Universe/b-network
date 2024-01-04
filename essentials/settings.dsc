settings_command:
  type: command
  debug: false
  name: settings
  usage: /settings
  description: Configures your b settings
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
        - define command <context.args.first>
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
  slots:
    - [1] [] [] [] []
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
