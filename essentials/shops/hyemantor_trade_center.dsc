#<location[501,100,501,home_the_end].to_cuboid[719,200,753,home_the_end]>
hyemantor_trade_center_rules:
  type: world
  debug: false
  events:
    on shulker spawns in:hyemantor_trade_center:
      - determine cancelled
hyemantor_trade_center_rules_testing:
  type: world
  debug: true
  data:
    whitelisted_blocks:
      - *shulker_box
      - *chest
      - crafting_table
      - furnace
      - blast_furnace
      - smoker
  events:
    on player places block in:hyemantor_trade_center:
      - define whitelist <script.data_key[data.whitelisted_blocks]>
      - determine cancelled if:!<context.material.advanced_matches[<[whitelist]>]>

    on player breaks block in:hyemantor_trade_center:
      - define whitelist <script.data_key[data.whitelisted_blocks]>
      - determine cancelled if:!<context.material.advanced_matches[<[whitelist]>]>
