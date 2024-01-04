add_elytra:
  type: item
  debug: false
  material: elytra
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - phantom_membrane|bone|phantom_membrane
        - phantom_membrane|bone|phantom_membrane
        - phantom_membrane|air|phantom_membrane

add_string:
  type: item
  debug: false
  material: string
  no_id: true
  recipes:
    1:
      type: shapeless
      input: cobweb

add_string_2:
  type: item
  debug: false
  material: string
  no_id: true
  mechanisms:
    quantity: 9
  recipes:
    1:
      type: shapeless
      input: white_wool

add_wool:
  type: item
  debug: false
  material: white_wool
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - string|string|string
        - string|string|string
        - string|string|string
    2:
      type: shaped
      input:
        - cobweb|cobweb|cobweb
        - cobweb|cobweb|cobweb
        - cobweb|cobweb|cobweb

add_bell:
  type: item
  debug: false
  material: bell
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - stick|stick|stick
        - gold_ingot|gold_ingot|gold_ingot
        - gold_ingot|gold_ingot|gold_ingot

more_redstone_repeaters:
  type: item
  debug: false
  material: repeater
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - air|air|air
        - redstone_torch|redstone|redstone_torch
        - smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite

more_redstone_comparators:
  type: item
  debug: false
  material: comparator
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - air|redstone_torch|air
        - redstone_torch|quartz|redstone_torch
        - smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite

more_dispensers:
  type: item
  debug: false
  material: dispenser
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite
        - smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|bow|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite
        - smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|redstone|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite

more_droppers:
  type: item
  debug: false
  material: dropper
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite
        - smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|air|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite
        - smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|redstone|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite

more_observers:
  type: item
  debug: false
  material: observer
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite
        - redstone|redstone|quartz
        - smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite

more_pistons:
  type: item
  debug: false
  material: piston
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - *_planks|*_planks|*_planks
        - smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|iron_ingot|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite
        - smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite|redstone|smooth_stone/andesite/granite/diorite/polished_andesite/polished_granite/polished_diorite

bottled_allay:
  type: item
  debug: false
  material: allay_spawn_egg
  display name: <&f>Bottled Allay

jar_of_bees:
  type: item
  debug: false
  material: honey_bottle
  display name: <&f>Jar of Bees

bee_handler:
  type: world
  debug: false
  events:
    after player right clicks block with:jar_of_bees:
      - spawn <entity[bee].repeat_as_list[<util.random.int[1].to[5]>]> <context.location.above.if_null[<player.location.forward[3]>]>
      - take item:jar_of_bees if:<player.gamemode.equals[survival]>

    after player consumes jar_of_bees:
      - determine passively cancelled
      - spawn <entity[bee[anger=1m]].repeat_as_list[<util.random.int[1].to[5]>]> <context.location.above.if_null[<player.location.forward[3]>]>
      - take item:jar_of_bees if:<player.gamemode.equals[survival]>
