shulker_hhandler:
  type: world
  debug: false
  events:
    after delta time minutely:
      - define color <list[white|gray|light_gray|black].random>
      - flag server behr.essentials.shulker_color:<[color]>

    on shulker spawns:
      - adjust <context.entity> color:<server.flag[behr.essentials.shulker_color]>

    on player potion effects added effect:levitation:
      - determine cancelled
