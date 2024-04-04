structure_block_cuboid:
  type: procedure
  debug: false
  definitions: location
  script:
    - define block_data <[location].structure_block_data>
    - define location_1 <[location].add[<[block_data.box_position]>]>
    - define location_2 <[location_1].add[<[block_data.size]>]>
    - determine <[location_1].to_cuboid[<[location_2]>]>