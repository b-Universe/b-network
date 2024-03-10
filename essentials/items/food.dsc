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

gyro:
  type: item
  debug: false
  material: cooked_chicken
  display name: <&f>Gyro
  mechanisms:
    custom_model_data: 1000
  recipes:
    1:
      type: shapeless
      input: bread|cooked_mutton|kelp/dried_kelp|carrot/beetroot
      # recipe_id: denizen:shapeless_recipe_gyro

golden_gyro:
  type: item
  debug: false
  material: cooked_chicken
  display name: <&f>Golden Gyro
  mechanisms:
    custom_model_data: 1001
  recipes:
    1:
      type: shapeless
      input: gyro|gold_nugget|gold_nugget|gold_nugget|gold_nugget|gold_nugget|gold_nugget|gold_nugget|gold_nugget
    2:
      type: shapeless
      input: gyro|golden_carrot/golden_apple/enchanted_golden_apple
    3:
      type: shapeless
      input: bread|cooked_porkchop|kelp/dried_kelp|golden_carrot

sweet_gyro:
  type: item
  debug: false
  material: cooked_chicken
  display name: <&f>Sweet Gyro
  mechanisms:
    custom_model_data: 1002
  recipes:
    1:
      type: shapeless
      input: gyro|sugar|honey_bottle/cocoa_beans/sweet_berries

spicy_gyro:
  type: item
  debug: false
  material: cooked_chicken
  display name: <&f>Spicy Gyro
  mechanisms:
    custom_model_data: 1003
  recipes:
    1:
      type: shapeless
      input: gyro|pufferfish|poisonous_potato

hamburger:
  type: item
  debug: false
  material: cooked_chicken
  display name: <&f>Hamburger
  mechanisms:
    custom_model_data: 1004
  recipes:
    1:
      type: shapeless
      input: bread|cooked_beef|kelp/dried_kelp

sandwich:
  type: item
  debug: false
  material: cooked_chicken
  display name: <&f>Sandwich
  mechanisms:
    custom_model_data: 1005
  recipes:
    1:
      type: shapeless
      input: bread|cooked_chicken/cooked_porkchop|kelp/dried_kelp

hotdog:
  type: item
  debug: false
  material: cooked_chicken
  display name: <&f>Hotdog
  mechanisms:
    custom_model_data: 1006
  recipes:
    1:
      type: shapeless
      input: bread|cooked_mutton
