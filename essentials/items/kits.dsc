starter_kit:
  type: item
  debug: false
  material: bundle

create_starter_kit:
  type: task
  debug: false
  script:
    - define items <list>
    - define items <[items].include[<list[golden_gyro|sweet_gyro|spicy_gyro].proc[starter_random_foods].context[3]>]>
    - define items <[items].include[phantom_membrane[quantity=20]]>
    - define items <[items].include[firework_rocket[quantity=64]]>
    - define items <[items].include[<list[gyro|hamburger|sandwich].proc[starter_random_foods].context[12]>]>
    - define starter_kit <item[starter_kit].with[inventory_contents=<[items]>]>

starter_random_foods:
  type: procedure
  definitions: foods|quantity
  script:
    - define food_items <list>
    - define foods_list <[foods].parse[repeat_as_list[<[quantity]>]].combine.random[<[quantity]>]>
    - foreach <[foods]> as:food:
      - define food_quantity <[foods_list].count[<[food]>]>
      - foreach next if:<[food_quantity].is_less_than_or_equal_to[0]>
      - define food_items <[food_items].include_single[<[food].as[item].with[quantity=<[food_quantity]>]>]>
    - determine <[food_items]>
