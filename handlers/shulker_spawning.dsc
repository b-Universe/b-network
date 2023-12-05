shulker_coloring:
  type: world
  debug: false
  events:
    after delta time minutely:
      - define color <list[white|gray|light_gray|black].random>
      - flag server behr.essentials.shulker_color:<[color]>

    on shulker spawns:
      - adjust <context.entity> color:<server.flag[behr.essentials.shulker_color]>
