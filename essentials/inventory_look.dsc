inventory_look_command:
  type: command
  name: inventory_look
  debug: false
  description: Views another players inventory
  usage: /inventory_look (player)
  tab completions:
    1: <server.online_players.exclude[<player>].parse[name]>
  aliases:
    - invsee
  script:
    - if <context.args.size> > 1:
      - inject command_syntax_error

    - if <context.args.is_empty>:
      - inventory open destination:inventory_look_main_menu

    - else:
      - define player_name <context.args.first>
      - inject command_player_verification

    #- define contents <[player].inventory.list_contents>
    #- define inventory <inventory[generic[contents=<[contents]>;size=45;title=<[player].name><&sq>s Inventory]]>
    - define inventory <[player].inventory>
    - inventory open destination:<[inventory]>
