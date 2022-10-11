reload_command:
  type: command
  debug: false
  name: r
  permission: behr.essentials.reload
  usage: /r
  description: Reloads Denizen scripts
  script:
    - reload
    - if <context.args.size> == 1 && <context.args.first> == -c:
      - narrate actions/reload
