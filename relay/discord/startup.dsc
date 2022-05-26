discord_startup_handler:
  type: world
  debug: true
  events:
    after server start:
      - ~discordconnect id:c token:<secret[c]>
