dynmap_command:
  type: command
  name: dynmap
  debug: false
  enabled: false
  usage: /dynmap
  description: Gives you the dynmap link
  script:
  # % ██ [ check if typing arguments                ] ██:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

  # % ██ [ give the link to our dynmap map          ] ██:
    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - narrate <element[<&b><underline>https<&co>//www.behr.dev/dynmap].on_click[http://68.51.84.156:8123].type[open_url]>
