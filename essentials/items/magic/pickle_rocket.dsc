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

pickle_rocket_handler:
  type: world
  debug: false
  events:
    on player places pickle_rocket:
      - determine passively cancelled
      - inject pickle_launch

    on player right clicks block with:pickle_rocket:
      - determine passively cancelled
      - inject pickle_launch if:!<player.is_inside_vehicle>
    on player damaged by fall flagged:behr.essentials.pickle_launched:
      - determine cancelled
    # Prevention from riptide animation playing while player is mounted
    on player enters entity:
      - adjust <player> is_using_riptide:false

pickle_launch:
  type: task
  debug: false
  script:
    - playeffect at:<player.location> effect:explosion_large quantity:4
    - playeffect at:<player.location> effect:explosion_normal quantity:10
    - adjust <player> velocity:<player.velocity.div[3].with_y[1].with_pose[<player>].forward_flat[1]>
    - playsound <player> sound:entity_generic_explode
    - flag player behr.essentials.pickle_launched
    - adjust <player> is_using_riptide:true
    - wait 5t
    - waituntil <player.is_on_ground> || !<player.is_truthy>
    - flag player behr.essentials.pickle_launched
    - adjust <player> is_using_riptide:false if:<player.is_truthy>
