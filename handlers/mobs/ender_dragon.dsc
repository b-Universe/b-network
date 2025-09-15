ender_dragon_handler:
  type: world
  debug: false
  events:
    after player kills ender_dragon:
      - wait 16s
      - modifyblock <location[0,70,0,home_the_end]> dragon_egg
      - flag <player> behr.essentials.dragon_counter:++
