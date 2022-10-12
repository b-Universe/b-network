generate_font_textures:
  type: task
  debug: false
  script:
    - define path resource_pack/minecraft/textures
    - definemap item_entry:
        type: bitmap
        ascent: 8
        height: 9
    - define items <list>

    - foreach <server.list_files[<[path]>/item]> as:item:
      # foreach -32768/-16;5/16;-13/16;-31/16
      - define items <[items].include_single[<[item_entry].with[chars].as[<list[\u<[loop_index].add[1000]>]>].with[file].as[minecraft<&co>item/<[item]>]>]>

    - define providers <map.with[providers].as[<[items]>]>
    - filewrite path:resource_pack/items.json data:<[providers].to_yaml.replace[<&sq>].utf8_encode>

generate_font_block_textures:
  type: task
  debug: false
  script:
    - define path resource_pack/minecraft/textures
    - definemap item_entry:
        type: bitmap
        ascent: 8
        height: 9
    - define items <list>

    - define i <util.list_numbers_to[861].parse_tag[\u<[parse_value].add[1457]>].sub_lists[25].parse[unseparated]>
    - define items <[items].include[<[item_entry].with[chars].as[<[i]>].with[file].as[minecraft<&co>block/block_sheet.png]>]>

    #- foreach <server.list_files[<[path]>/block].parse[before[.png]].exclude[<server.material_types.filter[is_block.not].alphabetical.parse[name]>]> as:item:
    #  # foreach -32768/-16;5/16;-13/16;-31/16
    #  - define items <[items].include_single[<[item_entry].with[chars].as[<list[\u<[loop_index].add[1457]>]>].with[file].as[minecraft<&co>item/<[item]>.png]>]>
#
    - define providers <map.with[providers].as[<[items]>]>
    - filewrite path:resource_pack/block_items.json data:<[providers].to_yaml.replace[<&sq>].utf8_encode>


# 30 x 44, 9 duds
generate_new_font:
  type: task
  debug: false
  script:
    - define path resource_pack/minecraft/textures
    - definemap item_entry:
        type: bitmap
      # ascent: 30
        height: 35
        file: gui/custom/sprite.png

    - define characters <list>
    - define index 57345
    - define ascent 30

    # there are 44 rows and 30 columns in the sprite
    - repeat 44:
      - define items <list>
      - repeat 30 as:column:
        - define character \u<[index].number_to_hex.pad_left[4].with[0]>
        - define items <[items].include_single[<[character]>]>
        - define index:++
      - define characters <[characters].include_single[<[items].unseparated>]>

    - repeat 25:
      - define character_map <[item_entry].with[ascent].as[<[ascent]>].with[chars].as[<[characters]>]>
      - define providers <map.with[providers].as[<list_single[<[character_map]>]>]>

      # there are several ascents available:
      - filewrite path:resource_pack/items_<[ascent]>.json data:<[providers].to_yaml.replace_text[<&sq>].replace_text[\\].with[\].utf8_encode>
      - define ascent:-:8


# replace \\ with \
# replace (\d|a|b|c|d|e|f)",\n\s{8} with $1",
# replace "\n\s*\], with "],
