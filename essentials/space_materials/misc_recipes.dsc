elytra_wing_piece:
  type: item
  debug: false
  material: phantom_membrane
  display name: <&f>Elytra Wing Piece
  recipes:
    1:
      type: shaped
      input:
        - phantom_membrane|phantom_membrane|air
        - phantom_membrane|phantom_membrane|air
        - phantom_membrane|phantom_membrane|air
    2:
      type: shaped
      input:
        - air|phantom_membrane|phantom_membrane
        - air|phantom_membrane|phantom_membrane
        - air|phantom_membrane|phantom_membrane

add_elytra:
  type: item
  debug: false
  material: elytra
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - elytra_wing_piece|bone|elytra_wing_piece
        - elytra_wing_piece|bone|elytra_wing_piece
        - elytra_wing_piece|air|elytra_wing_piece

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

more_redstone_comparator:
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
