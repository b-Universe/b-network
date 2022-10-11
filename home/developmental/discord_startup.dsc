discord_startup_handler:
  type: world
  debug: false
  events:
    after server start:
      - ~discordconnect id:b token:<secret[b]>
