food_on_the_table:
  type: task
  script:
    - define item <player.item_in_hand>
    - define location <player.cursor_on.center.above[0.8]>
    - spawn food_on_table_armor_stand <[location]> save:armor_stand
    - equip <entry[armor_stand].spawned_entity> head:<[item]>


food_on_table_armor_stand:
  type: entity
  entity_type: armor_stand
  mechanisms:
    marker: true
    visible: false
    is_small: true
