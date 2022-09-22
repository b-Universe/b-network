lore_command:
  type: command
  name: lore
  debug: false
  description: Applies basic lore to the item in hand
  usage: /lore <&lt>Lore line 1<&gt>(|Lore line <&ns>)*
  permission: behr.essentials.lore
  script:
  # % ██ [ check if not typing anything ] ██
    - if <context.args.is_empty>:
      - inject command_syntax_error

  # % ██ [ check if holding an item     ] ██
    - if <player.item_in_hand.material.name> == air:
      - define reason "You have to hold an item to add lore to"
      - inject command_error

  # % ██ [ format lore to add           ] ██
    - define lore <context.raw_args.split[|].parse[trim.parse_color]>

  # % ██ [ sets lore to item            ] ██
    - inventory adjust slot:<player.held_item_slot> lore:<list>
    - inventory adjust slot:<player.held_item_slot> lore:<[lore]>
    - playsound <player> entity_ender_eye_death
