#nether:
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
      #cook_time: 5s
      cook_time: 1s
      experience: 5
      input: nether_wart
    2:
      type: furnace
      #cook_time: 45s
      cook_time: 1s
      experience: 5
      input: nether_wart_block
    3:
      type: furnace
      #cook_time: 60s
      cook_time: 1s
      experience: 5
      input: crimson_stem
    4:
      type: furnace
      #cook_time: 55s
      cook_time: 1s
      experience: 5
      input: stripped_crimson_stim
    5:
      type: furnace
      #cook_time: 70s
      cook_time: 1s
      experience: 5
      input: crimson_hyphae
    6:
      type: furnace
      #cook_time: 65s
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

long_burn:
  type: world
  data:
    materials:
      # nether materials
      nether_brick:
        type: netherrack
        smelt_quantity:
          min: 2
          max: 2
        result: condensed_netherrack

      # crimson materials
      nether_wart:
        type: crimson_nylium
        smelt_quantity:
          min: 200
          max: 300
        result: crimson_morel
      nether_wart_block:
        type: crimson_nylium
      crimson_stem:
        type: crimson_nylium
      stripped_crimson_stim:
        type: crimson_nylium
      crimson_hyphae:
        type: crimson_nylium
      stripped_crimson_hyphae:
        type: crimson_nylium

      # warped materials
      warped_wart_block:
        type: warped_nylium
      crimson_warped_stem:
        type: warped_nylium
      stripped_warped_stim:
        type: warped_nylium
      crimson_hyphae:
        type: warped_nylium
      stripped_crimson_hyphae:
        type: warped_nylium
      

  events:
    on block smelts nether_brick|crimson_stem|warped_stem:
      - flag <context.location> behr.essentials.crafting.nether_brick:++
      - if <context.location.flag[behr.essentials.crafting.nether_brick]> == 2:
        - determine item_to_make
      - else:
        - determine air
        # [ after testing ] - determine cancelled
        # [ after testing ] - wait 1t
        # [ after testing ] - inventory set destination:<context.location.inventory> slot:2 origin:<context.location.inventory.list_contents.get[2]>
        # [ after testing ] - inventory set destination:<context.location.inventory> slot:3?origin:<context.location.inventory.list_contents.get[last]> (or 3?)
