space_food_handler:
  type: world
  debug: false
  events:
    on player teleports cause:chorus_fruit:
      - determine cancelled
    on player consumes space_fruit:
      - feed <player> amount:10 saturation:10
    on player consumes space_juice:
      - feed <player> amount:6 saturation:18

space_fruit:
  type: item
  debug: false
  material: chorus_fruit
  display name: <&f>Hydrated Space Fruit
  mechanisms:
    quantity: 9
  recipes:
    1:
      type: shaped
      input:
        - chorus_fruit|chorus_fruit|chorus_fruit
        - chorus_fruit|water_bucket|chorus_fruit
        - chorus_fruit|chorus_fruit|chorus_fruit

space_juice:
  type: item
  debug: false
  material: milk_bucket
  display name: <&f>Space Juice
  recipes:
    1:
      type: shapeless
      input: bucket|space_fruit
