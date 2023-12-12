ender_dragon_handler:
  type: world
  events:
    after player kills ender_dragon:
      - wait 16s
      - modifyblock <location[0,70,0].with_world[<player.world>]> dragon_egg
      - flag <player> behr.essentials.dragon_counter:++
