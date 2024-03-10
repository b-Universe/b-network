command_error:
  type: task
  debug: false
  definitions: reason
  script:
    - playsound <player> sound:block_fire_extinguish pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    # ██ [ Check if being ran as the server ] ██:
    - if <context.source_type.if_null[invalid]> != player || <context.server.if_null[false]>:
      - announce to_console "<&[red]>Command error <&b>| <&6><underline>/<&e><context.alias> <context.raw_args> <&b>| <&[red]><[reason]>"
      - stop

    - definemap message:
        text: <&[red]><[reason]>
        hover: <&[green]>Click to insert<&co><n><&6>/<&e><context.alias.proc[command_usage].proc[command_syntax_format]><n><&[red]>You typed<&co> <underline>/<context.alias> <context.raw_args>
    - narrate <[message.text].on_hover[<[message.hover]>].on_click[/<context.alias> ].type[suggest_command]>
    - stop

command_syntax_error:
  type: task
  debug: false
  script:
    - playsound <player> sound:block_fire_extinguish pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - definemap message:
        text: <&[red]>Invalid syntax - <context.alias.proc[command_usage].proc[command_syntax_format]>
        hover: <&[green]>Click to insert<&co><n><&6>/<&e><context.alias><n><&[red]>You typed<&co> <underline>/<context.alias> <context.raw_args>
    - narrate <[message.text].on_hover[<[message.hover]>].on_click[/<context.alias> ].type[suggest_command]>
    - stop

command_permission_error:
  type: task
  debug: false
  script:
    - playsound <player> sound:block_fire_extinguish pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - definemap message:
        text: <&[red]><[reason]>
        hover: <&[red]>You don<&sq>t have permission to run that command
    - narrate <[message.text].on_hover[<[message.hover]>]>
    - stop

command_usage:
  type: procedure
  debug: false
  definitions: alias
  script:
    - if <script[<[alias]>_command].exists>:
      - determine <script[<[alias]>_command].parsed_key[usage]>
    - else:
      - determine <util.scripts.filter[data_key[aliases].contains_text[<[alias]>]].first.parsed_key[usage].if_null[invalid]>

command_syntax_format:
  type: procedure
  debug: false
  definitions: syntax
  script:
    - define characters <list[/|\|(|)|,|.|<&ns>|<&lt>|<&gt>|<&lb>|<&rb>].include_single[|]>
    - foreach <[characters]> as:character:
      - define syntax <[syntax].replace_text[<[character]>].with[<&6><[character]><&e>]>
    - determine <[syntax]>
