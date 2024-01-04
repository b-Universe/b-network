discord_command:
  type: command
  name: discord
  debug: false
  usage: /discord
  description: Gives you the Discord link
  script:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

    - narrate <&b><underline>https<&co>//www.behr.dev/Discord
