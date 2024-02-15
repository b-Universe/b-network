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
