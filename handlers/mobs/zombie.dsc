zombie_handler:
  type: world
  debug: false
  events:
    on zombie spawns:
      - if <util.random_chance[10]>:
        - equip <context.entity> head:zombie_head_steve_mask

zombie_head_steve_mask:
  type: item
  debug: false
  material: player_head
  mechanisms:
    skull_skin: 66b6004f-4998-4c13-8b85-e734ec258d76|ewogICJ0aW1lc3RhbXAiIDogMTYxODg5NDE0ODg4MCwKICAicHJvZmlsZUlkIiA6ICI1ZWE0ODg2NTg2OWI0Y2ZhOWRjNTg5YmFlZWQwNzM5MCIsCiAgInByb2ZpbGVOYW1lIiA6ICJfUllOMF8iLAogICJzaWduYXR1cmVSZXF1aXJlZCIgOiB0cnVlLAogICJ0ZXh0dXJlcyIgOiB7CiAgICAiU0tJTiIgOiB7CiAgICAgICJ1cmwiIDogImh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOTIzYTY4NThhZWZmODk4MmE2MjUzYWZkYTEwOTljNjI3N2Y1NmRhMTljZGJkNmUxMzA5NzcxNjU3NzgxYmQ1MCIKICAgIH0KICB9Cn0=|

001_helmet:
  type: item
  debug: false
  material: chainmail_helmet
  mechanisms:
    trim:
      material: diamond
      pattern: custom_armor:001
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 8
          slot: head
001_helmet2:
  type: item
  debug: false
  material: chainmail_helmet
  mechanisms:
    trim:
      material: diamond
      pattern: 001
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 8
          slot: head

001_top:
  type: item
  debug: false
  material: chainmail_chestplate
  mechanisms:
    trim:
      material: diamond
      pattern: custom_armor:001
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 6
          slot: chest

001_bottom:
  type: item
  debug: false
  material: chainmail_boots
  mechanisms:
    trim:
      material: diamond
      pattern: custom_armor:001
    attribute_modifiers:
      generic_armor:
        1:
          operation: add_number
          amount: 6
          slot: feet
