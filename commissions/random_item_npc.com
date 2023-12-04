clumsy_the_npc:
  type: assignment
  debug: false
  actions:
    on assignment:
      - flag server my.npc:<npc>
    on spawn:
      - flag server my.npc:<npc>
    on despawn:
      - flag server my.npc:!

random_item_list:
  type: data
  items:
    1:
      chance: 20
      item: netherite_scraps
    2:
      chance: 20
      item: netherite_ingot
    3:
      chance: 20
      item: experience_bottle[quantity=64]
    4:
      chance: 5
      item: enchanted_golden_apple
    5:
      chance: 11.5
      item: diamond[quantity=32]

random_item_counter:
  type: world
  debug: false
  events:
    on system time secondly every:30 server_flagged:my.npc:
      - define npc <server.flag[my.npc].if_null[null]>
      - if !<[npc].is_truthy>:
        - flag server my.npc:!
        - narrate "<&c>Random Drop NPC Missing"
        - stop

      - define random_chance <util.random.int[0].to[100]>
      - define item_list <script[random_item_list].parsed_key[items]>
      - define item_list <[item_list].include[<server.flag[my.items].if_null[<map>]>]>
      - foreach <[item_list]> as:drop:
        - define chance <[chance].if_null[0].add[<[drop.chance]>]>
        - if <[chance]> >= <[random_chance]>:
          - define item <[drop.item]>
          - foreach stop
      - drop <[item]> <[npc].location>
      - firework <[npc].location> primary:<color[red].with_hue[<util.random.int[1].to[255]>]> power:1 random trail flicker

save_my_item:
  type: command
  debug: false
  name: fancy_drop_item
  description: Saves an item to the fancy drop list
  usage: /fancy_drop_item (name) (chance) / reset / list
  aliases:
    - fdi
  tab completions:
    1: list|reset
  script:
    - if <context.args.is_empty>:
      - narrate "<&c>invalid usage - <&e>/fancy_drop_item (name) (chance) / reset / list"
      - stop
    - if <player.item_in_hand> matches air:
      - narrate "<&c>Hold an item to add to the list."
      - stop

    - choose <context.args.first>:
      - case reset:
        - if <server.flag[my.items].is_empty.if_null[true]>:
          - narrate "<&c>Item list is empty. use <&e>/fdi <&lt>name<&gt> <&lt>chance<&gt> <&c>to add items."
          - stop

        - flag server my.items:!
        - narrate "<&A>List cleared."

      - case list:
        - if <server.flag[my.items].is_empty.if_null[true]>:
          - narrate "<&c>Item list is empty. use <&e>/fdi <&lt>name<&gt> <&lt>chance<&gt> <&c>to add items."
          - stop

          - narrate "<&3>item name: <&6>drop chance<&pc>"
        - foreach <server.flag[my.items]> key:name as:drop:
          - narrate "<&b><[name]>: <&e><[drop.chance].format_number[0.00]><&pc>"


      - default:
        - if <context.args.size> < 2:
          - narrate "<&c>Requires you input a <&e>Name<&c> for the item and a <&e>percentage chance<&c> for it to drop."
          - stop

        - define name <context.args.remove[last].separated_by[ ]>
        - define chance <context.args.last>

        - flag server my.items.<[name]>.item:<player.item_in_hand>
        - flag server my.items.<[name]>.chance:<[chance]>

        - narrate "<&A>Added <&e><[name]> <&a>to the item list. type <&e>/fdi list<&a> for the full list."
