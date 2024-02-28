
crafting_table_command:
  type: command
  name: crafting_table
  debug: false
  usage: /crafting_table
  description: Opens a crafting table
  script:
  # % ██ [ check if typing arguments                ] ██:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

  # % ██ [ fake opening a crafting table            ] ██:
    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - define fake_location <player.location.above[10]>
    - showfake <[fake_location]> crafting_table d:1t
    - adjust <player> show_workbench:<[fake_location]>
    - showfake <[fake_location]> cancel
