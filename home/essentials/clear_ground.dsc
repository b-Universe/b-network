clear_ground_command:
  type: command
  name: clear_ground
  debug: false
  description: Clears the ground of dropped items around you
  usage: /clear_ground
  permission: behr.essentials.clear_ground
  aliases:
    - cleanground
    - groundclean
  script:
  # % ██ [ Check if using command wrongly  ] ██
    - if !<context.args.is_empty>:
      - inject command_syntax_error

  # % ██ [ Find ground entities and remove them ] ██
    - define entities <player.location.find_entities[DROPPED_ITEM].within[128]>
    - remove <[entities]>
    - narrate "<&[green]>Removed <&[yellow]><[entities].size> <&[green]>items on the ground"
