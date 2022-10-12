crossbow_attac:
  type: task
  debug: true
  script:
    - define turret <player.flag[test_turret].last>
    #- define target <player>
    #- define target <server.match_player[hydrox]>
    #- define target <server.flag[test_target]>
    - while <server.has_flag[testing_turret]>:
      - inject turret_attack_task

turret_attack_task:
  type: task
  debug: false
  definitions: turret
  script:
      - define target_entity_types <list[zombie|skeleton|creeper|warden]>
      - define target_entities <[turret].location.find_entities[<[target_entity_types]>].within[25].filter_tag[<[turret].can_see[<[filter_value]>]>].filter_tag[<[turret].location.distance[<[filter_value].location>].is_more_than[2]>]>
      - if <[target_entities].is_empty>:
        - wait 1s
        - while next
      - define target <[target_entities].first>
      - define direction <[turret].location.face[<[target].location>]>
      - define x <[direction].pitch.to_radians>
      - define y <[direction].yaw.to_radians>
      - adjust <[turret]> armor_pose:head|<[x]>,<[y]>,0
      - wait 4t
      - if !<[target].is_truthy> || !<[turret].can_see[<[target]>]>:
        - wait 5t
        - while next
      - shoot arrow origin:<[direction].above[2]> destination:<[target].eye_location> speed:<player.flag[test_turret].last.location.distance[<player.location>].div[5].max[2].min[7]> save:arrow
      - burn <entry[arrow].shot_entity>
# second is .49 lower
