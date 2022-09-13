clear_console_command:
  type: command
  name: clear_console
  debug: false
  usage: /clear_console
  description: Clears the console for a blank screen
  permission: behr.essentials.clear_console
  script:
  # % ██ [ if emptying  ] ██
    - if !<context.args.is_empty>:
      - inject command_syntax_error

    - announce to_console "<n.repeat[100]><&[green]>Console cleared"
