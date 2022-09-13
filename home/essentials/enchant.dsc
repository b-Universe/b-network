enchant_command:
  type: command
  debug: false
  name: enchant
  description: Enchants an item in your hand
  usage: /enchant <&lt>enchantment<&gt> (level)
  permission: behr.essentials.enchant
  tab completions:
    1: <server.enchantments.parse[name]>
  script:
    - if <player.item_in_hand.material.name> == air:
      - define reason "You must hold something in your hand to enchant"
      - inject command_error
      - stop

    - if <context.args.is_empty>:

      - else if !<player.item_in_hand.is_enchanted>:
        - define reason "This item is not enchanted."
      - inject command_error

      - else:
        - narrate "<&[green]>This item is enchanted with<&6><&co><n><player.item_in_hand.enchantment_map.parse_value_tag[<&[green]><[parse_key]><&co> <&e><[parse_value]>].values.separated_by[<n>]>"

      - stop

    - else if <context.args.size> > 2:
      - inject command_syntax_error

    - else if <context.args.size> == 1:
      - define level 1

    - else:
      - define level <context.args.last>

    - if !<[level].is_integer>:
      - define reason "Enchantment level must be a number"
      - inject command_error

    - else if <[level]> < 1:
      - define reason "Enchantment level must be higher than zero"
      - inject command_error

    - else if <[level]> > 1000:
      - define reason "Enchantment level must be less than one thousand for now"
      - inject command_error

    - define enchantment <context.args.first>
    - if !<[enchantment].advanced_matches[<server.enchantments.parse[name]>]>:
      - define reason "Invalid enchantment"
      - inject command_error

    - define existing_enchantment_map <player.item_in_hand.enchantment_map>
    - if <[existing_enchantment_map].contains[<[enchantment]>]>:
      - define existing_level <[existing_enchantment_map].get[<[enchantment]>]>
      - if <[existing_level]> > <[level]>:
        - narrate "<&[green]><[enchantment].to_titlecase> enchantment lowered from <[existing_level]> to <[level]>"

      - else if <[existing_level]> < <[level]>:
        - narrate "<&[green]><[enchantment].to_titlecase> enchantment raised from <[existing_level]> to <[level]>"

      - else:
        - narrate "<&[yellow]>Nothing interesting happens"

    - else:
      - narrate "<&[green]>Added level <[level]> <[enchantment]> enchantment to item"

    - inventory adjust slot:<player.held_item_slot> enchantments:<player.item_in_hand.enchantment_map.with[<[enchantment]>].as[<[level]>]>
