bed_command:
  type: command
  name: bed
  debug: false
  usage: /bed
  description: Takes you to your bed
  script:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

    - if !<player.bed_spawn.exists>:
      - narrate "<&c>You have no bed location currently"
    - else:
      - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
      - teleport <player> <player.bed_spawn>
      - narrate "<&a>Teleported you to your bed"
