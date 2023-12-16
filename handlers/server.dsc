server_handler:
  type: world
  debug: false
  events:
    on system time minutely:
      - adjust server save

    after server start:
      - discordconnect id:b token:<secret[b]>

    on server list ping:
      - determine "<&b>Okie time to log in now!"

    on proxy server list ping:
      - determine "motd:<&b>Okie time to log in now!"
