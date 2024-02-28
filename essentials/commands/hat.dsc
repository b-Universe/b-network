hat_command:
  type: command
  name: hat
  debug: false
  description: Wears the item in your hand as a hat
  usage: /hat
  script:
  # % ██ [ check if typing arguments                ] ██:
    - if !<context.args.is_empty>:
      - inject command_syntax_error

  # % ██ [ check if not holding a hat               ] ██:
    - if !<player.item_in_hand.is_truthy>:
      - define reason "You have to hold an item"
      - inject command_error

  # % ██ [ check if player is wearing a hat already ] ██:
    - if <player.equipment_map.contains[helmet]>:
      - define reason "You have to remove your current hat first"
      - inject command_error

  # % ██ [ receive hat                              ] ██:
    - playsound <player> entity_player_levelup pitch:<util.random.decimal[0.8].to[1.2]> volume:0.3 if:<player.has_flag[behr.essentials.settings.playsounds]>
    - equip <player> head:<player.item_in_hand.with[quantity=1]>
    - take iteminhand quantity:1
    - narrate "<&a>And now it's a hat!"
