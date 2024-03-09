#<location[501,100,501,home_the_end].to_cuboid[719,200,753,home_the_end]>
sim_city_rules:
  type: world
  debug: false
  events:
    on !player spawns in:sim_city:
      - determine cancelled if:<list[default|build_wither|natural|patrol|village_defense|village_invasion].contains[<context.reason>]>

sim_city_rules_testing:
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
    on player places block in:sim_city:
      - stop if:<server.flag[behr.uuids].contains[<player.uuid>]>
      - define whitelist <script.data_key[data.whitelisted_blocks]>
      - determine cancelled if:!<context.material.advanced_matches[<[whitelist]>]>

    on player breaks block in:sim_city:
      - stop if:<server.flag[behr.uuids].contains[<player.uuid>]>
      - define whitelist <script.data_key[data.whitelisted_blocks]>
      - determine cancelled if:!<context.material.advanced_matches[<[whitelist]>]>
