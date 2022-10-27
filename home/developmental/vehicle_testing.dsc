test_create:
  type: task
  script:
    - remove <player.location.find_entities[vehicle_test].within[20]> if:!<player.location.find_entities[vehicle_test].within[20].is_empty>
    - define location <server.flag[test_spawn].with_yaw[-180]>

    - define location <[location].below[0.4]>
    #- define location <[location].above[1.5]>

    - spawn vehicle_test <[location]> save:vehicle
    - note <[location].sub[2,-1,2].to_cuboid[<[location].add[2,4,2]>]> as:test_vehicle
    - wait 3m
    - remove <entry[vehicle].spawned_entity> if:<entry[vehicle].spawned_entity.is_truthy>

vehicle_test:
  type: entity
  entity_type: armor_stand
  mechanisms:
    visible: false
    gravity: false
    equipment:
      - air
      - air
      - air
      - aircraft_landed_hatch_open

vehicle_hatch_test:
  type: entity
  entity_type: armor_stand
  mechanisms:
    visible: false
    gravity: false
    equipment:
      - air
      - air
      - air
      - aircraft_hatch

aircraft_landed_hatch_open:
  type: item
  debug: false
  material: leather_horse_armor
  mechanisms:
    custom_model_data: 1300013
aircraft_landed_hatch_closed:
  type: item
  debug: false
  material: leather_horse_armor
  mechanisms:
    custom_model_data: 1300014
aircraft_hatch:
  type: item
  debug: false
  material: leather_horse_armor
  mechanisms:
    custom_model_data: 1300011
aircraft_landed_no_hatch:
  type: item
  debug: false
  material: leather_horse_armor
  mechanisms:
    custom_model_data: 1300012
aircraft_whole:
  type: item
  debug: false
  material: leather_horse_armor
  mechanisms:
    custom_model_data: 1300010

vehicle_event_testing:
  type: world
  events:
    on player clicks block in:test_vehicle:
      - determine passively cancelled
      - run vehicle_hatch_test_thing def:<player.location.find_entities[vehicle_test].within[10].first> if:!<player.location.find_entities[vehicle_test].within[10].is_empty>

    on player right clicks vehicle_test:
      - determine passively cancelled
      - run vehicle_hatch_test_thing def:<context.entity>

vehicle_hatch_test_thing:
  type: task
  definitions: entity
  script:
    - define location <[entity].location>
    - wait 1s
    - spawn vehicle_hatch_test <[location].above[1.85].backward_flat[0.59].with_pitch[0]> save:hatch
    - equip <[entity]> head:aircraft_landed_no_hatch

    #- mount <player>|<[entity]> <[location]>
    - repeat 12 as:index:
      - adjust <entry[hatch].spawned_entity> armor_pose:head|<[index].mul[6].min[67].to_radians>,0,0
      - wait 1t

    - playeffect at:<[location].forward_flat[1.1].up[2].left[1].points_between[<[location].forward_flat[1.1].up[2].right[1]>].distance[0.2]> quantity:3 offset:0.1 effect:cloud data:0.005
    - playeffect at:<[location].forward_flat[0.9].up[2].left[1.1]> quantity:3 offset:0.1 effect:cloud data:0.005
    - playeffect at:<[location].forward_flat[0.9].up[2].right[1.1]> quantity:3 offset:0.1 effect:cloud data:0.005
    - equip <[entity]> head:aircraft_landed_hatch_closed
    - remove <entry[hatch].spawned_entity> if:<entry[hatch].spawned_entity.is_truthy>
