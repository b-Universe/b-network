wolf_handler:
  type: world
  debug: false
  events:
    on system time minutely:
      - foreach <server.worlds> as:world:
        - foreach <[world].entities[wolf].filter[is_tamed]> as:wolf:
          - define players <[wolf].location.find_entities[player].within[10]>
          - choose <[wolf].color>:
            - case red:
              - cast increase_damage duration:30s <[players]>

            - case orange:
              - cast fire_resistance duration:30s <[players]>

            - case yellow:
              - cast speed duration:30s <[players]>

            - case lime green:
              - cast regeneration duration:10s <[players]>

            - case cyan:
              - cast water_breathing duration:30s <[players]>

            - case light_blue blue gray:
              - cast damage_resistance duration:30s <[players]>

            - case purple magenta:
              - cast slow_falling duration:10s <[players]>

            - case pink:
              - flag <[players]> behr.essentials.wolf_passive_aggression expire:30s

            - case white:
              - cast invisibility duration:10s <[players]>

            - case black:
              - cast night_vision duration:10s <[players]>

    on entity targets player flagged:behr.essentials.wolf_passive_aggression:
      - determine cancelled