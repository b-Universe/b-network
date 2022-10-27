block_entity_item:
  type: item
  debug: false
  material: spawner
  mechanisms:
    spawner_type: block_entity
    spawner_player_range: 0
    spawner_max_nearby_entities: 0

block_entity:
  type: entity
  debug: false
  entity_type: armor_stand
  mechanisms:
    marker: true
    visible: false
    can_tick: false
    equipment:
      helmet: custom_material_item

custom_material_item:
  type: item
  debug: false
  material: obsidian
  mechanisms:
    custom_model_data: 1000
