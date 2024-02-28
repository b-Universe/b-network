ping_command:
  type: command
  name: ping
  debug: false
  description: Shows yours or another player's ping
  usage: /ping (player)
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
  # % ██ [ check if player is typing too much    ] ██
    - if <context.args.size> > 1:
      - inject command_syntax_error

    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>

  # % ██ [ check if typing another player or not ] ██
    - if <context.args.is_empty>:
      - narrate "<&a>Your ping is <&e><player.ping><&6>ms"

    - else:
      - define player_name <context.args.first>
      - inject command_online_player_verification
      - narrate "<&e><[player_name]><&a><&sq>s ping is <&e><[player].ping><&6>ms"
