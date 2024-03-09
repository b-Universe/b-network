extra_recipe_handler:
  type: world
  debug: false
  events:
    after player joins:
    - adjust <player> quietly_discover_recipe:<server.recipe_ids.filter[contains_text[denizen]].filter[advanced_matches[*_add_*]]>

    - foreach <script[recipe_list].parsed_key[all]> as:recipe:
      - adjust <player> discover_recipe:<[recipe]>

    - adjust <player> resend_discovered_recipes

    on player granted advancement criterion criterion:has_needed_dye:
      - foreach red|orange|yellow|lime|green|cyan|light_blue|blue|purple|magenta|pink|white|black|gray|light_gray|brown as:color:
        - if <context.advancement.contains_text[<[color]>]>:
          - adjust <player> discover_recipe:<server.recipe_ids.filter[contains_text[denizen]].filter[contains_text[more_<[color]>_dye]]>
      - adjust <player> resend_discovered_recipes

    on player granted advancement criterion advancement:*_more_*:
      - define item <context.advanement.after[_more_].before_last[_]>
      - adjust <player> discover_recipe:<server.recipe_ids.filter[contains_text[denizen]].filter[contains_text[more_<[item]>]]>
      - adjust <player> resend_discovered_recipes

recipe_list:
  type: data
  all:
    - denizen:shaped_redstone_crystal_1
    - denizen:shaped_attuned_lever_1
    - denizen:shaped_attuned_lever_2
    - denizen:shaped_attuned_observer_1
    - denizen:shaped_attuned_observer_2
    - denizen:shaped_wireless_transmitter_block_1
    - denizen:shaped_wireless_transmitter_block_2
    - denizen:shaped_wireless_receiver_block_1
    - denizen:shaped_wireless_receiver_block_2
    - denizen:shaped_recipe_bwand_1
    - denizen:shaped_recipe_add_iron_horse_armor_1
    - denizen:shapeless_recipe_sandwich_1
    - denizen:shapeless_recipe_uncooked_fries_1
    - denizen:shapeless_recipe_add_string_2_1
    - denizen:shaped_recipe_steel_plate_2
    - denizen:shaped_recipe_steel_plate_1
    - denizen:shaped_recipe_add_wool_2
    - denizen:shaped_recipe_add_wool_1
    - denizen:shapeless_recipe_steel_ingot_1
    - denizen:shapeless_recipe_add_magma_block_1
    - denizen:shaped_recipe_steel_block_1
    - denizen:shaped_recipe_add_bell_1
    - denizen:shapeless_recipe_add_string_1
    - denizen:shapeless_recipe_gyro_1
    - denizen:shapeless_recipe_spicy_gyro_1
    - denizen:shaped_recipe_steel_bar_2
    - denizen:shaped_recipe_steel_bar_1
    - denizen:shaped_recipe_add_golden_horse_armor_1
    - denizen:shapeless_recipe_reverse_molten_iron_1
    - denizen:shapeless_recipe_golden_gyro_3
    - denizen:shapeless_recipe_golden_gyro_2
    - denizen:shapeless_recipe_golden_gyro_1
    - denizen:shaped_recipe_add_elytra_1
    - denizen:shaped_recipe_ice_block_1
    - denizen:shaped_recipe_condensed_crimson_morel_1
    - denizen:shapeless_recipe_baked_fries_1
    - denizen:shapeless_recipe_sweet_gyro_1
    - denizen:shaped_recipe_condensed_warped_morel_1
    - denizen:shaped_recipe_add_diamond_horse_armor_1
    - denizen:shaped_recipe_space_fruit_1
    - denizen:shapeless_recipe_space_juice_1
    - denizen:shapeless_recipe_ice_block_reverse_1
    - denizen:shaped_recipe_pickle_rocket_1
    - denizen:shapeless_recipe_hamburger_1
    - denizen:shapeless_recipe_hotdog_1
    - denizen:furnace_recipe_molten_redstone_block_1
    - denizen:furnace_recipe_molten_gold_block_1
    - denizen:furnace_recipe_molten_iron_1
    - denizen:furnace_recipe_condensed_netherrack_1
    - denizen:furnace_recipe_warped_morel_6
    - denizen:furnace_recipe_warped_morel_5
    - denizen:furnace_recipe_warped_morel_4
    - denizen:furnace_recipe_warped_morel_3
    - denizen:furnace_recipe_warped_morel_2
    - denizen:furnace_recipe_warped_morel_1
    - denizen:furnace_recipe_crimson_morel_6
    - denizen:furnace_recipe_crimson_morel_5
    - denizen:furnace_recipe_crimson_morel_4
    - denizen:furnace_recipe_crimson_morel_3
    - denizen:furnace_recipe_crimson_morel_2
    - denizen:furnace_recipe_crimson_morel_1
    - denizen:blast_recipe_molten_redstone_block_2
    - denizen:blast_recipe_molten_gold_block_2
