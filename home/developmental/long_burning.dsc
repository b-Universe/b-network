#nether: bryan stevens
condensed_netherrack:
  type: item
  material: obsidian
  display name: <&f>Condensed Netherrack
  recipes:
    1:
      type: furnace
      #cook_time: 30s
      cook_time: 1s
      experience: 5
      input: nether_brick

crimson_morel:
  type: item
  material: obsidian
  display name: <&f>Crimson Morel
  recipes:
    1:
      type: furnace
      # toto: cook_time: 5s
      cook_time: 1s
      experience: 5
      input: nether_wart
    2:
      type: furnace
      # toto: cook_time: 45s
      cook_time: 1s
      experience: 5
      input: nether_wart_block
    3:
      type: furnace
      # toto: cook_time: 60s
      cook_time: 1s
      experience: 5
      input: crimson_stem
    4:
      type: furnace
      # toto: cook_time: 55s
      cook_time: 1s
      experience: 5
      input: stripped_crimson_stim
    5:
      type: furnace
      # toto: cook_time: 70s
      cook_time: 1s
      experience: 5
      input: crimson_hyphae
    6:
      type: furnace
      # toto: cook_time: 65s
      cook_time: 1s
      experience: 5
      input: stripped_crimson_hyphae

condensed_crimson_morel:
  type: item
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
  material: obsidian
  display name: <&f>Warped Morel
  recipes:
    1:
      type: furnace
      cook_time: 45s
      experience: 5
      input: warped_wart_block
    1:
      type: furnace
      cook_time: 60s
      experience: 5
      input: crimson_warped_stem
    1:
      type: furnace
      cook_time: 55s
      experience: 5
      input: stripped_warped_stim
    1:
      type: furnace
      cook_time: 70s
      experience: 5
      input: crimson_hyphae
    1:
      type: furnace
      cook_time: 65s
      experience: 5
      input: stripped_crimson_hyphae

condensed_warped_morel:
  type: item
  material: obsidian
  display name: <&f>Condensed Warped Morel
  recipes:
    1:
      type: shaped
      input:
      - warped_morel|warped_morel|warped_morel
      - warped_morel|warped_morel|warped_morel
      - warped_morel|warped_morel|warped_morel

long_burn:
  type: world
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
          
          nether_wart_block: <util.random.int[6].to[9]>
          crimson_stem: <util.random.int[9].to[12]>
          stripped_crimson_stim: <util.random.int[8].to[11]>
          crimson_hyphae: <util.random.int[11].to[14]>
          stripped_crimson_hyphae: <util.random.int[10].to[13]>

      warped_nylium: 
        required: <util.random.int[850].to[1000]>
        output: warped_morel
        smelting:
          warped_roots: 1
          twisting_vines: 1

          warped_wart_block: <util.random.int[6].to[9]>
          crimson_warped_stem: <util.random.int[9].to[12]>
          stripped_warped_stim: <util.random.int[8].to[11]>
          crimson_hyphae: <util.random.int[11].to[14]>
          stripped_crimson_hyphae: <util.random.int[10].to[13]>
    materials:
      nether_brick: netherrack

      nether_wart: crimson_nylium
      crimson_roots: crimson_nylium
      weeping_vines: crimson_nylium
      nether_wart_block: crimson_nylium
      crimson_stem: crimson_nylium
      stripped_crimson_stim: crimson_nylium
      crimson_hyphae: crimson_nylium
      stripped_crimson_hyphae: crimson_nylium

      warped_roots: warped_nylium
      twisting_vines: warped_nylium
      warped_wart_block: warped_nylium
      crimson_warped_stem: warped_nylium
      stripped_warped_stim: warped_nylium
      crimson_hyphae: warped_nylium
      stripped_crimson_hyphae: warped_nylium
  events:
    on block smelts nether_brick|crimson_stem|warped_stem:
      - define material <context.source_item.material.name>
      - define type <script.data_key[data.materials.<[material]>]>
      - define smelt_quantity <script.parsed_key[data.materials.<[material]>.smelt_quantity]>
      - flag <context.location> behr.essentials.crafting.<[type]>:+:<[smelt_quantity]>
      - if <context.location.flag[behr.essentials.crafting.<[type]>]> >= <script.parsed_key[data.material_types.<[type]>.required]>:
        - determine <script.data_key[data.material_types.<[type]>.output]>
      - else:
        - determine air

        # [ after testing ] - determine cancelled
        # [ after testing ] - wait 1t
        # [ after testing ] - inventory set destination:<context.location.inventory> slot:2 origin:<context.location.inventory.list_contents.get[2]>
        # [ after testing ] - inventory set destination:<context.location.inventory> slot:3?origin:<context.location.inventory.list_contents.get[last]> (or 3?)
