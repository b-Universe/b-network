ender_dragon_handler:
  type: world
  debug: false
  events:
    after player kills ender_dragon:
      - wait 16s
      - modifyblock <location[0,70,0].with_world[<player.world>]> dragon_egg
      - flag <player> behr.essentials.dragon_counter:++

dragon_scales:
  type: item
  debug: false
  material: phantom_membrane
  display name: <&f>Dragon Scales
  mechanisms:
    quantity: <util.random.int[1].to[16]>
