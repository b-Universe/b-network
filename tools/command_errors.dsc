command_error:
  type: task
  enabled: false
  debug: false
  definitions: reason
  script:
    # ██ [ Check if being ran as the server ] ██:
    - if <context.source_type.if_null[invalid]> != player || <context.server.if_null[false]>:
      - announce to_console "<&c>Command error <&b>| <&6><underline>/<&e><context.alias> <context.raw_args> <&b>| <&c><[reason]>"
      - stop

    - definemap message:
        text: <&c><[reason]>
        hover: <&a>Click to insert<&co><n><&6>/<&e><context.alias.proc[command_usage].proc[command_syntax_format]><n><&c>You typed<&co> <underline>/<context.alias> <context.raw_args>
    - narrate <[message.text].on_hover[<[message.hover]>].on_click[/<context.alias> ].type[suggest_command]>
    - stop

command_syntax_error:
  type: task
  enabled: false
  debug: false
  script:
    - definemap message:
        text: <&c>Invalid syntax - <context.alias.proc[command_usage].proc[command_syntax_format]>
        hover: <&a>Click to insert<&co><n><&6>/<&e><context.alias><n><&c>You typed<&co> <underline>/<context.alias> <context.raw_args>
    - narrate <[message.text].on_hover[<[message.hover]>].on_click[/<context.alias> ].type[suggest_command]>
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
  definitions: syntax
  script:
    - define characters <list[/|\|(|)|,|.|<&ns>|<&lt>|<&gt>|<&lb>|<&rb>].include_single[|]>
    - foreach <[characters]> as:character:
      - define syntax <[syntax].replace_text[<[character]>].with[<&6><[character]><&e>]>
    - determine <[syntax]>
