more_furnace:
  type: item
  debug: false
  material: furnace
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - andesite/granite/diorite|andesite/granite/diorite|andesite/granite/diorite
        - andesite/granite/diorite|air|andesite/granite/diorite
        - andesite/granite/diorite|andesite/granite/diorite|andesite/granite/diorite

more_blast_furnace:
  type: item
  debug: false
  material: blast_furnace
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - iron_ingot|iron_ingot|iron_ingot
        - iron_ingot|furnace|iron_ingot
        - polished_andesite/polished_granite/polished_diorite/smooth_stone/polished_deepslate/polished_blackstone|polished_andesite/polished_granite/polished_diorite/smooth_stone/polished_deepslate/polished_blackstone|polished_andesite/polished_granite/polished_diorite/smooth_stone/polished_deepslate/polished_blackstone

more_stonecutter:
  type: item
  debug: false
  material: stonecutter
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - air|air|air
        - air|iron_ingot|air
        - polished_andesite/polished_granite/polished_diorite/smooth_stone|polished_andesite/polished_granite/polished_diorite/smooth_stone|polished_andesite/polished_granite/polished_diorite/smooth_stone
