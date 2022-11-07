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
      - inject command_syntax_error

  # % ██ [ check if they're already at the top ] ██
    - if <player.has_flag[behr.essentials.gamemode.builder_mode]>:
      - narrate "You can only do this in builder mode"
      - stop

  # % ██ [ check if they're already at the top ] ██
    - if <player.location.y> > <player.location.highest.y>:
      - narrate "<&[yellow]><element[Nothing interesting happens].on_hover[<&[yellow]>You're already at the top.]>"
      - stop

    - else:
      - narrate "<&[green]>Taking you to the top"
      - teleport <player> <player.location.highest.above[2]>
