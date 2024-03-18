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
      - actionbar "<&[yellow]>Debug mode is currently <&[green]>enabled"
    - else:
      - actionbar "<&[yellow]>Debug mode is currently <&[red]>disabled"
  script:
  # % ██ [ check if typing arguments                ] ██:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

  # % ██ [ change the server's debug mode           ] ██:
    - if <server.has_flag[behr.developmental.debug_mode]>:
      - flag server behr.developmental.debug_mode:!
      - narrate "<&[red]>Debug mode disabled"

    - else:
      - flag server behr.developmental.debug_mode
      - narrate "<&[green]>Debug mode enabled"
