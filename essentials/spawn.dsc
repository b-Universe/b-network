spawn_command:
  type: command
  name: spawn
  debug: false
  usage: /spawn
  description: Teleports you to the spawn
  script:
  # % ██ [ check if typing arguments                ] ██:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

  # % ██ [ teleport player to the spawn             ] ██:
    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - teleport <server.flag[behr.essentials.spawn_location]>
    - narrate "<&a>You teleported to spawn"
