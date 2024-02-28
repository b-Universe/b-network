discord_command:
  type: command
  name: discord
  debug: false
  usage: /discord
  description: Gives you the Discord link
  script:
  # % ██ [ check if typing arguments                ] ██:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

  # % ██ [ give the link to our discord             ] ██:
    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - narrate <&b><underline>https<&co>//www.behr.dev/Discord
