ladder_handler:
  type: world
  debug: false
  enabled: true
  events:
    on player right clicks ladder with:ladder:
      - stop if:!<player.has_flag[behr.essentials.settings.descending_ladders]>
      - define distance <element[255].sub[<context.location.y>]>

      - if <[distance]> > 8:
        - stop

      - repeat <[distance]> as:loop_index:
        - define lower_block <context.location.below[<[loop_index]>]>
        - repeat next if:<[lower_block].material.equals[<context.location.material>]>
        - define support <[lower_block].sub[<context.location.block_facing>]>
        - if <[lower_block].material.name> NOT in AIR|VOID_AIR|CAVE_AIR OR NOT <[support].material.is_solid> or <[support].y> < -64:
          - repeat stop
        - modifyblock <[lower_block]> ladder[direction=<context.location.material.direction>] source:<player>
        - animate <player> animation:ARM_SWING
        - playsound <[lower_block].center> sound:block_ladder_place
        - take iteminhand if:<player.gamemode.equals[survival]>
        - repeat stop

    on player right clicks block with:ladder:
      - stop if:!<player.has_flag[behr.essentials.settings.airborne_ladders]>
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
