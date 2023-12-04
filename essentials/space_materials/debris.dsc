space_material_mining_handler:
  type: world
  debug: false
  events:
    on player breaks andesite in:home_the_end:
      - define efficiency <player.item_in_hand.enchantment_map.get[efficiency].if_null[1]>
      - stop if:!<util.random_chance[<[efficiency].mul[16]>]>
      - define quantity <util.random.int[1].to[<[efficiency]>]>
      - determine andesite|ice_shard[quantity=<[quantity]>]

ice_shard:
  type: item
  debug: false
  material: ghast_tear
  display name: <&f>Ice Shard

ice_block:
  type: item
  debug: false
  material: ice
  no_id: true
  recipes:
    1:
      type: shaped
      input:
        - ice_shard|ice_shard|ice_shard
        - ice_shard|ice_shard|ice_shard
        - ice_shard|ice_shard|ice_shard

ice_block_reverse:
  type: item
  debug: false
  material: ice_shard
  no_id: true
  mechanisms:
    quantity: 9
    script: ice_shard
  recipes:
    1:
      type: shapeless
      input: ice

add_magma_block:
  type: item
  debug: false
  material: magma_block
  no_id: true
  mechanisms:
    quantity: 1
  recipes:
    1:
      type: shapeless
      input: stone/andesite/granite/diorite/blackstone|lava_bucket
