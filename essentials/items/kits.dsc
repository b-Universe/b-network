starter_kit:
  type: item
  debug: false
  material: bundle
  mechanisms:
    list_contents:
      - <list[golden_gyro|sweet_gyro|spicy_gyro].random>
      - <list[golden_gyro|sweet_gyro|spicy_gyro].random>
      - <list[golden_gyro|sweet_gyro|spicy_gyro].random>
      - phantom_membrane[quantity=20]
      - firework_rocket[quantity=64]
#      - <list[gyro|hamburger|sandwich|hotdog].proc[starter_random_foods].context[9]>
#
#starter_random_foods:
#  type: procedure
#  debug: false
#  definitions: foods|quantity
#  script:
#    - define food_base <list>
#    - foreach <[foods]> as:food:
#      - define food_base <[food_base].include[<[food].repeat_as_list[<[quantity]>]>]>
#    - foreach <[food_base].deduplicate> as:food:
#      - define food_map.<[food]>:++
#    - define food_list <list>
#    - foreach <[food_map]> key:food as:quantity:
#      - define food_list <[food_list].include_single[<[food]>[quantity=<[quantity]>]]>
#    - determine <[food_list]>