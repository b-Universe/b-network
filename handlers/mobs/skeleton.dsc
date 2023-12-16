skeleton_handler:
  type: world
  debug: false
  events:
    on skeleton dies:
      - stop if:<list[drowning|dragon_breath|kill|void].contains[<context.cause>]>
      - define drops <context.drops>
      - if <util.random_chance[10]>:
        - define drops <[drops].include[bow]>
      - if <util.random_chance[50]>:
        - define drops <[drops].include[arrow[quantity=<util.random.int[1].to[20]>]]>
      - if <util.random_chance[20]>:
        - define drops <[drops].include[gunpowder[quantity=<util.random.int[1].to[10]>]]>
      - if <util.random_chance[20]>:
        - define drops <[drops].include[stick[quantity=<util.random.int[1].to[4]>]]>
      - determine <[drops]>

    on wither_skeleton dies:
      - stop if:<list[drowning|dragon_breath|kill|void].contains[<context.cause>]>
      - define drops <context.drops>
      - if <util.random_chance[10]>:
        - define drops <[drops].include[iron_sword]>
      - if <util.random_chance[50]>:
        - define drops <[drops].include[arrow[quantity=<util.random.int[1].to[10]>]]>
      - if <util.random_chance[20]>:
        - define drops <[drops].include[gunpowder[quantity=<util.random.int[1].to[20]>]]>
      - determine <[drops]>

    on player potion effects added effect:wither:
      - determine cancelled
