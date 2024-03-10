dback_command:
  type: command
  name: dback
  debug: false
  usage: /dback
  description: Teleports you to your last death location
  script:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

    - if !<player.has_flag[behr.essentials.teleport.last_death_location]>:
      - define reason "No last death location to teleport to"
      - inject command_error

    - teleport <player.flag[behr.essentials.teleport.last_death_location]>
    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - narrate "<&[green]>Teleported you to your last death location"

    - flag <player> behr.essentials.teleport.last_death_location:!

death_location_handler:
  type: world
  events:
    on player dies:
      - flag player behr.essentials.teleport.last_death_location:<player.location>
