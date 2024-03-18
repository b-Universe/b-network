settings_command:
  type: command
  debug: false
  name: settings
  usage: /settings
  description: Configures your b settings
  tab completions:
    1: commands_playsound
  script:
    # ██ [  open settings menu                             ] ██:
    - if <context.args.is_empty>:
      - inventory open destination:b_commands_settings_menu
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
      - stop

    - choose <context.args.first>:
      - case commands_playsound:
        - if <player.has_flag[behr.essentials.settings.playsounds]>:
          - flag player behr.essentials.settings.playsounds:!
          - definemap message:
              text: <&[red]>Commands and menu sounds disabled
              hover_1: <&color[<proc[argb]>]>Click to re-enable<n>command and menu sounds
              hover_2: <&color[<proc[argb]>]>Command and menu<n>sounds are disabled
              click: /settings commands_playsound true

        - else:
          - flag player behr.essentials.settings.playsounds
          - definemap message:
              text: <&[green]>Commands and menu sounds enabled
              hover_1: <&color[<proc[argb]>]>Click to re-disable<n>command and menu sounds
              hover_2: <&color[<proc[argb]>]>Command and menu<n>sounds are enabled
              click: /settings commands_playsound false

        - define message.hover_3 "<&color[<proc[argb]>]>*Excludes bEdit commands"
        - narrate <element[<&color[<proc[argb]>]><&lb>⏺<&rb> ].on_hover[<[message.hover_1]>].on_click[<[message.click]>]><[message.text].on_hover[<[message.hover_2]>]><element[*].on_hover[<[message.hover_3]>]>

        - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

      - default:
        - inject command_syntax_error
