dback_command:
  type: command
  name: dback
  debug: false
  usage: /dback
  description: Teleports you to your last death location
  script:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

    - if !<player.has_flag[behr.essentials.teleport.last_death.location]>:
      - define reason "No last death location to teleport to"
      - inject command_error

    - if <player.flag[behr.essentials.teleport.last_death.world_name]> !in <server.worlds.parse[name]>:
      - define reason "That location to teleport to is in a world not loaded"
      - inject command_error

    - flag <player> behr.essentials.teleport.last_teleport.location:<player.location>
    - flag <player> behr.essentials.teleport.last_teleport.world_name:<player.location.world.name>
    - teleport <player.flag[behr.essentials.teleport.last_death.location]>
    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - narrate "<&[green]>Teleported you to your last death location"

    - flag <player> behr.essentials.teleport.last_death:!

death_location_handler:
  type: world
  events:
    on player dies:
      - flag player behr.essentials.teleport.last_death.location:<player.location>
      - flag player behr.essentials.teleport.last_death.world_name:<player.location.world.name>
