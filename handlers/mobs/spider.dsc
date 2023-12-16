spider_handler:
  type: world
  debug: false
  events:
    after server start:
      - adjust <material[dragon_egg]> piston_reaction:normal

    after spider spawns in:home_the_end:
      - define location <context.entity.location.if_null[null]>
      - stop if:!<[location].is_truthy>
      - stop if:!<[location].find_blocks[dragon_egg].within[15].is_empty>
      - spawn falling_block[fallingblock_type=dragon_egg] <[location]>

    on dragon egg moves:
      - determine cancelled

    on player breaks dragon_egg:
      - stop if:<context.location.with_y[0].simple.equals[0,0,0,home_the_end]>
      - determine spider_egg_sac

    on player places spider_egg_sac:
      - determine passively cancelled
      - wait 1t
      - take item:spider_egg_sac if:<player.gamemode.equals[survival]>
      - define spiders <entity[spider].repeat_as_list[<list[0|0|1|1|1|2|2|3].random>]>
      - define cave_spiders <entity[cave_spider].repeat_as_list[<list[0|0|0|0|1|1|1|1|2].random>]>
      - spawn <list.include[<[spiders]>].include[<[cave_spiders]>]>

    on player completes advancement:
      - determine passively cancelled

    on player granted advancement criterion advancement:end/dragon_egg:
      - if !<player.inventory.exclude_item[spider_egg_sac].contains_item[dragon_egg]>:
        - determine passively cancelled

spider_egg_sac:
  type: item
  material: dragon_egg
  display name: <&f>Spider Egg Sac
