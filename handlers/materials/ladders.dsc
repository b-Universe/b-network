ladder_handler:
  type: world
  debug: false
  enabled: false
  events:
    on player right clicks block with:ladder:
      - stop if:<context.relative.advanced_matches[ladder]>
      - stop if:!<context.relative.advanced_matches[air|water]>
      - determine passively cancelled
      - if <context.hand> == mainhand:
        - animate <player> animation:start_use_mainhand_item
      - else:
        - animate <player> animation:start_use_offhand_item
      - modifyblock <context.relative> ladder[direction=<location[0,0,0].with_yaw[<player.location.yaw.add[180]>].yaw.simple>;waterlogged=<context.relative.advanced_matches[water]>] source:<player>
      - playsound sound:block_ladder_place <context.relative>
      - take item:ladder if:<player.gamemode.equals[survival]>

    on block physics adjacent:ladder:
      - determine cancelled

    #on player steps on !*air| flagged:behr.essentials.location.biome.toxic_water:
    #  - if <context.location> !matches water || <context.location.above> !matches water:
    #    - define toxification <player.flag[behr.essentials.intoxicated].if_null[0]>
    #    - if <[toxification]> < 5:
    #      - flag <player> behr.essentials.intoxicated:++ expire:10s
    #      - cast poison duration:7s amplifier:<[toxification]>
