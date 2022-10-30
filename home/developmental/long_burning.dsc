condensed_netherrack:
  type: item
  debug: false
  material: obsidian
  display name: <&f>Condensed Netherrack
  recipes:
    1:
      type: furnace
      cook_time: 1s
      experience: 6
      input: nether_brick

crimson_morel:
  type: item
  debug: false
  material: obsidian
  display name: <&f>Crimson Morel
  recipes:
    1:
      type: furnace
      cook_time: 5s
      experience: 2
      input: nether_wart|crimson_roots|weeping_vines|crimson_fungus
    2:
      type: furnace
      cook_time: 45s
      experience: 6
      input: nether_wart_block
    3:
      type: furnace
      cook_time: 60s
      experience: 8
      input: crimson_stem
    4:
      type: furnace
      cook_time: 55s
      experience: 7
      input: stripped_crimson_stem
    5:
      type: furnace
      cook_time: 70s
      experience: 10
      input: crimson_hyphae
    6:
      type: furnace
      cook_time: 65s
      experience: 9
      input: stripped_crimson_hyphae

condensed_crimson_morel:
  type: item
  debug: false
  material: obsidian
  display name: <&f>Condensed Crimson Morel
  recipes:
    1:
      type: shaped
      input:
      - crimson_morel|crimson_morel|crimson_morel
      - crimson_morel|crimson_morel|crimson_morel
      - crimson_morel|crimson_morel|crimson_morel

warped_morel:
  type: item
  debug: false
  material: obsidian
  display name: <&f>Warped Morel
  recipes:
    1:
      type: furnace
      cook_time: 6s
      experience: 3
      input: warped_roots|twisting_vines|warped_fungus
    2:
      type: furnace
      cook_time: 50s
      experience: 7
      input: warped_wart_block
    3:
      type: furnace
      cook_time: 65s
      experience: 9
      input: warped_stem
    4:
      type: furnace
      cook_time: 60s
      experience: 8
      input: stripped_warped_stem
    5:
      type: furnace
      cook_time: 75s
      experience: 11
      input: warped_hyphae
    6:
      type: furnace
      cook_time: 70s
      experience: 10
      input: stripped_warped_hyphae


condensed_warped_morel:
  type: item
  debug: false
  material: obsidian
  display name: <&f>Condensed Warped Morel
  recipes:
    1:
      type: shaped
      input:
      - warped_morel|warped_morel|warped_morel
      - warped_morel|warped_morel|warped_morel
      - warped_morel|warped_morel|warped_morel

molten_iron:
  type: item
  debug: false
  material: obsidian
  display name: <&f>Molten Iron
  recipes:
    1:
      type: furnace
      cook_time: 1s
      experience: 100
      input: iron_block

reverse_molten_iron:
  type: item
  debug: false
  material: iron_ingot
  no_id: true
  mechanisms:
    quantity: 5
  recipes:
    1:
      type: shapeless
      input: molten_iron

steel_ingot:
  type: item
  debug: false
  material: iron_ingot
  display name: <&f>Steel Ingot
  recipes:
    1:
      type: shapeless
      input: molten_iron|molten_iron|molten_iron|raw_copper_block|raw_copper_block

steel_bar:
  type: item
  debug: false
  material: obsidian
  display name: <&f>Steel Bar
  recipes:
    1:
      type: shaped
      input:
      - steel_ingot|steel_ingot|steel_ingot
    2:
      type: shaped
      input:
      - steel_ingot
      - steel_ingot
      - steel_ingot

steel_plate:
  type: item
  debug: false
  material: obsidian
  display name: <&f>Steel Plate
  recipes:
    1:
      type: shaped
      input:
        - steel_ingot|steel_ingot|steel_ingot
        - steel_ingot|steel_ingot|steel_ingot
    2:
      type: shaped
      input:
        - steel_ingot|steel_ingot
        - steel_ingot|steel_ingot
        - steel_ingot|steel_ingot

steel_block:
  type: item
  debug: false
  material: obsidian
  display name: <&f>Steel Block
  recipes:
    1:
      type: shaped
      input:
      - steel_ingot|steel_ingot|steel_ingot
      - steel_ingot|steel_ingot|steel_ingot
      - steel_ingot|steel_ingot|steel_ingot

long_burn:
  type: world
  debug: false
  data:
    material_types:
      netherrack:
        required: <util.random.int[125].to[150]>
        output: condensed_netherrack
        smelting:
          nether_brick: <util.random.int[1].to[5]>

      crimson_nylium:
        required: <util.random.int[850].to[1000]>
        output: crimson_morel
        smelting:
          nether_wart: <util.random.int[1].to[3]>
          crimson_roots: 1
          weeping_vines: 1
          crimson_fungus: 2

          nether_wart_block: <util.random.int[6].to[9]>
          crimson_stem: <util.random.int[9].to[12]>
          stripped_crimson_stem: <util.random.int[8].to[11]>
          crimson_hyphae: <util.random.int[11].to[14]>
          stripped_crimson_hyphae: <util.random.int[10].to[13]>

      warped_nylium:
        required: <util.random.int[850].to[1000]>
        output: warped_morel
        smelting:
          warped_roots: 1
          twisting_vines: 1
          warped_fungus: 2

          warped_wart_block: <util.random.int[6].to[9]>
          crimson_warped_stem: <util.random.int[9].to[12]>
          stripped_warped_stem: <util.random.int[8].to[11]>
          crimson_hyphae: <util.random.int[11].to[14]>
          stripped_warped_hyphae: <util.random.int[10].to[13]>

    materials:
      nether_brick: netherrack

      nether_wart: crimson_nylium
      crimson_roots: crimson_nylium
      weeping_vines: crimson_nylium
      nether_wart_block: crimson_nylium
      crimson_stem: crimson_nylium
      stripped_crimson_stem: crimson_nylium
      crimson_hyphae: crimson_nylium
      stripped_crimson_hyphae: crimson_nylium

      warped_roots: warped_nylium
      twisting_vines: warped_nylium
      warped_fungus: warped_nylium
      warped_wart_block: warped_nylium
      warped_warped_stem: warped_nylium
      stripped_warped_stem: warped_nylium
      warped_hyphae: warped_nylium
      stripped_warped_hyphae: warped_nylium

  events:
    on block smelts item:
      - define material <context.source_item.material.name>
      - stop if:!<script.data_key[data.materials].contains[<[material]>]>
      - define type <script.data_key[data.materials.<[material]>]>
      - define smelt_quantity <script.parsed_key[data.material_types.<[type]>.smelting.<[material]>]>

      - flag <context.location> behr.essentials.crafting.<[type]>:+:<[smelt_quantity]>
      - if <context.location.flag[behr.essentials.crafting.<[type]>]> >= <script.parsed_key[data.material_types.<[type]>.required]>:
        - flag <context.location> behr.essentials.crafting.<[type]>:!
        - determine <script.data_key[data.material_types.<[type]>.output]>
      - else:
        - determine air
