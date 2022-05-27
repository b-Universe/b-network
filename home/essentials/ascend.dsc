ascend_command:
  type: command
  name: ascend
  debug: false
  description: Takes you to the top!
  usage: /ascend
  permission: behr.essentials.top
  script:
  # % ██ [ check if typing more than nothing   ] ██
    - if !<context.args.is_empty>:
      - narrate "<&c>Invalid usage - /ascend"

  # % ██ [ check if they're already at the top ] ██
    - if <player.location.y> > <player.location.highest.y>:
      - narrate "<&e>Nothing interesting happens"
      - stop

    - else:
      - narrate "<&a>Taking you to the top"
      - teleport <player> <player.location.highest.add[0,2,0]>
