clear_inventory_command:
  type: command
  name: clear_inventory
  debug: false
  description: Clears yours or another player<&sq>s inventory
  usage: /clear_inventory (player)
  permission: behr.essentials.clear_inventory
  aliases:
    - clearinv
    - invclear
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  script:
  # % ██ [ check if tryping arguments ] ██
    - if <context.args.is_empty>:
        - define player <player>

  # % ██ [ check if player is truthy  ] ██
    - else if <context.args.size> == 1:
      - define player_name <context.args.first>
      - inject offline_player_verification

  # % ██ [ player typed it wrongly    ] ██
    - else:
      - inject command_syntax_error

  # % ██ [ clear the inventory        ] ██
    - inventory clear d:<[player].inventory>
    - if <[player]> != <player>:
      - narrate targets:<player> "<&[yellow]><[player_name]><&[green]>'s Inventory was cleared"
    - narrate targets:<[player]> "<&[green]>Inventory cleared"
