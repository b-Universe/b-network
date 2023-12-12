me_command:
  type: command
  name: me
  debug: false
  usage: /me (message)
  description: me irl but outloud
  script:
    - if <context.args.is_empty>:
      - announce "<&5><player.name> irl"
    - else:
      - announce "<&5><player.name> <context.raw_args.parse_color.strip_color>"
