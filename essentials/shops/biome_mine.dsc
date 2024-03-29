#<location[-851,0,-512,home_the_end].to_cuboid[-451,255,-112,home_the_end]> as:
biome_mine_rules:
  type: world
  debug: false
  events:
    on monster spawns in:biome_mine:
      - determine cancelled

biome_mine_rules_testing:
  type: world
  debug: false
  data:
    whitelisted_blocks:
      - *shulker_box
      - *chest
      - crafting_table
      - furnace
      - blast_furnace
      - smoker
  events:
    on player damages player in:biome_mine:
      - determine cancelled

    on player places block in:biome_mine:
      - stop if:<server.flag[behr.uuids].contains[<player.uuid>]>
      - define whitelist <script.data_key[data.whitelisted_blocks]>
      - determine cancelled if:!<context.material.advanced_matches[<[whitelist]>]>

    on player breaks block in:biome_mine:
      - stop if:<server.flag[behr.uuids].contains[<player.uuid>]>
      - define whitelist <script.data_key[data.whitelisted_blocks]>
      - determine cancelled if:!<context.material.advanced_matches[<[whitelist]>]>
