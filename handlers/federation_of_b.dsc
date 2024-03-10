galactic_federation_of_b_rules:
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
    on monster|phantom|magma_cube|shulker spawns in:galactic_federation_of_b:
      - if <cuboid[home_the_end,-4800,345,1703,-4826,332,1675].contains[<context.location>]>:
        - stop if:<context.entity.entity_type.advanced_matches[zombie|skeleton|shulker]>
      - determine cancelled

    on player breaks block in:galactic_federation_of_b:
      - stop if:<server.flag[behr.uuids].contains[<player.uuid>]>
      - define whitelist <script.data_key[data.whitelisted_blocks]>
      - determine cancelled if:!<context.material.advanced_matches[<[whitelist]>]>

    on player places block in:galactic_federation_of_b:
      - stop if:<server.flag[behr.uuids].contains[<player.uuid>]>
      - define whitelist <script.data_key[data.whitelisted_blocks]>
      - determine cancelled if:!<context.material.advanced_matches[<[whitelist]>]>

    on player changes farmland into dirt in:galactic_federation_of_b:
      - determine cancelled
