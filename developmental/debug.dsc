debugging_command:
  type: command
  debug: false
  name: debug
  usage: /debug
  description: Enables debugging for scripts
  aliases:
    - /debug
  tab complete:
    - if <server.has_flag[behr.developmental.debug_mode]>:
      - actionbar "<&e>Debug mode is currently <&a>enabled"
    - else:
      - actionbar "<&e>Debug mode is currently <&c>disabled"
  script:
  # % ██ [ check if typing arguments                ] ██:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

  # % ██ [ change the server's debug mode           ] ██:
    - if <server.has_flag[behr.developmental.debug_mode]>:
      - flag server behr.developmental.debug_mode:!
      - narrate "<&c>Debug mode disabled"

    - else:
      - flag server behr.developmental.debug_mode
      - narrate "<&a>Debug mode enabled"
