bed_command:
  type: command
  name: bed
  debug: false
  usage: /bed
  description: Takes you to your bed
  script:
  # % ██ [ check if typing arguments                ] ██:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

  # % ██ [ check if player owns a respawn location  ] ██:
    - if !<player.bed_spawn.exists>:
      - define reason "You have no bed location currently"
      - inject command_error

  # % ██ [ teleport to respawn location             ] ██:
    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - teleport <player> <player.bed_spawn>
    - narrate "<&[green]>Teleported you to your bed"
