villager_handler:
  type: world
  debug: false
  events:
    after villager added to world:
      - stop if:!<context.entity.profession.advanced_matches[armorer|mason|weaponsmith]>
      - flag server behr.essentials.active_villagers:->:<context.entity>

    after villager changes profession:
      - if <context.entity.profession.advanced_matches[armorer|mason|weaponsmith]>:
        - flag server behr.essentials.active_villagers:->:<context.entity>

      - else if <server.flag[behr.essentials.active_villagers].contains[<context.entity>].if_null[false]>:
        - flag server behr.essentials.active_villagers:<-:<context.entity>

    # todo: this event actually doesn't work currently
    after villager despawns:
      - stop if:!<server.flag[behr.essentials.active_villagers].contains[<context.entity>].if_null[false]>
      - flag server behr.essentials.active_villagers:<-:<context.entity>

    on system time secondly every:10 server_flagged:behr.essentials.active_villagers:
      - if <server.flag[behr.essentials.active_villagers].is_empty>:
        - flag server behr.essentials.active_villagers:!
        - stop

      - foreach <server.flag[behr.essentials.active_villagers]> as:villager:
        - if !<[villager].is_truthy>:
          - flag server behr.essentials.active_villagers:<-:<[villager]>
          - foreach next

        - run villager_help_iron_golem_task def.villager:<[villager]>

villager_help_iron_golem_task:
  type: task
  debug: false
  definitions: villager
  script:
    - stop if:<[villager].world.time.is_more_than[12000]>
    - define iron_golems <[villager].location.find_entities[iron_golem].within[15].filter[has_flag[behr.essentials.villager_healed].not].filter[health.is_less_than[74]]>
    - stop if:<[iron_golems].is_empty>

    - define iron_golem <[iron_golems].first>
    - if <[iron_golem].health> < 74:
      - define health_applied 0

      - repeat 5:
        - if <[villager].location.distance[<[iron_golem].location>]> > 3:
          - define doors <[villager].location.find_blocks[*door].within[2]>
          - if !<[doors].is_empty>:
            - foreach <[doors]> as:door:
              - switch <[door]> if:!<[door].switched> duration:1s

          - ~walk <[villager]> <[iron_golem].location.with_pose[<[villager].location>].backward>

          - wait 10t
          - repeat next

        - if <[villager].location.distance[<[iron_golem].location>]> < 3:
          - define health_applied:+:10
          - look <[villager]> <[iron_golem].eye_location>
          - heal <[iron_golem]> 10
          - playsound <[iron_golem].location> sound:ENTITY_IRON_GOLEM_REPAIR
          - repeat 3:
            - playeffect effect:happy_villager at:<[iron_golem].location.above[1.5]> offset:0.3,0.8,0.3 quantity:<element[20].div[<[value]>].round_up>
            - wait 3t

        - wait 1s

      - if <[health_applied]> > 0:
        - flag <[iron_golem]> behr.essentials.villager_healed expire:5m
