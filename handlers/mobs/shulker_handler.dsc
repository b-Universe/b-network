shulker_hhandler:
  type: world
  debug: false
  events:
    after delta time minutely:
      - if <util.random_chance[10]>:
        - define color cyan
        - wait 10s
        - define color <list[white|gray|light_gray|black].random>

      - else if <util.random_chance[10]>:
        - define color yellow
        - wait 10s
        - define color <list[white|gray|light_gray|black].random>

      - else:
        - define color <list[white|gray|light_gray|black].random>

      - flag server behr.essentials.shulker_color:<[color]>

    on shulker spawns:
      - adjust <context.entity> color:<server.flag[behr.essentials.shulker_color]>

    on player potion effects added effect:levitation:
      - determine cancelled

    on shulker dies:
      - define drops <context.drops>
      - if <util.random_chance[20]>:
        - define drops <[drops].include[gunpowder[quantity=<util.random.int[1].to[6]>]]>
      - if <util.random_chance[50]>:
        - define drops <[drops].include[ender_pearl[quantity=<util.random.int[1].to[4]>]]>

      - choose <context.entity.color>:
        - case white:
          - if <util.random_chance[20]>:
            - define drops <[drops].include_single[iron_block]>
          - else:
            - define drops <[drops].include_single[polished_diorite]>

          - if <util.random_chance[10]>:
            - define random_iron_drop <list[iron_axe|iron_pickaxe|iron_sword|iron_helmet|iron_chestplate|iron_leggings|iron_boots].random>
            - define drops <[drops].include_single[<[random_iron_drop]>]>

        - case light_gray:
          - define drops <[drops].include_single[smooth_stone]>

        - case gray:
          - define drops <[drops].include_single[polished_andesite]>

        - case black:
          - define drops <[drops].include_single[polished_blackstone]>
          - if <util.random_chance[10]>:
            - define drops <[drops].include_single[netherite_upgrade_smithing_template]>

        - case cyan:
          - define drops <[drops].include[ender_pearl[quantity=16]|diamond_block|diamond[quantity=<util.random.int[5].to[16]>]]>

          - if <util.random_chance[10]>:
            - define drops <[drops].include_single[netherite_upgrade_smithing_template]>

          - if <util.random_chance[10]>:
            - define random_diamond_drop <list[diamond_axe|diamond_pickaxe|diamond_sword|diamond_helmet|diamond_chestplate|diamond_leggings|diamond_boots].random>
            - define drops <[drops].include_single[<[random_diamond_drop]>]>

        - case yellow:
          - define drops <[drops].include[gold_block|raw_gold[quantity=<util.random.int[5].to[16]>]]>

          - if <util.random_chance[10]>:
            - define drops <[drops].include_single[golden_apple[quantity=<util.random.int[5].to[16]>]]>

          - if <util.random_chance[10]>:
            - define drops <[drops].include_single[golden_carrot[quantity=<util.random.int[5].to[16]>]]>

          - if <util.random_chance[25]>:
            - define random_gold_drop <list[gold_axe|gold_pickaxe|gold_sword|gold_helmet|gold_chestplate|gold_leggings|gold_boots].random>
            - define drops <[drops].include_single[<[random_gold_drop]>]>

      - determine <[drops]>
