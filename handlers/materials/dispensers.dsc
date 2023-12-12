dispenser_handler:
  type: world
  debug: false
  events:
    on dispenser tries to dispense *concrete_powder:
      - determine passively cancelled
      - narrate "<&6>Debug<&e>: <&a><context.location.inventory.list_contents>"
      - define material <context.item.material>
      - define direction_name <context.location.material.direction>
      - definemap direction_map:
          north: 0,0,-1
          south: 0,0,1
          east: 1,0,0
          west: -1,0,0
          up: 0,1,0
          down: 0,-1,0
      - define direction_offset <[direction_map].get[<[direction_name]>]>
      - define offset_location <context.location.add[<[direction_offset]>]>
      - if <[offset_location]> matches air:
        - wait 2t
        - take item:<context.item> from:<context.location.inventory>
        - playsound <context.location> sound:block_stone_place
        - modifyblock <[offset_location]> <[material]>
      - else:
        - playsound <context.location> sound:entity_generic_extinguish_fire pitch:2
      - narrate "<&6>Debug<&e>: <&a><context.location.inventory.list_contents>"
