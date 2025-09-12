back_command:
  type: command
  name: back
  debug: true
  usage: /back
  description: Teleports you to the last location that you teleported from
  script:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

    - if !<player.has_flag[behr.essentials.teleport.last_teleport.location]> || !<player.has_flag[behr.essentials.teleport.last_teleport.world_name]>:
      - define reason "No last teleport location to teleport to"
      - inject command_error

    - if <player.flag[behr.essentials.teleport.last_teleport.world_name]> !in <server.worlds.parse[name]>:
      - define reason "Last location to teleport to is a world not loaded"
      - inject command_error

    - define previous_location <player.location>
    - teleport <player.flag[behr.essentials.teleport.last_teleport.location]>
    - flag <player> behr.essentials.teleport.last_teleport.location:<[previous_location]>
    - flag <player> behr.essentials.teleport.last_teleport.world_name:<[previous_location].world.name>
    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - narrate "<&[green]>Teleported you to your last location"
