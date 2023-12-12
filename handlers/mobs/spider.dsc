spider_handler:
  type: world
  debug: false
  events:
    after server start:
      - adjust <material[dragon_egg]> piston_reaction:normal

    after spider spawns in:home_the_end:
      - define location <context.entity.location>
      - stop if:!<[location].find_blocks[dragon_egg].within[15].is_empty>
      - spawn falling_block[fallingblock_type=dragon_egg] <[location]>

    on dragon egg moves:
      - determine cancelled

    on player breaks dragon_egg:
      - determine spider_egg_sac

    on player completes advancement:
      - determine passively cancelled
      - announce <context.advancement>

spider_egg_sac:
  type: item
  material: dragon_egg
