me_command:
  type: command
  name: me
  debug: false
  usage: /me (message)
  description: me irl but outloud
  script:
    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - if <context.args.is_empty>:
      - announce "<&5><player.name> irl"
    - else:
      - announce "<&5><player.name> <context.raw_args.parse_color.strip_color>"
