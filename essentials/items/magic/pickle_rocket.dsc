pickle_rocket:
  type: item
  debug: false
  material: music_disc_11
  display name: <&b>Pickle Rocket
  lore:
    - <&e>Right click<&co> <&3>launch
  recipes:
    1:
      type: shaped
      input:
        - torchflower|sniffer_egg|pitcher_plant
        - seagrass|sea_pickle|seagrass
        - tnt|redstone_block|tnt
  mechanisms:
    hides: all
    custom_model_data: 2002

pickel_rocket:
  type: item
  material: firework_rocket
  display name: pickel

pickle_rocket_handler:
  type: world
  debug: false
  events:
    on player damaged by block_explosion flagged:behr.essentials.firework_explosion:
      - determine passively cancelled
      - define distance <element[2].sub[<player.location.distance[<player.flag[behr.essentials.firework_explosion]>]>].min[2].max[0.1]>
      - adjust <player> velocity:<player.velocity.add[<player.location.sub[<player.flag[behr.essentials.firework_explosion]>].above[0.3]>].normalize.mul[<[distance]>]>
      - flag <player> behr.essentials.firework_explosion:!

    on player shoots crossbow:
      - define projectile <context.projectile.if_null[null]>
      - if <[projectile].firework_item.if_null[null]> !matches firework_rocket:
        - stop

      - while <[projectile].is_truthy> && !<[projectile].is_on_ground>:
        - define location <[projectile].location>
        - wait 1t
      - flag <player> behr.essentials.firework_explosion:<[location]> expire:1t
      - explode <[projectile].location> power:2

    on player places pickle_rocket:
      - determine passively cancelled
      - inject pickle_launch

    on player right clicks block with:pickle_rocket:
      - determine passively cancelled
      - inject pickle_launch if:!<player.is_inside_vehicle>
    on player damaged by fall flagged:behr.essentials.pickle_launched:
      - determine cancelled
    # Prevention from riptide animation playing while player is mounted
    on player enters entity flagged:behr.essentials.pickle_launched:
      - adjust <player> is_using_riptide:false

    on music_disc_11 moves from hopper to inventory:
      - determine cancelled if:<context.item.script.name.if_null[null].equals[pickle_rocket]>

pickle_launch:
  type: task
  debug: false
  script:
    - stop if:<player.has_flag[behr.essentials.ratelimit.pickle_rocket]>
    - itemcooldown music_disc_11 duration:10t
    - flag player behr.essentials.ratelimit.pickle_rocket expire:10t
    #- playeffect effect:explosion_large at:<player.location> quantity:4
    #- playeffect effect:explosion_normal at:<player.location> quantity:10
    - adjust <player> velocity:<player.velocity.div[3].with_y[1].with_pose[<player>].forward_flat[1]>
    - playsound <player> sound:entity_generic_explode
    - flag player behr.essentials.pickle_launched
    - adjust <player> is_using_riptide:true
    - wait 5t
    - waituntil <player.is_on_ground> || !<player.is_truthy>
    - flag player behr.essentials.pickle_launched:!
    - adjust <player> is_using_riptide:false if:<player.is_truthy>
