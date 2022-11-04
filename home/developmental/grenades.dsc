test_events_gr:
  type: world
  debug: false
  events:
    on player clicks block using:either_hand with:sticky_grenade_item:
      - determine passively cancelled

      - shoot sticky_grenade_entity speed:1 shooter:<player> save:entity
      - while <entry[entity].shot_entity.is_truthy>:
        - define location <entry[entity].shot_entity.location>
        - playeffect at:<[location]> visibility:100 quantity:3 offset:0.15 effect:electric_spark
        - playeffect effect:redstone at:<[location]> visibility:100 offset:0.1 special_data:1|white
        - playeffect effect:redstone at:<[location]> visibility:100 offset:0.1 special_data:1|<color[0,200,255]>
        - playeffect effect:redstone at:<[location]> visibility:100 offset:0.1 special_data:1|<color[0,150,255]>
        - wait 1t

    on entity shoots block:
      - stop if:!<context.projectile.script.is_truthy>
      - determine passively cancelled

      - define location <context.projectile.location>
      - foreach <context.hit_face.xyz.split[,]> as:coordinate:
        - foreach next if:<[coordinate].equals[0]>
        - choose <[loop_index]>:
          - case 1:
            - if <[coordinate]> > 0:
              - define location <[location].with_x[<context.location.add[<context.hit_face>].x>]>
            - else:
              - define location <[location].with_x[<context.location.x>]>
            - define location <[location].with_z[<context.projectile.location.z.min[<context.location.z.add[1]>].max[<context.location.z>]>]>

          - case 2:
            - if <[coordinate]> > 0:
              - define location <[location].with_y[<context.location.add[<context.hit_face>].y>]>
            - else:
              - define location <[location].with_y[<context.location.y.sub[0.1]>]>

          - case 3:
            - if <[coordinate]> > 0:
              - define location <[location].with_z[<context.location.add[<context.hit_face>].z>]>
            - else:
              - define location <[location].with_z[<context.location.z>]>
            - define location <[location].with_x[<context.projectile.location.x.max[<context.location.x>].min[<context.location.x.add[1]>]>]>

      - spawn sticky_grenade_stuck_entity <[location]> save:entity
      - playsound <context.projectile.location> volume:0.5 sound:entity_tnt_primed
      - repeat 40:
        - playeffect at:<[location]> quantity:3 offset:0.15 effect:electric_spark
        - wait 1t
      - remove <entry[entity].spawned_entity> if:<entry[entity].spawned_entity.is_truthy>
      - run grenade_effects def:<[location]>|<context.shooter>

    on player damages entity:
      - stop if:!<context.projectile.script.is_truthy>
      - determine passively cancelled

      - choose <context.projectile.script.name>:
        - case sticky_grenade_entity:
          - define offset <location[0,<context.entity.eye_height.sub[0.2]>,0].random_offset[0.4,0.4,0.4]>
          #- spawn sticky_grenade_stuck_entity <context.entity.location.add[<[offset]>]> save:entity
          #- attach <entry[entity].spawned_entity> to:<context.entity> relative sync_server
          - playsound <context.entity.location> volume:0.5 sound:entity_tnt_primed
          - flag <context.entity> behr.essentials.combat.grenade_stickied:++ expire:3s
          - repeat 40:
            - repeat stop if:!<context.entity.is_truthy>
            - define location <context.entity.location.add[<[offset]>]>
            - playeffect at:<[location]> visibility:100 quantity:3 offset:0.15 effect:electric_spark
            - playeffect effect:redstone at:<[location]> visibility:30 offset:0 special_data:1|white
            - playeffect effect:redstone at:<[location]> visibility:30 offset:0 special_data:1|<color[0,200,255]>
            - playeffect effect:redstone at:<[location]> visibility:30 offset:0 special_data:1|<color[0,150,255]>
            - wait 1t
          - run grenade_effects def:<[location]>|<context.damager>

    after sticky_grenade_entity hits entity:
      - wait 1t
      - stop if:<context.hit_entity.has_flag[behr.essentials.combat.grenade_stickied]>
      - stop if:!<context.shooter.exists>

      - shoot sticky_grenade_entity speed:<util.random.decimal[0.025].to[0.1]> lead:<context.shooter.location.sub[<context.hit_entity.location>].normalize> origin:<context.hit_entity> save:entity
      - playsound <entry[entity].shot_entity.location> volume:0.5 sound:entity_tnt_primed
      - define timer 0
      - repeat 40:
        - define timer:++
        - repeat stop if:!<entry[entity].shot_entity.is_truthy>
        - define location <entry[entity].shot_entity.location>
        - playeffect at:<[location]> visibility:100 quantity:3 offset:0.15 effect:electric_spark
        - wait 1t
      #- repeat <[timer].sub[40]> if:!<[timer].equals[40]>:
      #  - wait 1t
      #- run grenade_effects def:<[location]>|<context.shooter>

grenade_effects:
  type: task
  debug: false
  definitions: location|damager
  script:
    - playeffect effect:explosion_large at:<[location]> visibility:100 quantity:10 offset:1.0
    - playeffect effect:cloud at:<[location]> visibility:100 quantity:20 data:0.1 offset:0.0
    - playeffect effect:redstone at:<[location]> visibility:100 quantity:150 offset:1.0 special_data:1|<color[0,200,255]>
    - playeffect effect:redstone at:<[location]> visibility:100 quantity:70 offset:1.0 special_data:1|<color[0,150,255]>
    - playsound <[location]> volume:3 sound:entity_generic_explode

    - define radius_2 <[location].find_entities[!armor_stand].within[2].filter[eye_location.line_of_sight[<[location]>]]>
    - define radius_4 <[location].find_entities[!armor_stand].within[4].exclude[<[radius_2]>].filter[eye_location.line_of_sight[<[location]>]]>
    - define radius_6 <[location].find_entities[!armor_stand].within[6].exclude[<[radius_4]>].filter[eye_location.line_of_sight[<[location]>]]>
    - foreach <[radius_2]> as:entity:
      - hurt <[entity]> <[entity].flag[behr.essentials.combat.grenade_stickied].mul[4].add[10].if_null[10]> cause:block_explosion
    - hurt <[radius_4]> 5 source:<[damager]> cause:block_explosion
    - hurt <[radius_6]> 1 source:<[damager]> cause:block_explosion
    - foreach <[radius_2].filter[is_truthy]> as:entity:
      - adjust <[entity]> velocity:<[entity].location.sub[<[location]>].normalize.above[0.2]> if:<[entity].is_truthy>
    - foreach <[radius_4].filter[is_truthy]> as:player:
      - adjust <[entity]> velocity:<[entity].location.sub[<[location]>].normalize.div[2]> if:<[entity].is_truthy>

    - repeat 3:
      - playeffect at:<[location]> visibility:100 quantity:50 offset:1 effect:electric_spark
      - wait 2t

sticky_grenade_item:
  type: item
  debug: false
  material: snowball
  display name: <&b>Sticky Grenade
  mechanisms:
    custom_model_data: 200

sticky_grenade_entity_item:
  type: item
  debug: false
  material: snowball
  display name: <&b>Sticky Grenade
  mechanisms:
    custom_model_data: 201

sticky_grenade_entity:
  type: entity
  debug: false
  entity_type: snowball
  mechanisms:
    item: sticky_grenade_entity_item

sticky_grenade_stuck_entity:
  type: entity
  debug: false
  entity_type: snowball
  mechanisms:
    item: sticky_grenade_entity_item
    gravity: false
    velocity: 0,0,0

#bundle_control:
#  type: world
#  events:
#    on player clicks in inventory:
#      - narrate fire
#
