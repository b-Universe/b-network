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
      - narrate "<&c>You have no bed location currently"
      - stop

  # % ██ [ teleport to respawn location             ] ██:
    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - teleport <player> <player.bed_spawn>
    - narrate "<&a>Teleported you to your bed"
