spawn_command:
  type: command
  name: spawn
  debug: false
  usage: /spawn
  description: Teleports you to the spawn
  script:
    - teleport <server.flag[behr.essentials.spawn_location]>
    - narrate "<&a>You teleported to spawn"
