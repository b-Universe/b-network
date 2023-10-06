debugging_command:
  type: command
  debug: false
  name: debug
  usage: /debug
  description: Enables debugging for scripts
  aliases:
    - /debug
  tab complete:
    - if <player.has_flag[behr.developmental.debug_mode]>:
      - actionbar "<&e>Debug mode is currently <&a>enabled"
    - else:
      - actionbar "<&e>Debug mode is currently <&c>disabled"
  script:
    - if !<context.args.is_empty>:
      - definemap message:
          text: <&c>Syntax<&co> <&6>//<&e>debug
          hover: <&a>Click to insert<&co><n><&6>//<&e>debug<n><&c>You typed<&co> <underline>/<context.alias> <context.raw_args>
      - narrate <[message.text].on_hover[<[message.hover]>].on_click[//debug].type[suggest_command]>
      - stop

    - if <server.has_flag[behr.developmental.debug_mode]>:
      - flag server behr.developmental.debug_mode:!
      - narrate "<&c>Debug mode disabled"

    - else:
      - flag server behr.developmental.debug_mode
      - narrate "<&a>Debug mode enabled"
