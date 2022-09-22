rules_command:
  type: command
  name: rules
  debug: false
  description: Lists the rules for b
  usage: /rules
  permission: behr.essentials.rules
  script:
  # % ██ [ check if typing arguments ] ██
    - if !<context.args.is_empty>:
      - inject command_syntax_error

  # % ██ [ narrate the rules for b   ] ██
    - narrate "<&[yellow]>1. <&[green]>Use common sense."
